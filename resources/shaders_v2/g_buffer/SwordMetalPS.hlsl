#include "Common.hlsli"

Texture2D<float4> t13 : register(t13);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);

SamplerState s13_s : register(s13);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

cbuffer cb4 : register(b4)
{
    float4 cb4[7];
}

cbuffer cb2 : register(b2)
{
    float4 cb2[1];
}


#define cmp -


void PSMain(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float3 v3 : TEXCOORD3,
  uint v4 : SV_IsFrontFace0,
  out float4 albedo_translucency : SV_Target0,
  out float4 normal_roughness : SV_Target1,
  out float4 o2 : SV_Target2)
{
    float4 r0, r1, r2, r3, r4;

    float4 x0[13];
    r0.xyz = t0.Sample(s0_s, v0.xy).xyz;
    r0.w = r0.x + r0.y;
    r0.w = r0.w + r0.z;
    r1.x = 0.333299994 * r0.w;
    r1.y = cb4[1].x + -1;
    r1.y = 0.5 * r1.y;
    r1.z = saturate(r1.y);
    r0.w = r0.w * -0.666599989 + 1;
    r0.w = r1.z * r0.w + r1.x;
    r1.xzw = cb4[0].xyz * r0.xyz;
    r1.xzw = saturate(float3(1.5, 1.5, 1.5) * r1.xzw);
    r0.w = saturate(r0.w * abs(r1.y));
    r1.xyz = r1.xzw + -r0.xyz;
    r0.xyz = r0.www * r1.xyz + r0.xyz;
    r0.w = 0.100000001 + cb2[0].z;
    r1.x = floor(r0.w);
    r1.x = 0.25 * r1.x;
    r0.w = 0.25 * r0.w;
    r1.y = floor(r0.w);
    r1.xy = v0.zw * float2(0.25, 1) + r1.xy;
    r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
    r0.w = (int) cb2[0].w;
    x0[0].xyz = float3(0, 0, 0);
    x0[1].xyz = float3(0.686200023, 0.423500001, 0.0901999995);
    x0[2].xyz = float3(0.160799995, 0.0666999966, 0.0234999992);
    x0[3].xyz = float3(0.411799997, 0.674499989, 0.223499998);
    x0[4].xyz = float3(0.180399999, 0.41170001, 0.176499993);
    x0[5].xyz = float3(0.905900002, 0.415600002, 0);
    x0[6].xyz = float3(1, 0.713699996, 0.176499993);
    x0[7].xyz = float3(0.149000004, 0.5255, 0.858799994);
    x0[8].xyz = float3(0.68629998, 0.074500002, 0.074500002);
    x0[9].xyz = float3(0.945100009, 0.231399998, 0.0392000005);
    x0[10].xyz = float3(0.537199974, 0.533299983, 0.407799989);
    x0[11].xyz = float3(0.443100005, 0.835300028, 0.705900013);
    x0[12].xyz = float3(0.67839998, 0.0469999984, 0.356900007);
    r2.xyz = x0[r0.w + 0].xyz;
    r3.xyzw = t2.Sample(s0_s, v0.zw).wxyz;
    r3.x = saturate(r3.x);
    r0.w = cmp(cb2[0].w < 0.00999999978);
    r0.w = r0.w ? 0 : 1;
    r0.w = r3.x * r0.w;
    r4.xyz = float3(0.0500000007, 0.0500000007, 0.0500000007) + -r0.xyz;
    r0.xyz = r1.www * r4.xyz + r0.xyz;
    r4.xyz = r3.zzz * r2.xyz;
    r2.xyz = r4.xyz * float3(-0.75, -0.75, -0.75) + r2.xyz;
    r2.xyz = r2.xyz + -r0.xyz;
    albedo_translucency.xyz = r0.www * r2.xyz + r0.xyz;
    r2.xyzw = t3.Sample(s0_s, v0.xy).xyzw;
    r0.xyz = float3(-0.5, -0.5, -0.5) + r2.xyz;
    r0.xyz = r0.xyz + r0.xyz;
    r1.xyz = float3(-0.5, -0.5, -0.5) + r1.xyz;
    r2.x = cb4[2].x;
    r2.z = 2;
    r1.xyz = r2.xxz * r1.xyz;
    r2.xyz = float3(-0.5, -0.5, -0.5) + r3.yzw;
    r3.x = dot(r0.zzx, r1.xxz);
    r3.y = dot(r0.zzy, r1.yyz);
    r3.z = r1.z * r0.z;
    r0.x = dot(r3.xyz, r3.xyz);
    r0.x = rsqrt(r0.x);
    r0.xyz = r3.xyz * r0.xxx;
    r1.xyz = r2.xyz * float3(2, 2, 2) + -r0.xyz;
    r0.xyz = r0.www * r1.xyz + r0.xyz;
    r1.xyz = v1.xyz * r0.yyy;
    r1.xyz = v3.xyz * r0.xxx + r1.xyz;
    r0.xyz = v2.xyz * r0.zzz + r1.xyz;
    r1.x = cmp(0 >= (uint) v4.x);
    if (r1.x != 0)
    {
        r1.x = dot(v2.xyz, r0.xyz);
        r1.xyz = v2.xyz * r1.xxx;
        r0.xyz = -r1.xyz * float3(2, 2, 2) + r0.xyz;
    }
    r1.x = 0.600000024 + -r2.w;
    r1.x = r1.w * r1.x + r2.w;
    r1.y = 0.25 + -r1.x;
    r1.x = r0.w * r1.y + r1.x;
    r1.y = 1 + -r1.x;
    r1.z = 0.5 + -r1.y;
    r0.w = r0.w * r1.z + r1.y;
    r1.yzw = log2(cb4[3].xyz);
    r1.yzw = float3(2.20000005, 2.20000005, 2.20000005) * r1.yzw;
    r1.yzw = exp2(r1.yzw);
    r0.w = r0.w * cb4[4].x + cb4[5].x;
    r1.yzw = saturate(r1.yzw * r0.www);
    r1.yzw = log2(r1.yzw);
    r1.yzw = float3(0.454544991, 0.454544991, 0.454544991) * r1.yzw;
    o2.xyz = exp2(r1.yzw);
    r0.w = dot(r0.xyz, r0.xyz);
    r0.w = rsqrt(r0.w);
    r0.xyz = r0.xyz * r0.www;

    float3 normal = r0.xyz;

    r0.w = max(abs(r0.x), abs(r0.y));
    r0.w = max(abs(r0.z), r0.w);
    r1.yz = cmp(abs(r0.zy) < r0.ww);
    r1.zw = r1.zz ? abs(r0.zy) : abs(r0.zx);
    r1.yz = r1.yy ? r1.zw : abs(r0.yx);
    r1.w = cmp(r1.z < r1.y);
    r2.xy = r1.ww ? r1.yz : r1.zy;
    r2.z = r2.y / r2.x;
    r0.xyz = r0.xyz / r0.www;
    r0.w = t13.SampleLevel(s13_s, r2.xz, 0).x;
    r0.xyz = r0.xyz * r0.www;
    normal_roughness.xyz = r0.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
    albedo_translucency.w = cb4[6].x;
    normal_roughness.w = r1.x;
    o2.w = 0;

    float roughness = normal_roughness.w;
    normal_roughness.w = FilterNDF(normal, roughness);
}