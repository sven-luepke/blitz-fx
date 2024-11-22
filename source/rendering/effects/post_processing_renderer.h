#pragma once
#include "rendering/constant_buffer.h"
#include "renderer_base.h"
#include "rendering/render_texture.h"

#include "wrl/client.h"
#include "DirectXMath.h"


namespace w3
{
struct PostProcessingParams
{
    DirectX::XMFLOAT4 source_texture_size;
    DirectX::XMFLOAT4 target_texture_size;
    float bloom_upscale_weight_0;
    float bloom_upscale_weight_1;
    float pad[2];
};

class PostProcessingRenderer : public RendererBase
{
public:
    using RendererBase::RendererBase;

    void Initialize() override;
    void Terminate() override;
    void OnResize(int width, int height) override;

    void DrawRainDrops(ID3D11DeviceContext* d3d_context, UINT index_count_per_instance, UINT instance_count,
        UINT start_index_location, INT base_vertex_location, UINT start_instance_location, ID3D11RenderTargetView* responsive_aa_rtv);
    void DrawRainDropsBob(ID3D11DeviceContext* d3d_context, UINT index_count_per_instance, UINT instance_count,
        UINT start_index_location, INT base_vertex_location, UINT start_instance_location, ID3D11RenderTargetView* responsive_aa_rtv);
    void HdrPostProcess(ID3D11DeviceContext* d3d_context, bool do_motion_blur, int tonemap_shader_index, bool do_bloom, bool do_taa);

private:
    ID3D11ShaderResourceView* DrawTaa(ID3D11DeviceContext* d3d_context, ID3D11ShaderResourceView* input_srv, ID3D11Buffer* tonemap_cbuffer,
                                      ID3D11ShaderResourceView* avg_luma_srv, int tonemap_shader_index);

    ConstantBuffer<PostProcessingParams> _post_processing_params_cbuffer;

    RenderTexture _previous_frame_raw_hdr_buffer{DXGI_FORMAT_R11G11B10_FLOAT, RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV};
    RenderTexture _taa_output_texture{ DXGI_FORMAT_R11G11B10_FLOAT, RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV };

    RenderTexture _taa_buffer_0{DXGI_FORMAT_R16G16B16A16_FLOAT, RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV};
    RenderTexture _taa_buffer_1{DXGI_FORMAT_R16G16B16A16_FLOAT, RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV};

    RenderTexture* _history_taa_buffer;
    RenderTexture* _current_taa_buffer;

    RenderTexture _half_res_depth_mask_velocity_buffer_0{ DXGI_FORMAT_R32G32_FLOAT, RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV };
    RenderTexture _half_res_depth_mask_velocity_buffer_1{ DXGI_FORMAT_R32G32_FLOAT, RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV };
    RenderTexture _half_res_depth_mask_velocity_buffer_2{ DXGI_FORMAT_R32G32_FLOAT, RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV };
    RenderTexture* _half_res_depth_mask_velocity_buffers[3];

    // luminance of previous frame for color weighting
    RenderTexture _luma_buffer_0{DXGI_FORMAT_R16_FLOAT, RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV};
    RenderTexture _luma_buffer_1{DXGI_FORMAT_R16_FLOAT, RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV};
    RenderTexture _luma_buffer_2{DXGI_FORMAT_R16_FLOAT, RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV};
    RenderTexture _luma_buffer_3{DXGI_FORMAT_R16_FLOAT, RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV};
    RenderTexture* _luma_buffers[4];

    RenderTexture _bloomed_scene_buffer{ DXGI_FORMAT_R11G11B10_FLOAT, RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_RTV };
};
}
