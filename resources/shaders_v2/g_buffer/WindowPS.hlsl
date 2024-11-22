#include "Common.hlsli"
Texture2D<float4> t13 : register(t13);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);

SamplerState s13_s : register(s13);
SamplerState s0_s : register(s0);

cbuffer cb4 : register(b4)
{
    float4 cb4[6];
}

#define cmp -

void PSMain(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float3 v2 : TEXCOORD2,
  uint v3 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0,
  out float4 normal_roughness : SV_Target1,
  out float4 o2 : SV_Target2)
{
    float4 r0, r1, r2;

    r0.xy = cb4[0].xy * v0.xy;
    r1.xyz = t0.Sample(s0_s, r0.xy).xyz;
    r0.z = r1.x + r1.y;
    r0.z = r0.z + r1.z;
    r0.w = 0.333299994 * r0.z;
    r1.w = cb4[2].x + -1;
    r1.w = 0.5 * r1.w;
    r2.x = saturate(r1.w);
    r0.z = r0.z * -0.666599989 + 1;
    r0.z = r2.x * r0.z + r0.w;
    r2.xyz = cb4[1].xyz * r1.xyz;
    r2.xyz = saturate(float3(1.5, 1.5, 1.5) * r2.xyz);
    r0.z = saturate(r0.z * abs(r1.w));
    r2.xyz = r2.xyz + -r1.xyz;
    o0.xyz = r0.zzz * r2.xyz + r1.xyz;
    r0.xyzw = t1.Sample(s0_s, r0.xy).xyzw;
    r0.xyz = float3(-0.5, -0.5, -0.5) + r0.xyz;
    r0.xyz = r0.xyz + r0.xyz;
    r1.xyz = v1.xyz * r0.yyy;
    r2.xy = v0.zw;
    r2.z = v1.w;
    r1.xyz = v2.xyz * r0.xxx + r1.xyz;
    r0.xyz = r2.xyz * r0.zzz + r1.xyz;
    r1.x = cmp(0 >= (uint) v3.x);
    if (r1.x != 0)
    {
        r1.x = dot(r2.xyz, r0.xyz);
        r1.xyz = r2.xyz * r1.xxx;
        r0.xyz = -r1.xyz * float3(2, 2, 2) + r0.xyz;
    }
    r1.x = 1 + -r0.w;
    r1.yzw = log2(cb4[3].xyz);
    r1.yzw = float3(2.20000005, 2.20000005, 2.20000005) * r1.yzw;
    r1.yzw = exp2(r1.yzw);
    r1.x = r1.x * cb4[4].x + cb4[5].x;
    r1.xyz = saturate(r1.yzw * r1.xxx);
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(0.454544991, 0.454544991, 0.454544991) * r1.xyz;
    o2.xyz = exp2(r1.xyz);
    r1.x = dot(r0.xyz, r0.xyz);
    r1.x = rsqrt(r1.x);
    r0.xyz = r1.xxx * r0.xyz;

    float3 normal = r0.xyz;

    r1.x = max(abs(r0.x), abs(r0.y));
    r1.x = max(r1.x, abs(r0.z));
    r1.yz = cmp(abs(r0.zy) < r1.xx);
    r1.zw = r1.zz ? abs(r0.zy) : abs(r0.zx);
    r1.yz = r1.yy ? r1.zw : abs(r0.yx);
    r1.w = cmp(r1.z < r1.y);
    r2.xy = r1.ww ? r1.yz : r1.zy;
    r2.z = r2.y / r2.x;
    r0.xyz = r0.xyz / r1.xxx;
    r1.x = t13.SampleLevel(s13_s, r2.xz, 0).x;
    r0.xyz = r1.xxx * r0.xyz;
    normal_roughness.xyz = r0.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
    o0.w = 0;
    normal_roughness.w = r0.w;
    o2.w = 0;

    float roughness = normal_roughness.w;
    normal_roughness.w = FilterNDF(normal, roughness);
}