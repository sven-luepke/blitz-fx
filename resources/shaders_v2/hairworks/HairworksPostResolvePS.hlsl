#include "Common.hlsli"

cbuffer cbPerFrame : register(b0)
{
    float g_msaaWidth : packoffset(c0);
    float g_msaaHeight : packoffset(c0.y);
    float g_msaaTopLeftX : packoffset(c0.z);
    float g_msaaTopLeftY : packoffset(c0.w);
    float g_userWidth : packoffset(c1);
    float g_userHeight : packoffset(c1.y);
    float g_userTopLeftX : packoffset(c1.z);
    float g_userTopLeftY : packoffset(c1.w);
    int g_sampleCountUser : packoffset(c2);
    int g_sampleCountMSAA : packoffset(c2.y);
    int g_depthComparisonLess : packoffset(c2.z);
    int g_emitPartialFragment : packoffset(c2.w);
}

Texture2D<float4> g_ColorTexture : register(t0);

void PSMain(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
    float4 r0;

    r0.xyzw = g_ColorTexture.Load(int3(v0.xy, 0)).xyzw;
    if (r0.w < 0.00001)
    {
        discard;
    }
    //r0.rgb = r0.rgb / max(1 - Luminance(r0.rgb), 0.0001);

    r0.w = saturate(r0.w);
    o0.xyz = r0.xyz / r0.www;
    o0.w = r0.w;
}