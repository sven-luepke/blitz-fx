#include "Common.hlsli"
#include "GameData.hlsli"

Texture2D<float> full_res_depth : register(t15);
RWTexture2D<float> half_res_depth : register(u0);

SamplerState _linear_sampler;

/*
 * Downsample the depth buffer to half resolution by alternating between min and max in a checkerboard pattern.
 */

[numthreads(8, 8, 1)]
void CSMain(uint3 thread_id : SV_DispatchThreadID)
{
    float2 uv = float2(thread_id.xy + 0.5) * screenDimensions.zw * 2;

    float4 depths = full_res_depth.GatherRed(_linear_sampler, uv);

    float max_depth = max(depths.x, max(depths.y, max(depths.z, depths.w)));
    float min_depth = min(depths.x, min(depths.y, min(depths.z, depths.w)));

    half_res_depth[thread_id.xy] = Checkerboard(thread_id.xy) > 0.5f ? max_depth : min_depth;
}