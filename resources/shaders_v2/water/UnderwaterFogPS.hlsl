#include "GameData.hlsli"
#include "ScatteringCommon.hlsli"
#define USE_INTERIOR_VOLUME
#define USE_VOLUMETRIC_WATER_CAUSTICS
#include "WaterCommon.hlsli"

cbuffer cb13 : register(b13)
{
    float4 cb13[3323];
}
cbuffer cb12 : register(b12)
{
    float4 cb12[269];
}

Texture2D<float4> t15 : register(t15);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t3 : register(t3);
Texture2D<float2> under_water_mask : register(t2);
Texture2D<float4> t0 : register(t0);

Texture2D<float3> underwater_fog_transmittance_texture : register(t63);
Texture2D<float3> underwater_fog_inscattering_texture : register(t64);

SamplerState s15_s : register(s15);
SamplerState s5_s : register(s5);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s0_s : register(s0);

#define cmp -

Texture2D<float2> _interior_dimmer_texture;

void PSMain(
  float4 sv_position : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
    float4 r0, r1, r2;

    r0.xy = v1.xy / cb0[2].zw;

    r0.xy = under_water_mask.Sample(s2_s, r0.xy).xy;

    float2 mask = r0.xy;

    r0.z = r0.y + r0.x;
    r0.z = cmp(r0.z < 0.00100000005);
    r0.w = saturate(r0.y);
    r0.w = r0.w * r0.w;
    r0.w = r0.w * r0.w;
    r0.w = r0.w * r0.w;
    r1.xy = float2(0.150000006, 0.150000006) * v1.xy;
    r1.xy = cb12[0].xy * float2(0.00200000009, 0.00200000009) + r1.xy;
    r1.z = 0.0250000004 * r0.w;
    r1.xy = r0.ww * float2(0.100000001, 0.100000001) + r1.xy;

    float2 tex_coord = r1.xy;

    r1.xy = t5.Sample(s5_s, r1.xy).xy;    

    r1.xy = r1.xy * r0.xx;
    r2.xy = float2(30, 30) * r1.xy;
    r1.xy = -r1.xy * float2(30, 30) + v1.xy;
    r0.w = t15.Sample(s15_s, r1.xy).x;
    r0.w = r0.w * cb12[22].x + cb12[22].y;
    r0.w = r0.w * cb12[21].x + cb12[21].y;
    r0.w = max(9.99999975e-005, r0.w);
    r0.w = 1 / r0.w;
    r1.x = t3.SampleLevel(s3_s, r1.xy, 0).x;
    r1.x = r1.x * cb12[22].x + cb12[22].y;
    r1.x = r1.x * cb12[21].x + cb12[21].y;
    r1.x = max(9.99999975e-005, r1.x);
    r1.x = 1 / r1.x;
    r0.w = -r1.x + r0.w;
    r0.w = r0.x * r0.w + r1.x;
    r0.w = saturate(0.0500000007 * r0.w);
    r0.w = max(0.200000003, r0.w);
    r1.xy = r2.xy * r0.ww + -r1.zz;
    r1.xy = v1.xy + -r1.xy;

    tex_coord = r1.xy;

    float3 scene_color = t0.SampleLevel(_linear_sampler, tex_coord, 0).rgb;
    [branch]
    if (mask.x + mask.y < 0.001)
    {
        o0.rgb = scene_color;
        return;
    }

    float3 transmittance = underwater_fog_transmittance_texture.SampleLevel(_linear_sampler, tex_coord, 0);
    float3 in_scattering = underwater_fog_inscattering_texture.SampleLevel(_linear_sampler, tex_coord, 0);

    o0.rgb = lerp(scene_color, scene_color * transmittance + in_scattering, Square(mask.x));

    o0.w = 0;
}