#pragma once
#include "d3d_interface.h"
#include "red_shader_ids.h"
#include "cbuffer_structs.h"
#include "DirectXMath.h"
#include "effects/post_processing_renderer.h"
#include "effects/shadow_renderer.h"
#include "config.h"
#include "effects/water_renderer.h"

namespace w3
{

class RenderingEngine : D3DInterface
{
public:
    RenderingEngine(PipelineStateManager& pipeline_state_manager, ConstantBuffer<CustomFrameData>& custom_frame_data_cbuffer);
    void Initialize();
    void Terminate();

    void OnResize(int width, int height);

    void OnUpdateConstantBuffer(GameFrameData* data);
    void OnUpdateConstantBuffer(GameLightingData* data); 
    void OnUpdateConstantBuffer(FrameCB* data);
    void OnUpdateConstantBuffer(GameTerrainData* data);
    void OnUpdateConstantBuffer(GameWaterData* data);

    bool OnDraw(RedShaderBinding red_shader_binding, UINT vertex_count, UINT start_vertex_location);
    bool OnDrawInstanced(RedShaderBinding red_shader_binding, UINT vertex_count_per_instance, UINT instance_count, UINT start_vertex_location,
        UINT start_instance_location);
    bool OnDrawIndexed(RedShaderBinding red_shader_binding, UINT index_count, UINT start_index_location, INT base_vertex_location);
    bool OnDrawIndexedInstanced(RedShaderBinding red_shader_binding, UINT index_count_per_instance, UINT instance_count,
        UINT start_index_location, INT base_vertex_location, UINT start_instance_location);
    bool OnDispatch(RedShaderBinding red_shader_binding, UINT thread_group_count_x, UINT thread_group_count_y, UINT thread_group_count_z);

    void OnPresent();
    void SetConfiguration(Configuration configuration);
    Configuration GetConfiguration() const;

    bool IsCutscene() const;
    const std::vector<int> GetPlayerLightIndices() const;

    double GetFrameTime() const;

private:
    void StartTimer();
    double GetTime();
    double RefreshFrameTime();

    bool IsCameraCut(const float3& current_camera_position, const float3& previous_camera_position, const float3& current_camera_direction, const float3 previous_camera_direction);

    PipelineStateManager& _pipeline_state_manager;
    ConstantBuffer<CustomFrameData>& _custom_frame_data_cbuffer;

    ShadowRenderer _shadow_renderer;
    WaterRenderer _water_renderer;
    PostProcessingRenderer _post_processing_renderer;

    Configuration _configuration;

    DirectX::XMINT2 _resolution;
    DirectX::XMFLOAT2 _taa_jitter;
    float3 _directional_light_direction;
    float3 _current_camera_position;
    float3 _previous_camera_position;
    float3 _current_camera_direction;
    float3 _previous_camera_direction;

    float _current_water_color_luma;
    float _previous_water_color_luma;
    float4 _history_water_color;

    bool _enabled_water_shader_this_frame = false;
    bool _is_water_shader_active = false;
    bool _is_before_lighting_pass = true;
    bool _is_ansel_enabled = false;
    bool _is_cutscene = false;
    bool _is_bob = false;
    bool _is_inventory = false;

    // timing (source: https://www.braynzarsoft.net/viewtutorial/q16390-15-high-resolution-timer)
    double _counts_per_second = 0.0;
    __int64 _counter_start = 0;
    int _frame_count = 0;
    __int64 _frame_time_old = 0;
    double _frame_time;

    float _camera_lights_non_character_scale = 1;

    std::vector<int> _player_light_indices;

    RenderTexture _responsive_aa_mask{ DXGI_FORMAT_R8_SNORM, RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_RTV };

    Microsoft::WRL::ComPtr<ID3D11ShaderResourceView> _underwater_post_process_mask;
    bool _apply_underwater_fog_mask = false;

    RenderTexture _aurora_texture_0{ DXGI_FORMAT_R16G16B16A16_FLOAT, RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV };
    RenderTexture _aurora_texture_1{ DXGI_FORMAT_R16G16B16A16_FLOAT, RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_UAV };
    RenderTexture* _current_aurora_texture;
    RenderTexture* _history_aurora_texture;
};

inline Configuration RenderingEngine::GetConfiguration() const
{
    return _configuration;
}
}
