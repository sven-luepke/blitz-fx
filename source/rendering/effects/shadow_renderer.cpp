#include "shadow_renderer.h"


using namespace w3;
using namespace Microsoft::WRL;

void ShadowRenderer::Initialize()
{
    _current_shadow_mask = &_shadow_mask_0;
    _history_shadow_mask = &_shadow_mask_1;
}
void ShadowRenderer::Terminate()
{
    _shadow_mask_0.Release();
    _shadow_mask_1.Release();
    _previous_scene_depth.Release();
}
void ShadowRenderer::OnResize(int width, int height)
{
    RendererBase::OnResize(width, height);

    _shadow_mask_0.Release();
    _shadow_mask_1.Release();
    _previous_scene_depth.Release();

    _shadow_mask_0.Create(width, height);
    _shadow_mask_1.Create(width, height);
    _previous_scene_depth.Create(width, height);
}
void ShadowRenderer::RenderDirectionalShadows(bool enable_contact_shadows)
{
    ID3D11DeviceContext* d3d_context = _pipeline_state_manager.GetD3D11DeviceContext();

    ComPtr<ID3D11ShaderResourceView> cascade_shadow_map;
    ComPtr<ID3D11ShaderResourceView> cloud_shadow_map;
    ComPtr<ID3D11ShaderResourceView> terrain_shadow_map;
    ComPtr<ID3D11SamplerState> cascade_shadow_sampler;

    d3d_context->PSGetShaderResources(8, 1, cascade_shadow_map.GetAddressOf());
    d3d_context->PSGetShaderResources(14, 1, cloud_shadow_map.GetAddressOf());
    d3d_context->PSGetShaderResources(19, 1, terrain_shadow_map.GetAddressOf());
    d3d_context->PSGetSamplers(9, 1, cascade_shadow_sampler.GetAddressOf());
    RenderTexture* raw_cascade_shadow_mask = RenderTexture::GetTemporary(DXGI_FORMAT_R16_FLOAT,
                                                                         RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV, _resolution.x,
                                                                         _resolution.y);

    // set global textures
    _pipeline_state_manager.SetGlobalShaderResource(cascade_shadow_map.Get(), "_cascade_shadow_map"_id);
    _pipeline_state_manager.SetGlobalShaderResource(cloud_shadow_map.Get(), "_cloud_shadow_map"_id);
    _pipeline_state_manager.SetGlobalShaderResource(terrain_shadow_map.Get(), "_terrain_shadow_height_map"_id);

    // render noise cascade shadow
    _pipeline_state_manager.SetShaderResourceView(cascade_shadow_map.Get(), SHADER_TYPE_COMPUTE, 8);
    _pipeline_state_manager.SetSamplerState(cascade_shadow_sampler.Get(), SHADER_TYPE_COMPUTE, 9);
    _pipeline_state_manager.SetUnorderedAccessView(raw_cascade_shadow_mask->GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
    _pipeline_state_manager.BindShader("CascadeShadowCS"_id);
    _pipeline_state_manager.BindResourcesForCurrentShaders();
    d3d_context->Dispatch(std::ceil(_resolution.x / 8.0f), std::ceil(_resolution.y / 8.0f), 1);
    _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 0);

    RenderTexture* shadow_mask = RenderTexture::GetTemporary(DXGI_FORMAT_R16_FLOAT,
        RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV,
        _resolution.x, _resolution.y);
    if (enable_contact_shadows)
    {
        // create shadow type mask
        RenderTexture* ss_shadow_packed_data = RenderTexture::GetTemporary(DXGI_FORMAT_R32G32_FLOAT,
            RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV,
            _resolution.x, _resolution.y);
        _pipeline_state_manager.SetUnorderedAccessView(ss_shadow_packed_data->GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
        _pipeline_state_manager.BindShader("ContactShadowsPackDataCS"_id);
        _pipeline_state_manager.BindResourcesForCurrentShaders();
        d3d_context->Dispatch(std::ceil(_resolution.x / 8.0f), std::ceil(_resolution.y / 8.0f), 1);
        _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 0);
        _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 1);

        // trace screen space shadows
        RenderTexture* screen_space_shadows = RenderTexture::GetTemporary(DXGI_FORMAT_R16_FLOAT,
            RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV,
            _resolution.x, _resolution.y);
        _pipeline_state_manager.SetShaderResourceView(raw_cascade_shadow_mask->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 42);
        _pipeline_state_manager.SetShaderResourceView(ss_shadow_packed_data->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 43);
        _pipeline_state_manager.SetUnorderedAccessView(screen_space_shadows->GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
        _pipeline_state_manager.BindShader("ContactShadowsCS"_id);
        _pipeline_state_manager.BindResourcesForCurrentShaders();
        d3d_context->Dispatch(std::ceil(_resolution.x / 8.0f), std::ceil(_resolution.y / 8.0f), 1);
        _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 0);

        // screen space shadows spatial filter and combine with cascade shadows
        
        _pipeline_state_manager.SetUnorderedAccessView(shadow_mask->GetUnorderedAccessView(),
            SHADER_TYPE_COMPUTE, 0);
        _pipeline_state_manager.SetShaderResourceView(screen_space_shadows->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 42);
        _pipeline_state_manager.SetShaderResourceView(raw_cascade_shadow_mask->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 43);
        _pipeline_state_manager.BindShader("ContactShadowsSpatialFilterCS"_id);
        _pipeline_state_manager.BindResourcesForCurrentShaders();
        d3d_context->Dispatch(std::ceil(_resolution.x / 8.0f), std::ceil(_resolution.y / 8.0f), 1);
        _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 0);

        RenderTexture::ReleaseTemporary(ss_shadow_packed_data);
        RenderTexture::ReleaseTemporary(screen_space_shadows);
    }

    // combined temporal filter
    _pipeline_state_manager.SetShaderResourceView(_history_shadow_mask->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 42);
    _pipeline_state_manager.SetShaderResourceView((enable_contact_shadows ? shadow_mask : raw_cascade_shadow_mask)->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 43);
    _pipeline_state_manager.SetShaderResourceView(_previous_scene_depth.GetShaderResourceView(), SHADER_TYPE_COMPUTE, 44);
    _pipeline_state_manager.SetUnorderedAccessView(_current_shadow_mask->GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
    _pipeline_state_manager.BindShader("ShadowsTemporalFilterCS"_id);
    _pipeline_state_manager.BindResourcesForCurrentShaders();
    d3d_context->Dispatch(std::ceil(_resolution.x / 8.0f), std::ceil(_resolution.y / 8.0f), 1);
    _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 0);

    // cloud + terrain shadows and combine with screen space and cascade shadows
    _pipeline_state_manager.SetShaderResourceView(_current_shadow_mask->GetShaderResourceView(), SHADER_TYPE_PIXEL, 42);
    _pipeline_state_manager.BindShader("ShadowPS"_id);
    _pipeline_state_manager.BindResourcesForCurrentShaders();
    d3d_context->Draw(3, 0);

    
    RenderTexture::ReleaseTemporary(shadow_mask);
    RenderTexture::ReleaseTemporary(raw_cascade_shadow_mask);

    // swap temporal buffers
    std::swap(_history_shadow_mask, _current_shadow_mask);
}
void ShadowRenderer::StorePreviousSceneDepth()
{
    _pipeline_state_manager.SetUnorderedAccessView(_previous_scene_depth.GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
    _pipeline_state_manager.BindShader("StorePreviousSceneDepthCS"_id);
    _pipeline_state_manager.BindResourcesForCurrentShaders();
    _pipeline_state_manager.GetD3D11DeviceContext()->Dispatch(
        std::ceil(_resolution.x / 8.0f), std::ceil(_resolution.y / 8.0f), 1);
}
