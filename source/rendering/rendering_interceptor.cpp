#include "rendering_interceptor.h"
#include "gui.h"

#include "external/imgui/imgui.h"
#include "external/imgui/imgui_curve.h"

#include <unordered_set>

#include "external/DirectXTex.h"
#include "external/aixlog.h"

//#define ENABLE_EXPERIMENTAL_FEATURES

using namespace w3;
using namespace DirectX;
using namespace Microsoft::WRL;

void RenderingInterceptor::Initialize(ID3D11Device* d3d_device, ID3D11DeviceContext* d3d_context)
{
    LOG(INFO) << "Initializing Blitz Renderer" << std::endl;

    D3DInterface::Initialize(d3d_device, d3d_context);
    _rendering_engine.Initialize();

    _custom_frame_data_cbuffer.Create(true);
    _pipeline_state_manager.SetGlobalConstantBuffer(_custom_frame_data_cbuffer.GetBuffer(), "_CustomFrameData"_id);

    _enabled = true;
    _initialized = true;
    // Call OnResize() in case it was called before the RenderingInterceptor was initialized
    OnResize(_resolution.x, _resolution.y);
}
void RenderingInterceptor::Terminate()
{
    //_resource_manager.SaveConfig(_rendering_engine.GetConfiguration());
    LOG(INFO) << "Terminating Blitz Renderer" << std::endl;
    _velocity_g_buffer.Release();
    _custom_frame_data_cbuffer.Release();
    _rendering_engine.Terminate();
}
void RenderingInterceptor::OnResize(int width, int height)
{
    _resolution = {width, height};
    if (_initialized)
    {
        _rendering_engine.OnResize(width, height);

        _velocity_g_buffer.Release();
        _velocity_g_buffer.Create(width, height);
    }
}
void RenderingInterceptor::OnMap(ID3D11Resource* pResource, UINT Subresource, D3D11_MAP MapType, UINT MapFlags,
                                 D3D11_MAPPED_SUBRESOURCE* pMappedResource)
{
    if (pMappedResource != nullptr)
    {
        _mapped_data = pMappedResource->pData;
        _mapped_row_pitch = pMappedResource->RowPitch;
    }
    else
    {
        _mapped_data = nullptr;
        _mapped_row_pitch = 0;
    }
}
void RenderingInterceptor::OnUnmap(ID3D11Resource* pResource, UINT Subresource)
{
    if (!_enabled || _mapped_data == nullptr)
    {
        return;
    }
    if (pResource == _game_frame_data_cbuffer.Get() && _mapped_row_pitch > sizeof(GameFrameData))
    {
        auto* data = static_cast<GameFrameData*>(_mapped_data);
        _rendering_engine.OnUpdateConstantBuffer(data);
    }
    else if (pResource == _game_lighting_data_cbuffer.Get() && _mapped_row_pitch >= sizeof(GameLightingData))
    {
        auto* data = static_cast<GameLightingData*>(_mapped_data);
        _rendering_engine.OnUpdateConstantBuffer(data);
    }
    else if (pResource == _game_frame_cb_cbuffer.Get() && _is_after_first_g_buffer_pass && _mapped_row_pitch >= sizeof(
        FrameCB))
    {
        auto* data = static_cast<FrameCB*>(_mapped_data);
        _rendering_engine.OnUpdateConstantBuffer(data);
    }
    else if (pResource == _game_terrain_data_cbuffer.Get() && _mapped_row_pitch >= sizeof(GameTerrainData))
    {
        auto* data = static_cast<GameTerrainData*>(_mapped_data);
        _rendering_engine.OnUpdateConstantBuffer(data);
    }
    else if (pResource == _game_water_data_cbuffer.Get() && _mapped_row_pitch >= sizeof(GameWaterData) && !_is_before_lighting)
    {
        auto* data = static_cast<GameWaterData*>(_mapped_data);
        _rendering_engine.OnUpdateConstantBuffer(data);
    }
    else
    {
        if (_mapped_row_pitch >= sizeof(WindDynamicsCB))
        {
            auto iterator = _wind_dynamics_cbuffer_map.find(pResource);
            if (iterator != _wind_dynamics_cbuffer_map.end())
            {
                // copy WindDynamicsCB for next frame
                auto* previous_frame_cbuffer = iterator->second;
                std::memcpy(previous_frame_cbuffer->operator->()->data, _mapped_data, sizeof(WindDynamicsCB));
            }
        }
    }
}
void RenderingInterceptor::OnCopySubresourceRegion(ID3D11DeviceContext* d3d_context, ID3D11Resource* pDstResource, UINT DstSubresource,
                                                   UINT DstX, UINT DstY, UINT DstZ,
                                                   ID3D11Resource* pSrcResource, UINT SrcSubresource, const D3D11_BOX* pSrcBox)
{
    D3D11_BOX* new_src_box_ptr = nullptr;
    D3D11_BOX new_src_box;
    UINT new_DstX = DstX;
    if (pSrcBox != nullptr)
    {
        if (_enabled)
        {
            UINT buffer_size = pSrcBox->right;
            if (pDstResource == _game_lighting_data_cbuffer.Get() && !_rendering_engine.IsCutscene() && buffer_size >= sizeof(
                GameLightingData))
            {
                static GameLightingData dummy;

                const auto& player_light_indices = _rendering_engine.GetPlayerLightIndices();

                if (player_light_indices.empty())
                {
                    d3d_context->CopySubresourceRegion(pDstResource, DstSubresource, new_DstX, DstY, DstZ, pSrcResource, SrcSubresource,
                                                       new_src_box_ptr);
                }
                else
                {
                    // dont' overwrite player lights
                    uint64_t offset = reinterpret_cast<uint64_t>(&dummy.local_lights[player_light_indices[0]]) - reinterpret_cast<uint64_t>(
                        &dummy);
                    new_src_box = *pSrcBox;

                    new_DstX = 0;
                    new_src_box.right = offset;

                    new_src_box_ptr = &new_src_box;
                    d3d_context->CopySubresourceRegion(pDstResource, DstSubresource, new_DstX, DstY, DstZ, pSrcResource, SrcSubresource,
                                                       new_src_box_ptr);

                    // copy data after last player light
                    {
                        new_DstX = offset + sizeof(GameLightingData::LocalLight) * (1 + player_light_indices.back() - player_light_indices[0
                        ]);
                        new_src_box.left = new_DstX;
                        new_src_box.right = pSrcBox->right;

                        if (new_src_box.right - new_src_box.left > 0)
                        {
                            new_src_box_ptr = &new_src_box;
                            d3d_context->CopySubresourceRegion(pDstResource, DstSubresource, new_DstX, DstY, DstZ, pSrcResource,
                                                               SrcSubresource,
                                                               new_src_box_ptr);
                        }
                    }
                    // copy data between player lights
                    if (player_light_indices.back() - player_light_indices[0] > 1)
                    {
                        new_DstX = reinterpret_cast<uint64_t>(&dummy.local_lights[player_light_indices[0] + 1]) - reinterpret_cast<uint64_t>
                            (&dummy);
                        new_src_box.left = new_DstX;
                        new_src_box.right = reinterpret_cast<uint64_t>(&dummy.local_lights[player_light_indices.back() - 1]) -
                            reinterpret_cast<uint64_t>(&dummy);

                        new_src_box_ptr = &new_src_box;
                        d3d_context->CopySubresourceRegion(pDstResource, DstSubresource, new_DstX, DstY, DstZ, pSrcResource, SrcSubresource,
                                                           new_src_box_ptr);
                    }
                }
                return;
            }
        }
    }
    d3d_context->CopySubresourceRegion(pDstResource, DstSubresource, new_DstX, DstY, DstZ, pSrcResource, SrcSubresource, new_src_box_ptr);
}
void RenderingInterceptor::OnSetRenderTargets(ID3D11DeviceContext* d3d_context, UINT num_views,
                                              ID3D11RenderTargetView* const* render_target_views,
                                              ID3D11DepthStencilView* depth_stencil_view)
{
    _is_render_target_bound = num_views > 0;
    _is_depth_buffer_bound = depth_stencil_view != nullptr;

    if (num_views == 3 && _enabled)
    {
        _is_after_first_g_buffer_pass = true;
        _g_buffer_bind_count++;

        if (_is_before_lighting && _g_buffer_bind_count >= 2 && _rendering_engine.GetConfiguration().anti_aliasing_method == ANTI_ALIASING_METHOD_TAA)
        {
            ID3D11RenderTargetView* rtvs[4];
            rtvs[0] = render_target_views[0];
            rtvs[1] = render_target_views[1];
            rtvs[2] = render_target_views[2];
            rtvs[3] = _velocity_g_buffer.GetRenderTargetView();

            d3d_context->OMSetRenderTargets(4, rtvs, depth_stencil_view);
            return;
        }
    }

    d3d_context->OMSetRenderTargets(num_views, render_target_views, depth_stencil_view);
}
void RenderingInterceptor::AssignReplacementShader(const ShaderSignature& shader_signature, const ID3D11DeviceChild* shader)
{
    const auto& replacement_shader = _shader_config.GetReplacementShader(shader_signature);
    _replacement_shaders[shader] = replacement_shader;

    // get shader to create it 
    _resource_manager.GetShader(replacement_shader.shader_name_string_id_hash);
}
bool RenderingInterceptor::BindReplacementShader(const ID3D11DeviceChild* d3d_shader, REPLACEMENT_SHADER_INDEX index)
{
    auto iterator = _replacement_shaders.find(d3d_shader);
    bool bound_custom_shader = false;
    if (iterator != _replacement_shaders.end())
    {
        const ReplacementShader& replacement_shader = iterator->second;
        if (
            (!((replacement_shader.condition & REPLACEMENT_SHADER_CONDITION_WATER_ENABLED) != 0) || _rendering_engine
                                                                                                    .GetConfiguration().enable_water)
            && (!((replacement_shader.condition & REPLACEMENT_SHADER_CONDITION_TAA_ENABLED) != 0) || _rendering_engine
                                                                                                     .GetConfiguration().
                                                                                                     anti_aliasing_method ==
                ANTI_ALIASING_METHOD_TAA)
            && (!((replacement_shader.condition & REPLACEMENT_SHADER_CONDITION_CUSTOM_VANILLA_DOF_ENABLED) != 0) || _rendering_engine
                .GetConfiguration().gameplay_dof_blur_type == DEPTH_OF_FIELD_BLUR_TYPE_VANILLA)
        )
        {
            switch (replacement_shader.type)
            {
            case ReplacementShaderType::GENERIC:
                _current_replacement_shaders[index] = replacement_shader.shader_name_string_id_hash;
                return false;
            case ReplacementShaderType::SIMPLE:
                {
                    Shader* shader = _resource_manager.GetShader(replacement_shader.shader_name_string_id_hash);
                    if (shader != nullptr)
                    {
                        shader->Bind();
                        return true;
                    }
                }
            default:
                break;
            }
        }
    }
    _current_replacement_shaders[index] = 0;
    return false;
}
void RenderingInterceptor::OnCreatedVertexShader(const void* shader_bytecode, const ID3D11VertexShader* vertex_shader)
{
    ShaderSignature shader_signature(shader_bytecode);
    AssignReplacementShader(shader_signature, vertex_shader);

    RedVertexShaderId vertex_shader_id = _shader_config.GetCheckpointVertexShaderId(shader_signature);
    if (vertex_shader_id != RedVertexShaderId::UNKNOWN)
    {
        // don't store unknown is hash map; would just slow down the look up
        _red_vertex_shaders[vertex_shader] = vertex_shader_id;
    }
}
void RenderingInterceptor::OnCreatedHullShader(const void* shader_bytecode, const ID3D11HullShader* hull_shader)
{
    ShaderSignature shader_signature(shader_bytecode);
    AssignReplacementShader(shader_signature, hull_shader);

    RedHullShaderId hull_shader_id = _shader_config.GetCheckpointHullShaderId(shader_signature);
    if (hull_shader_id != RedHullShaderId::UNKNOWN)
    {
        // don't store unknown is hash map; would just slow down the look up
        _red_hull_shaders[hull_shader] = hull_shader_id;
    }
}
void RenderingInterceptor::OnCreatedDomainShader(const void* shader_bytecode, const ID3D11DomainShader* domain_shader)
{
    ShaderSignature shader_signature(shader_bytecode);
    AssignReplacementShader(shader_signature, domain_shader);

    RedDomainShaderId domain_shader_id = _shader_config.GetCheckpointDomainShaderId(shader_signature);
    if (domain_shader_id != RedDomainShaderId::UNKNOWN)
    {
        // don't store unknown is hash map; would just slow down the look up
        _red_domain_shaders[domain_shader] = domain_shader_id;
    }
}
void RenderingInterceptor::OnCreatedGeometryShader(const void* shader_bytecode, const ID3D11GeometryShader* geometry_shader)
{
    ShaderSignature shader_signature(shader_bytecode);
    AssignReplacementShader(shader_signature, geometry_shader);
}
void RenderingInterceptor::OnCreatedPixelShader(const void* shader_bytecode, const ID3D11PixelShader* pixel_shader)
{
    ShaderSignature shader_signature(shader_bytecode);
    AssignReplacementShader(shader_signature, pixel_shader);

    RedPixelShaderId pixel_shader_id = _shader_config.GetCheckpointPixelShaderId(shader_signature);
    if (pixel_shader_id != RedPixelShaderId::UNKNOWN)
    {
        // don't store unknown is hash map; would just slow down the look up
        _red_pixel_shaders[pixel_shader] = pixel_shader_id;
    }
}
void RenderingInterceptor::OnCreatedComputeShader(const void* shader_bytecode, const ID3D11ComputeShader* compute_shader)
{
    ShaderSignature shader_signature(shader_bytecode);
    AssignReplacementShader(shader_signature, compute_shader);

    RedComputeShaderId compute_shader_id = _shader_config.GetCheckpointComputeShaderId(shader_signature);
    if (compute_shader_id != RedComputeShaderId::UNKNOWN)
    {
        // don't store unknown is hash map; would just slow down the look up
        _red_compute_shaders[compute_shader] = compute_shader_id;
    }
}
bool RenderingInterceptor::OnSetVertexShader(const ID3D11VertexShader* vertex_shader)
{
    if (!_enabled)
    {
        return false;
    }
    bool bound_custom_shader = BindReplacementShader(vertex_shader, REPLACEMENT_SHADER_INDEX_VERTEX);

    auto it = _red_vertex_shaders.find(vertex_shader);
    if (it != _red_vertex_shaders.end())
    {
        _current_bound_vertex_shader = it->second;
    }
    else
    {
        _current_bound_vertex_shader = RedVertexShaderId::UNKNOWN;
    }
    return bound_custom_shader;
}
bool RenderingInterceptor::OnSetHullShader(const ID3D11HullShader* hull_shader)
{
    if (!_enabled)
    {
        return false;
    }
    auto it = _red_hull_shaders.find(hull_shader);
    if (it != _red_hull_shaders.end())
    {
        _current_bound_hull_shader = it->second;
    }
    else
    {
        _current_bound_hull_shader = RedHullShaderId::UNKNOWN;
    }
    return false;
}
bool RenderingInterceptor::OnSetDomainShader(const ID3D11DomainShader* domain_shader)
{
    if (!_enabled)
    {
        return false;
    }
    bool bound_custom_shader = BindReplacementShader(domain_shader, REPLACEMENT_SHADER_INDEX_DOMAIN);

    auto it = _red_domain_shaders.find(domain_shader);
    if (it != _red_domain_shaders.end())
    {
        _current_bound_domain_shader = it->second;
    }
    else
    {
        _current_bound_domain_shader = RedDomainShaderId::UNKNOWN;
    }
    return bound_custom_shader;
}
bool RenderingInterceptor::OnSetGeometryShader(const ID3D11GeometryShader* geometry_shader)
{
    if (!_enabled)
    {
        return false;
    }
    bool bound_custom_shader = BindReplacementShader(geometry_shader, REPLACEMENT_SHADER_INDEX_GEOMETRY);

    // TODO: handle checkpoint shader
    return bound_custom_shader;
}
bool RenderingInterceptor::OnSetPixelShader(const ID3D11PixelShader* pixel_shader)
{
    if (!_enabled)
    {
        return false;
    }
    bool bound_custom_shader = BindReplacementShader(pixel_shader, REPLACEMENT_SHADER_INDEX_PIXEL);

    auto it = _red_pixel_shaders.find(pixel_shader);
    if (it != _red_pixel_shaders.end())
    {
        _current_bound_pixel_shader = it->second;
    }
    else
    {
        _current_bound_pixel_shader = RedPixelShaderId::UNKNOWN;
    }
    return bound_custom_shader;
}
bool RenderingInterceptor::OnSetComputeShader(const ID3D11ComputeShader* compute_shader)
{
    if (!_enabled)
    {
        return false;
    }
    bool bound_custom_shader = BindReplacementShader(compute_shader, REPLACEMENT_SHADER_INDEX_COMPUTE);

    auto it = _red_compute_shaders.find(compute_shader);
    if (it != _red_compute_shaders.end())
    {
        _current_bound_compute_shader = it->second;
    }
    else
    {
        _current_bound_compute_shader = RedComputeShaderId::UNKNOWN;
    }
    return bound_custom_shader;
}
void RenderingInterceptor::VSSetContantBuffers(ID3D11DeviceContext* d3d_context, UINT start_slot, UINT num_buffers,
                                               ID3D11Buffer* const* constant_buffers)
{
    d3d_context->VSSetConstantBuffers(start_slot, num_buffers, constant_buffers);

    if (_is_after_first_g_buffer_pass && _is_before_lighting && num_buffers == 1 && _rendering_engine
                                                                                    .GetConfiguration().anti_aliasing_method ==
        ANTI_ALIASING_METHOD_TAA)
    {
        if (start_slot == 3)
        {
            auto iterator = _wind_dynamics_cbuffer_map.find(constant_buffers[0]);
            if (iterator != _wind_dynamics_cbuffer_map.end())
            {
                ID3D11Buffer* previous_frame_buffer = iterator->second->GetBuffer();
                d3d_context->VSSetConstantBuffers(4, 1, &previous_frame_buffer);
            }
            else
            {
                // when previous frame buffer is not found bind the current frame buffer in its place -> zero motion vector
                d3d_context->VSSetConstantBuffers(4, 1, constant_buffers);
            }
        }
    }
}
void RenderingInterceptor::Draw(ID3D11DeviceContext* d3d_context, UINT vertex_count, UINT start_vertex_location)
{
    ID3D11DeviceContext* orig = nullptr;
    if (_current_replacement_shaders[REPLACEMENT_SHADER_INDEX_PIXEL])
    {
        orig = GetD3DContext();
    }

    PreDraw();
    if (!_rendering_engine.OnDraw(
        RedShaderBinding{
            _current_bound_vertex_shader, _current_bound_hull_shader, _current_bound_pixel_shader, _current_bound_compute_shader
        },
        vertex_count, start_vertex_location))
    {
        d3d_context->Draw(vertex_count, start_vertex_location);
    }
    PostDraw();

    if (_current_replacement_shaders[REPLACEMENT_SHADER_INDEX_PIXEL])
    {
        SetD3DContext(orig);
    }
}
void RenderingInterceptor::DrawInstanced(ID3D11DeviceContext* d3d_context, UINT vertex_count_per_instance, UINT instance_count,
                                         UINT start_vertex_location, UINT start_instance_location)
{
    PreDraw();
    if (!_rendering_engine.OnDrawInstanced(
        RedShaderBinding{
            _current_bound_vertex_shader, _current_bound_hull_shader, _current_bound_pixel_shader, _current_bound_compute_shader
        },
        vertex_count_per_instance, instance_count, start_vertex_location, start_instance_location))
    {
        d3d_context->DrawInstanced(vertex_count_per_instance, instance_count, start_vertex_location, start_instance_location);
    }
    PostDraw();

    switch (_current_bound_hull_shader)
    {
    case RedHullShaderId::TERRAIN_0:
    case RedHullShaderId::TERRAIN_1:
        d3d_context->HSGetConstantBuffers(5, 1, _game_terrain_data_cbuffer.ReleaseAndGetAddressOf());
        _pipeline_state_manager.SetGlobalConstantBuffer(_game_terrain_data_cbuffer.Get(), "_GameTerrainData"_id);
        break;
    default:
        break;
    }
}
void RenderingInterceptor::DrawIndexed(ID3D11DeviceContext* d3d_context, UINT index_count, UINT start_index_location,
                                       INT base_vertex_location)
{
    PreDraw();

    switch (_current_bound_pixel_shader)
    {
    case RedPixelShaderId::SKY:
        d3d_context->PSGetConstantBuffers(0, 1, _game_water_data_cbuffer.ReleaseAndGetAddressOf());
        break;
    default:
        break;
    }

    if (!_rendering_engine.OnDrawIndexed(
        RedShaderBinding{
            _current_bound_vertex_shader, _current_bound_hull_shader, _current_bound_pixel_shader, _current_bound_compute_shader
        },
        index_count, start_index_location, base_vertex_location))
    {
        d3d_context->DrawIndexed(index_count, start_index_location, base_vertex_location);
    }
    PostDraw();
}
void RenderingInterceptor::DrawIndexedInstanced(ID3D11DeviceContext* d3d_context, UINT index_count_per_instance, UINT instance_count,
                                                UINT start_index_location, INT base_vertex_location, UINT start_instance_location)
{
    PreDraw();

    switch (_current_bound_vertex_shader)
    {
    case RedVertexShaderId::VEGETATION_SHADOW_0:
    case RedVertexShaderId::VEGETATION_SHADOW_1:
    case RedVertexShaderId::VEGETATION_SHADOW_2:
        if (!_grabbed_frame_cb)
        {
            d3d_context->VSGetConstantBuffers(0, 1, _game_frame_cb_cbuffer.ReleaseAndGetAddressOf());
            _grabbed_frame_cb = true;
        }
        break;
    case RedVertexShaderId::VEGETATION_BRANCH:
    case RedVertexShaderId::FOLIAGE_0:
    case RedVertexShaderId::FOLIAGE_1:
    case RedVertexShaderId::FOLIAGE_2:
    case RedVertexShaderId::TREE_BILLBOARD:
    case RedVertexShaderId::GRASS:
        // TODO: bind velocity buffer here
        if (_rendering_engine.GetConfiguration().anti_aliasing_method == ANTI_ALIASING_METHOD_TAA)
        {
            ComPtr<ID3D11Buffer> wind_dynamics_cb;
            d3d_context->VSGetConstantBuffers(3, 1, wind_dynamics_cb.GetAddressOf());
            auto iterator = _wind_dynamics_cbuffer_map.find(wind_dynamics_cb.Get());
            if (iterator == _wind_dynamics_cbuffer_map.end())
            {
                auto* cbuffer = new ConstantBuffer<WindDynamicsCB>;
                cbuffer->Create(true);
                _wind_dynamics_cbuffer_map[wind_dynamics_cb.Get()] = cbuffer;
            }
        }
        break;
    default:
        break;
    }
    if (_current_bound_pixel_shader == RedPixelShaderId::WATER)
    {
        d3d_context->PSGetConstantBuffers(0, 1, _game_water_data_cbuffer.ReleaseAndGetAddressOf());
    }

    if (!_rendering_engine.OnDrawIndexedInstanced(
        RedShaderBinding{
            _current_bound_vertex_shader, _current_bound_hull_shader, _current_bound_pixel_shader, _current_bound_compute_shader
        },
        index_count_per_instance, instance_count, start_index_location, base_vertex_location, start_instance_location))
    {
        d3d_context->DrawIndexedInstanced(index_count_per_instance, instance_count, start_index_location, base_vertex_location,
                                          start_instance_location);
    }
    PostDraw();
}
void RenderingInterceptor::Dispatch(ID3D11DeviceContext* d3d_context, UINT thread_group_count_x, UINT thread_group_count_y,
                                    UINT thread_group_count_z)
{
    PreDraw();
    if (!_rendering_engine.OnDispatch(
        RedShaderBinding{
            _current_bound_vertex_shader, _current_bound_hull_shader, _current_bound_pixel_shader, _current_bound_compute_shader
        },
        thread_group_count_x, thread_group_count_y, thread_group_count_z))
    {
        d3d_context->Dispatch(thread_group_count_x, thread_group_count_y, thread_group_count_z);
    }
    PostDraw();

    switch (_current_bound_compute_shader)
    {
    case RedComputeShaderId::WATER_FFT_TO_TEXTURE:
        {
            d3d_context->CSGetConstantBuffers(0, 1, _game_water_texture_cbuffer.ReleaseAndGetAddressOf());
            _pipeline_state_manager.SetGlobalConstantBuffer(_game_water_texture_cbuffer.Get(), "_GameWaterTextureParams"_id);
        }
        break;
    case RedComputeShaderId::DEFERRED_LIGHTING:
        _is_before_lighting = false;
        {
            d3d_context->CSGetConstantBuffers(12, 1, _game_frame_data_cbuffer.ReleaseAndGetAddressOf());
            d3d_context->CSGetConstantBuffers(13, 1, _game_lighting_data_cbuffer.ReleaseAndGetAddressOf());

            _pipeline_state_manager.SetGlobalConstantBuffer(_game_frame_data_cbuffer.Get(), "_GameFrameData"_id);
            _pipeline_state_manager.SetGlobalConstantBuffer(_game_lighting_data_cbuffer.Get(), "_GameLightingData"_id);

            d3d_context->CSGetShaderResources(0, 1, _g_buffer_depth_srv.ReleaseAndGetAddressOf());
            _pipeline_state_manager.SetGlobalShaderResource(_g_buffer_depth_srv.Get(), "_g_buffer_depth"_id);
            d3d_context->CSGetShaderResources(1, 1, _g_buffer_albedo_translucency_srv.ReleaseAndGetAddressOf());
            _pipeline_state_manager.SetGlobalShaderResource(_g_buffer_albedo_translucency_srv.Get(), "_g_buffer_albedo_translucency"_id);
            d3d_context->CSGetShaderResources(2, 1, _g_buffer_normal_roughness_srv.ReleaseAndGetAddressOf());
            _pipeline_state_manager.SetGlobalShaderResource(_g_buffer_normal_roughness_srv.Get(), "_g_buffer_normal_roughness"_id);
            d3d_context->CSGetShaderResources(3, 1, _g_buffer_stencil_srv.ReleaseAndGetAddressOf());
            _pipeline_state_manager.SetGlobalShaderResource(_g_buffer_stencil_srv.Get(), "_g_buffer_stencil"_id);
            d3d_context->CSGetShaderResources(4, 1, _g_buffer_specular_mask_srv.ReleaseAndGetAddressOf());
            _pipeline_state_manager.SetGlobalShaderResource(_g_buffer_specular_mask_srv.Get(), "_g_buffer_specular_mask"_id);
            d3d_context->CSGetShaderResources(16, 1, _ao_shadow_interior_mask.ReleaseAndGetAddressOf());
            _pipeline_state_manager.SetGlobalShaderResource(_ao_shadow_interior_mask.Get(), "_ao_shadow_interior_mask"_id);
        }
        break;
    default:
        break;
    }
}
void RenderingInterceptor::Toggle()
{
    _enabled = !_enabled;
}
void RenderingInterceptor::Reload()
{
    _schedule_reload = true;
}
void RenderingInterceptor::OnMenu()
{
    Configuration config = _rendering_engine.GetConfiguration();

    if (gui::HandleInput(config, IsEnabled()))
    {
        Toggle();
    }

    _rendering_engine.SetConfiguration(config);
}
void RenderingInterceptor::OnCloseMenu()
{
    _resource_manager.SaveConfig(_rendering_engine.GetConfiguration());
}
void RenderingInterceptor::OnPresent()
{
    RenderTexture::OnPresent();

    if (!_loaded_config)
    {
        _rendering_engine.SetConfiguration(_resource_manager.LoadConfig());
        _resource_manager.SaveConfig(_rendering_engine.GetConfiguration());
        _loaded_config = true;
    }

    _rendering_engine.OnPresent();

    if (_schedule_reload)
    {
        _resource_manager.ReloadShaders();
        _schedule_reload = false;
    }
    _is_after_first_g_buffer_pass = false;
    _grabbed_frame_cb = false;


    _pipeline_state_manager.SetGlobalTexture("blue_noise"_id, "_blue_noise"_id);
    _pipeline_state_manager.SetGlobalTexture("caustics"_id, "_caustics_texture"_id);

    _pipeline_state_manager.SetGlobalShaderResource(_velocity_g_buffer.GetShaderResourceView(), "_g_buffer_velocity"_id);

    static const float velocity_clear_color[4] = {1, 1, 0, 0};
    GetD3DContext()->ClearRenderTargetView(_velocity_g_buffer.GetRenderTargetView(), velocity_clear_color);

    for (auto& pair : _wind_dynamics_cbuffer_map)
    {
        pair.second->UploadBuffer();
    }

    _is_before_lighting = true;

    _pipeline_state_manager.Clear();
}
RenderingInterceptor::RenderingInterceptor()
    :
    _resolution(1, 1),
    _resource_manager("x64\\blitz_resources\\"),
    _pipeline_state_manager(_resource_manager),
    _rendering_engine(_pipeline_state_manager, _custom_frame_data_cbuffer),
    _current_bound_vertex_shader(RedVertexShaderId::UNKNOWN),
    _current_bound_hull_shader(RedHullShaderId::UNKNOWN),
    _current_bound_pixel_shader(RedPixelShaderId::UNKNOWN),
    _current_bound_compute_shader(RedComputeShaderId::UNKNOWN)
{
}
void RenderingInterceptor::PreDraw()
{
    DisableCulling(GetD3DContext());
    bool bound_replacement_shader = false;
    for (int i = 0; i < 6; i++)
    {
        if (_current_replacement_shaders[i])
        {
            _pipeline_state_manager.BindShader(_current_replacement_shaders[i]);
            bound_replacement_shader = true;
        }
    }
    if (bound_replacement_shader)
    {
        _pipeline_state_manager.BindResourcesForCurrentShaders();
    }
}
void RenderingInterceptor::PostDraw()
{
    _pipeline_state_manager.RestoreOriginalPipelineState();
}
void RenderingInterceptor::DisableCulling(ID3D11DeviceContext* d3d_context)
{
    return; // disabled this function as caused some shadows to be incorrect (Kaer Morhen interior)
    if (_is_depth_buffer_bound && !_is_render_target_bound)
    {
        // this means we are probably drawing a shadow map
        ID3D11RasterizerState* current_rasterizer_state;
        d3d_context->RSGetState(&current_rasterizer_state);

        auto it = _rasterizer_to_cull_none_map.find(current_rasterizer_state);
        if (it == _rasterizer_to_cull_none_map.end())
        {
            D3D11_RASTERIZER_DESC rasterizer_desc;
            current_rasterizer_state->GetDesc(&rasterizer_desc);
            rasterizer_desc.CullMode = D3D11_CULL_NONE;

            ID3D11Device* d3d_device;
            d3d_context->GetDevice(&d3d_device);

            ID3D11RasterizerState* cull_none_rasterizer_state;
            d3d_device->CreateRasterizerState(&rasterizer_desc, &cull_none_rasterizer_state);
            d3d_device->Release();
            _rasterizer_to_cull_none_map[current_rasterizer_state] = cull_none_rasterizer_state;

            d3d_context->RSSetState(cull_none_rasterizer_state);
        }
        else
        {
            d3d_context->RSSetState(it->second);
        }
        current_rasterizer_state->Release();
    }
}
