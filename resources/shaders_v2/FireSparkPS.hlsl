#include "Common.hlsli"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb4 : register(b4)
{
float4 cb4[6];
}

cbuffer cb2 : register(b2)
{
float4 cb2[3];
}

void PSMain(
    float4 v0 : TEXCOORD0,
    float4 v1 : TEXCOORD1,
    float4 v2 : TEXCOORD2,
    float4 v3 : TEXCOORD3,
    out float4 o0 : SV_Target0,
    out float responsive_aa_mask : SV_Target1)
{
    float4 r0, r1;

    r0.xy = float2(1, 1) / cb4[2].xx;
    r0.x = v1.x * r0.x;
    r0.x = floor(r0.x);
    r0.z = 1 / cb4[3].x;
    r1.y = r0.x * r0.z;
    r0.x = floor(v1.x);
    r1.x = r0.x * r0.y;
    r0.xy = v1.yz * r0.yz + r1.xy;
    r0.xyz = t0.Sample(s0_s, r0.xy).xyz;

    float luma = Luminance(r0.xyz);

    r1.xyz = v3.www * r0.xyz;
    r0.w = dot(r1.xyz, float3(0.298999995, 0.587000012, 0.114));
    r0.xyz = -v3.www * r0.xyz + r0.www;
    r0.xyz = cb4[4].xxx * r0.xyz + r1.xyz;
    r1.xyz = cb4[1].xxx * cb4[0].xyz;
    r0.xyz = r1.xyz * r0.xyz;
    r0.xyz = log2(r0.xyz);
    r0.xyz = cb4[5].xxx * r0.xyz;
    r0.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r0.xyz = cb2[2].xyz * r0.xyz;
    r0.w = saturate(1 + -v2.w);
    r0.w = cb2[2].w * r0.w;
    o0.xyz = r0.xyz * r0.www;
    o0.w = 0;

    responsive_aa_mask = min(1, luma * 32);
}
