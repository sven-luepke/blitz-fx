#include "Common.hlsli"

Texture2D<float4> t13 : register(t13);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);

SamplerState s13_s : register(s13);
SamplerState s0_s : register(s0);

cbuffer cb4 : register(b4)
{
    float4 cb4[10];
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
    float4 r0, r1, r2, r3, r4, r5;

    r0.xy = cb4[1].xy * v1.xy;
    r1.x = -abs(cb4[2].x) + 1;
    r1.y = cb4[2].x;
    r2.x = dot(r1.xy, r0.xy);
    r1.z = -cb4[2].x;
    r2.y = dot(r1.zx, r0.xy);
    r0.xyzw = t1.Sample(s0_s, r2.xy).xyzw;
    r1.x = cb4[0].x * v0.z;
    r1.x = r1.x * -0.600000024 + cb4[0].x;
    r1.y = 0.25 * r1.x;
    r0.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r0.wxyz;
    r0.x = r1.y * r0.x;
    r2.xyzw = t2.Sample(s0_s, v1.xy).xyzw;
    r1.yzw = cb1[8].xyz + -v3.xyz;
    r1.y = dot(r1.yzw, r1.yzw);
    r1.y = sqrt(r1.y);
    r1.y = saturate(cb4[3].x + -r1.y);
    r3.xy = r1.xx * r1.yy;
    r1.x = saturate(r3.y * r0.x + r2.w);
    r4.xyz = t0.Sample(s0_s, v1.xy).xyz;
    r4.xyz = r0.xxx * r1.yyy + r4.xyz;
    r1.z = r4.x + r4.y;
    r1.z = r1.z + r4.z;
    r1.w = 0.333299994 * r1.z;
    r3.w = cb4[5].x + -1;
    r3.w = 0.5 * r3.w;
    r4.w = saturate(r3.w);
    r1.z = r1.z * -0.666599989 + 1;
    r1.z = r4.w * r1.z + r1.w;
    r5.xyz = cb4[4].xyz * r4.xyz;
    r5.xyz = saturate(float3(1.5, 1.5, 1.5) * r5.xyz);
    r1.z = saturate(r1.z * abs(r3.w));
    r5.xyz = r5.xyz + -r4.xyz;
    r4.xyz = r1.zzz * r5.xyz + r4.xyz;
    r1.z = max(r4.y, r4.z);
    r1.z = max(r4.x, r1.z);
    r1.z = cmp(0.219999999 < r1.z);
    r1.z = r1.z ? -0.300000012 : -0.149999976;
    r1.z = v0.z * r1.z + 1;
    albedo_translucency.xyz = r4.xyz * r1.zzz;
    r3.zw = float2(2, 2);
    r3.xyz = r3.xyz * r0.yzw;
    r0.yzw = float3(-0.5, -0.5, -0.5) + r2.xyz;
    r0.yzw = r3.zzw * r0.yzw;
    r1.z = dot(r0.ww, r3.xx);
    r0.y = r0.y * 2 + r1.z;
    r1.z = dot(r0.ww, r3.yy);
    r0.z = r0.z * 2 + r1.z;
    r0.w = r0.w * r3.z;
    r2.x = v0.w;
    r2.yz = v1.zw;
    r2.xyz = r2.xyz * r0.zzz;
    r2.xyz = v4.xyz * r0.yyy + r2.xyz;
    r0.yzw = v2.xyz * r0.www + r2.xyz;
    r1.z = cmp(0 >= (uint) v5.x);
    if (r1.z != 0)
    {
        r1.z = dot(v2.xyz, r0.yzw);
        r2.xyz = v2.xyz * r1.zzz;
        r0.yzw = -r2.xyz * float3(2, 2, 2) + r0.yzw;
    }
    r0.x = -r0.x * r1.y + r2.w;
    r0.x = 1 + -r0.x;
    r1.yzw = log2(cb4[6].xyz);
    r1.yzw = float3(2.20000005, 2.20000005, 2.20000005) * r1.yzw;
    r1.yzw = exp2(r1.yzw);
    r0.x = r0.x * cb4[7].x + cb4[8].x;
    r1.yzw = saturate(r1.yzw * r0.xxx);
    r1.yzw = log2(r1.yzw);
    r1.yzw = float3(0.454544991, 0.454544991, 0.454544991) * r1.yzw;
    r1.yzw = exp2(r1.yzw);
    r0.x = max(r1.z, r1.w);
    r0.x = max(r1.y, r0.x);
    r0.x = cmp(0.200000003 < r0.x);
    r2.xyz = r0.xxx ? r1.yzw : float3(0.119999997, 0.119999997, 0.119999997);
    r2.xyz = r2.xyz + -r1.yzw;
    o2.xyz = v0.zzz * r2.xyz + r1.yzw;
    r0.x = cmp(r1.x < 0.330000013);
    r1.y = 0.949999988 * r1.x;
    r0.x = r0.x ? r1.y : 0.330000013;
    r0.x = r0.x + -r1.x;
    normal_roughness.w = v0.z * r0.x + r1.x;
    r0.x = dot(r0.yzw, r0.yzw);
    r0.x = rsqrt(r0.x);
    r0.xyz = r0.yzw * r0.xxx;

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
    albedo_translucency.w = cb4[9].x;
    o2.w = 0;

    float roughness = normal_roughness.w;
    normal_roughness.w = FilterNDF(normal, roughness);
}