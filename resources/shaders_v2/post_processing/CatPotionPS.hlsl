#include "Common.hlsli"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> depth_texture : register(t1);
Texture2D<float4> color_texture : register(t0);

SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

cbuffer cb12 : register(b12)
{
    float4 cb12[214];
}
cbuffer cb3 : register(b3)
{
    float4 cb3[7];
}
cbuffer cb0 : register(b0)
{
    float4 cb0[2];
}

#define cmp -

void PSMain(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_Position0,
  out float4 o0 : SV_Target0)
{
    float4 r0, r1, r2, r3;

    r0.xy = cb3[6].xy * v1.xy;
    r0.x = t2.Sample(s2_s, r0.xy).x;
    r1.xyzw = float4(0.707000017, 0, 0, 0.707000017) * cb3[6].zwzw;
    r2.xyzw = v1.xyxy * cb3[6].xyxy + r1.xyzw;
    r1.xyzw = v1.xyxy * cb3[6].xyxy + -r1.xyzw;
    r0.y = t2.Sample(s2_s, r2.xy).x;
    r0.z = t2.Sample(s2_s, r2.zw).x;
    r0.x = r0.x + r0.y;
    r0.y = t2.Sample(s2_s, r1.xy).x;
    r0.w = t2.Sample(s2_s, r1.zw).x;
    r0.x = r0.x + r0.y;
    r0.x = r0.x + r0.z;
    r0.x = r0.x + r0.w;
    r0.x = cb3[0].x * r0.x;
    r0.x = 0.200000003 * r0.x;

    r0.yz = cb0[1].zw * v1.xy;
    r2.xyz = color_texture.Sample(s0_s, r0.yz).xyz;

    r0.yz = 0;
    r0.z = r0.z * r0.z;
    r0.w = 1 + -r0.y;
    r0.y = -r0.y * r0.y + 1;
    r0.w = cb3[0].w * r0.w * 3 + cb3[0].w;
    r0.w = -cb3[0].w * 0.25 * 3 + r0.w;
    r1.x = 0.25 * cb3[0].w * 3;
    r0.z = r0.z * r0.w + r1.x;
    r0.w = 0.200000003 * r0.z;
    r1.xyz = cb3[3].xyz * r0.www;
    r3.xyz = cb3[2].xyz * r0.zzz + -r1.xyz;
    r0.yzw = r0.yyy * r3.xyz + r1.xyz;

    r1.x = Luminance(r2.xyz);

    r0.yzw = r0.yzw * r1.xxx + -r2.xyz;
    r0.yzw = cb3[0].yyy * r0.yzw + r2.xyz;
    r0.xyz = cb3[5].xyz * r0.xxx + r0.yzw;

    r0.xyz = r0.xyz + -r2.xyz;
    r0.xyz = cb3[0].xxx * r0.xyz + r2.xyz;

    o0.xyz = min(1.1, r0.xyz);
    o0.w = 1;
}