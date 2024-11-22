#include "Common.hlsli"
#include "GameData.hlsli"
#include "CustomData.hlsli"
#include "ShadowCommon.hlsli"

TextureCube<float4> t1 : register(t1);
TextureCube<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{   
    float4 cb1[9];
}

cbuffer cb0 : register(b0)
{
    float4 cb0[10];
}

cbuffer cb12 : register(b12)
{
    float4 cb12[269];
}

Texture2DArray<float> cloud_shadow_map : register(t14);
SamplerState _linear_wrap_sampler;

#define cmp -

void PSMain(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : SV_Position0,
  out float4 o0 : SV_Target0)
{
    float3 world_position = float3(v0.zw, v1.w);

    float3 direction = normalize(world_position.xyz - cameraPosition.xyz);

    float dot_product = saturate(dot(normalize(cb12[203].yzw), direction));;
    float angle = PI_2 * (1 - cos(acos(dot_product) * 2)) * 2;

    float sun_radius = enable_custom_sun_radius ? custom_sun_radius : 10;
    float sun_distance = 100;
    // formula from https://math.stackexchange.com/questions/73238/calculating-solid-angle-for-a-sphere-in-space
    float solid_angle = PI_2 * (1 - sqrt(Square(sun_distance) - Square(sun_radius)) / sun_distance);

    if (angle > solid_angle)
    {
        discard;
    }

    float3 sun_color = directional_light_color.xyz / solid_angle;
    o0.rgb = sun_color;

    CloudShadowArgs args;
    args.world_position = world_position.xyz;
    args.shadow_map = cloud_shadow_map;
    args.shadow_sampler = _linear_wrap_sampler;
    o0.rgb *= ComputeCloudShadow(args);

    return;
}