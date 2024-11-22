#include "Common.hlsli"
Texture2D<float4> t13 : register(t13);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);

SamplerState s13_s : register(s13);
SamplerState s0_s : register(s0);

cbuffer cb4 : register(b4)
{
    float4 cb4[16];
}

cbuffer cb2 : register(b2)
{
    float4 cb2[14];
}

cbuffer cb1 : register(b1)
{
    float4 cb1[9];
}

#define cmp -


void PSMain(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float4 v3 : TEXCOORD3,
  float3 v4 : TEXCOORD4,
  uint v5 : SV_IsFrontFace0,
  out float4 albedo_translucency : SV_Target0,
  out float4 normal_roughness : SV_Target1,
  out float4 o2 : SV_Target2)
{
    float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9;

    r0.xyzw = t1.Sample(s0_s, v1.xy).xyzw;
    r1.xy = cb4[0].xy * v1.xy;
    r2.x = -abs(cb4[1].x) + 1;
    r2.y = cb4[1].x;
    r3.x = dot(r2.xy, r1.xy);
    r2.z = -cb4[1].x;
    r3.y = dot(r2.zx, r1.xy);
    r1.xyzw = t2.Sample(s0_s, r3.xy).xyzw;
    r1.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r1.wxyz;
    r1.x = 0.5 * r1.x;
    r2.xyz = cb1[8].xyz + -v3.xyz;
    r2.x = dot(r2.xyz, r2.xyz);
    r2.x = sqrt(r2.x);
    r2.x = saturate(cb4[3].x + -r2.x);
    r2.yzw = t3.Sample(s0_s, v1.xy).yxz;
    r3.xy = cb4[4].xy * v1.xy;
    r4.x = -abs(cb4[5].x) + 1;
    r4.y = cb4[5].x;
    r5.x = dot(r4.xy, r3.xy);
    r4.z = -cb4[5].x;
    r5.y = dot(r4.zx, r3.xy);
    r3.xyzw = t4.Sample(s0_s, r5.xy).xyzw;
    r3.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r3.wxyz;
    r3.x = 0.5 * r3.x;
    r4.x = cb4[2].x * v0.z;
    r4.x = r4.x * -0.600000024 + cb4[2].x;
    r4.yzw = float3(-0.550000012, -1, -0.5) + r2.wzw;
    r2.z = saturate(2.22222233 * r4.y);
    r4.y = 0.449999988 + -r2.w;
    r4.y = saturate(2.22222233 * r4.y);
    r5.x = r4.y * r3.x;
    r5.x = r1.x * r2.z + r5.x;
    r5.x = r5.x * r2.x;
    r0.w = saturate(r5.x * r4.x + r0.w);
    r5.x = cb4[6].x * r4.x;
    r3.x = r4.y * -r3.x;
    r1.x = -r1.x * r2.z + r3.x;
    r1.x = r1.x * r2.x;
    r1.x = r1.x * r5.x + 1;
    r1.x = max(0, r1.x);
    r5.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
    r6.xyz = log2(r5.xyz);
    r6.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r6.xyz;
    r5.xyz = exp2(r6.xyz);
    r5.xyzw = r5.xyzw * r1.xxxx;
    r2.z = cmp(0 < cb4[9].x);
    if (r2.z != 0)
    {
        r6.xyz = log2(r5.xzy);
        r6.xyz = float3(0.454544991, 0.454544991, 0.454544991) * r6.xyz;
        r6.xyz = exp2(r6.xyz);
        r2.z = r6.x + r6.y;
        r7.xy = r6.xy / r2.zz;
        r7.xy = float2(-0.300000012, -0.300000012) + r7.xy;
        r7.xy = saturate(float2(1.42857146, 1.42857146) * r7.xy);
        r2.z = cmp(0 < cb4[7].x);
        if (r2.z != 0)
        {
            r2.z = r7.x + r7.y;
            r2.z = r7.y / r2.z;
            r3.x = 1 + -r2.z;
            r7.xyzw = cb2[11].zyxw * r2.zzzz;
            r8.xyzw = cb2[12].zyxw * r2.zzzz;
            r9.xyzw = cb2[13].zyxw * r2.zzzz;
            r7.xyzw = r3.xxxx * cb2[7].xyzw + r7.xyzw;
            r8.xyzw = r3.xxxx * cb2[8].xyzw + r8.xyzw;
            r9.xyzw = r3.xxxx * cb2[9].xyzw + r9.xyzw;
        }
        else
        {
            r2.z = cmp(r6.x >= r6.y);
            r7.xyzw = r2.zzzz ? cb2[7].xyzw : cb2[11].zyxw;
            r8.xyzw = r2.zzzz ? cb2[8].xyzw : cb2[12].zyxw;
            r9.xyzw = r2.zzzz ? cb2[9].xyzw : cb2[13].zyxw;
        }
        r2.z = min(r6.z, r6.y);
        r2.z = min(r6.x, r2.z);
        r3.x = max(r6.z, r6.y);
        r3.x = max(r6.x, r3.x);
        r4.y = cmp(0 < cb4[8].x);
        if (r4.y != 0)
        {
            r2.z = r3.x + -r2.z;
            r2.z = r2.z / r3.x;
            r2.z = -0.100000001 + r2.z;
            r2.z = saturate(5 * r2.z);
            r2.y = r2.y * r2.z;
        }
        r6.xyz = log2(r5.xyz);
        r6.xyz = float3(0.454544991, 0.454544991, 0.454544991) * r6.xyz;
        r5.xyz = exp2(r6.xyz);
        r6.x = dot(r5.xyzw, r7.xyzw);
        r6.y = dot(r5.xyzw, r8.xyzw);
        r6.z = dot(r5.xyzw, r9.xyzw);
        r6.xyz = r6.xyz + -r5.xyz;
        r6.xyz = r2.yyy * r6.xyz + r5.xyz;
    }
    else
    {
        r5.xyz = log2(r5.xyz);
        r5.xyz = float3(0.454544991, 0.454544991, 0.454544991) * r5.xyz;
        r6.xyz = exp2(r5.xyz);
    }
    r2.y = saturate(cb4[10].x);
    r2.y = r2.y * r4.z + 1;
    r5.xyz = r6.xyz * r2.yyy;
    r2.y = max(r5.y, r5.z);
    r2.y = max(r5.x, r2.y);
    r2.y = cmp(0.219999999 < r2.y);
    r2.y = r2.y ? -0.300000012 : -0.149999976;
    r2.y = v0.z * r2.y + 1;
    albedo_translucency.xyz = r5.xyz * r2.yyy;
    r0.xyz = float3(-0.5, -0.5, -0.5) + r0.xyz;
    r0.xyz = r0.xyz + r0.xyz;
    r1.yzw = r1.yzw + r1.yzw;
    r3.xyz = r3.yzw + r3.yzw;
    r2.x = r4.x * r2.x;
    r2.y = -0.0500000007 + abs(r4.w);
    r2.y = saturate(2.22222233 * r2.y);
    r2.x = r2.x * r2.y;
    r2.y = cmp(0.5 < r2.w);
    r1.yzw = r2.yyy ? r1.yzw : r3.xyz;
    r2.yzw = r1.www * r0.xyz;
    r0.xy = r2.xx * r1.yz;
    r2.yz = r0.xy * r0.zz + r2.yz;
    r0.x = dot(r2.yzw, r2.yzw);
    r0.x = rsqrt(r0.x);
    r0.xyz = r2.yzw * r0.xxx;
    r2.x = v0.w;
    r2.yz = v1.zw;
    r1.yzw = r2.xyz * r0.yyy;
    r1.yzw = v4.xyz * r0.xxx + r1.yzw;
    r0.xyz = v2.xyz * r0.zzz + r1.yzw;
    r1.y = cmp(0 >= (uint) v5.x);
    if (r1.y != 0)
    {
        r1.y = dot(v2.xyz, r0.xyz);
        r1.yzw = v2.xyz * r1.yyy;
        r0.xyz = -r1.yzw * float3(2, 2, 2) + r0.xyz;
    }
    r1.yzw = t5.Sample(s0_s, v1.xy).xyz;
    r1.yzw = saturate(r1.yzw * cb4[11].xxx + cb4[12].xxx);
    r1.yzw = log2(r1.yzw);
    r1.yzw = float3(2.20000005, 2.20000005, 2.20000005) * r1.yzw;
    r1.yzw = exp2(r1.yzw);
    r1.xyz = r1.xxx * r1.yzw;
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(0.454544991, 0.454544991, 0.454544991) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.w = max(r1.y, r1.z);
    r1.w = max(r1.x, r1.w);
    r1.w = cmp(0.200000003 < r1.w);
    r2.xyz = r1.www ? r1.xyz : float3(0.119999997, 0.119999997, 0.119999997);
    r2.xyz = r2.xyz + -r1.xyz;
    o2.xyz = v0.zzz * r2.xyz + r1.xyz;
    r1.x = cb4[14].x + -cb4[13].x;
    r0.w = saturate(r0.w * r1.x + cb4[13].x);
    r1.x = cmp(r0.w < 0.330000013);
    r1.y = 0.949999988 * r0.w;
    r1.x = r1.x ? r1.y : 0.330000013;
    r1.x = r1.x + -r0.w;
    normal_roughness.w = v0.z * r1.x + r0.w;
    r0.w = dot(r0.xyz, r0.xyz);
    r0.w = rsqrt(r0.w);
    r0.xyz = r0.xyz * r0.www;

    float3 normal = r0.xyz;

    r0.w = max(abs(r0.x), abs(r0.y));
    r0.w = max(abs(r0.z), r0.w);
    r1.xy = cmp(abs(r0.zy) < r0.ww);
    r1.yz = r1.yy ? abs(r0.zy) : abs(r0.zx);
    r1.xy = r1.xx ? r1.yz : abs(r0.yx);
    r1.z = cmp(r1.y < r1.x);
    r1.xy = r1.zz ? r1.xy : r1.yx;
    r1.z = r1.y / r1.x;
    r0.xyz = r0.xyz / r0.www;
    r0.w = t13.SampleLevel(s13_s, r1.xz, 0).x;
    r0.xyz = r0.xyz * r0.www;
    normal_roughness.xyz = r0.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
    albedo_translucency.w = cb4[15].x;
    o2.w = 0;

    float roughness = normal_roughness.w;
    normal_roughness.w = FilterNDF(normal, roughness);
}