#include "PostProcessingCommon.hlsli"

Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);

void PSMain(
	float4 sv_position : SV_Position0,
	float2 tex_coord : TEXCOORD0,
	float2 w1 : TEXCOORD2,
	out float4 o0 : SV_Target0)
{
	float4 r0, r1, r2;

	r0.xy = cb3[17].zw * sv_position.xy;
    r2.xyz = t0.SampleLevel(s1_s, r0.xy, 0).xyz;

    // chromatic aberation
	r0.zw = sv_position.xy * cb3[17].zw + -cb3[17].xy;
	r0.zw = r0.zw / cb3[17].xy;
	r1.x = dot(r0.zw, r0.zw);
	r1.x = sqrt(r1.x);
	r1.y = -cb3[16].y + r1.x;
	r1.y = saturate(cb3[16].z * r1.y);
    if (0 < r1.y)
	{
		r1.y = r1.y * r1.y;
		r1.y = cb3[16].x * r1.y;
		r1.x = max(9.99999975e-005, r1.x);
		r1.x = r1.y / r1.x;
		r0.zw = r1.xx * r0.zw;
		r0.zw = cb3[17].zw * r0.zw;
		r0.xy = -r0.zw * float2(2, 2) + r0.xy;
		r2.x = t0.SampleLevel(s1_s, r0.xy, 0).x;
		r0.xy = sv_position.xy * cb3[17].zw + -r0.zw;
		r2.y = t0.SampleLevel(s1_s, r0.xy, 0).y;
	}

    // gamma correction
	r0.xyz = log2(abs(r2.xyz));
	r0.xyz = cb3[8].xxx * r0.xyz;
	r0.xyz = exp2(r0.xyz);

    // parametric balance
    r0.xyz = ApplyParametricColorBalance(r0.xyz);

	r1.xyz = cb3[9].xyz * r0.xyz;

    // vignette
    [branch]
    if (vignette_intensity < 0.001)
    {
        r2.xy = float2(-0.5, -0.5) + w1.xy;
        r0.w = dot(r2.xy, r2.xy);
        r0.w = sqrt(r0.w);
        r0.w = r0.w * 2 + -0.550000012;
        r2.w = saturate(1.21951222 * r0.w);
        r2.z = r2.w * r2.w;
        r2.xy = r2.zz * r2.zw;
        r0.w = dot(float4(-0.100000001, -0.104999997, 1.12, 0.0900000036), r2.xyzw);
        r0.w = min(0.939999998, r0.w);
    }
    else
    {
        r0.w = 0;
    }

	r2.xyz = log2(r1.xyz);
	r2.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r2.xyz;
	r2.xyz = exp2(r2.xyz);
	r1.w = dot(r2.xyz, cb3[6].xyz);
	r1.w = saturate(1 + -r1.w);
	r1.w = cb3[6].w * r1.w;
	r0.w = saturate(r1.w * r0.w);
	r0.xyz = -r0.xyz * cb3[9].xyz + cb3[7].xyz;
	r0.xyz = r0.www * r0.xyz + r1.xyz;
	r0.w = cb3[15].y + -cb3[15].x;
	o0.xyz = saturate(r0.xyz * r0.www + cb3[15].xxx);
	o0.w = 1;

    ApplyPostProcessDithering(sv_position.xy, o0.rgb);
    o0.rgb *= GetCinematicBorder(sv_position.xy);

    ApplyDebugView(sv_position.xy, o0.rgb);
}
