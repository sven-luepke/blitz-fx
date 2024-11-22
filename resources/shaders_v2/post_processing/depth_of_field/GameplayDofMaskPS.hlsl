#include "CustomData.hlsli"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);

cbuffer cb12 : register(b12)
{
    float4 cb12[214];
}

cbuffer cb3 : register(b3)
{
    float4 cb3[3];
}

#define cmp -

void PSMain(
  float4 sv_position : SV_Position0,
  out float4 o0 : SV_Target0,
  out float sv_depth : SV_Depth)
{
    float4 r0, r1, r2;

    r0.xy = trunc(sv_position.xy);
    r1.xyzw = cb12[211].xyzw * r0.yyyy;
    r0.xyzw = cb12[210].xyzw * r0.xxxx + r1.xyzw;
    r1.xy = (int2) sv_position.xy;
    r1.zw = float2(0, 0);
    r2.x = t1.Load(r1.xyw).x;
    r1.xyz = t0.Load(r1.xyz).xyz;
    r0.xyzw = cb12[212].xyzw * r2.xxxx + r0.xyzw;
    r1.w = r2.x * cb12[22].x + cb12[22].y;
    r1.w = r1.w * cb12[21].x + cb12[21].y;
    r1.w = max(9.99999975e-005, r1.w);
    r1.w = 1 / r1.w;
    r0.xyzw = cb12[213].xyzw + r0.xyzw;
    r0.xyz = r0.xyz / r0.www;
    r0.xyz = -cb12[0].xyz + r0.xyz;
    r0.x = dot(r0.xyz, r0.xyz);
    r0.x = rsqrt(r0.x);
    r0.x = r0.z * r0.x + -cb3[2].x;
    r0.x = saturate(-r0.x * cb3[2].y + 1);

    r0.x = 1; // disable sky exclusion

    float farFocusDist, intensity, farBlurMinusFocusDistRcp;
    [flatten]
    if (enable_custom_gameplay_dof_params)
    {
        farFocusDist = gameplay_dof_focus_distance;
        intensity = gameplay_dof_intensity;
        farBlurMinusFocusDistRcp = rcp(max(gameplay_dof_blur_distance - gameplay_dof_focus_distance, 0.01));

        // overwrite sv_depth to disable depth culling
        sv_depth = 1.0f;
    }
    else
    {
        farFocusDist = cb3[0].x;
        intensity = min(1, cb3[0].z * gameplay_dof_intensity_scale);
        farBlurMinusFocusDistRcp = cb3[0].w;
    }

    r0.y = -farFocusDist + r1.w;
    r0.y = saturate(farBlurMinusFocusDistRcp * r0.y);
    r0.y = sqrt(r0.y);
    r0.y = saturate(intensity * r0.y);


    r0.x = r0.y * r0.x;
    r0.z = cb12[21].x + cb12[21].y;
    r0.z = max(9.99999975e-005, r0.z);
    r0.z = 1 / r0.z;
    r0.z = 0.999000013 * r0.z;
    r0.z = cmp(r1.w >= r0.z);
    r0.x = r0.z ? r0.x : r0.y;
    r0.x = 3 * r0.x;
    r0.x = ceil(r0.x);
    r0.y = 8 * r0.x;
    o0.w = 0.333333343 * r0.x;
    o0.xyz = r1.xyz * r0.yyy;
}