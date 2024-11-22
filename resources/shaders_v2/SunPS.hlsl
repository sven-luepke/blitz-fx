#include "GameData.hlsli"
#include "Common.hlsli"
#include "CustomData.hlsli"
#include "ShadowCommon.hlsli"

cbuffer cb4 : register(b4)
{
    float4 cb4[1];
}
cbuffer cb2 : register(b2)
{
    float4 cb2[3];
}
cbuffer cb1 : register(b1)
{
    float4 cb1[9];
}
cbuffer cb0 : register(b0)
{
    float4 cb0[11];
}
cbuffer cb12 : register(b12)
{
    float4 cb12[269];
}

cbuffer _SunGeometryData
{
    float sun_scale_0;
    float _unknown_0;
    float _unknown_1;
    float sun_position_x;

    float _unknown_2;
    float sun_scale_1;
    float _unknown_3;
    float sun_position_y;

    float _unknown_4;
    float _unknown_5;
    float sun_scale_2;
    float sun_position_z;
}

Texture2DArray<float> cloud_shadow_map : register(t14);
SamplerState _linear_wrap_sampler;

void PSMain(
  float4 v0 : TEXCOORD0,
  float3 world_position : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
    float4 r0, r1, r2, r3;
 
    r0.xyz = cb1[8].xyz + -world_position.xyz;
    r0.w = dot(r0.xyz, r0.xyz);
    r0.w = rsqrt(r0.w);
    r1.xyz = r0.xyz * r0.www;
    r0.x = r0.z * r0.w + 1.03999996;
    r0.y = r0.x * r0.x;
    r0.x = r0.x * r0.y;
    r0.y = r0.y * r0.y;
    r0.z = dot(v0.xyz, v0.xyz);
    r0.z = rsqrt(r0.z);
    r2.xyz = v0.xyz * r0.zzz;
    r0.z = dot(r1.xyz, r2.xyz);

    r0.z = -0.6 + r0.z;
    //r0.z = -0.5 + r0.z;

    r0.z = saturate(r0.z + r0.z);
    r0.x = -r0.x * r0.y + 1;

    float horizon_attenuation = r0.x;// * pow(r0.z, 0.1);
    horizon_attenuation = pow(horizon_attenuation, 2.2);

    r0.x = r0.x * r0.z;
    r0.y = dot(cb0[10].xyz, cb0[10].xyz);
    r0.y = rsqrt(r0.y);
    r0.yzw = cb0[10].xyz * r0.yyy;
    r1.x = saturate(cb4[0].x);
    r1.x = dot(cb0[10].xyz, r1.xxx);
    r0.yzw = r0.yzw / r1.xxx;
    r0.yzw = cb0[10].xyz * r0.yzw;
    r0.xyz = r0.xxx * r0.yzw;
    r0.xyz = cb2[0].xyz * r0.xyz;

    float sun_radius = enable_custom_sun_radius ? custom_sun_radius : sun_scale_0;

    float3 sun_position = float3(sun_position_x, sun_position_y, sun_position_z);
    float sun_distance = distance(cameraPosition.xyz, sun_position);

    // formula from https://math.stackexchange.com/questions/73238/calculating-solid-angle-for-a-sphere-in-space
    float solid_angle = PI_2 * (1 - sqrt(Square(sun_distance) - Square(sun_radius)) / sun_distance);

    r0.xyz = directional_light_color.xyz / solid_angle;
    r0.xyz *= horizon_attenuation;

    // TODO: attenuate based on cloud coverage

    r1.xyz = -cb12[0].xyz + world_position.xyz;
    r0.w = dot(r1.xyz, r1.xyz);
    r0.w = sqrt(r0.w);
    r1.w = -cb12[22].z + r0.w;
    r1.w = max(0, r1.w);
    r1.w = min(cb12[42].z, r1.w);
    if (r1.w >= cb12[48].y)
    {
        r1.xyz = r1.xyz / r0.www;
        r0.w = r1.z * cb12[22].z + cb12[0].z;
        r2.x = r1.z * r1.w;
        r2.y = cb12[43].x * r1.w;
        r2.xy = float2(0.0625, 0.0625) * r2.xy;
        r1.x = dot(cb12[38].xyz, r1.xyz);
        r1.x = cb12[42].x + r1.x;
        r1.y = 1 + cb12[42].x;
        r1.x = saturate(r1.x / r1.y);
        r1.y = cb12[43].y + -cb12[43].z;
        r1.x = r1.x * r1.y + cb12[43].z;
        r0.w = cb12[42].y + r0.w;
        r1.y = r0.w * r1.x;
        r1.z = r2.x * r1.x;
        r3.xyzw = r1.zzzz * float4(16, 15, 14, 13) + r1.yyyy;
        r3.xyzw = max(float4(0, 0, 0, 0), r3.xyzw);
        r3.xyzw = float4(1, 1, 1, 1) + r3.xyzw;
        r3.xyzw = saturate(r2.yyyy / r3.xyzw);
        r3.xyzw = float4(1, 1, 1, 1) + -r3.xyzw;
        r2.x = r3.x * r3.y;
        r2.x = r2.x * r3.z;
        r2.x = r2.x * r3.w;
        r3.xyzw = r1.zzzz * float4(12, 11, 10, 9) + r1.yyyy;
        r3.xyzw = max(float4(0, 0, 0, 0), r3.xyzw);
        r3.xyzw = float4(1, 1, 1, 1) + r3.xyzw;
        r3.xyzw = saturate(r2.yyyy / r3.xyzw);
        r3.xyzw = float4(1, 1, 1, 1) + -r3.xyzw;
        r2.x = r3.x * r2.x;
        r2.x = r2.x * r3.y;
        r2.x = r2.x * r3.z;
        r2.x = r2.x * r3.w;
        r3.xyzw = r1.zzzz * float4(8, 7, 6, 5) + r1.yyyy;
        r3.xyzw = max(float4(0, 0, 0, 0), r3.xyzw);
        r3.xyzw = float4(1, 1, 1, 1) + r3.xyzw;
        r3.xyzw = saturate(r2.yyyy / r3.xyzw);
        r3.xyzw = float4(1, 1, 1, 1) + -r3.xyzw;
        r2.x = r3.x * r2.x;
        r2.x = r2.x * r3.y;
        r2.x = r2.x * r3.z;
        r2.x = r2.x * r3.w;
        r2.zw = r1.zz * float2(4, 3) + r1.yy;
        r2.zw = max(float2(0, 0), r2.zw);
        r2.zw = float2(1, 1) + r2.zw;
        r2.zw = saturate(r2.yy / r2.zw);
        r2.zw = float2(1, 1) + -r2.zw;
        r2.x = r2.x * r2.z;
        r2.x = r2.x * r2.w;
        r1.y = r1.z * 2 + r1.y;
        r1.y = max(0, r1.y);
        r1.y = 1 + r1.y;
        r1.y = saturate(r2.y / r1.y);
        r1.y = 1 + -r1.y;
        r1.y = r2.x * r1.y;
        r0.w = r0.w * r1.x + r1.z;
        r0.w = max(0, r0.w);
        r0.w = 1 + r0.w;
        r0.w = saturate(r2.y / r0.w);
        r0.w = 1 + -r0.w;
        r0.w = -r1.y * r0.w + 1;
        r1.x = -cb12[48].y + r1.w;
        r1.x = saturate(cb12[48].z * r1.x);
    }
    else
    {
        r0.w = 1;
        r1.x = 0;
    }
    r0.w = log2(r0.w);
    r0.w = cb12[42].w * r0.w;
    r0.w = exp2(r0.w);
    r0.w = r1.x * r0.w;
    r1.x = saturate(r0.w * cb12[189].z + cb12[189].w);
    r1.y = -1 + cb12[188].w;
    r1.x = r1.x * r1.y + 1;
    r1.x = saturate(r1.x * r0.w);
    if (0 < cb12[192].x)
    {
        r1.y = saturate(r0.w * cb12[191].z + cb12[191].w);
        r1.z = -1 + cb12[190].w;
        r1.y = r1.y * r1.z + 1;
        r0.w = saturate(r1.y * r0.w);
        r0.w = r0.w + -r1.x;
        r1.x = cb12[192].x * r0.w + r1.x;
    }
    r0.w = 1 + -r1.x;
    r0.xyz = r0.xyz * r0.www;
    r0.xyz = max(float3(0, 0, 0), r0.xyz);
    //r0.xyz = log2(r0.xyz);
   // r0.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r0.xyz;
   // r0.xyz = exp2(r0.xyz);
    //r0.xyz = cb2[2].xyz * r0.xyz;
   // o0.xyz = cb2[2].www * r0.xyz;

    // added code
    o0.xyz = r0.xyz;

    CloudShadowArgs args;
    args.world_position = world_position.xyz;
    args.shadow_map = cloud_shadow_map;
    args.shadow_sampler = _linear_wrap_sampler;
    o0.rgb *= ComputeCloudShadow(args);

    o0.w = 0;
    return;   
}