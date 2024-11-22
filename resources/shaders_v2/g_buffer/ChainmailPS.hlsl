#include "Common.hlsli"

Texture2D<float4> t13 : register(t13);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);

SamplerState s13_s : register(s13);
SamplerState s0_s : register(s0);

cbuffer cb4 : register(b4)
{
    float4 cb4[11];
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
    float4 r0, r1, r2, r3, r4;

    r0.xyzw = t1.Sample(s0_s, v1.xy).xyzw;
    r0.w = r0.w + r0.w;
    r1.xy = cb4[2].xy * v1.xy;
    r2.x = -abs(cb4[3].x) + 1;
    r2.y = cb4[3].x;
    r3.x = dot(r2.xy, r1.xy);
    r2.z = -cb4[3].x;
    r3.y = dot(r2.zx, r1.xy);
    r1.xyzw = t2.Sample(s0_s, r3.xy).xyzw;
    r0.w = saturate(r1.w * r0.w);
    r1.w = cb4[1].x + -cb4[0].x;
    r1.w = saturate(r0.w * r1.w + cb4[0].x);
    r2.x = cb4[5].x * cb4[4].x;
    r2.yz = t3.Sample(s0_s, v1.xy).xz;
    r4.xyz = cb1[8].xyz + -v3.xyz;
    r2.w = dot(r4.xyz, r4.xyz);
    r2.w = sqrt(r2.w);
    r2.w = saturate(50 + -r2.w);
    r2.yz = float2(-0.550000012, -1) + r2.zy;
    r2.y = saturate(2.22222233 * r2.y);
    r2.y = r2.y * -r0.w;
    r2.y = r2.y * r2.w;
    r2.x = r2.y * r2.x + 1;
    r2.x = max(0, r2.x);
    r3.xyz = t4.Sample(s0_s, r3.xy).xyz;
    r4.xyz = t0.Sample(s0_s, v1.xy).xyz;
    r3.xyz = r4.xyz * r3.xyz;
    r3.xyz = saturate(r3.xyz + r3.xyz);
    r3.xyz = log2(r3.xyz);
    r3.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r3.xyz;
    r3.xyz = exp2(r3.xyz);
    r3.xyz = r3.xyz * r2.xxx;
    r2.x = saturate(cb4[6].x);
    r3.xyz = log2(r3.xyz);
    r3.xyz = float3(0.454544991, 0.454544991, 0.454544991) * r3.xyz;
    r3.xyz = exp2(r3.xyz);
    r2.x = r2.x * r2.z + 1;
    r2.xyz = r3.xyz * r2.xxx;
    r3.x = max(r2.y, r2.z);
    r3.x = max(r3.x, r2.x);
    r3.x = cmp(0.219999999 < r3.x);
    r3.x = r3.x ? -0.300000012 : -0.149999976;
    r3.x = v0.z * r3.x + 1;
    albedo_translucency.xyz = r3.xxx * r2.xyz;
    r1.xyz = float3(-0.5, -0.5, -0.5) + r1.xyz;
    r3.xyz = r1.xyz + r1.xyz;
    r0.xyz = float3(-0.5, -0.5, -0.5) + r0.xyz;
    r3.w = 2;
    r0.xyz = r3.zzw * r0.xyz;
    r1.x = cb4[5].x * r2.w;
    r0.xy = r0.xy + r0.xy;
    r1.xy = r1.xx * r3.xy;
    r0.xy = r1.xy * r0.zz + r0.xy;
    r0.z = r0.z * r3.z;
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
    r0.w = 1 + -r0.w;
    r1.xyz = log2(cb4[7].xyz);
    r1.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r0.w = r0.w * cb4[8].x + cb4[9].x;
    r1.xyz = saturate(r1.xyz * r0.www);
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(0.454544991, 0.454544991, 0.454544991) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r0.w = max(r1.y, r1.z);
    r0.w = max(r1.x, r0.w);
    r0.w = cmp(0.200000003 < r0.w);
    r2.xyz = r0.www ? r1.xyz : float3(0.119999997, 0.119999997, 0.119999997);
    r2.xyz = r2.xyz + -r1.xyz;
    o2.xyz = v0.zzz * r2.xyz + r1.xyz;
    r0.w = cmp(r1.w < 0.330000013);
    r1.x = 0.949999988 * r1.w;
    r0.w = r0.w ? r1.x : 0.330000013;
    r0.w = r0.w + -r1.w;
    normal_roughness.w = v0.z * r0.w + r1.w;
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
    albedo_translucency.w = cb4[10].x;
    o2.w = 0;

    float roughness = normal_roughness.w;
    normal_roughness.w = FilterNDF(normal, roughness);
}