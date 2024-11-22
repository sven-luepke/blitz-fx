#include "PostProcessingCommon.hlsli"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

// only gamma correction an screen fade
void PSMain(
  float4 sv_position : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
    float4 r0;
    r0.xyz = t0.SampleLevel(s0_s, v1.xy, 0).xyz;

    // gamma correction
    r0.rgb = pow(r0.rgb, cb3[8].x);

    // fade in/out
    r0.xyz = cb3[9].xyz * r0.xyz;
    r0.w = cb3[15].y + -cb3[15].x;
    o0.xyz = saturate(r0.xyz * r0.www + cb3[15].xxx);
    o0.w = 1;

    ApplyPostProcessDithering(sv_position.xy, o0.rgb);
    o0.rgb *= GetCinematicBorder(sv_position.xy);

    ApplyDebugView(sv_position.xy, o0.rgb);
}