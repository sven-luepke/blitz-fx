#include "Common.hlsli"

Texture2D<float> t0 : register(t0);

cbuffer cb3 : register(b3)
{
    float4 cb3[2];
}

SamplerState _point_sampler;

void PSMain(
    float4 v0 : SV_Position0,
    out float4 o0 : SV_Target0)
{
    float4 r0;

    r0.xy = floor(v0.xy);

    float2 resolution_rcp = rcp(cb3[0].xy);
    float2 tex_coord = ThreadIdToTexCoord(r0.xy, resolution_rcp);

    o0.xyzw = t0.SampleLevel(_point_sampler, tex_coord, 0);
}