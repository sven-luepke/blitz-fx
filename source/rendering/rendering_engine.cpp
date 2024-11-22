#include "rendering_engine.h"

#include <algorithm>
#include <iostream>

#include "DirectXMath.h"
#include "pipeline_state_manager.h"

using namespace w3;
using namespace DirectX;
using namespace Microsoft::WRL;


float FresnelSchlick(float cosTheta, float F0)
{
    return F0 + (1.0 - F0) * std::pow(std::clamp(1.0 - cosTheta, 0.0, 1.0), 5.0);
}

RenderingEngine::RenderingEngine(PipelineStateManager& pipeline_state_manager, ConstantBuffer<CustomFrameData>& custom_frame_data_cbuffer)
    : _pipeline_state_manager(pipeline_state_manager), _custom_frame_data_cbuffer(custom_frame_data_cbuffer),
      _shadow_renderer(pipeline_state_manager),
      _water_renderer(pipeline_state_manager),
      //_atmosphere_renderer(pipeline_state_manager),
      _post_processing_renderer(pipeline_state_manager)
{
}
void RenderingEngine::Initialize()
{
    _shadow_renderer.Initialize();
    _post_processing_renderer.Initialize();
    _water_renderer.Initialize();

    _current_aurora_texture = &_aurora_texture_0;
    _history_aurora_texture = &_aurora_texture_1;
}
void RenderingEngine::Terminate()
{
    _water_renderer.Terminate();
    _post_processing_renderer.Terminate();
    _shadow_renderer.Terminate();

    _responsive_aa_mask.Release();
    _aurora_texture_0.Release();
    _aurora_texture_1.Release();
}
void RenderingEngine::OnResize(int width, int height)
{
    _resolution = {width, height};
    _shadow_renderer.OnResize(width, height);
    _water_renderer.OnResize(width, height);
    _post_processing_renderer.OnResize(width, height);

    _responsive_aa_mask.Release();
    _responsive_aa_mask.Create(width, height);

    _aurora_texture_0.Release();
    _aurora_texture_0.Create(width / 2, height / 2);
    _aurora_texture_1.Release();
    _aurora_texture_1.Create(width / 2, height / 2);
}
void RenderingEngine::OnUpdateConstantBuffer(GameFrameData* data)
{
    if (data->projection_matrix._31 > 0)
    {
        _taa_jitter = {0.5f / _resolution.x, -0.5f / _resolution.y};
    }
    else
    {
        _taa_jitter = {-0.5f / _resolution.x, 0.5f / _resolution.y};
    }
    _custom_frame_data_cbuffer->taa_jitter = _taa_jitter;

    // create our own unjittered view projection matrix
    float fov = atanf(1.0f / data->projection_matrix._22) * 2;
    float aspect_ratio = data->screen_width / data->screen_height;
    // hardcode near plane to avoid flickering
    // because the near plane is dynamically adjusted by the game based on the camera's distance to the clostest object
    // 0.2 is the minimum near plane
    float near_plane = max(0.2f, data->near_plane);
    float far_plane = data->far_plane;
    // flipped near and far plane because of the reversed depth buffer
    XMMATRIX frustum_volume_projection = XMMatrixPerspectiveFovLH(fov, aspect_ratio, far_plane, 0.2);
    XMMATRIX view_matrix = XMLoadFloat4x4(&data->view_matrix);
    XMMATRIX frustum_volume_view_projection = view_matrix * frustum_volume_projection;
    XMMATRIX frustum_volume_view_projection_inverse = XMMatrixInverse(nullptr, frustum_volume_view_projection);

    XMStoreFloat4x4(&_custom_frame_data_cbuffer->frustum_volume_view_projection_matrix,
                    XMMatrixTranspose(frustum_volume_view_projection));
    XMStoreFloat4x4(&_custom_frame_data_cbuffer->frustum_volume_projection_matrix, XMMatrixTranspose(frustum_volume_projection));
    XMStoreFloat4x4(&_custom_frame_data_cbuffer->frustum_volume_inverse_view_projection_matrix,
                    XMMatrixTranspose(frustum_volume_view_projection_inverse));

    XMMATRIX projection_matrix = XMMatrixPerspectiveFovLH(fov, aspect_ratio, data->far_plane, data->near_plane);
    XMMATRIX view_projection_matrix = view_matrix * projection_matrix;
    XMStoreFloat4x4(&_custom_frame_data_cbuffer->view_projection_matrix, XMMatrixTranspose(view_projection_matrix));
    XMStoreFloat4x4(&_custom_frame_data_cbuffer->inverse_view_projection_matrix,
                    XMMatrixTranspose(XMMatrixInverse(nullptr, view_projection_matrix)));

    // based on: Padraic Hennessy, "Mixed Resolution Rendering in Skylanders: Superchargers"
    static constexpr float pi = 3.1415926535f;
    float pixel_angle = fov / _resolution.y;
    float plane_angle_rad = pi * 0.005;
    float sigma = cos(pixel_angle) * sin(plane_angle_rad);
    sigma /= sin(plane_angle_rad - pixel_angle);
    sigma = sigma - 1;
    _custom_frame_data_cbuffer->depth_similarity_sigma = sigma;

    if (_configuration.physical_ao)
    {
        // disable non ambient AO influence
        data->ssaoParams.x = 0;
        data->ssaoParams.y = 1;
    }

    if (_is_bob && _configuration.physical_sun)
    {
        // disable default sun in bob
        auto cb12 = reinterpret_cast<float4*>(data);
        cb12[203].x = 1000000;
    }
    _camera_lights_non_character_scale = data->localLightsExtraParams.x;
    if (_configuration.unify_player_light_influence && !_is_cutscene)
    {
        data->localLightsExtraParams.x = 1;
    }

    _is_inventory = data->screen_height == data->screen_width;

    _current_camera_position = float3(data->camera_position.x, data->camera_position.y, data->camera_position.z);
    _current_camera_direction = float3(data->view_matrix._13, data->view_matrix._23, data->view_matrix._33);
}
void RenderingEngine::OnUpdateConstantBuffer(GameLightingData* data)
{
    // Compute the width and depth of the shadow frustum
    XMMATRIX xm_shadow_matrix = XMLoadFloat4x4(&data->directional_shadow_matrix);
    XMMATRIX shadow_matrix_inverse = XMMatrixInverse(nullptr, xm_shadow_matrix);

    XMVECTOR xm_distance = XMVector3Length(XMVector4Transform(XMVectorSet(1, 0, 0, 0), shadow_matrix_inverse));
    float width;
    XMStoreFloat(&width, xm_distance);
    _custom_frame_data_cbuffer->cascade_penumbra_scale = 7.0f / (width - 1);

    xm_distance = XMVector3Length(XMVector4Transform(XMVectorSet(0, 0, 1, 0), shadow_matrix_inverse));
    float depth;
    XMStoreFloat(&depth, xm_distance);
    _custom_frame_data_cbuffer->cascade_shadow_map_depth_scale = depth / 2100.0f;

    _directional_light_direction.x = data->directional_light_direction.x;
    _directional_light_direction.y = data->directional_light_direction.y;
    _directional_light_direction.z = data->directional_light_direction.z;

    int artificial_light_count = 0;
    int scene_light_count = 0;
    _player_light_indices.clear();
    for (int i = 0; i < data->local_light_count; i++)
    {
        // that's an artifical light?
        if (data->local_lights[i].flags == -2147477504)
        {
            float3 color = data->local_lights[i].color;
            if (color.x == 0 && color.y == 0 && color.z == 0)
            {
                ++scene_light_count;
            }
            else
            {
                _player_light_indices.emplace_back(i);
            }
            float scale = _configuration.player_light_scale;
            if (_configuration.unify_player_light_influence)
            {
                scale *= _camera_lights_non_character_scale;
            }
            color.x *= scale;
            color.y *= scale;
            color.z *= scale;
            data->local_lights[i].color = color;
            ++artificial_light_count;
        }
    }
    if (scene_light_count > 0 && scene_light_count == artificial_light_count)
    {
        _is_cutscene = true;
    }
    else
    {
        _is_cutscene = false;
    }

    // precompute data for water shaders
    XMVECTOR xm_directional_light_direction = XMLoadFloat3(&_directional_light_direction);
    XMVECTOR xm_reflected_directional_light_direction = XMVector3Reflect(-xm_directional_light_direction, XMVectorSet(0, 0, 1, 0));
    XMVECTOR xm_directional_reflection_half_vector = XMVector3Normalize(
        xm_directional_light_direction + xm_reflected_directional_light_direction);
    XMVECTOR xm_cos_theta;
    xm_cos_theta = XMVector3Dot(xm_directional_reflection_half_vector, xm_directional_light_direction);
    float cos_theta;
    XMStoreFloat(&cos_theta, xm_cos_theta);
    _custom_frame_data_cbuffer->water_refracted_directional_light_fraction = 1 - FresnelSchlick(cos_theta, 0.02);

    XMVECTOR xm_refracted_directional_light_direction = XMVector3Refract(-xm_directional_light_direction, XMVectorSet(0, 0, 1, 0), 0.7519);
    xm_refracted_directional_light_direction = -XMVector3Normalize(xm_refracted_directional_light_direction);
    XMStoreFloat3(&(_custom_frame_data_cbuffer->water_refracted_directional_light_direction), xm_refracted_directional_light_direction);
}
void RenderingEngine::OnUpdateConstantBuffer(FrameCB* data)
{
    if (_configuration.anti_aliasing_method == ANTI_ALIASING_METHOD_VANILLA_PLUS || _configuration.anti_aliasing_method ==
        ANTI_ALIASING_METHOD_TAA)
    {
        // apply temporal AA jitter to vegetation
        XMMATRIX projection_matrix = XMLoadFloat4x4(&data->projection_matrix);
        XMMATRIX taa_jitter_matrix = XMMatrixTranspose(XMMatrixTranslation(_taa_jitter.x, _taa_jitter.y, 0));
        projection_matrix = taa_jitter_matrix * projection_matrix;
        XMStoreFloat4x4(&data->projection_matrix, projection_matrix);
    }
}
void RenderingEngine::OnUpdateConstantBuffer(GameTerrainData* data)
{
    _custom_frame_data_cbuffer->num_clipmap_levels = data->num_terrain_clipmap_levels;
    _custom_frame_data_cbuffer->terrain_size = data->terrain_size;
}
void RenderingEngine::OnUpdateConstantBuffer(GameWaterData* data)
{
    if (_configuration.enable_water)
    {
        XMVECTOR albedo;
        float extinction;
        if (_configuration.water_config_mode == CONFIG_MODE_ENV)
        {
            // clamp albedo luma
            float luma = (data->water_color.x + data->water_color.y + data->water_color.z) * 0.33;
            float clamped_luma = min(luma, _configuration.underwater_fog_color_max_luma);
            albedo = XMLoadFloat4(&data->water_color);
            albedo *= clamped_luma / max(luma, 0.0001);

            // temporal filter to reduce flickering
            _current_water_color_luma = (data->water_color.x + data->water_color.y + data->water_color.z) * 0.33f;
            float alpha = min(1, abs(_current_water_color_luma - _previous_water_color_luma) * 100) * 0.96f;
            XMVECTOR history_albedo = XMLoadFloat4(&_history_water_color);
            albedo = alpha * history_albedo + (1 - alpha) * albedo;
            XMStoreFloat4(&_history_water_color, albedo);

            extinction = max(data->underwater_fog_intensity, 0.0f) * _configuration.underwater_fog_density_scale;
        }
        else
        {
            albedo = XMLoadFloat3(&_configuration.underwater_fog_color);

            extinction = _configuration.underwater_fog_density;
        }

        XMVECTOR xm_scattering_coefficient = albedo * extinction;
        XMVECTOR xm_absorbtion_coefficient = XMVectorSet(1, 1, 1, 0) * extinction - xm_scattering_coefficient;

        const XMVECTOR WATER_BASE_ABSORBTION = XMVectorSet(0.35, 0.07, 0.03, 0) * 0.1;
        const XMVECTOR WATER_BASE_SCATTERING = XMVectorSet(0.0007, 0.0021, 0.0025, 0) * 0.1;
        xm_absorbtion_coefficient += WATER_BASE_ABSORBTION;
        xm_scattering_coefficient += WATER_BASE_SCATTERING;

        XMStoreFloat3(&_custom_frame_data_cbuffer->water_absorbtion_coefficient, xm_absorbtion_coefficient);
        XMStoreFloat3(&_custom_frame_data_cbuffer->water_scattering_coefficient, xm_scattering_coefficient);
    }

    _custom_frame_data_cbuffer->game_time = data->game_time;
}
bool RenderingEngine::OnDraw(RedShaderBinding red_shader_binding, UINT vertex_count, UINT start_vertex_location)
{
    int tonemap_shader_index = -1;
    ID3D11DeviceContext* d3d_context = GetD3DContext();
    switch (red_shader_binding.pixel_shader)
    {
    case RedPixelShaderId::REFLECTION_PROBE_BLUR:
        // skip first reflection probe blur
        return true;
    case RedPixelShaderId::UNDERWATER_MODIFY_GBUFFER:
        d3d_context->PSGetShaderResources(6, 1, _underwater_post_process_mask.ReleaseAndGetAddressOf());
        _apply_underwater_fog_mask = true;
        return false;
    case RedPixelShaderId::SHADOW_ANSEL:
        _is_ansel_enabled = true;
    case RedPixelShaderId::SHADOW:
        {
            if (_is_inventory)
            {
                _custom_frame_data_cbuffer->cinematic_border = 1;
            }
            else
            {
                _custom_frame_data_cbuffer->cinematic_border = 1 - (_is_cutscene
                                                                        ? _configuration.cinematic_border_cutscene
                                                                        : _configuration.cinematic_border_gameplay);
            }
            _custom_frame_data_cbuffer->is_camera_cut = IsCameraCut(_current_camera_position, _previous_camera_position,
                                                                    _current_camera_direction, _previous_camera_direction);
            _custom_frame_data_cbuffer.UploadBuffer();
            _shadow_renderer.RenderDirectionalShadows(_configuration.enable_contact_shadows);
            return true;
        }
        return false;
    case RedPixelShaderId::HAIRWORKS:
        _pipeline_state_manager.BindShader("HairWorksPS"_id);
        _pipeline_state_manager.BindResourcesForCurrentShaders();
        return false;
    case RedPixelShaderId::FOG:
        if (_apply_underwater_fog_mask)
        {
            _pipeline_state_manager.BindShader("FogPS"_id);
            _pipeline_state_manager.BindResourcesForCurrentShaders();
            _pipeline_state_manager.SetShaderResourceView(_underwater_post_process_mask.Get(), SHADER_TYPE_PIXEL, 64);
        }
        d3d_context->Draw(vertex_count, start_vertex_location);
        if (_configuration.enable_water)
        {
            _water_renderer.GrabUnfoggedScene(d3d_context);
        }
        return true;
    case RedPixelShaderId::UNDERWATER_FOG:
        if (_configuration.enable_water)
        {
            _water_renderer.DrawUnderwaterFog(d3d_context, vertex_count, start_vertex_location);
            return true;
        }
        return false;
    case RedPixelShaderId::TONEMAP_0:
        tonemap_shader_index = 0;
    case RedPixelShaderId::TONEMAP_1:
        {
            if (tonemap_shader_index < 0)
            {
                tonemap_shader_index = 1;
            }
            bool do_motion_blur = _configuration.enable_motion_blur && !_custom_frame_data_cbuffer->is_camera_cut;
            bool do_taa = _configuration.anti_aliasing_method == ANTI_ALIASING_METHOD_TAA;
            bool do_bloom = _configuration.bloom_scattering > 0.0001 || _configuration.enable_refractive_raindrops;

            _post_processing_renderer.HdrPostProcess(d3d_context, do_motion_blur, tonemap_shader_index, do_bloom, do_taa);
            if (!_enabled_water_shader_this_frame)
            {
                _is_water_shader_active = false;
            }
        }
        _water_renderer.ClearWaterBuffers(d3d_context);
        return true;
    case RedPixelShaderId::ANTI_ALIASING:
        if (_configuration.anti_aliasing_method == ANTI_ALIASING_METHOD_TAA)
        {
            if (_custom_frame_data_cbuffer->sharpening > 0)
            {
                _pipeline_state_manager.BindShader("SharpenPS"_id);
                _pipeline_state_manager.BindResourcesForCurrentShaders();
            }
            else
            {
                _pipeline_state_manager.BindShader("BlitPS"_id);
            }
        }
        return false;
    case RedPixelShaderId::DOF_GAMEPLAY_SETUP:
        if (_configuration.gameplay_dof_blur_type == DEPTH_OF_FIELD_BLUR_TYPE_BOKEH)
        {
            _pipeline_state_manager.BindShader("BokehGameplayDofSetupPS"_id);
        }
        else
        {
            _pipeline_state_manager.BindShader("GameplayDofMaskPS"_id);
            _pipeline_state_manager.BindResourcesForCurrentShaders();
        }
        return false;
    case RedPixelShaderId::DOF_GAMEPLAY_BLUR:
        if (_configuration.gameplay_dof_blur_type == DEPTH_OF_FIELD_BLUR_TYPE_BOKEH
            && (_configuration.gameplay_dof_intensity > 0 && _configuration.gameplay_dof_config_mode == CONFIG_MODE_GLOBAL
                || _configuration.gameplay_dof_intensity_scale > 0 && _configuration.gameplay_dof_config_mode == CONFIG_MODE_ENV))
        {
            XMINT2 half_resolution = { _resolution.x / 2, _resolution.y / 2 };

            // bind dof cbuffer to compute
            ComPtr<ID3D11Buffer> dof_cbuffer;
            d3d_context->PSGetConstantBuffers(3, 1, dof_cbuffer.GetAddressOf());
            ComPtr<ID3D11Buffer> orig_cb3;
            d3d_context->CSGetConstantBuffers(3, 1, orig_cb3.GetAddressOf());
            d3d_context->CSSetConstantBuffers(3, 1, dof_cbuffer.GetAddressOf());

            ComPtr<ID3D11ShaderResourceView> color_tex_srv;
            d3d_context->PSGetShaderResources(0, 1, color_tex_srv.GetAddressOf());


            // render full res circle of confusion
            RenderTexture* full_res_coc_texture = RenderTexture::GetTemporary(DXGI_FORMAT_R16_FLOAT,
                RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV,
                _resolution.x, _resolution.y);
            _pipeline_state_manager.SetUnorderedAccessView(full_res_coc_texture->GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
            _pipeline_state_manager.BindShader("BokehGameplayDofCocCS"_id);
            _pipeline_state_manager.BindResourcesForCurrentShaders();
            d3d_context->Dispatch(std::ceil(_resolution.x / 8.0), std::ceil(_resolution.y / 8.0), 1);
            _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 0);

            // compute circle of confusion and downsample to half resolution
            RenderTexture* half_res_color_coc_texture = RenderTexture::GetTemporary(DXGI_FORMAT_R16G16B16A16_FLOAT,
                                                                                    RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV,
                                                                                    _resolution.x / 2, _resolution.y / 2);
            _pipeline_state_manager.SetUnorderedAccessView(half_res_color_coc_texture->GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
            RenderTexture* half_res_min_coc_texture = RenderTexture::GetTemporary(DXGI_FORMAT_R16_FLOAT,
                RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV,
                _resolution.x / 2, _resolution.y / 2);
            _pipeline_state_manager.SetShaderResourceView(color_tex_srv.Get(), SHADER_TYPE_COMPUTE, 50);
            _pipeline_state_manager.SetShaderResourceView(full_res_coc_texture->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 52);
            _pipeline_state_manager.SetUnorderedAccessView(half_res_min_coc_texture->GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 1);
            _pipeline_state_manager.BindShader("BokehGameplayDofDownsampleCS"_id);
            _pipeline_state_manager.BindResourcesForCurrentShaders();
            d3d_context->Dispatch(std::ceil(half_resolution.x / 8.0), std::ceil(half_resolution.y / 8.0), 1);
            _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 0);
            _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 1);

            // main blur pass
            RenderTexture* blurred_texture = RenderTexture::GetTemporary(DXGI_FORMAT_R16G16B16A16_FLOAT,
                RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV,
                _resolution.x / 2, _resolution.y / 2);
            _pipeline_state_manager.SetShaderResourceView(half_res_color_coc_texture->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 50);
            _pipeline_state_manager.SetShaderResourceView(half_res_min_coc_texture->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 51);
            _pipeline_state_manager.BindShader("BokehGameplayDofBlurCS"_id);
            _pipeline_state_manager.BindResourcesForCurrentShaders();
            _pipeline_state_manager.SetUnorderedAccessView(blurred_texture->GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
            d3d_context->Dispatch(std::ceil(half_resolution.x / 8.0), std::ceil(half_resolution.y / 8.0), 1);
            _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 0);

            // max filter / flood fill
            _pipeline_state_manager.SetShaderResourceView(blurred_texture->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 50);
            _pipeline_state_manager.BindShader("BokehGameplayDofFillCS"_id);
            _pipeline_state_manager.BindResourcesForCurrentShaders();
            _pipeline_state_manager.SetUnorderedAccessView(half_res_color_coc_texture->GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
            d3d_context->Dispatch(std::ceil(half_resolution.x / 8.0), std::ceil(half_resolution.y / 8.0), 1);
            _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 0);

            // upsample and blend
            _pipeline_state_manager.SetShaderResourceView(half_res_color_coc_texture->GetShaderResourceView(), SHADER_TYPE_PIXEL, 50);
            _pipeline_state_manager.SetShaderResourceView(full_res_coc_texture->GetShaderResourceView(), SHADER_TYPE_PIXEL, 52);
            _pipeline_state_manager.BindShader("BokehGameplayDofCompositePS"_id);
            _pipeline_state_manager.BindResourcesForCurrentShaders();
            d3d_context->Draw(vertex_count, start_vertex_location);

            RenderTexture::ReleaseTemporary(blurred_texture);
            RenderTexture::ReleaseTemporary(half_res_min_coc_texture);
            RenderTexture::ReleaseTemporary(half_res_color_coc_texture);
            RenderTexture::ReleaseTemporary(full_res_coc_texture);
            d3d_context->CSSetConstantBuffers(3, 1, orig_cb3.GetAddressOf());
            return true;
        }
        // vanilla DOF
        _pipeline_state_manager.BindShader("GameplayDofBlurPS"_id);
        _pipeline_state_manager.BindResourcesForCurrentShaders();
        return false;
    default:
        break;
    }
    return false;
}
bool RenderingEngine::OnDrawInstanced(RedShaderBinding red_shader_binding, UINT vertex_count_per_instance, UINT instance_count,
                                      UINT start_vertex_location, UINT start_instance_location)
{
    return false;
}
bool RenderingEngine::OnDrawIndexed(RedShaderBinding red_shader_binding, UINT index_count, UINT start_index_location,
                                    INT base_vertex_location)
{
    ID3D11DeviceContext* d3d_context = GetD3DContext();
    switch (red_shader_binding.pixel_shader)
    {
    case RedPixelShaderId::SKY:
        _is_bob = false;
        if (!_is_before_lighting_pass && _configuration.enable_aurora)
        {
            XMINT2 half_resolution = {_resolution.x / 2, _resolution.y / 2};

            // precompute aurora shape
            RenderTexture* aurora_shape_texture = RenderTexture::GetTemporary(
                DXGI_FORMAT_R16_FLOAT, RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV, 1024, 1024
            );
            _pipeline_state_manager.SetUnorderedAccessView(aurora_shape_texture->GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
            _pipeline_state_manager.BindShader("AuroraShapeCS"_id);
            _pipeline_state_manager.BindResourcesForCurrentShaders();
            d3d_context->Dispatch(std::ceil(1024.0f / 8.0f), std::ceil(1024.0f / 8.0f), 1);
            _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 0);

            RenderTexture* aurora_detail_texture = RenderTexture::GetTemporary(
                DXGI_FORMAT_R16G16_FLOAT, RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV, 256, 256
            );
            _pipeline_state_manager.SetUnorderedAccessView(aurora_detail_texture->GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
            _pipeline_state_manager.BindShader("AuroraDetailCS"_id);
            _pipeline_state_manager.BindResourcesForCurrentShaders();
            d3d_context->Dispatch(std::ceil(256.0f / 8.0f), std::ceil(256.0f / 8.0f), 1);
            _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 0);

            // raymarch half res aurora
            RenderTexture* tmp_texture = RenderTexture::GetTemporary(
                DXGI_FORMAT_R11G11B10_FLOAT, RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV, half_resolution.x, half_resolution.y
            );

            _pipeline_state_manager.SetShaderResourceView(aurora_shape_texture->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 0);
            _pipeline_state_manager.SetShaderResourceView(aurora_detail_texture->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 1);
            _pipeline_state_manager.SetUnorderedAccessView(tmp_texture->GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
            _pipeline_state_manager.BindShader("AuroraRaymarchCS"_id);
            _pipeline_state_manager.BindResourcesForCurrentShaders();
            d3d_context->Dispatch(std::ceil(half_resolution.x / 8.0), std::ceil(half_resolution.y / 8.0), 1);
            _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 0);

            RenderTexture::ReleaseTemporary(aurora_detail_texture);
            RenderTexture::ReleaseTemporary(aurora_shape_texture);

            // temporal filter
            _pipeline_state_manager.SetShaderResourceView(tmp_texture->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 0);
            _pipeline_state_manager.SetShaderResourceView(_history_aurora_texture->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 1);
            _pipeline_state_manager.SetUnorderedAccessView(_current_aurora_texture->GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
            _pipeline_state_manager.BindShader("AuroraTemporalFilterCS"_id);
            _pipeline_state_manager.BindResourcesForCurrentShaders();
            d3d_context->Dispatch(std::ceil(half_resolution.x / 8.0), std::ceil(half_resolution.y / 8.0), 1);
            _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 0);

            RenderTexture::ReleaseTemporary(tmp_texture);

            // apply to sky
            _pipeline_state_manager.SetShaderResourceView(_current_aurora_texture->GetShaderResourceView(), SHADER_TYPE_PIXEL, 32);
            _pipeline_state_manager.BindShader("SkyPS"_id);
            _pipeline_state_manager.BindResourcesForCurrentShaders();
            d3d_context->DrawIndexed(index_count, start_index_location, base_vertex_location);

            std::swap(_current_aurora_texture, _history_aurora_texture);
            return true;
        }
        return false;
    case RedPixelShaderId::SKY_BOB:
        _is_bob = true;
        if (_configuration.physical_sun)
        {
            d3d_context->DrawIndexed(index_count, start_index_location, base_vertex_location);

            // Draw bob sun
            _pipeline_state_manager.BindShader("SunBobPS"_id);
            _pipeline_state_manager.BindResourcesForCurrentShaders();
            d3d_context->DrawIndexed(index_count, start_index_location, base_vertex_location);

            return true;
        }
        return false;
    case RedPixelShaderId::SUN:
        if (_configuration.physical_sun)
        {
            ComPtr<ID3D11Buffer> cb2;
            d3d_context->VSGetConstantBuffers(2, 1, cb2.GetAddressOf());
            _pipeline_state_manager.SetGlobalConstantBuffer(cb2.Get(), "_SunGeometryData"_id);
            _pipeline_state_manager.BindShader("SunVS"_id);
            _pipeline_state_manager.BindShader("SunPS"_id);
            _pipeline_state_manager.BindResourcesForCurrentShaders();
            d3d_context->DrawIndexed(index_count, start_index_location, base_vertex_location);
            return true;
        }
        return false;
    case RedPixelShaderId::FIRE_SPARK:
        if (_configuration.anti_aliasing_method == ANTI_ALIASING_METHOD_TAA)
        {
            // save original render targets
            ID3D11RenderTargetView* orig_rtvs[2] = {nullptr, nullptr};
            ComPtr<ID3D11DepthStencilView> orig_dsv;
            d3d_context->OMGetRenderTargets(2, orig_rtvs, orig_dsv.GetAddressOf());
            ID3D11RenderTargetView* new_rtvs[2] = {orig_rtvs[0], _responsive_aa_mask.GetRenderTargetView()};
            d3d_context->OMSetRenderTargets(2, new_rtvs, orig_dsv.Get());

            _pipeline_state_manager.BindShader("FireSparkPS"_id);
            d3d_context->DrawIndexed(index_count, start_index_location, base_vertex_location);

            d3d_context->OMSetRenderTargets(2, orig_rtvs, orig_dsv.Get());

            if (orig_rtvs[0] != nullptr)
            {
                orig_rtvs[0]->Release();
            }
            if (orig_rtvs[1] != nullptr)
            {
                orig_rtvs[1]->Release();
            }
            return true;
        }
        return false;

    default:
        break;
    }
    return false;
}
bool RenderingEngine::OnDrawIndexedInstanced(RedShaderBinding red_shader_binding, UINT index_count_per_instance, UINT instance_count,
                                             UINT start_index_location, INT base_vertex_location, UINT start_instance_location)
{
    ID3D11DeviceContext* d3d_context = GetD3DContext();
    switch (red_shader_binding.pixel_shader)
    {
    case RedPixelShaderId::WATER:
        if (_configuration.enable_water)
        {
            _water_renderer.DrawWater(d3d_context, index_count_per_instance, instance_count, start_index_location,
                                      base_vertex_location, start_instance_location, _responsive_aa_mask.GetRenderTargetView());
        }
        _is_water_shader_active = true;
        _enabled_water_shader_this_frame = true;
        return _configuration.enable_water;
    case RedPixelShaderId::HAIR:
        _pipeline_state_manager.BindShader("HairPS"_id);
        _pipeline_state_manager.BindResourcesForCurrentShaders();
        return false;
    case RedPixelShaderId::HAIR_TRANSPARENCY:
        _pipeline_state_manager.BindShader("HairTransparencyPS"_id);
        _pipeline_state_manager.BindResourcesForCurrentShaders();
        return false;
    case RedPixelShaderId::RAIN_DROPS:
        if (_configuration.enable_refractive_raindrops && !_is_before_lighting_pass)
        {
            _post_processing_renderer.DrawRainDrops(d3d_context, index_count_per_instance, instance_count, start_index_location,
                                                    base_vertex_location, start_instance_location,
                                                    _responsive_aa_mask.GetRenderTargetView());
            return true;
        }
        return false;
    case RedPixelShaderId::RAIN_DROPS_BOB:
        if (_configuration.enable_refractive_raindrops && !_is_before_lighting_pass)
        {
            _post_processing_renderer.DrawRainDropsBob(d3d_context, index_count_per_instance, instance_count, start_index_location,
                                                       base_vertex_location, start_instance_location,
                                                       _responsive_aa_mask.GetRenderTargetView());
        }
        return false;
    default:
        break;
    }
    return false;
}
bool RenderingEngine::OnDispatch(RedShaderBinding red_shader_binding, UINT thread_group_count_x, UINT thread_group_count_y,
                                 UINT thread_group_count_z)
{
    ID3D11DeviceContext* d3d_context = GetD3DContext();
    switch (red_shader_binding.compute_shader)
    {
    case RedComputeShaderId::DEFERRED_LIGHTING:
        {
            if (_is_water_shader_active && _configuration.enable_water)
            {
                _water_renderer.DrawWaterDepth(d3d_context);

                // TODO: modify albedo with compute shader
                // TODO: copy result to albedo resource
                // TODO: flush command buffer
            }

            _is_before_lighting_pass = false;
            _pipeline_state_manager.BindShader("LightingCS"_id);
            _pipeline_state_manager.BindResourcesForCurrentShaders();
            d3d_context->Dispatch(thread_group_count_x, thread_group_count_y, thread_group_count_z);

            _shadow_renderer.StorePreviousSceneDepth();
            return true;
        }
    default:
        break;
    }
    return false;
}

void RenderingEngine::OnPresent()
{
    _frame_count++;
    if (GetTime() > 1.0f)
    {
        _frame_count = 0;
        StartTimer();
    }
    _frame_time = RefreshFrameTime();

    _enabled_water_shader_this_frame = false;
    _is_ansel_enabled = false;

    _custom_frame_data_cbuffer->frame_counter++;
    _custom_frame_data_cbuffer->frame_time_seconds = _frame_time;
    _custom_frame_data_cbuffer->frustum_volume_previous_view_projection_matrix = _custom_frame_data_cbuffer->
        frustum_volume_view_projection_matrix;

    _custom_frame_data_cbuffer->history_view_projection_matrix_2 = _custom_frame_data_cbuffer->history_view_projection_matrix;
    _custom_frame_data_cbuffer->history_view_projection_matrix = _custom_frame_data_cbuffer->view_projection_matrix;

    _custom_frame_data_cbuffer->water_depth_volume_params = _water_renderer.GetWaterDepthVolumeParams();

    _is_before_lighting_pass = true;

    _previous_camera_position = _current_camera_position;
    _previous_camera_direction = _current_camera_direction;

    _previous_water_color_luma = _current_water_color_luma;

    _player_light_indices.clear();

    // clear responsive AA mask
    static const float responsive_aa_clear_color[4] = {0, 0, 0, 0};
    GetD3DContext()->ClearRenderTargetView(_responsive_aa_mask.GetRenderTargetView(), responsive_aa_clear_color);

    _pipeline_state_manager.SetGlobalShaderResource(_responsive_aa_mask.GetShaderResourceView(), "_responsive_aa_mask"_id);

    _apply_underwater_fog_mask = false;
}
void RenderingEngine::SetConfiguration(Configuration configuration)
{
    _configuration = configuration;
    _custom_frame_data_cbuffer->bloom_scattering = configuration.bloom_scattering;
    _custom_frame_data_cbuffer->modify_tonemap = configuration.enable_tonemap;
    _custom_frame_data_cbuffer->exposure_scale = configuration.exposure_scale;
    _custom_frame_data_cbuffer->enable_custom_sun_radius = configuration.enable_custom_sun_radius;
    _custom_frame_data_cbuffer->custom_sun_radius = configuration.sun_radius * 10.0f;
    _custom_frame_data_cbuffer->enable_parametric_color_balance = !configuration.disable_parametric_balance;
    _custom_frame_data_cbuffer->debug_view_mode = configuration.debug_view_mode;
    _custom_frame_data_cbuffer->hdr_contrast = configuration.hdr_contrast;
    _custom_frame_data_cbuffer->vignette_intensity = configuration.vignette_intensity;
    _custom_frame_data_cbuffer->vignette_exponent = configuration.vignette_exponent;
    _custom_frame_data_cbuffer->vignette_start_offset = configuration.vignette_start_offset;
    _custom_frame_data_cbuffer->sharpening = configuration.taa_sharpening;
    _custom_frame_data_cbuffer->underwater_fog_diffusion_scale = configuration.underwater_fog_diffusion;
    _custom_frame_data_cbuffer->underwater_fog_anisotropy = configuration.underwater_fog_anisotropy;
    _custom_frame_data_cbuffer->water_depth_scale = configuration.water_depth_scale;
    _custom_frame_data_cbuffer->taa_history_sharpening = configuration.taa_history_sharpening;
    _custom_frame_data_cbuffer->taa_resolve_outer_weight = std::expf(-2.29f * powf(2.0f / configuration.taa_resolve_filter_width, 2.0f));
    _custom_frame_data_cbuffer->taa_resolve_quincunx_weight = std::expf(
        -2.29f * powf(sqrtf(0.5f) * 2.0f / configuration.taa_resolve_filter_width, 2.0f));
    _custom_frame_data_cbuffer->aurora_brightness = configuration.aurora_brightness;
    _custom_frame_data_cbuffer->aurora_color_bottom = configuration.aurora_color_bottom;
    _custom_frame_data_cbuffer->aurora_color_top = configuration.aurora_color_top;
    _custom_frame_data_cbuffer->enable_soft_shadows = configuration.enable_soft_shadows;
    _custom_frame_data_cbuffer->enable_pbr_lighting = configuration.enable_pbr_lighting;
    _custom_frame_data_cbuffer->gameplay_dof_intensity = configuration.gameplay_dof_intensity;
    _custom_frame_data_cbuffer->gameplay_dof_blur_distance = configuration.gameplay_dof_blur_distance;
    _custom_frame_data_cbuffer->gameplay_dof_focus_distance = configuration.gameplay_dof_focus_distance;
    _custom_frame_data_cbuffer->enable_custom_gameplay_dof_params = configuration.gameplay_dof_config_mode == CONFIG_MODE_GLOBAL;
    _custom_frame_data_cbuffer->gameplay_dof_intensity_scale = configuration.gameplay_dof_intensity_scale;

    static const int hairworks_shadow_sample_counts[] = {2, 4, 8, 16};
    int sample_count_index = std::clamp(configuration.hairworks_shadow_quality, 0, 3);
    _custom_frame_data_cbuffer->hairworks_shadow_sample_count = hairworks_shadow_sample_counts[sample_count_index];

    if (configuration.enable_hdr_color_filter)
    {
        // normalize the color filter w.r.t. luminance
        float hdr_color_filter_luma = configuration.hdr_color_filter.x * 0.2126f + configuration.hdr_color_filter.y * 0.7152f +
            configuration.hdr_color_filter.z * 0.0722f;
        hdr_color_filter_luma = max(0.01, hdr_color_filter_luma);
        float3 normalized_hdr_filter;
        normalized_hdr_filter.x = configuration.hdr_color_filter.x / hdr_color_filter_luma;
        normalized_hdr_filter.y = configuration.hdr_color_filter.y / hdr_color_filter_luma;
        normalized_hdr_filter.z = configuration.hdr_color_filter.z / hdr_color_filter_luma;
        _custom_frame_data_cbuffer->hdr_color_filter = normalized_hdr_filter;
    }
    else
    {
        _custom_frame_data_cbuffer->hdr_color_filter = float3(1, 1, 1);
    }

    _custom_frame_data_cbuffer->hdr_saturation = configuration.hdr_saturation;
}
bool RenderingEngine::IsCutscene() const
{
    return _is_cutscene;
}
const std::vector<int> RenderingEngine::GetPlayerLightIndices() const
{
    return _player_light_indices;
}
double RenderingEngine::GetFrameTime() const
{
    return _frame_time;
}
void RenderingEngine::StartTimer()
{
    LARGE_INTEGER frequency_count;
    QueryPerformanceFrequency(&frequency_count);

    _counts_per_second = static_cast<double>(frequency_count.QuadPart);

    QueryPerformanceCounter(&frequency_count);
    _counter_start = frequency_count.QuadPart;
}
double RenderingEngine::GetTime()
{
    LARGE_INTEGER currentTime;
    QueryPerformanceCounter(&currentTime);
    return static_cast<double>(currentTime.QuadPart - _counter_start) / _counts_per_second;
}
double RenderingEngine::RefreshFrameTime()
{
    LARGE_INTEGER current_time;
    __int64 tick_count;
    QueryPerformanceCounter(&current_time);

    tick_count = current_time.QuadPart - _frame_time_old;
    _frame_time_old = current_time.QuadPart;

    if (tick_count < 0.0f)
    {
        tick_count = 0.0f;
    }
    return static_cast<double>(tick_count) / _counts_per_second;
}
bool RenderingEngine::IsCameraCut(const float3& current_camera_position, const float3& previous_camera_position,
                                  const float3& current_camera_direction, const float3 previous_camera_direction)
{
    float cos_camera_direction_frame_delta;
    XMStoreFloat(&cos_camera_direction_frame_delta,
                 XMVector3Dot(XMLoadFloat3(&current_camera_direction), XMLoadFloat3(&previous_camera_direction))
    );
    XMVECTOR translation = XMLoadFloat3(&current_camera_position) - XMLoadFloat3(&previous_camera_position);
    float squared_camera_position_frame_delta;
    XMStoreFloat(&squared_camera_position_frame_delta, XMVector3Dot(translation, translation));
    float position_delta = sqrtf(squared_camera_position_frame_delta);

    return cos_camera_direction_frame_delta < 0.25 || position_delta > 2;
}
