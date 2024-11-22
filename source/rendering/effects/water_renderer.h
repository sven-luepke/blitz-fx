#pragma once
#include "renderer_base.h"
#include "rendering/constant_buffer.h"
#include "rendering/render_texture.h"
#include "rendering/frustum_volume.h"

#include "wrl/client.h"

namespace w3
{
class WaterRenderer : public RendererBase
{
public:
    using RendererBase::RendererBase;

    void Initialize() override;
    void Terminate() override;
    void OnResize(int width, int height) override;

    void DrawWaterDepth(ID3D11DeviceContext* d3d_context);
    void GrabUnfoggedScene(ID3D11DeviceContext* d3d_context);
    void DrawWater(ID3D11DeviceContext* d3d_context, UINT index_count_per_instance, UINT instance_count,
        UINT start_index_location, INT base_vertex_location, UINT start_instance_location, ID3D11RenderTargetView* responsive_taa_mask_rtv);
    void DrawUnderwaterFog(ID3D11DeviceContext* d3d_context, UINT vertex_count, UINT start_vertex_location);
    void ClearWaterBuffers(ID3D11DeviceContext* d3d_context);

    FrustumVolumeParams GetWaterDepthVolumeParams() const;

private:
    RenderTexture _unfogged_scene{ DXGI_FORMAT_R11G11B10_FLOAT, RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV | RENDER_TEXTURE_BIND_RTV };
    RenderTexture _water_sky_ambient{ DXGI_FORMAT_R11G11B10_FLOAT, RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV };

    Microsoft::WRL::ComPtr<ID3D11ShaderResourceView> _interior_dimmer_texture;
    Microsoft::WRL::ComPtr<ID3D11Buffer> _water_cb4;
    Microsoft::WRL::ComPtr<ID3D11ShaderResourceView> _water_geometry_atlas;
    Microsoft::WRL::ComPtr<ID3D11ShaderResourceView> _water_wave_texture;
    Microsoft::WRL::ComPtr<ID3D11ShaderResourceView> _terrain_height_map;
    Microsoft::WRL::ComPtr<ID3D11ShaderResourceView> _terrain_lut;

    RenderTexture _underwater_reflection_fallback_paraboloid{ DXGI_FORMAT_R11G11B10_FLOAT, RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV };

    RenderTexture _water_depth{ DXGI_FORMAT_R16_FLOAT, RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV };

    FrustumVolumeParams _water_depth_volume_params;
    RenderTexture _water_depth_volume{ DXGI_FORMAT_R16_FLOAT, RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV };

    struct WaterRenderingParams
    {
        DirectX::XMFLOAT4 underwater_fog_blur_direction;
    };
    ConstantBuffer<WaterRenderingParams> _water_rendering_params_cbuffer;
    RenderTexture _underwater_fog_transmittance_texture{ DXGI_FORMAT_R11G11B10_FLOAT, RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV };
};
}
