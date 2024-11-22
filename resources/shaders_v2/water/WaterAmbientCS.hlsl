#include "Common.hlsli"
#include "WaterCommon.hlsli"
#include "GameData.hlsli"

RWTexture2D<float3> sky_ambient : register(u0);

// color in rgb, weight in alpha
groupshared float4 sky_average_shared[256];

#define cmp -

[numthreads(256, 1, 1)]
void CSMain(uint3 thread_id : SV_DispatchThreadID)
{
    float4 r0, r1, r2, r3, r4, r5;

    //r0.xy = v0.xy / cb3[0].xy;

    // paraboloid tex coord to direction
    //r0.xy = r0.xy * float2(2, 2) + float2(-1, -1);
    //r1.x = dot(r0.xy, r0.xy);
    //r0.zw = float2(-1, 1) + r1.xx;
    //r0.xyz = float3(-2, 2, -1) * r0.xyz;
    //r0.xyz = r0.xyz / r0.www;

    // uniformly distributed samples in the upper hemisphere
    float ray_azimuth = (thread_id.x % 16) * PI_2 / 16.0f;
    float ray_zenith = int(thread_id.x / 16) * PI / 32.0f;
   // ray_zenith -= 0.5;
    float3 ray_direction = SphericalToCartesianNormalized(ray_azimuth, ray_zenith);
    r0.xyz = ray_direction;

    r1.xyz = far_plane * r0.xyz;
    r2.xy = saturate(skyParamsInfluence.yx);
    r0.w = dot(r0.xyz, r0.xyz);
    r0.w = rsqrt(r0.w);
    r0.xyz = r0.xyz * r0.www;
    r0.w = dot(skyParamsMoon.yz, skyParamsMoon.yz);
    r0.w = rsqrt(r0.w);
    r2.zw = skyParamsMoon.yz * r0.ww;
    r0.w = dot(r0.xy, r0.xy);
    r0.w = rsqrt(r0.w);
    r3.xy = r0.xy * r0.ww;
    r0.w = dot(r2.zw, r3.xy);
    r1.w = saturate(dot(skyParamsMoon.yzw, r0.xyz));
    r2.z = dot(skyParamsSun.yz, skyParamsSun.yz);
    r2.z = rsqrt(r2.z);
    r2.zw = skyParamsSun.yz * r2.zz;
    r2.z = dot(r2.zw, r3.xy);
    r0.x = saturate(dot(skyParamsSun.yzw, r0.xyz));
    r0.y = r0.w * 0.5 + 0.5;
    r3.xyz = -moonBackHorizonColor.xyz + moonColorHorizon.xyz;
    r3.xyz = r0.yyy * r3.xyz + moonBackHorizonColor.xyz;
    r0.y = r2.z * 0.5 + 0.5;
    r4.xyz = -sunBackHorizonColor.xyz + sunColorHorizon.xyz;
    r4.xyz = r0.yyy * r4.xyz + sunBackHorizonColor.xyz;
    r0.y = -r0.z * r0.z + 1;
    r0.yz = r0.yy * r2.xy;
    r3.xyz = -skyColorHorizon.xyz + r3.xyz;
    r3.xyz = r0.yyy * r3.xyz + skyColorHorizon.xyz;
    r4.xyz = r4.xyz + -r3.xyz;
    r0.yzw = r0.zzz * r4.xyz + r3.xyz;
    r2.z = dot(r1.xyz, r1.xyz);
    r2.w = rsqrt(r2.z);
    r2.w = r2.w * r1.z;
    r2.w = r2.w * 1000 + cameraPosition.z;
    r2.w = 710 + r2.w;
    r2.w = skyParams1.z * r2.w;
    r2.w = r2.w * 0.00100000005 + 0.100000001;
    r2.w = max(9.99999975e-005, r2.w);
    r2.w = 1 / r2.w;
    r2.w = min(1, r2.w);
    r2.w = log2(r2.w);
    r2.w = 2.79999995 * r2.w;
    r2.w = exp2(r2.w);
    r2.w = 1 + -r2.w;
    r3.xyz = skyColor.xyz + -r0.yzw;
    r0.yzw = r2.www * r3.xyz + r0.yzw;
    r1.w = log2(r1.w);
    r1.w = skyParamsMoon.x * r1.w;
    r1.w = exp2(r1.w);
    r1.w = r1.w * r2.x;
    r0.x = log2(r0.x);
    r0.x = skyParamsSun.x * r0.x;
    r0.x = exp2(r0.x);
    r0.x = r0.x * r2.y;
    r2.xyw = moonColorSky.xyz + -r0.yzw;
    r0.yzw = r1.www * r2.xyw + r0.yzw;
    r2.xyw = sunColorSky.xyz + -r0.yzw;
    r0.xyz = r0.xxx * r2.xyw + r0.yzw;
    r0.xyz = skyParams1.xxx * r0.xyz;
    r0.xyz = skyParams1.yyy * r0.xyz;
    r0.w = sqrt(r2.z);
    r1.xyz = r1.xyz / r0.www;
    r0.w = dot(fogSunDir.xyz, r1.xyz);
    r1.x = abs(r0.w) * abs(r0.w);
    r1.y = saturate(fogBaseParams.z * 0.00200000009 + -0.300000012);
    r1.x = r1.x * r1.y;
    r1.y = cmp(0 < r0.w);
    r2.xyz = r1.yyy ? fogColorFront.xyz : fogColorBack.xyz;
    r2.xyz = -fogColorMiddle.xyz + r2.xyz;
    r2.xyz = r1.xxx * r2.xyz + fogColorMiddle.xyz;
    r3.xyz = r1.yyy ? aerialColorFront.xyz : aerialColorBack.xyz;
    r3.xyz = -aerialColorMiddle.xyz + r3.xyz;
    r1.xyw = r1.xxx * r3.xyz + aerialColorMiddle.xyz;
    r2.w = cmp(fogBaseParams.z >= aerialParams.y);
    if (r2.w != 0)
    {
        r2.w = r1.z * near_plane + cameraPosition.z;
        r1.z = fogBaseParams.z * r1.z;
        r1.z = 0.0625 * r1.z;
        r3.x = fogDensityParamsSky.x * fogBaseParams.z;
        r3.x = 0.0625 * r3.x;
        r0.w = fogBaseParams.x + r0.w;
        r3.y = 1 + fogBaseParams.x;
        r0.w = saturate(r0.w / r3.y);
        r3.y = fogDensityParamsSky.y + -fogDensityParamsSky.z;
        r0.w = r0.w * r3.y + fogDensityParamsSky.z;
        r2.w = fogBaseParams.y + r2.w;
        r3.y = r2.w * r0.w;
        r1.z = r1.z * r0.w;
        r4.xyzw = r1.zzzz * float4(16, 15, 14, 13) + r3.yyyy;
        r4.xyzw = max(float4(0, 0, 0, 0), r4.xyzw);
        r4.xyzw = float4(1, 1, 1, 1) + r4.xyzw;
        r4.xyzw = saturate(r3.xxxx / r4.xyzw);
        r4.xyzw = float4(1, 1, 1, 1) + -r4.xyzw;
        r3.z = r4.x * r4.y;
        r3.z = r3.z * r4.z;
        r3.z = r3.z * r4.w;
        r4.xyzw = r1.zzzz * float4(12, 11, 10, 9) + r3.yyyy;
        r4.xyzw = max(float4(0, 0, 0, 0), r4.xyzw);
        r4.xyzw = float4(1, 1, 1, 1) + r4.xyzw;
        r4.xyzw = saturate(r3.xxxx / r4.xyzw);
        r4.xyzw = float4(1, 1, 1, 1) + -r4.xyzw;
        r3.z = r4.x * r3.z;
        r3.z = r3.z * r4.y;
        r3.z = r3.z * r4.z;
        r3.z = r3.z * r4.w;
        r4.xyzw = r1.zzzz * float4(8, 7, 6, 5) + r3.yyyy;
        r4.xyzw = max(float4(0, 0, 0, 0), r4.xyzw);
        r4.xyzw = float4(1, 1, 1, 1) + r4.xyzw;
        r4.xyzw = saturate(r3.xxxx / r4.xyzw);
        r4.xyzw = float4(1, 1, 1, 1) + -r4.xyzw;
        r3.z = r4.x * r3.z;
        r3.z = r3.z * r4.y;
        r3.z = r3.z * r4.z;
        r3.z = r3.z * r4.w;
        r4.xy = r1.zz * float2(4, 3) + r3.yy;
        r4.xy = max(float2(0, 0), r4.xy);
        r4.xy = float2(1, 1) + r4.xy;
        r4.xy = saturate(r3.xx / r4.xy);
        r4.xy = float2(1, 1) + -r4.xy;
        r3.z = r4.x * r3.z;
        r3.z = r3.z * r4.y;
        r3.y = r1.z * 2 + r3.y;
        r3.y = max(0, r3.y);
        r3.y = 1 + r3.y;
        r3.y = saturate(r3.x / r3.y);
        r3.y = 1 + -r3.y;
        r3.y = r3.z * r3.y;
        r0.w = r2.w * r0.w + r1.z;
        r0.w = max(0, r0.w);
        r0.w = 1 + r0.w;
        r0.w = saturate(r3.x / r0.w);
        r0.w = 1 + -r0.w;
        r0.w = -r3.y * r0.w + 1;
        r1.z = -aerialParams.y + fogBaseParams.z;
        r1.z = saturate(aerialParams.z * r1.z);
    }
    else
    {
        r0.w = 1;
        r1.z = 0;
    }
    r0.w = log2(r0.w);
    r2.w = fogBaseParams.w * r0.w;
    r2.w = exp2(r2.w);
    r2.w = r2.w * r1.z;
    r0.w = aerialParams.x * r0.w;
    r0.w = exp2(r0.w);
    r0.w = r1.z * r0.w;
    r3.xy = saturate(r2.ww * fogCustomRangesEnv0.xz + fogCustomRangesEnv0.yw);
    r4.xyz = fogCustomValuesEnv0.xyz + -r2.xyz;
    r4.xyz = r3.xxx * r4.xyz + r2.xyz;
    r1.z = -1 + fogCustomValuesEnv0.w;
    r1.z = r3.y * r1.z + 1;
    r4.w = saturate(r2.w * r1.z);
    r1.z = cmp(0 < mostImportantEnvsBlendParams.x);
    if (r1.z != 0)
    {
        r3.xy = saturate(r2.ww * fogCustomRangesEnv1.xz + fogCustomRangesEnv1.yw);
        r5.xyz = fogCustomValuesEnv1.xyz + -r2.xyz;
        r5.xyz = r3.xxx * r5.xyz + r2.xyz;
        r1.z = -1 + fogCustomValuesEnv1.w;
        r1.z = r3.y * r1.z + 1;
        r5.w = saturate(r2.w * r1.z);
        r2.xyzw = r5.xyzw + -r4.xyzw;
        r4.xyzw = mostImportantEnvsBlendParams.xxxx * r2.xyzw + r4.xyzw;
    }
    r1.z = dot(float3(0.333000004, 0.555000007, 0.222000003), r0.xyz);
    r1.xyz = r1.zzz * r1.xyw + -r0.xyz;
    r0.xyz = r0.www * r1.xyz + r0.xyz;
    r1.xyz = r4.xyz + -r0.xyz;

    float3 sky_color = max(r4.www * r1.xyz + r0.xyz, 0);

    float weight = 1 - FresnelSchlick(ray_direction.z, 0.02);
    sky_average_shared[thread_id.x] = float4(sky_color * weight, weight);

    // Perform a parallel reduction
    GroupMemoryBarrierWithGroupSync();
    for (int s = 128; s > 0; s /= 2)
    {
        if (thread_id.x < s)
        {
            sky_average_shared[thread_id.x] += sky_average_shared[thread_id.x + s];
        }
        GroupMemoryBarrierWithGroupSync();
    }
    if (thread_id.x > 0)
    {
        return;
    }

    sky_ambient[int2(0, 0)] = sky_average_shared[0].rgb / sky_average_shared[0].w;
}