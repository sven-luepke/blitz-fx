#include "BloomCommon.hlsli"

Texture2D<float3> source_last : register(t77);
Texture2D<float3> source_current : register(t78);
RWTexture2D<float3> target : register(u0);

[numthreads(8, 8, 1)]
void CSMain( uint3 thread_id : SV_DispatchThreadID )
{
    float2 uv = float2(thread_id.xy + 0.5) / float2(target_texture_size.xy);

    float2 offset = source_texture_size.zw;

    float3 color = BloomUpsample(source_last, uv, offset);

    float3 combined = color * bloom_upscale_weight_0;
    combined += source_current.Load(int3(thread_id.xy, 0)) * bloom_upscale_weight_1;
    target[thread_id.xy] = combined;
}