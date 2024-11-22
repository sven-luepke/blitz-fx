#include "ShadowCommon.hlsli"
#include "Noise.hlsli"
#include "FogCommon.hlsli"
#include "WaterCommon.hlsli"

ByteAddressBuffer t20 : register(t20);
Texture2D<float4> t18 : register(t18);
Texture2D<float4> t12 : register(t12);
TextureCubeArray<float4> t10 : register(t10);
Texture2DArray<float4> t9 : register(t9);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);

SamplerState s12_s : register(s12);
SamplerState s10_s : register(s10);
SamplerState s0_s : register(s0);

cbuffer cb4 : register(b4)
{
float4 cb4[13];
}

cbuffer cb2 : register(b2)
{
float4 cb2[19];
}

cbuffer cb1 : register(b1)
{
float4 cb1[9];
}
cbuffer cb13 : register(b13)
{
    float4 cb13[3323];
}
cbuffer cb12 : register(b12)
{
    float4 cb12[269];
}

Texture2DArray<float> terrain_shadow_height_map : register(t19);

Texture2DArray<float> cascaded_shadow_map : register(t8);
SamplerComparisonState shadow_map_sampler : register(s9);

Texture2DArray<float> cloud_shadow_map : register(t14);
SamplerState cloud_shadow_sampler : register(s14);

#define cmp -

void PSMain(
	float4 aerial_fog : TEXCOORD0,
	float4 v1 : TEXCOORD1,
	float4 v2 : TEXCOORD2,
	float4 diffuse_ambient : TEXCOORD3,
	float4 specular_ambient : TEXCOORD4,
	float4 fog : TEXCOORD5,
	float4 v6 : TEXCOORD6,
	float4 v7 : TEXCOORD7,
	float4 v8 : TEXCOORD8,
	float4 v9 : TEXCOORD9,
	float4 world_position : TEXCOORD10,
	float3 v11 : TEXCOORD11,
	float4 sv_position : SV_Position0,
	uint v13 : SV_IsFrontFace0,
	out float4 o0 : SV_Target0)
{
	float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21;

	r0.x = v1.w;
	r0.y = diffuse_ambient.w;
	r1.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
	r0.z = saturate(3.030303 * r1.w);
    if (r0.z > 0.999)
    {
        discard;
    }

    float water_depth = SampleWaterDepthVolume(world_position);

	r2.xyz = cmp(cb2[18].yzw != float3(0, 0, 0));
	if (r2.x != 0)
	{
		r3.xyzw = float4(16, 16, 16, 16) * sv_position.xyxy;
		r3.xyzw = cmp(r3.xyzw >= -r3.zwzw);
		r3.xyzw = r3.xyzw ? float4(16, 16, 0.0625, 0.0625) : float4(-16, -16, -0.0625, -0.0625);
		r2.xw = sv_position.xy * r3.zw;
		r2.xw = frac(r2.xw);
		r2.xw = r3.xy * r2.xw;
		r3.xy = (int2)r2.xw;
		r3.zw = float2(0, 0);
		r0.w = t18.Load(r3.xyz).x;
		r0.w = r0.w * v2.x + v2.y;
		r0.w = cmp(r0.w < 0);
		if (r0.w != 0)
			discard;
	}
	if (r2.y != 0)
	{
		r0.w = t12.Sample(s12_s, v7.xy).x;
		r0.w = r0.w * v2.z + v2.w;
		r0.w = cmp(r0.w < 0);
		if (r0.w != 0)
			discard;
	}
	if (r2.z != 0)
	{
		r0.w = dot(v1.xyz, v1.xyz);
		r0.w = -1 + r0.w;
		r0.w = cmp(r0.w < 0);
		if (r0.w != 0)
			discard;
	}
	r0.w = r1.x + r1.y;
	r0.w = r0.w + r1.z;
	r2.x = 0.333299994 * r0.w;
	r2.y = cb4[1].x + -1;
	r2.y = 0.5 * r2.y;
	r2.z = saturate(r2.y);
	r0.w = r0.w * -0.666599989 + 1;
	r0.w = r2.z * r0.w + r2.x;
	r3.xyzw = cb4[0].xyzw * r1.xyzw;
	r3.xyzw = saturate(float4(1.5, 1.5, 1.5, 1.5) * r3.xyzw);
	r0.w = saturate(r0.w * abs(r2.y));
	r2.xyzw = r3.xyzw + -r1.xyzw;
	r2.xyzw = r0.wwww * r2.xyzw + r1.xyzw;
	r0.w = cmp(0 < cb4[3].x);
	if (r0.w != 0)
	{
		r0.w = r2.x + r2.z;
		r1.xy = r2.xz / r0.ww;
		r1.xy = float2(-0.300000012, -0.300000012) + r1.xy;
		r1.xy = saturate(float2(1.42857146, 1.42857146) * r1.xy);
		r0.w = r1.x + r1.y;
		r0.w = r1.y / r0.w;
		r1.x = 1 + -r0.w;
		r3.xyzw = cb2[11].zyxw * r0.wwww;
		r4.xyzw = cb2[12].zyxw * r0.wwww;
		r5.xyzw = cb2[13].zyxw * r0.wwww;
		r3.xyzw = r1.xxxx * cb2[7].xyzw + r3.xyzw;
		r4.xyzw = r1.xxxx * cb2[8].xyzw + r4.xyzw;
		r5.xyzw = r1.xxxx * cb2[9].xyzw + r5.xyzw;
	}
	else
	{
		r0.w = cmp(r2.x >= r2.z);
		r3.xyzw = r0.wwww ? cb2[7].xyzw : cb2[11].zyxw;
		r4.xyzw = r0.wwww ? cb2[8].xyzw : cb2[12].zyxw;
		r5.xyzw = r0.wwww ? cb2[9].xyzw : cb2[13].zyxw;
	}
	r0.w = cmp(0 < cb4[4].x);
	if (r0.w != 0)
	{
		r0.w = min(r2.y, r2.z);
		r0.w = min(r2.x, r0.w);
		r1.x = max(r2.y, r2.z);
		r1.x = max(r2.x, r1.x);
		r0.w = r1.x + -r0.w;
		r0.w = r0.w / r1.x;
		r0.w = -0.100000001 + r0.w;
		r0.w = saturate(5 * r0.w);
		r0.w = cb4[2].x * r0.w;
	}
	else
	{
		r0.w = cb4[2].x;
	}
	r6.xyzw = t1.Sample(s0_s, r0.xy).wxyz;
	r1.xyz = float3(-0.5, -0.5, -0.5) + r6.yzw;
	r1.xyz = r1.xyz + r1.xyz;
	r7.x = specular_ambient.w;
	r7.yz = v7.zw;
	r6.yzw = r7.xyz * r1.yyy;
	r6.yzw = v11.xyz * r1.xxx + r6.yzw;
	r1.xyz = v9.xyz * r1.zzz + r6.yzw;
	r0.x = cmp(0 >= (uint)v13.x);
	if (r0.x != 0)
	{
		r0.x = dot(v9.xyz, r1.xyz);
		r6.yzw = v9.xyz * r0.xxx;
		r6.yzw = -r6.yzw * float3(2, 2, 2) + r1.xyz;
	}
	else
	{
		r6.yzw = r1.xyz;
	}
	r0.x = cmp(0.00294117653 < r0.z);
	r0.y = -0.330000013 + r1.w;
	r0.y = cmp(r0.y < 0);
	r0.x = r0.y ? r0.x : 0;
	if (r0.x != 0)
	{
		r3.x = dot(r2.xyzw, r3.xyzw);
		r3.y = dot(r2.xyzw, r4.xyzw);
		r3.z = dot(r2.xyzw, r5.xyzw);
		r3.xyz = r3.xyz + -r2.xyz;
		r0.xyw = r0.www * r3.xyz + r2.xyz;
		r0.xyw = saturate(v8.xyz * r0.xyw);
		r1.w = 1 + -r6.x;
		r2.xyz = log2(cb4[5].xyz);
		r2.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r2.xyz;
		r2.xyz = exp2(r2.xyz);
		r1.w = r1.w * cb4[6].x + cb4[7].x;
		r2.xyz = saturate(r2.xyz * r1.www);
		r2.xyz = log2(r2.xyz);
		r3.xyz = cb1[8].xyz + -world_position.xyz;
		r1.w = dot(r3.xyz, r3.xyz);
		r1.w = rsqrt(r1.w);
		r3.xyz = r3.xyz * r1.www;
		r1.x = dot(r1.xyz, r3.xyz);
		r1.x = saturate(1 + -r1.x);
		r1.x = r1.x * r1.x;
		r1.x = log2(r1.x);
		r1.x = cb4[8].x * r1.x;
		r1.x = exp2(r1.x);
		r1.x = cb4[9].x * r1.x;
		r1.x = saturate(cb4[10].x * r1.x);
		r1.y = max(0.00100000005, v6.w);
		r3.xyz = diffuse_ambient.xyz / r1.yyy;
		r1.yzw = specular_ambient.xyz / r1.yyy;

        // TODO: load exterior lighting from froxel
        UnderwaterModifyAmbientLighting(water_depth, 1, r3.xyz, r1.yzw);

		r0.xyw = log2(r0.xyw);
		r0.xyw = float3(2.20000005, 2.20000005, 2.20000005) * r0.xyw;
		r0.xyw = exp2(r0.xyw);
		r2.xyz = float3(0.999998987, 0.999998987, 0.999998987) * r2.xyz;
		r2.xyz = exp2(r2.xyz);
		r6.x = saturate(r6.x);
		r4.xy = (uint2)sv_position.xy;
		r2.w = dot(r6.yzw, r6.yzw);
		r2.w = rsqrt(r2.w);
		r5.xyz = r6.yzw * r2.www;
		r2.w = dot(v9.xyz, v9.xyz);
		r2.w = rsqrt(r2.w);
		r6.yzw = v9.xyz * r2.www;
		r4.xy = (uint2)r4.xy >> int2(4, 4);
		r2.w = (int)cb12[24].x;
		r2.w = mad((int)r4.y, (int)r2.w, (int)r4.x);
		r2.w = (uint)r2.w << 8;
		r4.xyz = cb12[0].xyz + -world_position.xyz;
		r3.w = dot(r4.xyz, r4.xyz);
		r3.w = rsqrt(r3.w);
		r7.xyz = r4.xyz * r3.www;
		r4.w = cmp(0.00100000005 < v6.w);
		r5.w = ~(int)r4.w;
		r8.xyz = v6.xyz / v6.www;
		r8.xy = saturate(r8.xy);
		r8.z = saturate(1.00196469 * r8.z);
		if (r5.w != 0)
			discard;
		r8.xyz = r4.www ? r8.xyz : float3(1, 1, 1);

        TerrainShadowArgs terrain_shadow_args;
        terrain_shadow_args.shadow_height_map = terrain_shadow_height_map;
        terrain_shadow_args.shadow_sampler = s10_s;
        terrain_shadow_args.world_position = world_position.xyz;
        terrain_shadow_args.is_on_terrain = false;
        terrain_shadow_args.bias_offset_scale = 0;
        float shadow_factor = ComputeTerrainShadow(terrain_shadow_args);

        [branch]
        if (shadow_factor > 0)
        {
            CascadeShadowArgs args;
            args.shadow_map = cascaded_shadow_map;
            args.shadow_sampler = shadow_map_sampler;
            args.world_position = world_position.xyz;
            args.noise_01 = GetStaticBlueNoise(sv_position.xy);
            args.is_vegetation_shadow = false;
            shadow_factor *= ComputeCascadeShadowPCSS(args, 32);

            CloudShadowArgs cloud_shadow_args;
            cloud_shadow_args.shadow_map = cloud_shadow_map;
            cloud_shadow_args.shadow_sampler = cloud_shadow_sampler;
            cloud_shadow_args.world_position = world_position.xyz;
            shadow_factor *= ComputeCloudShadow(cloud_shadow_args);
        }

        r8.x = shadow_factor;
		
		r4.w = cmp(0 < r8.x);
		if (r4.w != 0)
		{
			r4.w = dot(r6.yzw, cb13[0].xyz);
			r4.w = cb4[12].x + r4.w;
			r5.w = cb4[12].x + 1;
			r4.w = saturate(r4.w / r5.w);
			r5.w = dot(r5.xyz, cb13[0].xyz);
			r7.w = r5.w + r4.w;
			r4.w = 1 + r4.w;
			r7.w = r7.w / r4.w;
			r4.w = 1 / r4.w;
			r9.xyz = saturate(r7.www);
			r10.xyz = r4.xyz * r3.www + cb13[0].xyz;
			r7.w = dot(r10.xyz, r10.xyz);
			r7.w = rsqrt(r7.w);
			r10.xyz = r10.xyz * r7.www;
			r7.w = dot(r10.xyz, r7.xyz);
			r7.w = 1 + -abs(r7.w);
			r7.w = max(0, r7.w);
			r8.w = r7.w * r7.w;
			r8.w = r8.w * r8.w;
			r7.w = r8.w * r7.w;
			r8.w = 1 + -r6.x;
			r10.xyz = float3(1, 1, 1) + -r2.xyz;
			r11.xyz = cb13[56].xxx * r10.xyz;
			r11.xyz = r11.xyz * r7.www;
			r7.w = 1 + cb13[56].z;
			r7.w = -cb13[56].z * r8.w + r7.w;
			r11.xyz = r11.xyz / r7.www;
			r11.xyz = r11.xyz + r2.xyz;
			r11.xyz = float3(1, 1, 1) + -r11.xyz;
			r11.xyz = r11.xyz * r9.zzz;
			r11.xyz = float3(0.318309873, 0.318309873, 0.318309873) * r11.xyz;
			r7.w = cmp(0 < r1.x);
			if (r7.w != 0)
			{
				r5.w = 1 + r5.w;
				r5.w = 0.5 * r5.w;
				r7.w = dot(cb13[0].xyz, -r7.xyz);
				r7.w = 1 + r7.w;
				r7.w = 0.5 * r7.w;
				r8.w = dot(r5.xyz, -r7.xyz);
				r8.w = 1 + r8.w;
				r8.w = cb12[36].w * r8.w;
				r7.w = r7.w * r7.w;
				r8.w = 0.5 * r8.w;
				r7.w = r7.w * r7.w + -r5.w;
				r5.w = cb12[36].x * r7.w + r5.w;
				r5.w = r8.w * r5.w;
				r7.w = cb12[36].y * r1.x;
				r10.xyz = cb12[36].zzz * r10.xyz + -r11.xyz;
				r10.xyz = r7.www * r10.xyz + r11.xyz;
				r11.xyz = r5.www * r1.xxx + r10.xyz;
			}
			r10.xyz = r11.xyz * r4.www;
			r11.xy = -cb12[0].xy + world_position.xy;
			r4.w = dot(r11.xy, r11.xy);
			r4.w = sqrt(r4.w);
			r5.w = saturate(world_position.z * cb12[218].z + cb12[218].w);
			r11.xyz = -cb13[52].xyz + cb13[51].xyz;
			r11.xyz = r5.www * r11.xyz + cb13[52].xyz;
			r4.w = saturate(r4.w * cb12[218].x + cb12[218].y);
			r11.xyz = -cb13[1].xyz + r11.xyz;
			r11.xyz = r4.www * r11.xyz + cb13[1].xyz;

            float3 directional_light_scale = GetUnderwaterDirectionalLightScale(water_depth, world_position);
            r11.xyz *= directional_light_scale;

			r10.xyz = r10.xyz * r8.xxx;
			r10.xyz = r10.xyz * r11.xyz;
		}
		else
		{
			r9.xyz = float3(0, 0, 0);
			r10.xyz = float3(0, 0, 0);
		}
		r9.xyz = min(r9.xyz, r8.xxx);
		r4.w = cmp(r8.z == 1.000000);
		r5.w = cmp(cb2[16].x < 0);
		r5.w = r5.w ? 1 : cb12[71].x;
		r7.w = cb4[12].x + 1;
		r6.x = 1 + -r6.x;
		r8.xzw = float3(1, 1, 1) + -r2.xyz;
		r11.xyz = cb13[56].xxx * r8.xzw;
		r12.xy = float2(1, 1) + cb13[56].zw;
		r12.xy = -cb13[56].zw * r6.xx + r12.xy;
		r6.x = cmp(0 < r1.x);
		r9.w = dot(r5.xyz, -r7.xyz);
		r9.w = 1 + r9.w;
		r9.w = cb12[36].w * r9.w;
		r9.w = 0.5 * r9.w;
		r10.w = cb12[36].y * r1.x;
		r11.w = r4.w ? 1.000000 : 0;
		r4.w = r4.w ? 0 : 1;
		r13.xyz = r10.xyz;
		r13.w = 0;
		while (true)
		{
			r12.z = cmp((int)r13.w >= 256);
			if (r12.z != 0)
				break;
			r12.z = (int)r2.w + (int)r13.w;
			r12.z = (uint)r12.z << 2;
			
			// No code for instruction (needs manual fix):
			// ld_raw_indexable(raw_buffer) (mixed, mixed, mixed, mixed) r12.z, r12.z, t20.xxxx
            r12.z = t20.Load(r12.z);

			r12.w = cmp((uint)r12.z >= 256);
			if (r12.w != 0)
			{
				break;
			}
			r12.z = (int)r12.z * 9;
			r14.xyz = cb13[r12.z + 58].xyz + -world_position.xyz;
			r12.w = dot(r14.xyz, r14.xyz);
			r15.x = sqrt(r12.w);
			r15.y = r15.x / cb13[r12.z + 58].w;
			r15.z = r15.y * r15.y;
			r15.z = -r15.z * r15.z + 1;
			r15.z = max(0, r15.z);
			r15.z = r15.z * r15.z;
			r16.xyz = int3(1, 2048, 4096) & asint(cb13[r12.z + 61].www);
			r15.w = cmp(0 < cb13[r12.z + 63].z);
			r16.w = cmp(0 < cb13[r12.z + 64].x);
			r17.x = r12.w * cb13[r12.z + 63].x + 1;
			r15.z = r15.z / r17.x;
			if (r16.x != 0)
			{
				r17.x = rsqrt(r12.w);
				r17.xyz = r17.xxx * r14.xyz;
				r17.x = dot(-r17.xyz, cb13[r12.z + 60].xyz);
				r17.x = saturate(r17.x * cb13[r12.z + 62].y + cb13[r12.z + 62].z);
				r17.x = log2(r17.x);
				r17.x = cb13[r12.z + 62].w * r17.x;
				r17.x = exp2(r17.x);
				r15.z = r17.x * r15.z;
			}
			r17.x = cmp(0 < r15.z);
			r15.w = r15.w ? r17.x : 0;
			if (r15.w != 0)
			{
				if (r16.x != 0)
				{
					r17.yzw = -cb13[r12.z + 58].xyz + world_position.xyz;
					r18.xyz = cb13[r12.z + 65].zwy * cb13[r12.z + 60].zxy;
					r18.xyz = cb13[r12.z + 60].yzx * cb13[r12.z + 65].wyz + -r18.xyz;
					r18.x = dot(r18.xyz, r17.yzw);
					r18.y = dot(cb13[r12.z + 65].yzw, r17.yzw);
					r18.z = dot(cb13[r12.z + 60].xyz, r17.yzw);
					r18.w = cb13[r12.z + 65].x;
				}
				else
				{
					r19.xyz = -cb13[r12.z + 58].xzy + world_position.xzy;
					r17.yzw = r14.xyz / r15.xxx;
					r15.x = max(abs(r17.z), abs(r17.w));
					r15.x = cmp(r15.x < abs(r17.y));
					if (r15.x != 0)
					{
						r15.x = cmp(0 < r17.y);
						r20.xyz = float3(1, 1, -1) * r19.zyx;
						r20.w = cb13[r12.z + 65].x;
						r21.xyz = float3(-1, 1, 1) * r19.zyx;
						r21.w = cb13[r12.z + 65].y;
						r18.xyzw = r15.xxxx ? r20.xyzw : r21.xyzw;
					}
					else
					{
						r15.x = max(abs(r17.y), abs(r17.w));
						r15.x = cmp(r15.x < abs(r17.z));
						if (r15.x != 0)
						{
							r15.x = cmp(0 < r17.z);
							r20.xyz = float3(-1, 1, -1) * r19.xyz;
							r20.w = cb13[r12.z + 65].z;
							r19.w = cb13[r12.z + 65].w;
							r18.xyzw = r15.xxxx ? r20.xyzw : r19.xyzw;
						}
						else
						{
							r15.x = cmp(0 < r17.w);
							r18.x = r19.x;
							r18.y = r15.x ? r19.z : -r19.z;
							r18.z = r15.x ? -r19.y : r19.y;
							r18.w = r15.x ? cb13[r12.z + 66].x : cb13[r12.z + 66].y;
						}
					}
				}
				r15.xw = cb13[r12.z + 63].yy * r18.xy;
				r15.xw = r15.xw / r18.zz;
				r15.xw = r15.xw * float2(0.5, -0.5) + float2(0.5, 0.5);
				
				//if (10 == 0)
				//	r17.y = 0;
				//else if (10 + 20 < 32)
				//{
				//	r17.y = (uint)r18.w << (32 - (10 + 20));
				//	r17.y = (uint)r17.y >> (32 - 10);
				//}
				//else
				//	r17.y = (uint)r18.w >> 20;
				//if (10 == 0)
				//	r17.z = 0;
				//else if (10 + 10 < 32)
				//{
				//	r17.z = (uint)r18.w << (32 - (10 + 10));
				//	r17.z = (uint)r17.z >> (32 - 10);
				//}
				//else
				//	r17.z = (uint)r18.w >> 10;
				//r17.yz = (uint2)r17.yz;
				//r16.x = (int)r18.w & 1023;
				//r16.x = (uint)r16.x;
				//r17.w = (uint)r18.w >> 30;
				//r17.w = cmp(0 < r16.x);

                uint source = asuint(r18.w);
                r17.yz = (source.xx >> int2(20, 10)) & 1023;
                r16.x = source & 1023;
                r18.z = source >> 30;
				
				if (r16.x)
				{
					r15.xw = r15.xw * r16.xx + r17.yz;
					r18.xy = float2(0.0009765625, 0.0009765625) * r15.xw;
					r15.x = t9.SampleLevel(s10_s, r18.xyz, 0).x;
					r15.x = -r15.y * 0.99000001 + r15.x;
					r15.x = 144.269501 * r15.x;
					r15.x = exp2(r15.x);
					r15.x = min(1, r15.x);
				}
				else
				{
					r15.x = 1;
				}
			}
			else
			{
				r15.x = 1;
			}
			r15.w = r16.w ? r17.x : 0;
			if (r15.w != 0)
			{
				r14.w = cb13[r12.z + 64].y;
				r14.w = t10.SampleLevel(s10_s, r14.xyzw, 0).x;
				r14.w = -r15.y * 0.99000001 + r14.w;
				r14.w = 144.269501 * r14.w;
				r14.w = exp2(r14.w);
				r14.w = min(1, r14.w);
				r15.x = r15.x * r14.w;
			}
			r14.w = -1 + r15.x;
			r14.w = cb13[r12.z + 60].w * r14.w + 1;
			r14.w = r15.z * r14.w;
			r15.x = r16.y ? 1 : r11.w;
			r15.y = r16.z ? 1 : r4.w;
			r15.x = r15.x * r15.y;
			r14.w = r15.x * r14.w;
			r15.x = cmp(0 < r14.w);
			if (r15.x != 0)
			{
				r15.x = 0x80000000 & asint(cb13[r12.z + 61].w);
				r15.x = r15.x ? r5.w : 1;
				r14.w = r15.x * r14.w;
				r12.w = rsqrt(r12.w);
				r14.xyz = r14.xyz * r12.www;
				r12.w = dot(r6.yzw, r14.xyz);
				r12.w = cb4[12].x + r12.w;
				r12.w = saturate(r12.w / r7.w);
				r15.x = dot(r5.xyz, r14.xyz);
				r15.y = r15.x + r12.w;
				r12.w = 1 + r12.w;
				r15.y = saturate(r15.y / r12.w);
				r12.w = 1 / r12.w;
				r16.xyz = r4.xyz * r3.www + r14.xyz;
				r15.z = dot(r16.xyz, r16.xyz);
				r15.z = rsqrt(r15.z);
				r16.xyz = r16.xyz * r15.zzz;
				r15.z = dot(r16.xyz, r7.xyz);
				r15.z = 1 + -abs(r15.z);
				r15.z = max(0, r15.z);
				r15.w = r15.z * r15.z;
				r15.w = r15.w * r15.w;
				r15.z = r15.w * r15.z;
				r16.xyz = r15.zzz * r11.xyz;
				r16.xyz = r16.xyz / r12.xxx;
				r16.xyz = r16.xyz + r2.xyz;
				r16.xyz = float3(1, 1, 1) + -r16.xyz;
				r15.yzw = r16.xyz * r15.yyy;
				r15.yzw = float3(0.318309873, 0.318309873, 0.318309873) * r15.yzw;
				if (r6.x != 0)
				{
					r15.x = 1 + r15.x;
					r15.x = 0.5 * r15.x;
					r14.x = dot(r14.xyz, -r7.xyz);
					r14.x = 1 + r14.x;
					r14.x = 0.5 * r14.x;
					r14.x = r14.x * r14.x;
					r14.x = r14.x * r14.x + -r15.x;
					r14.x = cb12[36].x * r14.x + r15.x;
					r14.x = r14.x * r9.w;
					r16.xyz = cb12[36].zzz * r8.xzw + -r15.yzw;
					r16.xyz = r10.www * r16.xyz + r15.yzw;
					r15.yzw = r14.xxx * r1.xxx + r16.xyz;
				}
				r14.xyz = r15.yzw * r12.www;
				r14.xyz = cb13[r12.z + 61].xyz * r14.xyz;
				r13.xyz = r14.www * r14.xyz + r13.xyz;
			}
			r13.w = (int)r13.w + 1;
		}
		r1.x = abs(cb2[16].x) + -cb2[16].y;
		r4.xyz = r9.xyz * r1.xxx + cb2[16].yyy;
		r1.x = cb2[16].z + -cb2[16].w;
		r10.xyz = r9.xyz * r1.xxx + cb2[16].www;
		r3.xyz = r4.xyz * r3.xyz;
		r1.xyz = r10.xyz * r1.yzw;
		r4.xy = -cb12[0].xy + world_position.xy;
		r1.w = dot(r4.xy, r4.xy);
		r1.w = sqrt(r1.w);
		r1.w = saturate(r1.w * cb12[218].x + cb12[218].y);
		r2.w = -1 + cb12[184].z;
		r1.w = r1.w * r2.w + 1;
		r2.w = cb12[183].x + -cb12[183].y;
		r4.xyz = r9.xyz * r2.www + cb12[183].yyy;
		r4.xyz = r4.xyz * r1.www;
		r2.w = cb12[184].x + -cb12[184].y;
		r9.xyz = r9.xyz * r2.www + cb12[184].yyy;
		r9.xyz = r9.xyz * r1.www;
		r10.xyz = cb12[183].zzz * r13.xyz;
		r3.xyz = r4.xyz * r3.xyz;
		r1.w = dot(r5.xyz, r7.xyz);
		r2.w = dot(r6.yzw, r7.xyz);
		r1.w = max(abs(r2.w), abs(r1.w));
		r1.w = 1 + -r1.w;
		r1.w = max(0, r1.w);
		r2.w = r1.w * r1.w;
		r2.w = r2.w * r2.w;
		r1.w = r2.w * r1.w;
		r2.w = min(0.25, cb13[56].y);
		r4.xyz = r2.www * r8.xzw;
		r4.xyz = r4.xyz * r1.www;
		r4.xyz = r4.xyz / r12.yyy;
		r2.xyz = r4.xyz + r2.xyz;
		r4.xyz = float3(1, 1, 1) + -r2.xyz;
		r3.xyz = r4.xyz * r3.xyz;
		r1.xyz = r9.xyz * r1.xyz;
		r1.xyz = r1.xyz * r2.xyz;
		r1.w = cb12[69].x + cb12[69].y;
		r1.xyz = r1.xyz * r8.yyy;
		r2.xyz = r10.xyz * r1.www;
		r2.xyz = r3.xyz * r8.yyy + r2.xyz;
		r0.xyw = r0.xyw * r2.xyz + r1.xyz;
	}
	else
	{
		r0.xyw = float3(0, 0, 0);
	}
    FogResult fog_result;
    fog_result.paramsFog = fog;
    fog_result.paramsAerial = aerial_fog;
    r0.xyw = ApplyFog(r0.xyw, fog_result);

	o0.xyz = r0.xyw * r0.zzz;
	o0.w = r0.z;
}
