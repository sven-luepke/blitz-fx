#include "Common.hlsli"
#include "FogCommon.hlsli"
#include "CustomData.hlsli"
#include "GBuffer.hlsli"
#include "WaterCommon.hlsli"
#include "ScatteringCommon.hlsli"
#include "Noise.hlsli"

Texture2D<float4> t24 : register(t24);
Texture2DArray<float4> t19 : register(t19);
Texture2D<float4> t17 : register(t17);
Texture2D<float> depth_buffer : register(t15);
Texture2DArray<float4> t14 : register(t14);
Texture2DArray<float4> t8 : register(t8);
Texture2D<float4> scene : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2DArray<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);

SamplerState s15_s : register(s15);
SamplerState s14_s : register(s14);
SamplerState s10_s : register(s10);
SamplerComparisonState s9_s : register(s9);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

cbuffer cb5 : register(b5)
{
float4 cb5[1];
}

cbuffer cb4 : register(b4)
{
float4 cb4[116];
}

cbuffer cb1 : register(b1)
{
float4 cb1[11];
}

cbuffer cb13 : register(b13)
{
    float4 cb13[3323];
}
cbuffer cb12 : register(b12)
{
    float4 cb12[269];
}


float3 SuperSampleT5(float2 uv, out float z_variance)
{
    // per pixel partial derivatives
    float2 dx = ddx(uv.xy);
    float2 dy = ddy(uv.xy); // rotated grid uv offsets
    float2 uvOffsets = float2(0.125, 0.375);
    float2 offsetUV = float2(0.0, 0.0); // supersampled using 2x2 rotated grid
    float3 normal = 0;

    float m1 = 0;
    float m2 = 0;

    offsetUV.xy = uv.xy + uvOffsets.x * dx + uvOffsets.y * dy;
    float3 nor = t5.SampleLevel(s5_s, offsetUV, 0).xyz;
    normal += nor;
    m1 += nor.z;
    m2 += Square(nor.z);

    offsetUV.xy = uv.xy - uvOffsets.x * dx - uvOffsets.y * dy;
    nor = t5.SampleLevel(s5_s, offsetUV, 0).xyz;
    normal += nor;
    m1 += nor.z;
    m2 += Square(nor.z);

    offsetUV.xy = uv.xy + uvOffsets.y * dx - uvOffsets.x * dy;
    nor = t5.SampleLevel(s5_s, offsetUV, 0).xyz;
    normal += nor;
    m1 += nor.z;
    m2 += Square(nor.z);

    offsetUV.xy = uv.xy - uvOffsets.y * dx + uvOffsets.x * dy;
    nor = t5.SampleLevel(s5_s, offsetUV, 0).xyz;;
    normal += nor;
    m1 += nor.z;
    m2 += Square(nor.z);

    normal *= 0.25;
    float mu = m1 * 0.25;
    z_variance = sqrt(max(m2 * 0.25 - mu * mu, 0));
    return normal;
}

#define DRAG_MULT 0.036
#define ITERATIONS_NORMAL 20


float4 wavedx(float2 position, float2 direction, float speed, float frequency, float time, float flatness, float height)
{
    float theta = dot(direction, position);
    float x = theta * frequency + time * speed;

    float f = Square(flatness - 1);

    float sin_x, cos_x;
    sincos(x, sin_x, cos_x);
    float exp_sin_x_1 = exp(sin_x - 1);

    float wave = lerp(exp_sin_x_1, sin_x * 0.5 + 0.5, f);
    float offset = lerp(wave * cos_x, 0, f);

    float common = cos_x * frequency * height;
    float dx = lerp(exp_sin_x_1, 0.5, f) * common * direction.x;
    float dy = lerp(exp_sin_x_1, 0.5, f) * common * direction.y;

    return float4(wave, -offset, dx, dy);
}

float3 normal_wave(float2 position, float height, float iteration_multiplier)
{
    float iterations = max(ITERATIONS_NORMAL * iteration_multiplier, 2);
    position *= 0.1;

    float iter = 0.0;
    float phase = 6.0;
    float speed = 4.0;
    float weight = 1.0;
    float ws = 0.0;
    float flatness = 1.0f;

    float2 dxdy = 0;

    [unroll]
    for (int i = 0; i < iterations; i++)
    {
        iter = frac(i * 1.618033);
        float2 p;
        sincos(iter * PI_2, p.x, p.y);

        float4 res = wavedx(position, p, speed, phase, Time, flatness, height);
        position += p * res.y * weight * DRAG_MULT * height;
        dxdy += res.zw * weight;

        ws += weight;
        weight = lerp(weight, 0.0, 0.22);
        phase *= 1.18;
        speed *= 1.085;
        flatness *= 1.035;
    }
    dxdy /= ws;

    return normalize(float3(-dxdy.x, -dxdy.y, ws));
}

SamplerState _linear_mirror_sampler;

#define cmp -

void PSMain(
	float4 sv_position : SV_Position0,
	float2 v1 : TEXCOORD0,
	float water_surface_scene_depth : TEXCOORD2,
	float4 world_position : TEXCOORD3,
	float4 aerial_fog : TEXCOORD4,
	float4 fog : TEXCOORD5,
    bool is_front_face : SV_IsFrontFace,
	out float4 o0 : SV_Target0,
	out float4 o1 : SV_Target1,
    out float responsive_aa_mask : SV_Target2)
{
	const float4 icb[] =
	{
		{1.000000, 0, 0, 0},
		{0, 1.000000, 0, 0},
		{0, 0, 1.000000, 0},
		{0, 0, 0, 1.000000}
	};
	float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18;
	
	float4 fDest;

	r0.xy = sv_position.xy / cb0[1].xy;
	r0.zw = -cb0[1].zw * float2(0.5, 0.5) + cb0[2].xy;
	r1.xy = float2(2.5, 2.5) / cb0[2].xy;
	r2.x = -r1.x;
	r2.z = 0;
	r2.xy = saturate(r0.xy * float2(0.5, 0.5) + r2.xz);
	r2.x = t3.Sample(s3_s, r2.xy).z;
	r1.z = 0;
	r3.xyzw = saturate(r0.xyxy * float4(0.5, 0.5, 0.5, 0.5) + r1.xzzy);
	r1.x = t3.Sample(s3_s, r3.xy).z;
	r4.x = r2.x + -r1.x;
	r1.x = t3.Sample(s3_s, r3.zw).z;
	r1.w = -r1.y;
	r1.yz = saturate(r0.xy * float2(0.5, 0.5) + r1.zw);
	r1.y = t3.Sample(s3_s, r1.yz).z;
	r4.y = r1.x + -r1.y;
	r4.z = 1;
	r1.x = dot(r4.xyz, r4.xyz);
	r1.x = rsqrt(r1.x);
	r1.yzw = r4.xyz * r1.xxx;
	r2.yz = -cb1[8].xy + world_position.xy;
	r2.y = dot(r2.yz, r2.yz);
	r2.y = sqrt(r2.y);
	r3.xyzw = float4(350, 2000, 40, 2000) + -r2.yyyy;
	r3.xyzw = float4(0.00285714283, 0.000500000024, 0.0250000004, 0.0005) * r3.xyzw;
	r3.xyzw = max(float4(0, 0, 0, 0), r3.xyzw);
	r2.z = r3.x * r3.x;
	r2.z = r2.z * r2.z;
	r2.w = r2.z * r2.z;
	r5.xyzw = v1.xyxy / cb4[0].xxyy;
	r6.xy = v1.xy / cb4[0].zz;

    float mip_level_0 = ComputeMipLevel(r5.xy, 512.0f);

	r6.zw = t5.SampleLevel(s5_s, r5.xy, 0).xy;
	r7.xy = t5.SampleLevel(s5_s, r5.zw, 0).xy;
	r8.xy = t5.SampleLevel(s5_s, r6.xy, 0).xy;

    float mip_level_1 = ComputeMipLevel(r6.xy, 512.0f);
    float iteration_multiplier = 1 - Rescale(0, 10, mip_level_1);
    float height_scale = 1 - Rescale(0, 14, mip_level_1);
    float2 detail_tex_coord = r6.xy;

	t17.GetDimensions(0, fDest.x, fDest.y, fDest.z);
	r4.w = fDest.x;
	r4.w = (int)r4.w;
	r9.yzw = float3(0, 0, 0);
	r6.y = 0;
	r7.zw = float2(0, 0);
	r8.w = 0;
	while (true)
	{
		r10.x = cmp((int)r7.w >= (int)r4.w);
		r8.w = 0;
		if (r10.x != 0)
			break;
		r9.x = r7.w;
		r10.xyzw = t17.Load(r9.xyz).xyzw;
		r10.xy = cmp(r10.xy < world_position.xy);
		r10.zw = cmp(world_position.xy < r10.zw);
		r9.x = r10.z ? r10.x : 0;
		r9.x = r10.y ? r9.x : 0;
		r9.x = r10.w ? r9.x : 0;
		if (r9.x != 0)
		{
			r7.z = r7.w;
			r8.w = -1;
			break;
		}
		r6.x = (int)r7.w + 1;
		r7.zw = r6.yx;
		r8.w = r9.x;
	}
	r9.x = r8.w ? r7.z : -1;
	r4.w = cmp((int)r9.x >= 0);
	if (r4.w != 0)
	{
		r9.yzw = float3(1, 0, 0);
		r10.xyzw = t17.Load(r9.xww).xyzw;
		r11.xyzw = t17.Load(r9.xyz).xyzw;
		t4.GetDimensions(0, fDest.x, fDest.y, fDest.z, fDest.w);
		r6.xy = fDest.xy;
		r7.zw = world_position.xy + -r10.xy;
		r9.yz = r10.zw + -r10.xy;
		r7.zw = r7.zw / r9.yz;
		r6.xy = float2(0.5, 0.5) / r6.xy;
		r6.xy = abs(r7.zw) + r6.xy;
		r7.zw = r11.zw + -r11.xy;
		r10.xy = r6.xy * r7.zw + r11.xy;
		r10.z = (int)r9.x;
		r4.w = t4.SampleLevel(s4_s, r10.xyz, 0).x;
		r4.w = saturate(r4.w);
		r6.x = cb5[0].y + -cb5[0].x;
		r4.w = r4.w * r6.x + cb5[0].x;
	}
	else
	{
		r4.w = -10;
	}
	r4.w = world_position.z + -r4.w;
    float distance_to_terrain = r4.w;
    float tmp_r4w = r4.w;

    bool is_above_terrain = false;
    if (r4.w >= 0)
    {
        r4.w = -10 + r4.w * 2 + 0.5;
        is_above_terrain = true;
    }

    r6.x = saturate(-0.100000001 * r4.w);
    r4.w = tmp_r4w;

    float small_wave_intensity;
    float wind_scale = 0.25 + 0.75 * Rescale(0, 3, water_wind_scale);
    if (r4.w >= 0)
    {
       small_wave_intensity = lerp(1.5, 0.5, r6.x) * wind_scale;
    }
    else
    {
        small_wave_intensity = lerp(0.5 * wind_scale, 0.1, r6.x);
        r6.x = max(r6.x, 0.8);
    }
    r8.xy = normal_wave(detail_tex_coord.xy * 32, small_wave_intensity * 0.5, iteration_multiplier).xy * height_scale;
    r8.xy *= 0.001;

	r6.x = 1 + -r6.x;
	r9.xyz = r3.xxx * float3(0, 1, 1) + float3(1, 0, -1);
	r9.xyz = r6.xxx * r9.xyz + float3(0, 0, 1);
	r7.zw = cb4[3].zw * r6.xx;
	r5.xy = r7.zz * r6.zw + r5.xy;

    float z_variance = 0;
	r6.yzw = t5.SampleLevel(s5_s, r5.xy, 0).xyz;
    r6.yzw = SuperSampleT5(r5.xy, z_variance);

	r5.xy = r7.ww * r7.xy + r5.zw;

	r5.xyz = t5.SampleLevel(s5_s, r5.xy, 0).xyz;
    // TODO: plug in strong wind normals

    // foam calculations
	r5.w = max(0.0500000007, cb4[1].w);
	r5.w = min(1, r5.w);
	r7.xy = float2(0.200000003, 15) * abs(r4.ww);
	r7.xy = min(float2(1, 1), r7.xy);
	r7.xz = r7.xx * float2(0.400000006, 0.400000006) + float2(-0.920000017, -0.200000003);
	r7.xz = r5.ww * r7.xz + float2(0.920000017, 0.200000003);
	r7.z = r7.z * r5.z;
	r7.x = r7.x * r6.w + r7.z;
	r7.x = max(0, r7.x);
	r7.x = min(100, r7.x);
	r3.x = r7.x * r3.x;

    r5.xyz = float3(0, 0, 1); 

	r6.w = 0.000150000007;
	r7.x = dot(r6.yzw, r6.yzw);
	r7.x = rsqrt(r7.x);
	r3.yzw = r9.xyz * r3.yzw;
	r6.yzw = r6.yzw * r7.xxx + float3(-0, -0, -1);
	r6.yzw = r3.yyy * r6.yzw + float3(0, 0, 1);
	r3.y = dot(r6.yzw, r6.yzw);
	r3.y = rsqrt(r3.y);
	r5.z = 0.000349999988;
	r7.x = dot(r5.xyz, r5.xyz);
	r7.x = rsqrt(r7.x);
	r5.xyz = r5.xyz * r7.xxx + float3(-0, -0, -1);
	r5.xyz = r3.zzz * r5.xyz + float3(0, 0, 1);
	r3.z = dot(r5.xyz, r5.xyz);
	r3.z = rsqrt(r3.z);
	r8.z = 0.00079999998;
	r7.x = dot(r8.xyz, r8.xyz);
	r7.x = rsqrt(r7.x);
	r7.xzw = r8.xyz * r7.xxx + float3(-0, -0, -1);
	r7.xzw = r3.www * r7.xzw + float3(0, 0, 1);
	r3.w = dot(r7.xzw, r7.xzw);
	r3.w = rsqrt(r3.w);
	r7.xzw = r7.xzw * r3.www;
	r5.xyz = r5.xyz * r3.zzz + float3(0, 0, 1);
	r7.xzw = float3(-1, -1, 1) * r7.xzw;
	r3.z = dot(r7.xzw, r7.xzw);
	r3.z = rsqrt(r3.z);
	r7.xzw = r7.xzw * r3.zzz;
	r3.z = dot(r5.xyz, r7.xzw);
	r7.xzw = r7.xzw * r5.zzz;
	r5.xyz = r5.xyz * r3.zzz + -r7.xzw;
	r3.z = dot(r5.xyz, r5.xyz);
	r3.z = rsqrt(r3.z);
	r7.xzw = r5.xyz * r3.zzz;
	r6.yzw = r6.yzw * r3.yyy + float3(0, 0, 1);
	r8.xyz = float3(-1, -1, 1) * r7.xzw;
	r3.y = dot(r8.xyz, r8.xyz);
	r3.y = rsqrt(r3.y);
	r8.xyz = r8.xyz * r3.yyy;
	r3.y = dot(r6.yzw, r8.xyz);
	r8.xyz = r8.xyz * r6.www;
	r6.yzw = r6.yzw * r3.yyy + -r8.xyz;
	r3.y = dot(r6.yzw, r6.yzw);
	r3.y = rsqrt(r3.y);
	r6.yzw = r6.yzw * r3.yyy;
	r3.y = saturate(1 + -r2.x);
	r6.yz = r6.yz * r3.yy;
	r3.y = dot(r6.yzw, r6.yzw);
	r3.y = rsqrt(r3.y);
	r6.yzw = r6.yzw * r3.yyy;


	r3.yw = -cb4[4].xy + world_position.xy;
	r3.yw = r3.yw * float2(0.0333333351, 0.0333333351) + float2(0.5, 0.5);
	r8.xyzw = t1.SampleLevel(s1_s, r3.yw, 0).xyzw;
	r3.yw = (int2)sv_position.xy;
	r5.xz = (int2)r3.yw ^ int2(2, 2);
	r3.yw = max((int2)-r3.yw, (int2)r3.yw);
	r3.yw = (uint2)r3.yw >> int2(1, 1);
	r9.xy = -(int2)r3.yw;
	r5.xz = (int2)r5.xz & int2(0, 0);
	r9.xy = r5.xz ? r9.xy : r3.yw;
	r9.zw = float2(0, 0);

    // read ambient dimmer
	r3.yw = t24.Load(r9.xyz).xy;
	r9.xyz = -cb12[0].xyz + world_position.xyz;
	r5.x = dot(r9.xyz, r9.xyz);
	r5.x = sqrt(r5.x);
	r10.x = cb12[1].z;
	r10.y = cb12[2].z;
	r10.z = cb12[3].z;
	r5.z = dot(r10.xyz, r9.xyz);
	r7.z = 1 / cb12[21].y;
	r7.z = r7.z * r5.x;
	r5.z = r7.z / r5.z;
	r5.z = r5.x + -r5.z;
	r5.z = saturate(cb13[33].w * r5.z);
	r5.z = cb13[33].z * r5.z;
	r5.z = max(0.00100000005, r5.z);
	r5.x = r5.x / cb13[34].z;
	r7.z = cmp(r3.y < r3.w);
	if (r7.z != 0)
	{
        // camera outside interior
		r9.y = cb13[34].z * r3.y + -cb13[34].x;
		r9.y = saturate(-r9.y * cb13[34].y + 1);
		r9.z = r5.x + -r3.y;
		r9.z = cb13[34].z * r9.z;
		r9.z = saturate(r9.z / r5.z);

		r11.y = r9.y * r9.z;
		r11.x = 1;
        r9.xy = r5.x < r3.y || r3.w < r5.x ? float2(0, 1) : r11.xy;
    }
	else
	{
        // camera inside interior
		r7.z = cmp(r3.w < r3.y);
		r9.z = cmp(r5.x < r3.w);
		r9.w = cmp(r3.y < r5.x);

		r3.y = cb13[34].z * r3.y + -cb13[34].x;
		r11.y = saturate(-r3.y * cb13[34].y + 1);
		r3.y = r5.x + -r3.w;
		r3.y = cb13[34].z * r3.y;
		r3.y = saturate(r3.y / r5.z);

		r11.w = 1 + -r3.y;
		r11.xz = float2(1, 1);
		r3.yw = r9.ww ? r11.xy : r11.zw;
		r3.yw = r9.zz ? float2(1, 1) : r3.yw;
		r9.xy = r7.zz ? r3.yw : float2(0, 1);
	}
    float2 dimmer = r9.xy;


	r3.y = -r9.y * r9.x + 1;
	r2.y = -r2.y * 0.0500000007 + 1;
	r2.y = max(0, r2.y);
	r5.xz = r8.zw * r2.yy;
	r9.xy = r5.xz * r3.yy;
	r8.z = 0.00499999989;
	r2.y = dot(r8.xyz, r8.xyz);
	r2.y = rsqrt(r2.y);
	r11.xyz = r8.xyz * r2.yyy;
	r9.z = 0.0500000007;
	r2.y = dot(r9.xyz, r9.xyz);
	r2.y = rsqrt(r2.y);
	r9.w = r11.z;
	r12.xyz = r9.xyw * r2.yyy;
	r9.xyz = r12.xyz * r9.wwz + r11.xyz;
	r2.y = dot(r9.xyz, r9.xyz);
	r2.y = rsqrt(r2.y);
	r11.xyz = r9.xyz * r2.yyy;
	r1.w = r11.z * r1.w;
	r1.w = min(1, r1.w);
	r12.xyz = r1.www * float3(0.999989986, 0.999989986, -39) + float3(9.99999975e-006, 9.99999975e-006, 40);
	r6.yzw = r12.xyz * r6.yzw;
	r1.w = dot(r6.yzw, r6.yzw);
	r1.w = rsqrt(r1.w);
	r6.yzw = r6.yzw * r1.www;
	r9.xyz = r9.xyz * r2.yyy + float3(0, 0, 1);
	r6.yzw = float3(-1, -1, 1) * r6.yzw;
	r1.w = dot(r6.yzw, r6.yzw);
	r1.w = rsqrt(r1.w);
	r6.yzw = r6.yzw * r1.www;
	r1.w = dot(r9.xyz, r6.yzw);
	r6.yzw = r6.yzw * r9.zzz;
	r6.yzw = r9.xyz * r1.www + -r6.yzw;
	r1.w = dot(r6.yzw, r6.yzw);
	r1.w = rsqrt(r1.w);
	r6.yzw = r6.yzw * r1.www;
	r4.xyz = r4.xyz * r1.xxx + float3(0, 0, 1);
	r6.yzw = float3(-1, -1, 1) * r6.yzw;
	r1.x = dot(r6.yzw, r6.yzw);
	r1.x = rsqrt(r1.x);
	r6.yzw = r6.yzw * r1.xxx;
	r1.x = dot(r4.xyz, r6.yzw);
	r6.yzw = r6.yzw * r4.zzz;
	r4.xyz = r4.xyz * r1.xxx + -r6.yzw;
	r1.x = dot(r4.xyz, r4.xyz);
	r1.x = rsqrt(r1.x);
	r6.yzw = r4.xyz * r1.xxx;


    r1.w = DeviceToSceneDepth(depth_buffer.Sample(s15_s, r0.xy));
	
	r2.y = -water_surface_scene_depth.x + r1.w;
	r9.zw = abs(r2.yy);
	r12.xyz = -cb1[8].xyz + world_position.xyz;
	r2.y = dot(r12.xyz, cb1[10].xyz);
	r2.y = 4.5 * abs(r2.y);
	r2.y = min(1, r2.y);
	r2.y = log2(r2.y);
	r2.y = 6.4000001 * r2.y;
	r2.y = exp2(r2.y);
	r3.yw = r5.ww * float2(-0.0149999997, 0.699999988) + float2(0.0299999993, 0.300000012);
	r4.xy = r3.yy * r6.yz;
	r3.y = r9.w + r9.w;
	r3.y = min(1, r3.y);
	r4.xy = r4.xy * r3.yy;
	r4.xy = r4.xy * r2.yy;
	r4.xy = r4.xy * r2.ww;
	r3.y = 0;
	r5.x = 0;
	while (true)
	{
		r5.z = cmp((int)r5.x >= asint(cb4[51].x));
		if (r5.z != 0)
			break;
		r5.z = (uint)r5.x << 2;

        uint4 bitmask;
		bitmask.x = ((~(-1 << 30)) << 2) & 0xffffffff;
		r13.x = (((uint)r5.x << 2) & bitmask.x) | ((uint)1 & ~bitmask.x);
		bitmask.y = ((~(-1 << 30)) << 2) & 0xffffffff;
		r13.y = (((uint)r5.x << 2) & bitmask.y) | ((uint)2 & ~bitmask.y);
		bitmask.z = ((~(-1 << 30)) << 2) & 0xffffffff;
		r13.z = (((uint)r5.x << 2) & bitmask.z) | ((uint)3 & ~bitmask.z);
		r14.xyz = -cb4[r13.z + 52].xyz + world_position.xyz;
		r7.z = dot(r14.xyz, cb4[r5.z + 52].xyz);
		r5.z = dot(cb4[r5.z + 52].xyz, cb4[r5.z + 52].xyz);
		r15.x = r7.z / r5.z;
		r5.z = dot(r14.xyz, cb4[r13.x + 52].xyz);
		r7.z = dot(cb4[r13.x + 52].xyz, cb4[r13.x + 52].xyz);
		r15.y = r5.z / r7.z;
		r5.z = dot(r14.xyz, cb4[r13.y + 52].xyz);
		r7.z = dot(cb4[r13.y + 52].xyz, cb4[r13.y + 52].xyz);
		r15.z = r5.z / r7.z;
		r5.z = dot(r15.xyz, r15.xyz);
		r5.z = sqrt(r5.z);
		r5.z = min(1, r5.z);
		r5.z = log2(r5.z);
		r5.z = 16 * r5.z;
		r5.z = exp2(r5.z);
		r5.z = -r5.z + r3.y;
		r3.y = 1 + r5.z;
		r5.x = (int)r5.x + 1;
	}
	r3.y = saturate(r3.y);
	r5.x = 1 + -r3.y;
	r3.x = r5.x * r3.x;
	r13.xy = r5.xx * r4.xy;
	r4.xy = r4.xy * r5.xx + r0.xy;

    r4.x = DeviceToSceneDepth(depth_buffer.Sample(s15_s, r4.xy));
	
	r4.y = dot(r10.xyz, r12.xyz);
	r4.y = cmp(r4.x < r4.y);
	r4.x = -water_surface_scene_depth.x + r4.x;

	r13.zw = abs(r4.xx);
	r9.xy = float2(0, 0);
	r9.xyzw = r4.yyyy ? r9.xyzw : r13.xyzw;
	r4.x = 2 + -r5.w;
	r10.xyzw = float4(0.100000001, 0.100000001, 0.300000012, 0.300000012) * r11.xyxy;
	r4.xy = r9.xy * r4.xx + r10.xy;
	r1.yz = r1.yz * float2(0.25, 0.25) + r4.xy;
	r11.xyzw = float4(1.20000005, 1.20000005, 0.200000003, 0.200000003) * v1.xyxy;
	r1.yz = r1.yz * float2(0.159999996, 0.159999996) + r11.xy;
	r4.x = cos(cb0[0].x);
	r4.xy = r10.zw * r4.xx;
	r1.yz = r1.yz * float2(2.20000005, 2.20000005) + r4.xy;
	r1.yz = cb0[0].xx * float2(0.0500000007, 0.0500000007) + r1.yz;
	r10.xy = r6.yz * float2(0.400000006, 0.400000006) + r1.yz;
	r10.z = 0;
	r1.y = t0.Sample(s0_s, r10.xyz).x;
	r4.xy = world_position.xy * float2(0.800000012, 0.800000012) + r11.zw;
	r10.xyzw = float4(0.639999986, 0.639999986, 3, 0.5) * r9.xyzw;
	r11.xy = r4.xy * float2(0.180000007, 0.180000007) + r10.xy;
	r11.z = 0;
	r1.z = t0.Sample(s0_s, r11.xyz).y;
	r1.y = r1.y * r1.z;
	r11.xyz = cb1[8].xyz + -world_position.xyz;
	r13.xyz = r6.yzw * float3(0.00499999989, 0.00499999989, 0.0500000007) + r11.xyz;
	r4.x = dot(r13.xyz, r13.xyz);
	r4.x = rsqrt(r4.x);
	r14.xyz = r13.xyz * r4.xxx;
	r4.y = dot(cb0[9].xyz, cb0[9].xyz);
	r4.y = rsqrt(r4.y);
	r15.xyz = cb0[9].xyz * r4.yyy;
	r8.zw = r9.xy + r0.xy;


	r0.z = dot(r6.yz, r6.yz);
	r0.z = rsqrt(r0.z);
	r0.zw = r6.yz * r0.zz;
	r0.zw = float2(0.00499999989, 0.00499999989) * r0.zw;
	r3.z = dot(r12.xyz, r12.xyz);
	r3.z = rsqrt(r3.z);
	r9.xyz = r12.xyz * r3.zzz;
	r3.z = dot(cb1[10].xyz, r9.xyz);
	r3.z = 1 / r3.z;
	r9.xyz = r9.xyz * r3.zzz;
	r9.xyz = r9.xyz * r1.www + cb1[8].xyz;
	r0.zw = r9.xy * float2(0.119999997, 0.119999997) + r0.zw;
	r5.yz = cb13[0].xy * r9.zz;
	r0.zw = -r5.yz * float2(0.100000001, 0.100000001) + r0.zw;
	r9.xy = cb0[0].xx * float2(0.00499999989, 0.00499999989) + r0.zw;
	r9.z = 0;
	r0.z = t0.Sample(s0_s, r9.xyz).w;
	r5.yz = float2(1.70000005, 1) + -abs(r4.ww);
	r5.y = saturate(r5.y);
	r0.w = r7.y * r5.y;
	r0.z = r0.z * r0.w;
	r0.w = -r2.z * r2.z + 1.01999998;
	r0.w = 3 * r0.w;
	r9.xy = r0.ww * r6.yz;
	r9.z = 0;
	r9.xyz = world_position.xyz + -r9.xyz;
	r0.w = cmp(0 < asint(cb13[35].x));
	if (r0.w != 0)
	{
		r8.zw = -cb12[0].xy + r9.xy;
		r0.w = dot(r8.zw, r8.zw);
		r0.w = sqrt(r0.w);
		r2.z = cmp(r0.w < cb13[36].y);
		if (r2.z != 0)
		{
			r2.z = cb13[37].z * r0.w;
			r2.z = max(1, r2.z);
			r2.z = cb13[36].x / r2.z;
			r2.z = min(1, r2.z);
			r0.w = cb13[36].z + r0.w;
			r0.w = saturate(cb13[36].w * r0.w);
			r10.y = 0;
			r8.zw = float2(0, 0);
			r3.z = 0;
			while (true)
			{
				r4.y = cmp((int)r8.w >= asint(cb13[35].x));
				r3.z = 0;
				if (r4.y != 0)
					break;
				r10.zw = -cb13[r8.w + 39].xy + r9.xy;
				r12.xy = cb13[r8.w + 39].zw * r10.zw;
				r17.xy = cmp(r12.xy >= float2(0, 0));
				r4.y = r17.y ? r17.x : 0;
				r17.xy = cmp(float2(1, 1) >= r12.xy);
				r4.y = r4.y ? r17.x : 0;
				r4.y = r17.y ? r4.y : 0;
				if (r4.y != 0)
				{
					r12.z = (int)r8.w;
					r12.w = -r10.w * cb13[r8.w + 39].w + 1;
					r7.y = t19.SampleLevel(s10_s, r12.xwz, 0).x;
					r7.y = cb13[38].x * r7.y + cb13[38].y;
					r7.y = r7.y + -r9.z;
					r7.y = -0.100000001 + r7.y;
					r7.y = saturate(r7.y * r2.z);
					r7.y = 1 + -r7.y;
					r10.z = 1 + -r7.y;
					r8.z = r0.w * r10.z + r7.y;
					r3.z = -1;
					break;
				}
				r10.x = (int)r8.w + 1;
				r8.zw = r10.yx;
				r3.z = r4.y;
			}
		}
		else
		{
			r3.z = 0;
		}
	}
	else
	{
		r3.z = 0;
	}
	r0.w = r3.z ? r8.z : 1;
	r2.z = cmp(0 < r0.w);
	if (r2.z != 0)
	{
		r10.xyz = cb13[5].xyz * r9.yyy;
		r10.xyz = cb13[4].xyz * r9.xxx + r10.xyz;
		r10.xyz = cb13[6].xyz * r9.zzz + r10.xyz;
		r10.xyz = cb13[7].xyz + r10.xyz;
		r2.z = cmp(abs(r10.z) >= 0.999000013);
		if (r2.z != 0)
		{
			r3.z = 1;
		}
		if (r2.z == 0)
		{
			r12.xyzw = -cb13[8].xyzw + r10.xxxx;
			r17.xyzw = -cb13[9].xyzw + r10.yyyy;
			r12.xyzw = max(abs(r17.xyzw), abs(r12.xyzw));
			r17.xyzw = cmp(r12.xyzw < cb13[10].xyzw);
			r17.xyzw = r17.xyzw ? float4(1, 1, 1, 1) : 0;
			r18.xyzw = cmp(float4(0.5, 1.5, 2.5, 3.5) < cb13[15].zzzz);
			r18.xyzw = r18.xyzw ? float4(1, 1, 1, 1) : 0;
			r2.z = dot(r17.xyzw, r18.xyzw);
			r4.y = cmp(r2.z < 0.5);
			if (r4.y != 0)
			{
				r3.z = 1;
			}
			if (r4.y == 0)
			{
				r12.xyzw = r12.xyzw / cb13[10].xyzw;
				r17.xyzw = float4(1, 1, 1, 1) + -cb13[17].xyzw;
				r12.xyzw = -r17.xyzw + r12.xyzw;
				r12.xyzw = saturate(r12.xyzw / cb13[17].xyzw);
				r2.z = cb13[15].z + -r2.z;
				r7.y = (int)r2.z;
				r8.z = (int)cb13[15].z;
				r8.z = (int)r8.z + -1;
				r17.xy = cb13[r7.y + 11].zz * float2(1, -1);
				r17.xy = r10.xy * r17.xy + cb13[r7.y + 11].xy;
				r17.z = trunc(r2.z);
				r2.z = cmp(asint(cb13[18].x) >= 1);

                r2.z = t8.SampleCmpLevelZero(s9_s, r17.xyz, r10.z).x;
                r2.z *= r2.z;

				r7.y = (int)r8.z;
				r7.y = cmp(r17.z >= r7.y);
				r7.y = r7.y ? 1.000000 : 0;
				r8.z = dot(r12.xyzw, icb[r8.z + 0].xyzw);
				r2.z = r7.y * r8.z + r2.z;
				r2.z = min(1, r2.z);
			}
			else
			{
				r2.z = 1;
			}
			r3.z = r4.y ? r3.z : r2.z;
		}
		r0.w = min(r3.z, r0.w);
	}
	r2.z = 20 * cb12[66].x;
	r10.zw = trunc(cb12[68].xy);
	r12.xyz = -cb12[0].xyz + r9.xyz;
	r3.z = dot(r12.xyz, r12.xyz);
	r3.z = sqrt(r3.z);
	r12.xy = cb12[67].xy;
	r12.z = 0;
	r12.xyz = r12.xyz + r9.xyz;
	r12.xyz = float3(0.00999999978, 0.00999999978, 0.00999999978) * r12.xyz;
	r12.xyz = r12.xyz / cb12[66].xxx;
	r17.xy = float2(20, 20) * cb12[67].xy;
	r17.z = 0;
	r9.xyz = r17.xyz + r9.xyz;
	r9.xyz = float3(0.00999999978, 0.00999999978, 0.00999999978) * r9.xyz;
	r9.xyz = r9.xyz / r2.zzz;
	r8.zw = cb13[0].xy * r12.zz;
	r8.zw = r8.zw / cb13[0].zz;
	r10.xy = r12.xy + -r8.zw;
	r8.zw = cb13[0].xy * r9.zz;
	r8.zw = r8.zw / cb13[0].zz;
	r12.xy = r9.xy + -r8.zw;
	r2.z = t14.SampleLevel(s14_s, r10.xyz, 1).x;
	r4.y = t14.SampleLevel(s14_s, r10.xyw, 1).x;
	r4.y = r4.y + -r2.z;
	r2.z = cb12[66].w * r4.y + r2.z;
	r12.zw = r10.zw;
	r4.y = t14.SampleLevel(s14_s, r12.xyz, 1).x;
	r7.y = t14.SampleLevel(s14_s, r12.xyw, 1).x;
	r7.y = r7.y + -r4.y;
	r4.y = cb12[66].w * r7.y + r4.y;
	r7.y = -0.25 + cb13[0].z;
	r7.y = saturate(10 * r7.y);
	r3.z = -100 + r3.z;
	r3.z = saturate(0.00666666683 * r3.z);
	r4.y = r4.y + -r2.z;
	r2.z = r3.z * r4.y + r2.z;
	r2.z = -r7.y * r2.z + 1;
	r0.w = r2.z * r0.w;

    float surface_shadow_factor = r0.w;

	r8.zw = cb12[211].zw * r0.yy;
	r0.xy = cb12[210].zw * r0.xx + r8.zw;
	r0.xy = cb12[212].zw * r1.ww + r0.xy;
	r0.xy = cb12[213].zw + r0.xy;
	r0.x = r0.x / r0.y;
	r0.x = -world_position.w + r0.x;
	r0.y = dot(r11.xy, r11.xy);
	r0.y = sqrt(r0.y);
	r1.w = saturate(1 + r11.z);
	r1.w = r1.w * 0.350000024 + 0.649999976;
	r1.w = r2.y * r1.w;
	r2.y = abs(r8.x) + abs(r8.y);
	r8.xy = float2(0.0160000008, 0.0109999999) * r0.yy;
	r2.z = 1 + -r6.x;
	r3.z = saturate(r0.y * 0.00499999989 + -r2.z);
	r4.y = -r9.w + abs(r4.w);
	r3.z = r3.z * r4.y + r9.w;
	r3.z = log2(r3.z);
	r3.z = 0.600000024 * r3.z;
	r3.z = exp2(r3.z);
	r4.y = saturate(cb0[9].w);
	r9.xyz = r4.yyy * float3(0.169999987, 0, 0.0300000012) + float3(0.330000013, 0.319999993, 0.310000002);
	r9.xyz = r9.xyz * r3.zzz;
	r4.y = r5.y * r1.y;
	r8.zw = min(float2(1, 0.300000012), r3.xx);
	r10.xy = float2(10, 20) * r2.yy;
	r4.y = saturate(r4.y * r8.z + -r10.x);
	r10.xz = float2(0.150000006, 0.00999999978) * r1.zz;
	r5.y = r1.y * 0.899999976 + r10.x;
	r5.y = r5.y * r2.y;
	r5.y = 20 * r5.y;
	r5.y = saturate(r5.y * r8.w);
	r3.w = r3.w * r4.y + r5.y;
	r11.z = r4.z * r1.x + r8.x;
	r0.y = -r0.y * 0.00555555569 + 1;
	r0.y = max(0, r0.y);
	r0.y = max(0.0500000007, r0.y);

    r0.y = 1 - Rescale(0, 8, mip_level_0);

	r11.xy = r6.yz * r0.yy;
	r0.y = dot(r11.xyz, r11.xyz);
	r0.y = rsqrt(r0.y);
	r8.xzw = r11.xyz * r0.yyy;

    float3 normal = normalize(r8.xzw);

    if (is_above_terrain)
    {
        r6.x = 1;
    }

	r4.xyz = r4.xyz * r6.x;
	r0.y = -r5.w * 5 + 7;
	r1.x = log2(r3.x);
	r0.y = r1.x * r0.y;
	r0.y = exp2(r0.y);
	r0.y = 0.100000001 * r0.y;
	r1.x = saturate(dot(r6.yzw, cb0[9].xyz));
	r1.x = 1 + -r1.x;
	r1.x = r1.x * 0.8 + 0.200000003;
	r0.y = r1.x * r0.y;
	r1.x = 0.5 + cb0[13].x;
	r1.x = max(0, r1.x);
	r1.x = min(20, r1.x);
	r5.y = r1.x + r1.x;
	r5.y = min(1, r5.y);
	r5.y = r6.x * r5.y;
	r0.y = r5.y * r0.y;
	r3.z = r3.z * r1.w;
	r3.xz = float2(0.5, 0.5) * r3.xz;
	r3.z = min(1, r3.z);
	r3.z = r3.z * -0.25 + 1;
	r5.y = r10.z * r10.z;
	r5.y = r5.y * r5.y;
	r7.y = r5.y * r5.y;
	r3.x = log2(r3.x);
	r3.x = 12 * r3.x;
	r3.x = exp2(r3.x);
	r3.x = min(1, r3.x);
	r5.y = -r5.y * r5.y + r1.z;
	r3.x = r3.x * r5.y + r7.y;
	r5.y = rsqrt(r3.x);
	r5.y = 1 / r5.y;
	r5.y = r5.y * 0.5 + -r3.x;
	r3.x = r5.w * r5.y + r3.x;
	r5.y = max(0, r5.z);
	r5.z = 1 + -r5.y;
	r3.x = r5.z * r3.x;
	r3.x = r3.x * r5.w;
	r5.z = saturate(r2.x);
	r3.x = r5.z * -r3.x + r3.x;
	r1.y = r2.y * r1.y;
	r1.y = r1.y * 0.5 + r3.x;

    // disable costal foam
	//r1.y = max(r1.y, r3.w);

	r2.y = 20 * cb0[12].z;
	r3.x = cb0[12].w * 20 + -r2.y;
	r2.y = r0.w * r3.x + r2.y;

    float shadow_interior = r0.w;
    float foam = r1.y * 20;

	r1.y = r2.y * r1.y;
	r2.y = r6.x * 0.899999976 + 0.100000001;
	r1.y = r2.y * r1.y;

	r0.z = saturate(cb0[12].y * r0.z);
	r2.y = r0.w * 0.699999988 + 0.300000012;
	r11.xyzw = float4(3, 0.5, 0.74000001, 1) * r0.yyyy;
	r3.x = min(1, r11.x);
	r0.z = r3.x * r0.z;
	r3.x = r2.y * r0.z;	
	r8.xzw = r2.yyy * r0.zzz + cb0[11].xyz * (0.5 + shadow_interior);
	r3.xzw = r7.xzw * r3.zzz + r3.xxx;
	r4.xyz = r4.xyz * r0.www + r8.xzw;
	r0.z = r1.x * r1.y;

    foam *= r1.x;
    //float foam = r1.x;

	r7.xyz = max(r11.yzw, r0.zzz);
	r4.xyz = r7.xyz + r4.xyz;
	r1.x = r2.x * r1.x;
	r1.y = saturate(r1.z * 0.850000024 + 0.150000006);
	r1.y = 4.5 * r1.y;
	r1.x = log2(r1.x);
	r1.x = 1.60000002 * r1.x;
	r1.x = exp2(r1.x);
	r1.x = r1.y * r1.x;
	r1.y = min(1, r10.y);
	r1.x = r1.y * -r1.x + r1.x;
	r1.xyz = r4.xyz + r1.xxx;
	r2.x = saturate(dot(r6.yzw, r14.xyz));
	r2.x = 1 + -r2.x;
	r2.x = r2.x * r2.x;
	r2.x = r2.x * r2.x;
	r2.x = r2.x * 0.25 + 0.0500000007;
	r2.y = 0.5 + cb0[12].x;
	r2.y = max(0.00999999978, r2.y);
	r2.y = min(6, r2.y);
	r2.x = log2(r2.x);
	r2.x = r2.y * r2.x;
	r2.x = exp2(r2.x);
	//r2.y = 1 + -aerial_fog.w;

    FogResult fog_result = CalculateFog(world_position.xyz, 1, false);
    r2.y = 1 - fog_result.paramsAerial.w;

	r2.y = log2(r2.y);
	r2.y = 2.5 * r2.y;
	r2.y = exp2(r2.y);
	r2.x = r2.x * r2.y;
	r2.x = r2.x * r1.w;
	r2.y = cb0[12].w + -cb0[12].z;
	r0.w = r0.w * r2.y + cb0[12].z;
	r0.w = r2.x * r0.w;
	r0.x = saturate(-10 * r0.x);
	r0.x = 1 + -r0.x;
	r2.xy = max(float2(0.00999999978, 0.5), r0.xx);
	r0.x = r2.x * r1.w;
	r4.xyz = r0.xxx * r9.xyz;
	r4.xyz = min(float3(1, 1, 1), r4.xyz);
	r1.xyz = r1.xyz * r6.xxx + -r3.xzw;
	r1.xyz = r4.xyz * r1.xyz + r3.xzw;
	r0.x = max(0, cb0[14].x);
	r0.x = min(10, r0.x);
	r1.w = 1 + -r2.x;
	r1.w = r8.y * r1.w;
	r1.w = min(1, r1.w);
	r3.xzw = r0.xxx * cb0[13].yzw + -r1.xyz;
	r1.xyz = r1.www * r3.xzw + r1.xyz;
	r0.x = r0.z * r5.y;
	r0.z = abs(r4.w) + abs(r4.w);
	r0.z = min(1, r0.z);
	r1.xyz = r0.zzz * r0.xxx + r1.xyz;
	r0.x = rsqrt(r0.y);
	r0.x = 1 / r0.x;
	r0.x = 4 * r0.x;
	r0.x = min(1, r0.x);
	r0.x = r0.x * 0.600000024 + 0.400000006;
	r0.y = 0.5 * r2.z;
	r0.x = r0.w * r0.x + r0.y;
	r0.y = min(1, r9.x);
	r0.x = saturate(r0.x * r0.y);
	r0.x = r0.x * r2.y;
	r0.yzw = r16.xyz + -r1.xyz;
	o0.xyz = r3.yyy * r0.yzw + r1.xyz;

	r0.y = r2.w * 0.0850000009 + 0.0149999997;
	r0.z = cmp(r6.x < 0.999000013);
	r0.w = r0.y * r2.z;
	r0.w = 6 * r0.w;
	r0.y = r0.z ? r0.w : r0.y;
	r0.yw = r0.yy * r6.yz;
	r1.xy = r0.yw * float2(2.5, 2.5) + float2(0.5, 0.5);
	r0.x = rsqrt(r0.x);
	r1.w = 1 / r0.x;
	r1.z = r0.z ? 0 : 1;
	o1.xyzw = r5.xxxx * r1.xyzw;
	o0.w = 0;


    float3 view_vector = normalize(cameraPosition.xyz - world_position.xyz);

    // compute view ray refraction and sample texture
    float floor_device_depth = depth_buffer.Load(int3(sv_position.xy, 0));
    float floor_scene_depth = DeviceToSceneDepth(floor_device_depth);
    float2 tex_coord = SvPositionToTexCoord(sv_position);
    bool is_above_water = !is_front_face || view_vector.z > 0.2;
    float surface_to_scene_depth = floor_scene_depth - water_surface_scene_depth;
    float2 refracted_tex_coord = ComputeRefractionTexCoord(tex_coord, world_position.xyz, normal, view_vector, surface_to_scene_depth, is_above_water);
    float max_refracted_device_depth = Max4(depth_buffer.GatherRed(_linear_sampler, refracted_tex_coord, 0));
    float refracted_scene_depth = DeviceToSceneDepth(max_refracted_device_depth);
    if (!is_above_water)
    {
        // bias to avoid artifacts due to strong refraction
        refracted_scene_depth -= 1;
    }
    bool enable_refraction_mip_mapping;
    if (refracted_scene_depth < water_surface_scene_depth)
    {
        refracted_tex_coord = tex_coord;
        enable_refraction_mip_mapping = false;
    }
    else
    {
        floor_device_depth = depth_buffer.SampleLevel(_linear_sampler, refracted_tex_coord, 0);
        floor_scene_depth = DeviceToSceneDepth(floor_device_depth);
        enable_refraction_mip_mapping = true;
    }

    float3 surface_behind_water;
    float3 behind_water_world_position = NdcToWorldPosition(float3(TexCoordToNdcXY(refracted_tex_coord), max(0.00001, floor_device_depth)));
    float3 view_ray = behind_water_world_position - world_position.xyz;
    float mip_level = enable_refraction_mip_mapping ? ComputeMipLevel(refracted_tex_coord, screenDimensions.xy) : 0;

    float2 refracted_tex_coord_red = tex_coord + 0.97 * (refracted_tex_coord - tex_coord);
    float2 refracted_tex_coord_green = refracted_tex_coord;
    float2 refracted_tex_coord_blue = tex_coord + 1.03 * (refracted_tex_coord - tex_coord);

    if (is_above_water)
    {
        surface_behind_water.r = _unfogged_scene.SampleLevel(_linear_mirror_sampler, refracted_tex_coord_red, mip_level).r;
        surface_behind_water.g = _unfogged_scene.SampleLevel(_linear_mirror_sampler, refracted_tex_coord_green, mip_level).g;
        surface_behind_water.b = _unfogged_scene.SampleLevel(_linear_mirror_sampler, refracted_tex_coord_blue, mip_level).b;
    }
    else
    {
        surface_behind_water.r = scene.SampleLevel(_linear_mirror_sampler, refracted_tex_coord_red, mip_level).r;
        surface_behind_water.g = scene.SampleLevel(_linear_mirror_sampler, refracted_tex_coord_green, mip_level).g;
        surface_behind_water.b = scene.SampleLevel(_linear_mirror_sampler, refracted_tex_coord_blue, mip_level).b;
        
    }
    o0.rgb = surface_behind_water;

    float F0 = 0.02;
    float specular;
    if (dot(normal, directional_light_direction.xyz) > 0)
    {
        float3 half_vector = normalize(directional_light_direction.xyz + view_vector.xyz);
        float roughness = 0.1;
        float NDF = DistributionGGX(normal, half_vector, roughness);
        float G = GeometrySmith(normal, view_vector, directional_light_direction.xyz, roughness);
        float F = FresnelSchlick(max(dot(half_vector, view_vector), 0.0), F0);

        float numerator = NDF * G * F;
        float denominator = 4.0 * max(dot(normal, view_vector), 0.00001);
        specular = numerator / denominator;
    }
    else
    {
        specular = 0;
    }
    float3 sun_reflection = directional_light_color.xyz * specular;


    float3 reflection_vector = reflect(-view_vector, normal);
    float3 half_vector = normalize(view_vector + reflection_vector);
    float view_fresnel = FresnelSchlick(max(dot(half_vector, view_vector), 0.0), F0);
    float delta = 1 - exp(-max(0, floor_scene_depth - water_surface_scene_depth) * 10);
    float fog_attentuation = (1 - fog_result.paramsFog.w) * (1 - fog_result.paramsAerial.w);
    o1.w = view_fresnel * fog_attentuation * delta;

    // attenuate specular reflection by foam amount
    // TODO: use actual mip mapping instead
    float normal_variance_scale = max(lerp(1 - sqrt(z_variance), 1, view_vector.z), 0.5);
    o1.w *= normal_variance_scale;

    [branch]
    if (is_above_water)
    {
        float total_ray_length = length(view_ray);

        float3 scattering_coefficient, absorbtion_coefficient;
        GetWaterScatteringAbsorbtion(scattering_coefficient, absorbtion_coefficient);

        float3 slice_extinction = absorbtion_coefficient + scattering_coefficient;

        float3 refracted_view_vector = refract(-view_vector, normal, 0.7519);
        float3 slice_scattering = directional_light_color.rgb * scattering_coefficient;

        slice_scattering *= HenyeyGreensteinPhase(WATER_SCATTERING_ANISOTROPY, dot(refracted_view_vector, water_refracted_directional_light_direction));

        float exterior_factor = dimmer.x * -dimmer.y + 1;
        exterior_factor *= 1 - Rescale(0, 8, -distance_to_terrain);

        // raymarch
        RaymarchWaterParams params;
        params.ray_start = world_position.xyz;
        params.surface_height = world_position.z;
        params.ray_direction = normalize(view_ray);
        params.total_ray_length = total_ray_length * WATER_DEPTH_SCALE;
        params.step_size = 0.5;
        params.step_increment = 1.25;
        params.slice_scattering = slice_scattering * surface_shadow_factor;
        params.slice_extinction = slice_extinction;
        params.ambient_scattering = _water_sky_ambient.Load(int3(0, 0, 0)) * scattering_coefficient * exterior_factor;
        params.ambient_scattering_add = scattering_coefficient * WATER_AMBIENT_ADD;
        params.is_underwater = false;
        params.interior_dimmer_sample = 0;
        float3 accum_view_scattering = 0;
        float3 accum_view_transmittance = 1;
        RaymarchDirectionalWaterScattering(params, accum_view_scattering, accum_view_transmittance);        

        o0.rgb = o0.rgb * accum_view_transmittance + accum_view_scattering;

        o0.rgb *= 1 - view_fresnel * normal_variance_scale;
        o0.rgb += sun_reflection * surface_shadow_factor;
        o0.rgb = lerp(surface_behind_water, o0.rgb, delta);

        // apply less fog when the reflection is strong
        // because the reflection already contains the fog along the view ray and not the reflection ray
        o0.rgb = lerp(ApplyFog(o0.rgb, fog_result), o0.rgb, max(0, o1.w - 0.4));
    }
    else
    {
        o1.w = view_fresnel * normal_variance_scale;

        // total internal reflection
        float n_dot_v = dot(-normal, view_vector);
        o1.w = lerp(1, o1.w, smoothstep(0.66, 0.69, n_dot_v));

        o0.rgb *= 1 - o1.w;
    }

    responsive_aa_mask = 0.9 * saturate(2 - distance(cameraPosition.xyz, world_position.xyz) * 0.1);
}
