#include "Common.hlsli"
#include "Noise.hlsli"
#include "ShadowCommon.hlsli"
#include "GameData.hlsli"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> depth : register(t0);

Texture2DArray<float> terrain_shadow_height_map : register(t19);
Texture2DArray<float> terrain_height_map : register(t15);
Texture2DArray<float> cloud_shadow_map : register(t14);
Texture2DArray<float> cascaded_shadow_map : register(t8);

Texture2D<float> shadow_mask : register(t42);

SamplerState cloud_shadow_sampler : register(s14);
SamplerState terrain_sampler : register(s10);
SamplerComparisonState shadow_map_sampler : register(s9);

cbuffer cb13 : register(b13)
{
    float4 cb13[3323];
}
cbuffer cb12 : register(b12)
{
    float4 cb12[269];
}

#define cmp -

void PSMain(
	float4 sv_position : SV_Position0,
	out float4 o0 : SV_Target0)
{
	float4 r0, r1, r2, r3, r4, r5;

	r0.xy = (uint2)sv_position.xy;
	r0.zw = float2(0, 0);
	r1.x = depth.Load(r0.xyw).x;
	r1.y = r1.x * cb12[22].x + cb12[22].y;
	r1.y = cmp(r1.y < 1);
    [branch]
	if (r1.y != 0)
	{
		r0.z = t2.Load(r0.xyz).w;
		r1.yz = (uint2)r0.xy;
		r2.xyzw = cb12[211].xyzw * r1.zzzz;
		r2.xyzw = cb12[210].xyzw * r1.yyyy + r2.xyzw;
		r1.xyzw = cb12[212].xyzw * r1.xxxx + r2.xyzw;
		r1.xyzw = cb12[213].xyzw + r1.xyzw;
		r1.xyz = r1.xyz / r1.www;

		r0.z = r0.z * 255 + 0.5;
		
		r0.z = (uint)r0.z;
		r0.z = (int)r0.z & 26;

        bool is_vegetation_shadow = r0.z != 0;

		r0.w = cmp(0 < asint(cb13[35].x));
		if (r0.w != 0)
		{
			r0.w = cmp(0 < asint(cb13[35].y));
			if (r0.w != 0)
			{
				r2.y = 0;
				r3.xyz = float3(0, 0, 0);
				r0.w = 0;
				while (true)
				{
					r1.w = cmp((int)r3.z >= asint(cb13[35].y));
					r0.w = 0;
					if (r1.w != 0)
						break;
					r2.zw = -cb13[r3.z + 39].xy + r1.xy;
					r2.zw = cb13[r3.z + 39].zw * r2.zw;
					r4.xy = cmp(r2.zw >= float2(0, 0));
					r1.w = r4.y ? r4.x : 0;
					r4.xy = cmp(float2(1, 1) >= r2.zw);
					r1.w = r1.w ? r4.x : 0;
					r1.w = r4.y ? r1.w : 0;
					if (r1.w != 0)	 
					{
						r4.xy = cb13[r3.z + 44].zw + -cb13[r3.z + 44].xy;
						r2.zw = r2.zw * r4.xy + cb13[r3.z + 44].xy;
						r4.xyzw = float4(0.00048828125, -0.00048828125, 0.00244140625, -0.00048828125) + r2.zwzw;
						r5.z = (int)r3.z;
						r5.xy = r4.xy;
                        r3.w = terrain_height_map.SampleLevel(terrain_sampler, r5.xyz, 0).x;
						r3.x = cb13[38].x * r3.w + cb13[38].y;
						r5.xy = r4.zw;
                        r3.w = terrain_height_map.SampleLevel(terrain_sampler, r5.xyz, 0).x;
						r3.w = cb13[38].x * r3.w + cb13[38].y;
						r4.xyzw = float4(0.00048828125, 0.00146484375, -0.00146484375, -0.00048828125) + r2.zwzw;
						r5.xy = r4.xy;
                        r4.x = terrain_height_map.SampleLevel(terrain_sampler, r5.xyz, 0).x;
						r4.x = cb13[38].x * r4.x + cb13[38].y;
						r5.xy = r4.zw;
                        r4.y = terrain_height_map.SampleLevel(terrain_sampler, r5.xyz, 0).x;
						r4.y = cb13[38].x * r4.y + cb13[38].y;
						r5.xy = float2(0.00048828125, -0.00244140625) + r2.zw;
                        r2.z = terrain_height_map.SampleLevel(terrain_sampler, r5.xyz, 0).x;
						r2.z = cb13[38].x * r2.z + cb13[38].y;
						r2.w = r3.w + -r3.x;
						r3.w = r4.y + -r3.x;
						r2.w = max(abs(r3.w), abs(r2.w));
						r3.w = r4.x + -r3.x;
						r2.z = r2.z + -r3.x;
						r2.z = max(abs(r3.w), abs(r2.z));
						r3.y = max(r2.w, r2.z);
						r0.w = -1;
						break;
					}
					r2.x = (int)r3.z + 1;
					r3.xyz = r2.yyx;
					r0.w = r1.w;
				}
			}
			else
			{
				r0.w = 0;
			}

            TerrainShadowArgs terrain_shadow_args;
            terrain_shadow_args.shadow_height_map = terrain_shadow_height_map;
            terrain_shadow_args.shadow_sampler = terrain_sampler;
            terrain_shadow_args.world_position = r1.xyz;
            terrain_shadow_args.is_on_terrain = r0.w;
            terrain_shadow_args.bias_offset_scale = r3.xy;
            r3.x = ComputeTerrainShadow(terrain_shadow_args);

            r2.z = 1;
        }
		else
		{
			r2.z = 0;
		}
		r0.w = r2.z ? r3.x : 1;

        float shadow_factor = r0.w;
        [branch]
		if (shadow_factor > 0)
		{
            CloudShadowArgs cloud_shadow_args;
            cloud_shadow_args.shadow_map = cloud_shadow_map;
            cloud_shadow_args.shadow_sampler = cloud_shadow_sampler;
            cloud_shadow_args.world_position = r1.xyz;
            shadow_factor *= ComputeCloudShadow(cloud_shadow_args);

            r0.w = shadow_factor;
		}
        [branch]
        if (r0.w > 0)
        {
            r0.w *= shadow_mask.Load(int3(sv_position.xy, 0));
        }
    }
	else
	{
		r0.w = 1;
	}	
	o0.xyzw = r0.wwww;
}
