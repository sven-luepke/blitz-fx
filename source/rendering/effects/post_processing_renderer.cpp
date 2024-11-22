#include "post_processing_renderer.h"

#include <iostream>

#include "rendering/pipeline_state_manager.h"

using namespace DirectX;
using namespace w3;
using namespace Microsoft::WRL;

void PostProcessingRenderer::Initialize()
{
	_post_processing_params_cbuffer.Create(true);
	_pipeline_state_manager.SetGlobalConstantBuffer(_post_processing_params_cbuffer.GetBuffer(), "_PostProcessingParams"_id);

    _history_taa_buffer = &_taa_buffer_0;
    _current_taa_buffer = &_taa_buffer_1;

    _half_res_depth_mask_velocity_buffers[0] = &_half_res_depth_mask_velocity_buffer_0;
    _half_res_depth_mask_velocity_buffers[1] = &_half_res_depth_mask_velocity_buffer_1;
    _half_res_depth_mask_velocity_buffers[2] = &_half_res_depth_mask_velocity_buffer_2;

    _luma_buffers[0] = &_luma_buffer_0;
    _luma_buffers[1] = &_luma_buffer_1;
    _luma_buffers[2] = &_luma_buffer_2;
    _luma_buffers[3] = &_luma_buffer_3;
}
void PostProcessingRenderer::Terminate()
{
	_post_processing_params_cbuffer.Release();
}
void PostProcessingRenderer::OnResize(int width, int height)
{
    RendererBase::OnResize(width, height);

    _previous_frame_raw_hdr_buffer.Release();
    _previous_frame_raw_hdr_buffer.Create(width, height);

    _taa_buffer_0.Release();
    _taa_buffer_0.Create(_resolution.x, _resolution.y);
    _taa_buffer_1.Release();
    _taa_buffer_1.Create(_resolution.x, _resolution.y);

    _half_res_depth_mask_velocity_buffer_0.Release();
    _half_res_depth_mask_velocity_buffer_0.Create(_resolution.x / 2, _resolution.y / 2);
    _half_res_depth_mask_velocity_buffer_1.Release();
    _half_res_depth_mask_velocity_buffer_1.Create(_resolution.x / 2, _resolution.y / 2);
    _half_res_depth_mask_velocity_buffer_2.Release();
    _half_res_depth_mask_velocity_buffer_2.Create(_resolution.x / 2, _resolution.y / 2);

    _luma_buffer_0.Release();
    _luma_buffer_0.Create(_resolution.x, _resolution.y);
    _luma_buffer_1.Release();
    _luma_buffer_1.Create(_resolution.x, _resolution.y);
    _luma_buffer_2.Release();
    _luma_buffer_2.Create(_resolution.x, _resolution.y);
    _luma_buffer_3.Release();
    _luma_buffer_3.Create(_resolution.x, _resolution.y);

    _taa_output_texture.Release();
    _taa_output_texture.Create(_resolution.x, _resolution.y);

    _bloomed_scene_buffer.Release();
    _bloomed_scene_buffer.Create(_resolution.x / 2, _resolution.y / 2);
}
void PostProcessingRenderer::DrawRainDrops(ID3D11DeviceContext* d3d_context, UINT index_count_per_instance, UINT instance_count,
    UINT start_index_location, INT base_vertex_location, UINT start_instance_location, ID3D11RenderTargetView* responsive_aa_rtv)
{
    if (index_count_per_instance < 500)
    {
        // skip because it might be the heat distortion cylinder
        d3d_context->DrawIndexedInstanced(index_count_per_instance, instance_count, start_index_location,
            base_vertex_location, start_instance_location);
        return;
    }

    // save original render targets
    ID3D11RenderTargetView* orig_rtvs[D3D11_SIMULTANEOUS_RENDER_TARGET_COUNT] = { nullptr };
    ComPtr<ID3D11DepthStencilView> orig_dsv;
    d3d_context->OMGetRenderTargets(D3D11_SIMULTANEOUS_RENDER_TARGET_COUNT, orig_rtvs, orig_dsv.GetAddressOf());

    ID3D11RenderTargetView* new_rtvs[2] = { orig_rtvs[0], responsive_aa_rtv };
    d3d_context->OMSetRenderTargets(2, new_rtvs, orig_dsv.Get());

    _pipeline_state_manager.SetShaderResourceView(_bloomed_scene_buffer.GetShaderResourceView(), SHADER_TYPE_PIXEL, 50);
    _pipeline_state_manager.BindShader("RainDropsPS"_id);
    _pipeline_state_manager.BindResourcesForCurrentShaders();
    d3d_context->DrawIndexedInstanced(index_count_per_instance, instance_count, start_index_location,
        base_vertex_location, start_instance_location);

    // restore original render targets
    d3d_context->OMSetRenderTargets(D3D11_SIMULTANEOUS_RENDER_TARGET_COUNT, orig_rtvs, orig_dsv.Get());

    for (int i = 0; i < D3D11_SIMULTANEOUS_RENDER_TARGET_COUNT; i++)
    {
        if (orig_rtvs[i] != nullptr)
        {
            orig_rtvs[i]->Release();
        }
    }
    // TODO: sample current frame on camera cut
}
void PostProcessingRenderer::DrawRainDropsBob(ID3D11DeviceContext* d3d_context, UINT index_count_per_instance, UINT instance_count,
    UINT start_index_location, INT base_vertex_location, UINT start_instance_location, ID3D11RenderTargetView* responsive_aa_rtv)
{
    // save original render targets
    ID3D11RenderTargetView* orig_rtvs[D3D11_SIMULTANEOUS_RENDER_TARGET_COUNT] = { nullptr };
    ComPtr<ID3D11DepthStencilView> orig_dsv;
    d3d_context->OMGetRenderTargets(D3D11_SIMULTANEOUS_RENDER_TARGET_COUNT, orig_rtvs, orig_dsv.GetAddressOf());

    ID3D11RenderTargetView* new_rtvs[2] = { orig_rtvs[0], responsive_aa_rtv };
    d3d_context->OMSetRenderTargets(2, new_rtvs, orig_dsv.Get());

    _pipeline_state_manager.SetShaderResourceView(_bloomed_scene_buffer.GetShaderResourceView(), SHADER_TYPE_PIXEL, 50);
    _pipeline_state_manager.BindShader("RainDropsBobPS"_id);
    _pipeline_state_manager.BindResourcesForCurrentShaders();
    d3d_context->DrawIndexedInstanced(index_count_per_instance, instance_count, start_index_location,
        base_vertex_location, start_instance_location);

    // restore original render targets
    d3d_context->OMSetRenderTargets(D3D11_SIMULTANEOUS_RENDER_TARGET_COUNT, orig_rtvs, orig_dsv.Get());

    for (int i = 0; i < D3D11_SIMULTANEOUS_RENDER_TARGET_COUNT; i++)
    {
        if (orig_rtvs[i] != nullptr)
        {
            orig_rtvs[i]->Release();
        }
    }
    // TODO: sample current frame on camera cut
}
void PostProcessingRenderer::HdrPostProcess(ID3D11DeviceContext* d3d_context, bool do_motion_blur, int tonemap_shader_index, bool do_bloom, bool do_taa)
{
    RenderTextureDescription render_texture_desc;
    render_texture_desc.bind_flags = RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV;
    render_texture_desc.format = DXGI_FORMAT_R11G11B10_FLOAT;
    render_texture_desc.width = _resolution.x;
    render_texture_desc.height = _resolution.y;
    RenderTexture* tmp_0 = RenderTexture::GetTemporary(render_texture_desc);
    RenderTexture* tmp_1 = RenderTexture::GetTemporary(render_texture_desc);

    ComPtr<ID3D11ShaderResourceView> hdr_scene_srv;
    d3d_context->PSGetShaderResources(0, 1, hdr_scene_srv.GetAddressOf());
    ID3D11ShaderResourceView* next_input_srv = hdr_scene_srv.Get();
    
    if (do_taa)
    {
        ComPtr<ID3D11ShaderResourceView> avg_luma_srv;
        d3d_context->PSGetShaderResources(1, 1, avg_luma_srv.GetAddressOf());

        ComPtr<ID3D11Buffer> tonemap_cbuffer;
        d3d_context->PSGetConstantBuffers(3, 1, tonemap_cbuffer.GetAddressOf());
        next_input_srv = DrawTaa(d3d_context, next_input_srv, tonemap_cbuffer.Get(), avg_luma_srv.Get(), tonemap_shader_index);
    }

    // copy HDR buffer for next frame SSR
    _previous_frame_raw_hdr_buffer.CopyFromSRV(d3d_context, 0, SHADER_TYPE_PIXEL);
    _pipeline_state_manager.SetGlobalShaderResource(_previous_frame_raw_hdr_buffer.GetShaderResourceView(), "_previous_frame_raw_hdr_buffer"_id);

    if (do_bloom)
    {
        // Bloom
        int iteration_count = 9;
        RenderTexture* render_textures[12];
        RenderTexture* upsampled_render_textures[12];
        XMUINT2 resolutions[12];
        XMFLOAT4 texture_sizes[12];
        render_texture_desc.width = _resolution.x;
        render_texture_desc.height = _resolution.y;
        for (int i = 0; i < iteration_count; i++)
        {
            //if (i > 0)
            {
                render_textures[i] = RenderTexture::GetTemporary(render_texture_desc);
            }
            //if (i < iteration_count - 1)
            {
                upsampled_render_textures[i] = RenderTexture::GetTemporary(render_texture_desc);
            }
            resolutions[i] = { render_texture_desc.width, render_texture_desc.height };
            texture_sizes[i] = {
                static_cast<float>(resolutions[i].x), static_cast<float>(resolutions[i].y), 1.0f / resolutions[i].x, 1.0f / resolutions[i].y
            };
            render_texture_desc.width /= 2;
            render_texture_desc.height /= 2;
        }

        _post_processing_params_cbuffer->source_texture_size = texture_sizes[0];
        _post_processing_params_cbuffer->target_texture_size = texture_sizes[1];
        _post_processing_params_cbuffer.UploadBuffer();
        _pipeline_state_manager.SetShaderResourceView(next_input_srv, SHADER_TYPE_COMPUTE, 77);
        _pipeline_state_manager.SetUnorderedAccessView(render_textures[1]->GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
        if (do_taa)
        {
            _pipeline_state_manager.BindShader("DownsampleCS"_id);
        }
        else
        {
            _pipeline_state_manager.BindShader("DownsampleAntiFlickerCS"_id);
        }
        _pipeline_state_manager.BindResourcesForCurrentShaders();
        d3d_context->Dispatch(std::ceil(resolutions[1].x / 8.0), std::ceil(resolutions[1].y / 8.0), 1);
        _pipeline_state_manager.SetShaderResourceView(nullptr, SHADER_TYPE_COMPUTE, 77);
        _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 0);


        _pipeline_state_manager.BindShader("DownsampleCS"_id);
        _pipeline_state_manager.BindResourcesForCurrentShaders();
        for (int i = 1; i < iteration_count - 1; i++)
        {
            // downsample
            _post_processing_params_cbuffer->source_texture_size = texture_sizes[i];
            _post_processing_params_cbuffer->target_texture_size = texture_sizes[i + 1];
            _post_processing_params_cbuffer.UploadBuffer();
            _pipeline_state_manager.SetShaderResourceView(render_textures[i]->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 77);
            _pipeline_state_manager.SetUnorderedAccessView(render_textures[i + 1]->GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);

            d3d_context->Dispatch(std::ceil(resolutions[i + 1].x / 8.0), std::ceil(resolutions[i + 1].y / 8.0), 1);
            _pipeline_state_manager.SetShaderResourceView(nullptr, SHADER_TYPE_COMPUTE, 77);
            _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 0);
        }


        _pipeline_state_manager.BindShader("UpsampleCS"_id);
        _pipeline_state_manager.BindResourcesForCurrentShaders();
        auto* last = render_textures[iteration_count - 1];
        RenderTexture* current;
        RenderTexture* target = nullptr;

        float weight = 1.0f / (iteration_count - 1);
        for (int i = iteration_count - 1; i > 1; i--)
        {
            current = render_textures[i - 1];
            target = upsampled_render_textures[i - 1];

            // upsample
            _post_processing_params_cbuffer->source_texture_size = texture_sizes[i];
            _post_processing_params_cbuffer->target_texture_size = texture_sizes[i - 1];
            if(i == iteration_count - 1)
            {
                _post_processing_params_cbuffer->bloom_upscale_weight_0 = weight;
            }
            else
            {
                _post_processing_params_cbuffer->bloom_upscale_weight_0 = 1;
            }
            _post_processing_params_cbuffer->bloom_upscale_weight_1 = weight;
            _post_processing_params_cbuffer.UploadBuffer();
            _pipeline_state_manager.SetShaderResourceView(last->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 77);
            _pipeline_state_manager.SetShaderResourceView(current->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 78);
            _pipeline_state_manager.SetUnorderedAccessView(target->GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
            d3d_context->Dispatch(std::ceil(resolutions[i - 1].x / 8.0), std::ceil(resolutions[i - 1].y / 8.0), 1);
            _pipeline_state_manager.SetShaderResourceView(nullptr, SHADER_TYPE_COMPUTE, 77);
            _pipeline_state_manager.SetShaderResourceView(nullptr, SHADER_TYPE_COMPUTE, 78);
            _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 0);

            last = target;
        }

        d3d_context->CopyResource(_bloomed_scene_buffer.GetResource(), target->GetResource());

        // bloom combine
        _pipeline_state_manager.SetShaderResourceView(target->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 51);
        _pipeline_state_manager.SetShaderResourceView(next_input_srv, SHADER_TYPE_COMPUTE, 52);
        _post_processing_params_cbuffer->source_texture_size = _post_processing_params_cbuffer->target_texture_size;
        _post_processing_params_cbuffer.UploadBuffer();
        _pipeline_state_manager.SetUnorderedAccessView(tmp_1->GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
        _pipeline_state_manager.BindShader("BloomCombineCS"_id);
        _pipeline_state_manager.BindResourcesForCurrentShaders();
        d3d_context->Dispatch(std::ceil(_resolution.x / 8.0), std::ceil(_resolution.y / 8.0), 1);
        _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 0);
           
        for (int i = 0; i < iteration_count; i++)
        {
            //if (i > 0)
            {
                RenderTexture::ReleaseTemporary(render_textures[i]);
            }
            //if (i < iteration_count - 1)
            {
                RenderTexture::ReleaseTemporary(upsampled_render_textures[i]);
            }
        }
        
        next_input_srv = tmp_1->GetShaderResourceView();
    }

    // motion blur
    if (do_motion_blur)
    {
        RenderTextureDescription mb_mask_rtd;
        mb_mask_rtd.bind_flags = RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV;
        mb_mask_rtd.format = DXGI_FORMAT_R8_UNORM;
        mb_mask_rtd.width = _resolution.x;
        mb_mask_rtd.height = _resolution.y;
        RenderTexture* mb_mask = RenderTexture::GetTemporary(mb_mask_rtd);

        _pipeline_state_manager.BindShader("MotionBlurMaskCS"_id);
        _pipeline_state_manager.BindResourcesForCurrentShaders();

        _pipeline_state_manager.SetUnorderedAccessView(mb_mask->GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
        d3d_context->Dispatch(std::ceil(_resolution.x / 8.0f), std::ceil(_resolution.y / 8.0f), 1);

        _pipeline_state_manager.RestoreOriginalPipelineState();

        // motion blur
        _pipeline_state_manager.SetShaderResourceView(mb_mask->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 51);
        _pipeline_state_manager.SetShaderResourceView(next_input_srv, SHADER_TYPE_COMPUTE, 52);
        _pipeline_state_manager.SetUnorderedAccessView(tmp_0->GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
        _pipeline_state_manager.BindShader("MotionBlurCS"_id);
        _pipeline_state_manager.BindResourcesForCurrentShaders();
        d3d_context->Dispatch(std::ceil(_resolution.x / 8.0), std::ceil(_resolution.y / 8.0), 1);
        _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 0);
        // second pass to increase sample count (https://www.gdcvault.com/play/247/CRYSIS-Next-Gen)
        _pipeline_state_manager.SetShaderResourceView(tmp_0->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 52);
        _pipeline_state_manager.SetUnorderedAccessView(tmp_1->GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
        d3d_context->Dispatch(std::ceil(_resolution.x / 8.0), std::ceil(_resolution.y / 8.0), 1);
        _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 0);

        RenderTexture::ReleaseTemporary(mb_mask);

        next_input_srv = tmp_1->GetShaderResourceView();
    }

    // Tone mapping
    _pipeline_state_manager.SetShaderResourceView(next_input_srv, SHADER_TYPE_PIXEL, 0);
    if (tonemap_shader_index == 0)
    {
        _pipeline_state_manager.BindShader("Tonemap0PS"_id);
    }
    else
    {
        _pipeline_state_manager.BindShader("Tonemap1PS"_id);
    }
    _pipeline_state_manager.BindResourcesForCurrentShaders();
    d3d_context->Draw(3, 0);

    RenderTexture::ReleaseTemporary(tmp_0);
    RenderTexture::ReleaseTemporary(tmp_1);
}
ID3D11ShaderResourceView* PostProcessingRenderer::DrawTaa(ID3D11DeviceContext* d3d_context, ID3D11ShaderResourceView* input_srv, ID3D11Buffer* tonemap_cbuffer, ID3D11ShaderResourceView* avg_luma_srv, int
                                                          tonemap_shader_index)
{
    RenderTextureDescription rt_desc;
    rt_desc.format = DXGI_FORMAT_R11G11B10_FLOAT;
    rt_desc.bind_flags = RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV;
    rt_desc.width = _resolution.x;
    rt_desc.height = _resolution.y;
    RenderTexture* temporally_super_sampled = RenderTexture::GetTemporary(rt_desc);

    // composite half res nearest velocity, character mask and depth
    _pipeline_state_manager.SetUnorderedAccessView(_half_res_depth_mask_velocity_buffers[0]->GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
    _pipeline_state_manager.BindShader("CompositeVelocityCS"_id);
    _pipeline_state_manager.BindResourcesForCurrentShaders();
    d3d_context->Dispatch(std::ceil(_resolution.x * 0.5 / 8.0), std::ceil(_resolution.y * 0.5 / 8.0), 1);
    _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 0);

    rt_desc.format = DXGI_FORMAT_R16_FLOAT;
    rt_desc.bind_flags = RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV;
    rt_desc.width = _resolution.x;
    rt_desc.height = _resolution.y;
    RenderTexture* exposure_texture = RenderTexture::GetTemporary(rt_desc);

    ComPtr<ID3D11Buffer> original_cb3;
    d3d_context->CSGetConstantBuffers(3, 1, original_cb3.GetAddressOf());

    // write current frame luma and exposure
    _pipeline_state_manager.SetUnorderedAccessView(_luma_buffers[0]->GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
    _pipeline_state_manager.SetUnorderedAccessView(exposure_texture->GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 1);
    _pipeline_state_manager.SetShaderResourceView(input_srv, SHADER_TYPE_COMPUTE, 0);
    d3d_context->CSSetConstantBuffers(3, 1, &tonemap_cbuffer);
    _pipeline_state_manager.SetShaderResourceView(avg_luma_srv, SHADER_TYPE_COMPUTE, 1);
    if (tonemap_shader_index == 0)
    {
        _pipeline_state_manager.BindShader("StoreLuma0CS"_id);
    }
    else
    {
        _pipeline_state_manager.BindShader("StoreLuma1CS"_id);
    }
    _pipeline_state_manager.BindResourcesForCurrentShaders();
    d3d_context->Dispatch(std::ceil(_resolution.x / 8.0), std::ceil(_resolution.y / 8.0), 1);
    _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 0);
    _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 1);
    d3d_context->CSSetConstantBuffers(3, 1, original_cb3.GetAddressOf());

    _pipeline_state_manager.SetShaderResourceView(exposure_texture->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 14);

    // temporal supersampling pass
    _pipeline_state_manager.SetShaderResourceView(_previous_frame_raw_hdr_buffer.GetShaderResourceView(), SHADER_TYPE_COMPUTE, 1);

    _pipeline_state_manager.SetShaderResourceView(_half_res_depth_mask_velocity_buffers[0]->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 4);
    _pipeline_state_manager.SetShaderResourceView(_half_res_depth_mask_velocity_buffers[1]->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 5);
    _pipeline_state_manager.SetShaderResourceView(_half_res_depth_mask_velocity_buffers[2]->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 6);

    _pipeline_state_manager.SetShaderResourceView(_luma_buffers[0]->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 10);
    _pipeline_state_manager.SetShaderResourceView(_luma_buffers[1]->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 11);
    _pipeline_state_manager.SetShaderResourceView(_luma_buffers[2]->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 12);
    _pipeline_state_manager.SetShaderResourceView(_luma_buffers[3]->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 13);
    _pipeline_state_manager.BindShader("TAAResolveCS"_id);
    _pipeline_state_manager.BindResourcesForCurrentShaders();
    _pipeline_state_manager.SetUnorderedAccessView(temporally_super_sampled->GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
    d3d_context->Dispatch(std::ceil(_resolution.x / 8.0), std::ceil(_resolution.y / 8.0), 1);
    _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 0);

    // temporal filter CS pass
    _pipeline_state_manager.SetShaderResourceView(_history_taa_buffer->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 0);
    _pipeline_state_manager.SetShaderResourceView(temporally_super_sampled->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 1);
    _pipeline_state_manager.SetUnorderedAccessView(_current_taa_buffer->GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
    _pipeline_state_manager.BindShader("TAATemporalFilterCS"_id);
    _pipeline_state_manager.BindResourcesForCurrentShaders();
    d3d_context->Dispatch(std::ceil(_resolution.x / 8.0), std::ceil(_resolution.y / 8.0), 1);
    _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 0);
    _pipeline_state_manager.SetShaderResourceView(nullptr, SHADER_TYPE_COMPUTE, 2);

    _pipeline_state_manager.SetShaderResourceView(_current_taa_buffer->GetShaderResourceView(), SHADER_TYPE_COMPUTE, 0);
    _pipeline_state_manager.SetUnorderedAccessView(_taa_output_texture.GetUnorderedAccessView(), SHADER_TYPE_COMPUTE, 0);
    _pipeline_state_manager.BindShader("InverseTonemapCS"_id);
    d3d_context->Dispatch(std::ceil(_resolution.x / 8.0), std::ceil(_resolution.y / 8.0), 1);
    _pipeline_state_manager.SetUnorderedAccessView(nullptr, SHADER_TYPE_COMPUTE, 0);

    ID3D11ShaderResourceView* output_srv = _taa_output_texture.GetShaderResourceView();

    std::swap(_current_taa_buffer, _history_taa_buffer);

    auto* tmp = _luma_buffers[3];
    _luma_buffers[3] = _luma_buffers[2];
    _luma_buffers[2] = _luma_buffers[1];
    _luma_buffers[1] = _luma_buffers[0];
    _luma_buffers[0] = tmp;

    tmp = _half_res_depth_mask_velocity_buffers[2];
    _half_res_depth_mask_velocity_buffers[2] = _half_res_depth_mask_velocity_buffers[1];
    _half_res_depth_mask_velocity_buffers[1] = _half_res_depth_mask_velocity_buffers[0];
    _half_res_depth_mask_velocity_buffers[0] = tmp;

    RenderTexture::ReleaseTemporary(exposure_texture);
    RenderTexture::ReleaseTemporary(temporally_super_sampled);

    return output_srv;
}
