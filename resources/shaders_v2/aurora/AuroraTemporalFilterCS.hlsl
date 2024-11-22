#include "Common.hlsli"
#include "CustomData.hlsli"
#include "GameData.hlsli"

Texture2D<float3> current_aurora_texture : register(t0);
Texture2D<float4> history_aurora_texture : register(t1);

RWTexture2D<float4> output : register(u0);

SamplerState _linear_sampler;

[numthreads(8, 8, 1)]
void CSMain(uint3 thread_id : SV_DispatchThreadID)
{
    float2 tex_coord = ThreadIdToTexCoord(thread_id.xy, screenDimensions.zw * 2);
    float3 current_aurora = current_aurora_texture.Load(int3(thread_id.xy, 0));
    float2 history_tex_coord = NdcXYToTexCoord(ComputeHistoryNdc(tex_coord, 0));
    [branch]
    if (any(history_tex_coord < 0) || any(history_tex_coord > 1))
    {
        output[thread_id.xy] = float4(current_aurora, 1);
        return;
    }

    float3 neighbor_min = current_aurora;
    float3 neighbor_max = current_aurora;
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
            float3 neighbor_sample = current_aurora_texture.Load(int3(position, 0));

            neighbor_min = min(neighbor_min, neighbor_sample);
            neighbor_max = max(neighbor_max, neighbor_sample);
        }
    }

    float4 history_sample = history_aurora_texture.SampleLevel(_linear_sampler, history_tex_coord, 0);

    float sample_frame_count = history_sample.w + 1;
    float alpha = max(0.1, rcp(sample_frame_count));

    float3 clamped_history = clamp(history_sample.rgb, neighbor_min, neighbor_max);
    float3 temporally_filtered_aurora = lerp(clamped_history, current_aurora, alpha);
    output[thread_id.xy] = float4(temporally_filtered_aurora, sample_frame_count);
}