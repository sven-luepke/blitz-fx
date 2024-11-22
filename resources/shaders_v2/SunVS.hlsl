#include "CustomData.hlsli"

cbuffer cb2 : register(b2)
{
    float4 cb2[6];
}

cbuffer cb1 : register(b1)
{
    float4 cb1[4];
}

void VSMain(
  float3 v0 : POSITION0,
  float2 v1 : TEXCOORD0,
  float3 v2 : NORMAL0,
  float4 v3 : TANGENT0,
  out float4 o0 : TEXCOORD0,
  out float3 o1 : TEXCOORD1,
  out float4 o2 : SV_Position0)
{
    float4 r0, r1;

    r0.xyz = v2.xyz * float3(2, 2, 2) + float3(-1, -1, -1);

    float4 cb2_0 = cb2[0];
    float4 cb2_1 = cb2[1];
    float4 cb2_2 = cb2[2];

    if (enable_custom_sun_radius)
    {
        cb2_0.x = custom_sun_radius;
        cb2_1.y = custom_sun_radius;
        cb2_2.z = custom_sun_radius;
    }

    r1.x = dot(r0.xyz, cb2_0.xyz);
    r1.y = dot(r0.xyz, cb2_1.xyz);
    r1.z = dot(r0.xyz, cb2_2.xyz);
    r0.x = dot(r1.xyz, r1.xyz);
    r0.x = rsqrt(r0.x);
    o0.xyz = r1.xyz * r0.xxx;
    r0.xyz = v0.xyz * cb2[4].xyz + cb2[5].xyz;
    r0.w = 1;
    o1.x = dot(r0.xyzw, cb2_0.xyzw);
    o1.y = dot(r0.xyzw, cb2_1.xyzw);
    o1.z = dot(r0.xyzw, cb2_2.xyzw);
    r1.xyzw = cb2_1.xyzw * cb1[0].yyyy;
    r1.xyzw = cb2_0.xyzw * cb1[0].xxxx + r1.xyzw;
    r1.xyzw = cb2_2.xyzw * cb1[0].zzzz + r1.xyzw;
    r1.xyzw = cb1[0].wwww * float4(0, 0, 0, 1) + r1.xyzw;
    o2.x = dot(r0.xyzw, r1.xyzw);
    r1.xyzw = cb2_1.xyzw * cb1[1].yyyy;
    r1.xyzw = cb2_0.xyzw * cb1[1].xxxx + r1.xyzw;
    r1.xyzw = cb2_2.xyzw * cb1[1].zzzz + r1.xyzw;
    r1.xyzw = cb1[1].wwww * float4(0, 0, 0, 1) + r1.xyzw;
    o2.y = dot(r0.xyzw, r1.xyzw);
    r1.xyzw = cb2_1.xyzw * cb1[2].yyyy;
    r1.xyzw = cb2_0.xyzw * cb1[2].xxxx + r1.xyzw;
    r1.xyzw = cb2_2.xyzw * cb1[2].zzzz + r1.xyzw;
    r1.xyzw = cb1[2].wwww * float4(0, 0, 0, 1) + r1.xyzw;
    o2.z = dot(r0.xyzw, r1.xyzw);
    r1.xyzw = cb2_1.xyzw * cb1[3].yyyy;
    r1.xyzw = cb2_0.xyzw * cb1[3].xxxx + r1.xyzw;
    r1.xyzw = cb2_2.xyzw * cb1[3].zzzz + r1.xyzw;
    r1.xyzw = cb1[3].wwww * float4(0, 0, 0, 1) + r1.xyzw;
    o2.w = dot(r0.xyzw, r1.xyzw);
    return;
}