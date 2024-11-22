#include "CustomData.hlsli"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb12 : register(b12)
{
    float4 cb12[214];
}

cbuffer cb3 : register(b3)
{
    float4 cb3[3];
    // 0.x farFocusDist
    // 0.y farBlurDist
    // 0.z intensity
    // 0.w farFocusMinusBlurDistRcp
}

#define cmp -

void PSMain(
  float4 sv_position : SV_Position0,
  out float4 o0 : SV_Target0,
  out float sv_depth : SV_Depth)
{
    float4 r0, r1, r2, r3, r4;

    r0.xy = (int2) sv_position.xy;
    r0.zw = float2(0, 0);
    r0.x = t1.Load(r0.xyz).x;
    r0.y = r0.x * cb12[22].x + cb12[22].y;
    r0.y = r0.y * cb12[21].x + cb12[21].y;
    r0.y = max(9.99999975e-005, r0.y);
    r0.y = 1 / r0.y;

    float farFocusDist, intensity, farBlurMinusFocusDistRcp;
    [flatten]
    if (enable_custom_gameplay_dof_params)
    {
        farFocusDist = gameplay_dof_focus_distance;
        intensity = gameplay_dof_intensity;
        farBlurMinusFocusDistRcp = rcp(gameplay_dof_blur_distance - gameplay_dof_focus_distance);

        // overwrite sv_depth to disable depth culling
        sv_depth = 1.0f;
    }
    else
    {
        farFocusDist = cb3[0].x;
        intensity = min(1, cb3[0].z * gameplay_dof_intensity_scale);
        farBlurMinusFocusDistRcp = cb3[0].w;
    }

    r0.z = -farFocusDist + r0.y;
    r0.z = saturate(farBlurMinusFocusDistRcp * r0.z);
    r0.z = sqrt(r0.z);
    r0.z = saturate(intensity * r0.z);

    r0.w = cb12[21].x + cb12[21].y;
    r0.w = max(9.99999975e-005, r0.w);
    r0.w = 1 / r0.w;
    r0.w = 0.999000013 * r0.w;
    r0.y = cmp(r0.y >= r0.w);
    r1.xy = trunc(sv_position.xy);
    r2.xyzw = cb12[211].xyzw * r1.yyyy;
    r1.xyzw = cb12[210].xyzw * r1.xxxx + r2.xyzw;
    r1.xyzw = cb12[212].xyzw * r0.xxxx + r1.xyzw;
    r1.xyzw = cb12[213].xyzw + r1.xyzw;
    r1.xyz = r1.xyz / r1.www;
    r1.xyz = -cb12[0].xyz + r1.xyz;
    r0.x = dot(r1.xyz, r1.xyz);
    r0.x = rsqrt(r0.x);

    // TODO:
    r0.x = r1.z * r0.x + -cb3[2].x;
    r0.x = saturate(-r0.x * cb3[2].y + 1);
    r0.x = 1;

    r0.x = r0.z * r0.x;
    r0.x = r0.y ? r0.x : r0.z;
    r0.y = cmp(0.00999999978 >= r0.x);
    if (r0.y != 0)
    {
        o0.xyzw = float4(0, 0, 0, 0);
        return;
    }

    r1.xyzw = cb12[73].zwzw * sv_position.xyxy;
    r0.xyzw = cb12[73].zwzw * r0.xxxx;
    r2.xyzw = t0.SampleLevel(s0_s, r1.zw, 0).xyzw;
    r3.xyzw = r0.zwzw * float4(-0.5, -1.5, 1.5, -0.5) + r1.zwzw;
    r4.xyzw = t0.SampleLevel(s0_s, r3.xy, 0).xyzw;
    r2.xyzw = r4.xyzw * float4(4, 4, 4, 4) + r2.xyzw;
    r3.xyzw = t0.SampleLevel(s0_s, r3.zw, 0).xyzw;
    r2.xyzw = r3.xyzw * float4(4, 4, 4, 4) + r2.xyzw;
    r3.xyzw = r0.zwzw * float4(0.5, 1.5, -1.5, 0.5) + r1.zwzw;
    r4.xyzw = t0.SampleLevel(s0_s, r3.xy, 0).xyzw;
    r2.xyzw = r4.xyzw * float4(4, 4, 4, 4) + r2.xyzw;
    r3.xyzw = t0.SampleLevel(s0_s, r3.zw, 0).xyzw;
    r2.xyzw = r3.xyzw * float4(4, 4, 4, 4) + r2.xyzw;
    r3.xyzw = r0.zwzw * float4(-2, -1, 1, -2) + r1.zwzw;
    r4.xyzw = t0.SampleLevel(s0_s, r3.xy, 0).xyzw;
    r2.xyzw = r4.xyzw + r2.xyzw;
    r3.xyzw = t0.SampleLevel(s0_s, r3.zw, 0).xyzw;
    r2.xyzw = r3.xyzw + r2.xyzw;
    r0.xyzw = r0.xyzw * float4(2, 1, -1, 2) + r1.xyzw;
    r1.xyzw = t0.SampleLevel(s0_s, r0.xy, 0).xyzw;
    r1.xyzw = r2.xyzw + r1.xyzw;
    r0.xyzw = t0.SampleLevel(s0_s, r0.zw, 0).xyzw;
    r0.xyzw = r1.xyzw + r0.xyzw;
    r1.x = max(0.00100000005, r0.w);
    r0.xyz = r0.xyz / r1.xxx;
    o0.xyz = float3(0.0416666679, 0.0416666679, 0.0416666679) * r0.xyz;
    o0.w = saturate(25 * r0.w);
    return;
}