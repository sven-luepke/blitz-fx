#pragma once
#include "renderer_base.h"
#include "rendering/render_texture.h"

namespace w3
{
class ShadowRenderer : public RendererBase
{
public:
    using RendererBase::RendererBase;

    void Initialize() override;
    void Terminate() override;
    void OnResize(int width, int height) override;

    void RenderDirectionalShadows(bool enable_contact_shadows);
    void StorePreviousSceneDepth();

private:
    RenderTexture _shadow_mask_0{ DXGI_FORMAT_R16_FLOAT, RENDER_TEXTURE_BIND_UAV | RENDER_TEXTURE_BIND_SRV };
    RenderTexture _shadow_mask_1{ DXGI_FORMAT_R16_FLOAT, RENDER_TEXTURE_BIND_UAV | RENDER_TEXTURE_BIND_SRV };
    RenderTexture* _history_shadow_mask;
    RenderTexture* _current_shadow_mask;

    RenderTexture _previous_scene_depth{ DXGI_FORMAT_R32_FLOAT, RENDER_TEXTURE_BIND_UAV | RENDER_TEXTURE_BIND_SRV };
};
}
