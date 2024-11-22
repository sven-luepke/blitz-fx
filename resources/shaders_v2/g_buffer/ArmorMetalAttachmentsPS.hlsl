#include "Common.hlsli"

Texture2D<float4> t13 : register(t13);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);

SamplerState s13_s : register(s13);
SamplerState s0_s : register(s0);

cbuffer cb4 : register(b4)
{
    float4 cb4[15];
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
    float4 r0, r1, r2, r3, r4, r5, r6, r7, r8;

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
    r3.x = cb4[2].x * v0.z;
    r3.x = r3.x * -0.600000024 + cb4[2].x;
    r2.zw = float2(-0.550000012, -1) + r2.wz;
    r2.z = saturate(2.22222233 * r2.z);
    r3.y = r2.z * r1.x;
    r3.y = r3.y * r2.x;
    r0.w = saturate(r3.y * r3.x + r0.w);
    r3.y = cb4[4].x * r3.x;
    r1.x = r2.z * -r1.x;
    r1.x = r1.x * r2.x;
    r1.x = r1.x * r3.y + 1;
    r1.x = max(0, r1.x);
    r4.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
    r3.yzw = log2(r4.xyz);
    r3.yzw = float3(2.20000005, 2.20000005, 2.20000005) * r3.yzw;
    r4.xyz = exp2(r3.yzw);
    r4.xyzw = r4.xyzw * r1.xxxx;
    r1.x = cmp(0 < cb4[7].x);
    if (r1.x != 0)
    {
        r3.yzw = log2(r4.xzy);
        r3.yzw = float3(0.454544991, 0.454544991, 0.454544991) * r3.yzw;
        r3.yzw = exp2(r3.yzw);
        r1.x = r3.y + r3.z;
        r5.xy = r3.yz / r1.xx;
        r5.xy = float2(-0.300000012, -0.300000012) + r5.xy;
        r5.xy = saturate(float2(1.42857146, 1.42857146) * r5.xy);
        r1.x = cmp(0 < cb4[5].x);
        if (r1.x != 0)
        {
            r1.x = r5.x + r5.y;
            r1.x = r5.y / r1.x;
            r5.x = 1 + -r1.x;
            r6.xyzw = cb2[11].zyxw * r1.xxxx;
            r7.xyzw = cb2[12].zyxw * r1.xxxx;
            r8.xyzw = cb2[13].zyxw * r1.xxxx;
            r6.xyzw = r5.xxxx * cb2[7].xyzw + r6.xyzw;
            r7.xyzw = r5.xxxx * cb2[8].xyzw + r7.xyzw;
            r5.xyzw = r5.xxxx * cb2[9].xyzw + r8.xyzw;
        }
        else
        {
            r1.x = cmp(r3.y >= r3.z);
            r6.xyzw = r1.xxxx ? cb2[7].xyzw : cb2[11].zyxw;
            r7.xyzw = r1.xxxx ? cb2[8].xyzw : cb2[12].zyxw;
            r5.xyzw = r1.xxxx ? cb2[9].xyzw : cb2[13].zyxw;
        }
        r1.x = min(r3.w, r3.z);
        r1.x = min(r3.y, r1.x);
        r3.z = max(r3.w, r3.z);
        r3.y = max(r3.y, r3.z);
        r3.z = cmp(0 < cb4[6].x);
        if (r3.z != 0)
        {
            r1.x = r3.y + -r1.x;
            r1.x = r1.x / r3.y;
            r1.x = -0.100000001 + r1.x;
            r1.x = saturate(5 * r1.x);
            r2.y = r2.y * r1.x;
        }
        r3.yzw = log2(r4.xyz);
        r3.yzw = float3(0.454544991, 0.454544991, 0.454544991) * r3.yzw;
        r4.xyz = exp2(r3.yzw);
        r6.x = dot(r4.xyzw, r6.xyzw);
        r6.y = dot(r4.xyzw, r7.xyzw);
        r6.z = dot(r4.xyzw, r5.xyzw);
        r3.yzw = r6.xyz + -r4.xyz;
        r3.yzw = r2.yyy * r3.yzw + r4.xyz;
    }
    else
    {
        r4.xyz = log2(r4.xyz);
        r4.xyz = float3(0.454544991, 0.454544991, 0.454544991) * r4.xyz;
        r3.yzw = exp2(r4.xyz);
    }
    r1.x = saturate(cb4[8].x);
    r1.x = r1.x * r2.w + 1;
    r3.yzw = r3.yzw * r1.xxx;
    r1.x = max(r3.z, r3.w);
    r1.x = max(r3.y, r1.x);
    r1.x = cmp(0.219999999 < r1.x);
    r1.x = r1.x ? -0.300000012 : -0.149999976;
    r1.x = v0.z * r1.x + 1;
    albedo_translucency.xyz = r3.yzw * r1.xxx;
    r0.xyz = float3(-0.5, -0.5, -0.5) + r0.xyz;
    r0.xyz = r0.xyz + r0.xyz;
    r1.xyz = r1.yzw + r1.yzw;
    r1.w = r3.x * r2.x;
    r1.w = r1.w * r2.z;
    r2.xyz = r1.zzz * r0.xyz;
    r0.xy = r1.ww * r1.xy;
    r2.xy = r0.xy * r0.zz + r2.xy;
    r0.x = dot(r2.xyz, r2.xyz);
    r0.x = rsqrt(r0.x);
    r0.xyz = r2.xyz * r0.xxx;
    r1.x = v0.w;
    r1.yz = v1.zw;
    r1.xyz = r1.xyz * r0.yyy;
    r1.xyz = v4.xyz * r0.xxx + r1.xyz;
    r0.xyz = v2.xyz * r0.zzz + r1.xyz;
    r1.x = cmp(0 >= (uint) v5.x);
    if (r1.x != 0)
    {
        r1.x = dot(v2.xyz, r0.xyz);
        r1.xyz = v2.xyz * r1.xxx;
        r0.xyz = -r1.xyz * float3(2, 2, 2) + r0.xyz;
    }
    r1.x = 1 + -r0.w;
    r1.yzw = log2(cb4[9].xyz);
    r1.yzw = float3(2.20000005, 2.20000005, 2.20000005) * r1.yzw;
    r1.yzw = exp2(r1.yzw);
    r1.x = r1.x * cb4[10].x + cb4[11].x;
    r1.xyz = saturate(r1.yzw * r1.xxx);
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(0.454544991, 0.454544991, 0.454544991) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.w = max(r1.y, r1.z);
    r1.w = max(r1.x, r1.w);
    r1.w = cmp(0.200000003 < r1.w);
    r2.xyz = r1.www ? r1.xyz : float3(0.119999997, 0.119999997, 0.119999997);
    r2.xyz = r2.xyz + -r1.xyz;
    o2.xyz = v0.zzz * r2.xyz + r1.xyz;
    r1.x = cb4[13].x + -cb4[12].x;
    r0.w = saturate(r0.w * r1.x + cb4[12].x);
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
    albedo_translucency.w = cb4[14].x;
    o2.w = 0;

    float roughness = normal_roughness.w;
    normal_roughness.w = FilterNDF(normal, roughness);
}