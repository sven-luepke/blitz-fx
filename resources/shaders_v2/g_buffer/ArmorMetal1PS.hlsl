#include "Common.hlsli"
Texture2D<float4> t13 : register(t13);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);

SamplerState s13_s : register(s13);
SamplerState s0_s : register(s0);

cbuffer cb4 : register(b4)
{
    float4 cb4[8];
}


#define cmp -


void PSMain(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float3 v3 : TEXCOORD3,
  uint v4 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0,
  out float4 normal_roughness : SV_Target1,
  out float4 o2 : SV_Target2)
{
    float4 r0, r1, r2, r3;

    r0.x = cb4[0].x * v0.z;
    r1.xyzw = t1.Sample(s0_s, v1.xy).xyzw;
    r0.yzw = t0.Sample(s0_s, v1.xy).xyz;
    r2.x = r0.y + r0.z;
    r2.x = r2.x + r0.w;
    r2.z = cb4[2].x + -1;
    r2.yz = float2(0.333299994, 0.5) * r2.xz;
    r2.w = saturate(r2.z);
    r2.x = r2.x * -0.666599989 + 1;
    r2.x = r2.w * r2.x + r2.y;
    r3.xyz = cb4[1].xyz * r0.yzw;
    r3.xyz = saturate(float3(1.5, 1.5, 1.5) * r3.xyz);
    r2.x = saturate(r2.x * abs(r2.z));
    r2.yzw = r3.xyz + -r0.yzw;
    r0.yzw = r2.xxx * r2.yzw + r0.yzw;
    r2.x = max(r0.z, r0.w);
    r2.x = max(r2.x, r0.y);
    r2.x = cmp(0.219999999 < r2.x);
    r2.x = r2.x ? -0.300000012 : -0.149999976;
    r0.x = r0.x * r2.x + 1;
    o0.xyz = r0.yzw * r0.xxx;
    r0.xyz = float3(-0.5, -0.5, -0.5) + r1.xyz;
    r0.xyz = r0.xyz + r0.xyz;
    r1.x = v0.w;
    r1.yz = v1.zw;
    r1.xyz = r1.xyz * r0.yyy;
    r0.xyw = v3.xyz * r0.xxx + r1.xyz;
    r0.xyz = v2.xyz * r0.zzz + r0.xyw;
    r0.w = cmp(0 >= (uint) v4.x);
    if (r0.w != 0)
    {
        r0.w = dot(v2.xyz, r0.xyz);
        r1.xyz = v2.xyz * r0.www;
        r0.xyz = -r1.xyz * float3(2, 2, 2) + r0.xyz;
    }
    r0.w = 1 + -r1.w;
    r1.xyz = log2(cb4[3].xyz);
    r1.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r0.w = r0.w * cb4[4].x + cb4[5].x;
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
    r0.w = cmp(0 < cb4[7].x);
    o2.w = r0.w ? 0.064706 : 0;
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
    o0.w = cb4[6].x;

    float roughness = normal_roughness.w;
    normal_roughness.w = FilterNDF(normal, roughness);
}