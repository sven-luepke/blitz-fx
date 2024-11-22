#include "PostProcessingCommon.hlsli"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

void PSMain(
	float4 sv_position : SV_Position0,
	float2 v1 : TEXCOORD0,
	float2 w1 : TEXCOORD2,
	out float4 o0 : SV_Target0)
{
	float4 r0, r1, r2;

    // vignette
    [branch]
    if (vignette_intensity < 0.001)
    {
        r0.xy = float2(-0.5, -0.5) + w1.xy;
        r0.x = dot(r0.xy, r0.xy);
        r0.x = sqrt(r0.x);
        r0.x = r0.x * 2 + -0.550000012;
        r0.w = saturate(1.21951222 * r0.x);
        r0.z = r0.w * r0.w;
        r0.xy = r0.zz * r0.zw;
        r0.x = dot(float4(-0.100000001, -0.104999997, 1.12, 0.0900000036), r0.xyzw);
        r0.x = min(0.939999998, r0.x);
    }
    else
    {
        r0.x = 0;
    }

	r0.yzw = t0.SampleLevel(s0_s, v1.xy, 0).xyz;

    // gamma correction
	r0.yzw = log2(abs(r0.yzw));
	r0.yzw = cb3[8].xxx * r0.yzw;
	r0.yzw = exp2(r0.yzw);

	r1.xyz = cb3[9].xyz * r0.yzw;
	r0.yzw = -r0.yzw * cb3[9].xyz + cb3[7].xyz;
	r2.xyz = log2(r1.xyz);
	r2.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r2.xyz;
	r2.xyz = exp2(r2.xyz);
	r1.w = dot(r2.xyz, cb3[6].xyz);
	r1.w = saturate(1 + -r1.w);
	r1.w = cb3[6].w * r1.w;
	r0.x = saturate(r1.w * r0.x);
	r0.xyz = r0.xxx * r0.yzw + r1.xyz;
	r0.w = cb3[15].y + -cb3[15].x;
	o0.xyz = saturate(r0.xyz * r0.www + cb3[15].xxx);
	o0.w = 1;

    ApplyPostProcessDithering(sv_position.xy, o0.rgb);
    o0.rgb *= GetCinematicBorder(sv_position.xy);

    ApplyDebugView(sv_position.xy, o0.rgb);
}
