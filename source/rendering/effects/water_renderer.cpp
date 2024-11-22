#include "water_renderer.h"

using namespace w3;
using namespace Microsoft::WRL;

void WaterRenderer::Initialize()
{
    _water_sky_ambient.Create(1, 1);
    _underwater_reflection_fallback_paraboloid.Create(64, 64);

    _water_depth_volume_params = ComputeFrustumVolumeParams({128, 64, 16}, 32, 32, 0.2);
    _water_depth_volume.Create(128, 64, 16);

    _pipeline_state_manager.SetGlobalShaderResource(_water_depth_volume.GetShaderResourceView(), "_water_depth_volume"_id);

    _water_rendering_params_cbuffer.Create(true);
    _pipeline_state_manager.SetGlobalConstantBuffer(_water_rendering_params_cbuffer.GetBuffer(), "_WaterRenderingParams"_id);
}
void WaterRenderer::Terminate()
{
    _water_depth_volume.Release();
    _water_sky_ambient.Release();
    _unfogged_scene.Release();
    _water_depth.Release();
}
void WaterRenderer::OnResize(int width, int height)
{
    RendererBase::OnResize(width, height);

    _unfogged_scene.Release();
    _unfogged_scene.Create(width, height);
    _water_depth.Release();
    _water_depth.Create(width, height);
    _underwater_fog_transmittance_texture.Release();
    _underwater_fog_transmittance_texture.Create(width, height);

    _pipeline_state_manager.SetGlobalShaderResource(_water_depth.GetShaderResourceView(), "_water_depth"_id);
    _pipeline_state_manager.SetGlobalShaderResource(_underwater_fog_transmittance_texture.GetShaderResourceView(), "_underwater_fog_transmittance_texture"_id);
}
void WaterRenderer::DrawWaterDepth(ID3D11DeviceContext* d3d_context)
{
    _pipeline_state_manager.SetUnorderedAccessView(_water_depth.GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 4);
    _pipeline_state_manager.BindShader("WaterDepthCS"_id);
    _pipeline_state_manager.BindResourcesForCurrentShaders();
    d3d_context->Dispatch(std::ceil(_resolution.x / 8.0), std::ceil(_resolution.y / 8.0), 1);
    _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 4);

    _pipeline_state_manager.SetUnorderedAccessView(_water_depth_volume.GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 4);
    _pipeline_state_manager.BindShader("WaterDepthVolumeCS"_id);
    _pipeline_state_manager.BindResourcesForCurrentShaders();
    d3d_context->Dispatch(32, 16, 4);
    _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 4);

    _pipeline_state_manager.RestoreOriginalPipelineState();
}
void WaterRenderer::GrabUnfoggedScene(ID3D11DeviceContext* d3d_context)
{
    // TODO: try if a simple blit draw is faster
    ComPtr<ID3D11ShaderResourceView> unfogged_scene;
    d3d_context->PSGetShaderResources(1, 1, unfogged_scene.GetAddressOf());
    _pipeline_state_manager.SetShaderResourceView(unfogged_scene.Get(), SHADER_TYPE_COMPUTE, 0);
    _pipeline_state_manager.SetUnorderedAccessView(_unfogged_scene.GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
    _pipeline_state_manager.BindShader("BlitCS"_id);
    d3d_context->Dispatch(std::ceil(_resolution.x / 8.0), std::ceil(_resolution.y / 8.0), 1);
    _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 0);

    _pipeline_state_manager.SetGlobalShaderResource(_unfogged_scene.GetShaderResourceView(), "_unfogged_scene"_id);
}
void WaterRenderer::DrawWater(ID3D11DeviceContext* d3d_context, UINT index_count_per_instance, UINT instance_count,
                              UINT start_index_location, INT base_vertex_location, UINT start_instance_location,
                              ID3D11RenderTargetView* responsive_taa_mask_rtv)
{
    ComPtr<ID3D11Buffer> water_cbuffer;
    d3d_context->PSGetConstantBuffers(0, 1, water_cbuffer.GetAddressOf());

    d3d_context->CSSetConstantBuffers(0, 1, water_cbuffer.GetAddressOf());
    _pipeline_state_manager.SetUnorderedAccessView(_water_sky_ambient.GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
    _pipeline_state_manager.BindShader("WaterAmbientCS"_id);
    _pipeline_state_manager.BindResourcesForCurrentShaders();
    d3d_context->Dispatch(1, 1, 1);
    _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 0);
    _pipeline_state_manager.SetGlobalShaderResource(_water_sky_ambient.GetShaderResourceView(), "_water_sky_ambient"_id);

    _pipeline_state_manager.SetUnorderedAccessView(_underwater_reflection_fallback_paraboloid.GetUnorderedAccessView(), SHADER_TYPE_COMPUTE,
                                                   0);
    _pipeline_state_manager.BindShader("UnderwaterReflectionFallbackCS"_id);
    _pipeline_state_manager.BindResourcesForCurrentShaders();
    d3d_context->Dispatch(8, 8, 1);
    _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 0);

    _pipeline_state_manager.SetGlobalShaderResource(_underwater_reflection_fallback_paraboloid.GetShaderResourceView(),
                                                    "_underwater_reflection_fallback_paraboloid"_id);

    //_pipeline_state_manager.BindShader("WaterDS"_id);
    _pipeline_state_manager.BindShader("WaterPS"_id);
    _pipeline_state_manager.BindResourcesForCurrentShaders();

    ID3D11RenderTargetView* orig_rtvs[] = {nullptr, nullptr};
    ComPtr<ID3D11DepthStencilView> orig_dsv;
    d3d_context->OMGetRenderTargets(2, orig_rtvs, orig_dsv.GetAddressOf());
    ID3D11RenderTargetView* new_rtvs[3] = {orig_rtvs[0], orig_rtvs[1], responsive_taa_mask_rtv};
    d3d_context->OMSetRenderTargets(3, new_rtvs, orig_dsv.Get());

    d3d_context->DrawIndexedInstanced(index_count_per_instance, instance_count, start_index_location, base_vertex_location,
                                      start_instance_location);

    ID3D11RenderTargetView* old_rtvs[3] = {orig_rtvs[0], orig_rtvs[1], nullptr};
    d3d_context->OMSetRenderTargets(3, old_rtvs, orig_dsv.Get());
    if (orig_rtvs[0] != nullptr)
    {
        orig_rtvs[0]->Release();
    }
    if (orig_rtvs[1] != nullptr)
    {
        orig_rtvs[1]->Release();
    }

    d3d_context->PSGetShaderResources(24, 1, _interior_dimmer_texture.ReleaseAndGetAddressOf());
    _pipeline_state_manager.SetGlobalShaderResource(_interior_dimmer_texture.Get(), "_interior_dimmer_texture"_id);

    d3d_context->PSGetConstantBuffers(4, 1, _water_cb4.ReleaseAndGetAddressOf());
    _pipeline_state_manager.SetGlobalConstantBuffer(_water_cb4.Get(), "_WaterCb4"_id);
    d3d_context->VSGetShaderResources(2, 1, _water_geometry_atlas.ReleaseAndGetAddressOf());
    _pipeline_state_manager.SetGlobalShaderResource(_water_geometry_atlas.Get(), "_water_geometry_atlas"_id);
    d3d_context->PSGetShaderResources(5, 1, _water_wave_texture.ReleaseAndGetAddressOf());
    _pipeline_state_manager.SetGlobalShaderResource(_water_wave_texture.Get(), "_water_wave_texture"_id);

    d3d_context->PSGetShaderResources(4, 1, _terrain_height_map.ReleaseAndGetAddressOf());
    _pipeline_state_manager.SetGlobalShaderResource(_terrain_height_map.Get(), "_terrain_height_map"_id);
    d3d_context->PSGetShaderResources(17, 1, _terrain_lut.ReleaseAndGetAddressOf());
    _pipeline_state_manager.SetGlobalShaderResource(_terrain_lut.Get(), "_terrain_lut"_id);
}
void WaterRenderer::DrawUnderwaterFog(ID3D11DeviceContext* d3d_context, UINT vertex_count, UINT start_vertex_location)
{
    ComPtr<ID3D11ShaderResourceView> depth_texture_srv;
    d3d_context->PSGetShaderResources(15, 1, depth_texture_srv.GetAddressOf());
    DirectX::XMINT2 half_resolution = {_resolution.x / 2, _resolution.y / 2};
    ComPtr<ID3D11ShaderResourceView> underwater_mask_srv;
    d3d_context->PSGetShaderResources(2, 1, underwater_mask_srv.GetAddressOf());

    // downsample depth buffer
    RenderTexture* half_res_depth_texture = RenderTexture::GetTemporary(DXGI_FORMAT_R32_FLOAT,
                                                                        RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV,
                                                                        half_resolution.x, half_resolution.y);
    _pipeline_state_manager.SetUnorderedAccessView(half_res_depth_texture->GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
    _pipeline_state_manager.SetShaderResourceView(depth_texture_srv.Get(), SHADER_TYPE_COMPUTE, 15);
    _pipeline_state_manager.BindShader("DownsampleDepthCS"_id);
    _pipeline_state_manager.BindResourcesForCurrentShaders();
    d3d_context->Dispatch(std::ceil(half_resolution.x / 8.0), std::ceil(half_resolution.y / 8.0), 1);

    // raymarch fog in half resolution
    RenderTexture* half_res_in_scattering_texture_0 = RenderTexture::GetTemporary(DXGI_FORMAT_R11G11B10_FLOAT,
                                                                       RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV,
                                                                       half_resolution.x, half_resolution.y);
    _pipeline_state_manager.SetUnorderedAccessView(half_res_in_scattering_texture_0->GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
    _pipeline_state_manager.SetShaderResourceView(underwater_mask_srv.Get(), SHADER_TYPE_COMPUTE, 2);
    _pipeline_state_manager.SetShaderResourceView(half_res_depth_texture->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 14);
    _pipeline_state_manager.BindShader("RaymarchUnderwaterFogCS"_id);
    _pipeline_state_manager.BindResourcesForCurrentShaders();
    d3d_context->Dispatch(std::ceil(half_resolution.x / 8.0), std::ceil(half_resolution.y / 8.0), 1);

    // bilateral seperable gaussian blur
    RenderTexture* half_res_in_scattering_texture_1 = RenderTexture::GetTemporary(DXGI_FORMAT_R11G11B10_FLOAT,
        RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV,
        half_resolution.x, half_resolution.y);
    _pipeline_state_manager.SetUnorderedAccessView(half_res_in_scattering_texture_1->GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
    _pipeline_state_manager.SetShaderResourceView(half_res_in_scattering_texture_0->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 16);
    _water_rendering_params_cbuffer->underwater_fog_blur_direction = { 1, 0, 0, 0 };
    _water_rendering_params_cbuffer.UploadBuffer();
    _pipeline_state_manager.BindShader("UnderwaterFogBlurCS"_id);
    _pipeline_state_manager.BindResourcesForCurrentShaders();
    d3d_context->Dispatch(std::ceil(half_resolution.x / 8.0), std::ceil(half_resolution.y / 8.0), 1);
    _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 0);

    _pipeline_state_manager.SetShaderResourceView(half_res_in_scattering_texture_1->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 16);
    _pipeline_state_manager.SetUnorderedAccessView(half_res_in_scattering_texture_0->GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
    _water_rendering_params_cbuffer->underwater_fog_blur_direction = { 0, 1, 0, 0 };
    _water_rendering_params_cbuffer.UploadBuffer();
    _pipeline_state_manager.BindShader("UnderwaterFogBlurCS"_id);
    _pipeline_state_manager.BindResourcesForCurrentShaders();
    d3d_context->Dispatch(std::ceil(half_resolution.x / 8.0), std::ceil(half_resolution.y / 8.0), 1);

    // bilateral upsample inscattering + render full res transmittance
    RenderTexture* full_res_in_scattering_texture = RenderTexture::GetTemporary(DXGI_FORMAT_R11G11B10_FLOAT,
        RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV,
        _resolution.x, _resolution.y);
    _pipeline_state_manager.SetUnorderedAccessView(full_res_in_scattering_texture->GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
    _pipeline_state_manager.SetUnorderedAccessView(_underwater_fog_transmittance_texture.GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 1);
    _pipeline_state_manager.SetShaderResourceView(half_res_in_scattering_texture_0->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 13);
    _pipeline_state_manager.BindShader("UpsampleUnderwaterFogCS"_id);
    _pipeline_state_manager.BindResourcesForCurrentShaders();
    d3d_context->Dispatch(std::ceil(_resolution.x / 8.0), std::ceil(_resolution.y / 8.0), 1);
    _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 0);
    _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 1);

    // apply fog to scene
    _pipeline_state_manager.SetShaderResourceView(_underwater_fog_transmittance_texture.GetShaderResourceView(), SHADER_TYPE_PIXEL, 63);
    _pipeline_state_manager.SetShaderResourceView(full_res_in_scattering_texture->GetShaderResourceView(), SHADER_TYPE_PIXEL, 64);
    _pipeline_state_manager.BindShader("UnderwaterFogPS"_id);
    _pipeline_state_manager.BindResourcesForCurrentShaders();
    d3d_context->Draw(vertex_count, start_vertex_location);

    RenderTexture::ReleaseTemporary(full_res_in_scattering_texture);
    RenderTexture::ReleaseTemporary(half_res_in_scattering_texture_1);
    RenderTexture::ReleaseTemporary(half_res_in_scattering_texture_0);
    RenderTexture::ReleaseTemporary(half_res_depth_texture);
}
void WaterRenderer::ClearWaterBuffers(ID3D11DeviceContext* d3d_context)
{
    static const float depth_clear_color[4] = {-1, -1, -1, -1};
    d3d_context->ClearUnorderedAccessViewFloat(_water_depth.GetUnorderedAccessView(), depth_clear_color);
    d3d_context->ClearUnorderedAccessViewFloat(_water_depth_volume.GetUnorderedAccessView(), depth_clear_color);

    static const float transmittance_clear_color[4] = { 1, 1, 1, 1 };
    d3d_context->ClearUnorderedAccessViewFloat(_underwater_fog_transmittance_texture.GetUnorderedAccessView(), transmittance_clear_color);
}
FrustumVolumeParams WaterRenderer::GetWaterDepthVolumeParams() const
{
    return _water_depth_volume_params;
}
