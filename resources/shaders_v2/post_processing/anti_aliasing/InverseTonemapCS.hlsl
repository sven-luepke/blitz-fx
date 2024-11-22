#include "TAACommon.hlsli"

Texture2D<float3> taa_tonemapped_texture : register(t0);

RWTexture2D<float3> output : register(u0);

[numthreads(8, 8, 1)]
void CSMain( uint3 thread_id : SV_DispatchThreadID )
{
    float3 tonemapped_color = taa_tonemapped_texture.Load(int3(thread_id.xy, 0));

    float exposure = GetExposure();;
    
    float3 hdr_color = TonemapReinhardInverse(tonemapped_color, exposure);

    output[thread_id.xy] = hdr_color;
}