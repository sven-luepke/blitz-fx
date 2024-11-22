#include "GBuffer.hlsli"

Texture2D<float4> t18 : register(t18);
Texture2D<float4> t13 : register(t13);
Texture2D<float4> t12 : register(t12);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);

SamplerState s13_s : register(s13);
SamplerState s12_s : register(s12);
SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
    float4 cb2[19];
}

#define cmp -


void PSMain(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float4 v3 : TEXCOORD3,
  float4 v4 : TEXCOORD4,
  float4 v5 : SV_Position0,
  uint v6 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0,
  out float4 specular_mask : SV_Target1)
{
    float4 r0, r1, r2;

    r0.x = t0.Sample(s0_s, v2.xy).w;
    r0.x = -0.330000013 + r0.x;
    r0.x = cmp(r0.x < 0);
    if (r0.x != 0)
        discard;
    r0.xyz = cmp(cb2[18].yzw != float3(0, 0, 0));
    if (r0.x != 0)
    {
        r1.xyzw = float4(16, 16, 16, 16) * v5.xyxy;
        r1.xyzw = cmp(r1.xyzw >= -r1.zwzw);
        r1.xyzw = r1.xyzw ? float4(16, 16, 0.0625, 0.0625) : float4(-16, -16, -0.0625, -0.0625);
        r0.xw = v5.xy * r1.zw;
        r0.xw = frac(r0.xw);
        r0.xw = r1.xy * r0.xw;
        r1.xy = (int2) r0.xw;
        r1.zw = float2(0, 0);
        r0.x = t18.Load(r1.xyz).x;
        r0.x = r0.x * v1.x + v1.y;
        r0.x = cmp(r0.x < 0);
        if (r0.x != 0)
            discard;
    }
    if (r0.y != 0)
    {
        r0.x = t12.Sample(s12_s, v2.zw).x;
        r0.x = r0.x * v1.z + v1.w;
        r0.x = cmp(r0.x < 0);
        if (r0.x != 0)
            discard;
    }
    if (r0.z != 0)
    {
        r0.x = dot(v0.xyz, v0.xyz);
        r0.x = -1 + r0.x;
        r0.x = cmp(r0.x < 0);
        if (r0.x != 0)
            discard;
    }
    r0.xyz = t1.Sample(s0_s, v2.xy).xyz;
    r0.xyz = float3(-0.5, -0.5, -0.5) + r0.xyz;
    r0.xyz = r0.xyz + r0.xyz;
    r1.x = v0.w;
    r1.y = v3.w;
    r1.z = v4.w;
    r2.xyz = v3.xyz * r0.yyy;
    r0.xyw = r1.xyz * r0.xxx + r2.xyz;
    r0.xyz = v4.xyz * r0.zzz + r0.xyw;
    r0.w = cmp(0 >= (uint) v6.x);
    if (r0.w != 0)
    {
        r0.w = dot(v4.xyz, r0.xyz);
        r1.xyz = v4.xyz * r0.www;
        r0.xyz = -r1.xyz * float3(2, 2, 2) + r0.xyz;
    }
    r0.w = dot(r0.xyz, r0.xyz);
    r0.w = rsqrt(r0.w);
    r0.xyz = r0.xyz * r0.www;
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
    o0.xyz = r0.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
    o0.w = 0.5;
    specular_mask.xyzw = float4(0, 0, 0, 0);

    specular_mask.w = G_BUFFER_OBJECT_MASK_HAIR / 255.0f;
}