#include "CustomData.hlsli"
#include "GameData.hlsli"
#include "GBuffer.hlsli"

Texture2D<float> screen_space_shadow_mask : register(t42);
Texture2D<float> cascade_shadow_mask : register(t43);

RWTexture2D<float> combined_shadow_mask : register(u0);

SamplerState _linear_sampler;

[numthreads(8, 8, 1)]
void CSMain(uint3 thread_id : SV_DispatchThreadID)
{
    float device_depth = _g_buffer_depth.Load(int3(thread_id.xy, 0));
    [branch]
    if (device_depth == 0)
    {
        return;
    }
    float scene_depth = DeviceToSceneDepth(device_depth);
    float current = screen_space_shadow_mask.Load(int3(thread_id.xy, 0));

    float total = 0;
    int sample_count = 0;
    [unroll]
    for (int x = -1; x <= 1; x++)
    {
        [unroll]
        for (int y = -1; y <= 1; y++)
        {
            int2 pos = thread_id.xy + int2(x, y);
            if (any(pos < 0) && any(pos >= screenDimensions.xy))
            {
                continue;
            }
            float neighbor_scene_depth = DeviceToSceneDepth(_g_buffer_depth.Load(int3(pos, 0)));
            if (GetDepthSimilarity(scene_depth, neighbor_scene_depth, 0.01) < 0.01)
            {
                continue;
            }
            total += screen_space_shadow_mask.Load(uint3(pos, 0));
            sample_count += 1;
        }
    }
    float contact_shadow = sample_count > 0 ? total / sample_count : current;
    float cascade_shadow = cascade_shadow_mask.Load(int3(thread_id.xy, 0));

    combined_shadow_mask[thread_id.xy] = min(contact_shadow, cascade_shadow);
}