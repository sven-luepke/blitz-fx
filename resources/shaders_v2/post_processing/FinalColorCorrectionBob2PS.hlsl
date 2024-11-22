#include "PostProcessingCommon.hlsli"

Texture2D<float4> vignette_texture : register(t2);
Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);
SamplerState s0_s : register(s0);

void PSMain(
  float4 sv_position : SV_Position0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD2,
  out float4 o0 : SV_Target0)
{
    float4 r0, r1, r2;

    r0.xyz = t0.SampleLevel(s0_s, v1.xy, 0).xyz;
    r0.xyz = log2(abs(r0.xyz));
    r0.xyz = cb3[8].xxx * r0.xyz;
    r0.xyz = exp2(r0.xyz);

    r0.xyz = ApplyParametricColorBalance(r0.xyz);

    r1.xyz = -r0.xyz * cb3[9].xyz + cb3[7].xyz;
    r0.xyz = cb3[9].xyz * r0.xyz;
    r2.xyz = log2(r0.xyz);
    r2.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r2.xyz;
    r2.xyz = exp2(r2.xyz);
    r0.w = dot(r2.xyz, cb3[6].xyz);
    r0.w = saturate(1 + -r0.w);
    r0.w = cb3[6].w * r0.w;

    [branch]
    if (vignette_intensity < 0.001)
    {
        r1.w = vignette_texture.Sample(s2_s, w1.xy).x;
    }
    else
    {
        r1.w = 0;
    }    

    r0.w = saturate(r1.w * r0.w);
    r0.xyz = r0.www * r1.xyz + r0.xyz;
    r0.w = cb3[15].y + -cb3[15].x;
    o0.xyz = saturate(r0.xyz * r0.www + cb3[15].xxx);
    o0.w = 1;

    ApplyPostProcessDithering(sv_position.xy, o0.rgb);
    o0.rgb *= GetCinematicBorder(sv_position.xy);

    ApplyDebugView(sv_position.xy, o0.rgb);
}