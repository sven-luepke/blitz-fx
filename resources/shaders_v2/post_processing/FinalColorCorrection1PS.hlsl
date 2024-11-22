#include "PostProcessingCommon.hlsli"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

void PSMain(
	float4 sv_position : SV_Position0,
	float2 tex_coord : TEXCOORD0,
	float2 w1 : TEXCOORD2,
	out float4 o0 : SV_Target0)
{
	float4 r0, r1, r2;

	r0.xyz = t0.SampleLevel(s0_s, tex_coord.xy, 0).xyz;

    // gamma correction
	r0.xyz = log2(abs(r0.xyz));
	r0.xyz = cb3[8].xxx * r0.xyz;
	r0.xyz = exp2(r0.xyz);

    // parametric balance
    r0.xyz = ApplyParametricColorBalance(r0.xyz);

	r1.xyz = cb3[9].xyz * r0.xyz;
	r0.xyz = -r0.xyz * cb3[9].xyz + cb3[7].xyz;
	r2.xyz = log2(r1.xyz);
	r2.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r2.xyz;
	r2.xyz = exp2(r2.xyz);
	r0.w = dot(r2.xyz, cb3[6].xyz);
	r0.w = saturate(1 + -r0.w);
	r0.w = cb3[6].w * r0.w;

    // vignette
    [branch]
    if (vignette_intensity < 0.001)
    {
        r2.xy = float2(-0.5, -0.5) + w1.xy;
        r1.w = dot(r2.xy, r2.xy);
        r1.w = sqrt(r1.w);
        r1.w = r1.w * 2 + -0.550000012;
        r2.w = saturate(1.21951222 * r1.w);
        r2.z = r2.w * r2.w;
        r2.xy = r2.zz * r2.zw;
        r1.w = dot(float4(-0.100000001, -0.104999997, 1.12, 0.0900000036), r2.xyzw);
        r1.w = min(0.939999998, r1.w);
    }
    else
    {
        r1.w = 0;
    }

	r0.w = saturate(r1.w * r0.w);
	r0.xyz = r0.www * r0.xyz + r1.xyz;
	r0.w = cb3[15].y + -cb3[15].x;
	o0.xyz = saturate(r0.xyz * r0.www + cb3[15].xxx);
	o0.w = 1;

    ApplyPostProcessDithering(sv_position.xy, o0.rgb);
    o0.rgb *= GetCinematicBorder(sv_position.xy);

    ApplyDebugView(sv_position.xy, o0.rgb);
}
