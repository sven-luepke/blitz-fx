#include "GameData.hlsli"
#include "CustomData.hlsli"
#include "GBuffer.hlsli"

Texture2D<float> history_shadow_mask : register(t42);
Texture2D<float> shadow_mask : register(t43);
Texture2D<float> previous_scene_depth : register(t44);

RWTexture2D<float> current_cascade_shadow_mask : register(u0);

SamplerState _linear_sampler;
SamplerState _point_sampler;

[numthreads(8, 8, 1)]
void CSMain( uint3 thread_id : SV_DispatchThreadID )
{
    float device_depth = _g_buffer_depth.Load(int3(thread_id.xy, 0));
    [branch]
    if (device_depth == 0)
    {
        return;
    }
    float2 tex_coord = ThreadIdToTexCoord(thread_id.xy, screenDimensions.zw);
    float current_shadow = shadow_mask.Load(int3(thread_id.xy, 0));
    float2 velocity_vector = ComputeTemporalReprojectionVector(tex_coord, device_depth);
    float2 history_tex_coord = tex_coord + velocity_vector.xy;
    [branch]
    if (any(history_tex_coord < 0) || any(history_tex_coord > 1))
    {
        current_cascade_shadow_mask[thread_id.xy] = current_shadow;
        return;
    }

    float neighbor_min = current_shadow;
    float neighbor_max = current_shadow;
    [unroll]
    for (int x = -1; x <= 1; x++)
    {
        [unroll]
        for (int y = -1; y <= 1; y++)
        {
            if (x == 0 && y == 0)
            {
                continue;
            }

            int2 position = thread_id.xy + int2(x, y);
            position = clamp(position, 0, screenDimensions.xy - 1);
            float neighbor_shadow = shadow_mask.Load(int3(position, 0));

            neighbor_min = min(neighbor_min, neighbor_shadow);
            neighbor_max = max(neighbor_max, neighbor_shadow);
        }
    }

    float scene_depth = DeviceToSceneDepth(device_depth);
    float4 previous_scene_depth_4 = previous_scene_depth.GatherRed(_linear_sampler, history_tex_coord);
    float4 history_shadow_4 = history_shadow_mask.GatherRed(_linear_sampler, history_tex_coord);
    [unroll]
    for (int i = 0; i < 4; i++)
    {
        // need to use abs here because otherwise the backgound shadow will bleed onto the foreground
        float bilateral_weight = saturate(1 - 10 * abs(scene_depth - previous_scene_depth_4[i]));
        history_shadow_4[i] = lerp(current_shadow, history_shadow_4[i], bilateral_weight);
    }
    float history_shadow = InterpolateGatheredBilinear(history_shadow_4, history_tex_coord, screenDimensions.xy);

    history_shadow = clamp(history_shadow, neighbor_min, neighbor_max);

    float alpha = Alpha(0.2);
    current_cascade_shadow_mask[thread_id.xy] = lerp(current_shadow, history_shadow, alpha);
}