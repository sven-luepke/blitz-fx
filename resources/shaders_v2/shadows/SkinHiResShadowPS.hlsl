#include "ShadowCommon.hlsli"
#include "Noise.hlsli"

Texture2D<float4> t11 : register(t11);

SamplerComparisonState s9_s : register(s9);

cbuffer cb3 : register(b3)
{
    float4 cb3[24];
}



void PSMain(
  float3 v0 : TEXCOORD0,
  float4 sv_position : SV_Position0,
  out float4 o0 : SV_Target0)
{
    float4 r0, r1, r2;

    r0.xyz = v0.xyz;
    r0.w = 1;
    r1.x = dot(r0.xyzw, cb3[21].xyzw);
    r1.y = dot(r0.xyzw, cb3[22].xyzw);
    r0.x = dot(r0.xyzw, cb3[23].xyzw);
    r0.x = -cb3[20].y + r0.x;

    r1.xyzw = r1.xyxy * float4(0.5, -0.5, 0.5, -0.5) + float4(0.5, 0.5, 0.5, 0.5);

    float2 shadow_tex_coord = r1.xy;
    const int shadow_sample_count = 16;
    const float rcp_sample_count = 1.0f / shadow_sample_count;
    float noise = GetStaticBlueNoise(sv_position.xy);
    float filter_radius = cb3[20].x;
    float shadow_map_depth = r0.x;
    float shadow_factor = 0;
    [unroll]
    for (int i = 0; i < shadow_sample_count; i++)
    {
        float2 sample_offset = VogelDiskSample(i, rcp_sample_count, noise, filter_radius);
        float2 offset_tex_coord = shadow_tex_coord + sample_offset;

        shadow_factor += t11.SampleCmpLevelZero(s9_s, offset_tex_coord, shadow_map_depth);
    }
    shadow_factor *= rcp_sample_count;
    o0.xyzw = shadow_factor;
    return;


    r2.xyzw = cb3[20].xxxx * float4(-0.507720828, -0.617089927, -0.0515490212, -0.750809789) + r1.zwzw;
    r0.y = t11.SampleCmpLevelZero(s9_s, r2.xy, r0.x).x;
    r0.z = t11.SampleCmpLevelZero(s9_s, r2.zw, r0.x).x;
    r0.y = r0.y + r0.z;
    r2.xyzw = cb3[20].xxxx * float4(-0.764104187, 0.200915202, 0.00728477398, -0.205946997) + r1.zwzw;
    r0.z = t11.SampleCmpLevelZero(s9_s, r2.xy, r0.x).x;
    r0.w = t11.SampleCmpLevelZero(s9_s, r2.zw, r0.x).x;
    r0.y = r0.y + r0.z;
    r0.y = r0.y + r0.w;
    r2.xyzw = cb3[20].xxxx * float4(-0.366203994, 0.732379675, -0.923958182, -0.255964309) + r1.zwzw;
    r0.z = t11.SampleCmpLevelZero(s9_s, r2.xy, r0.x).x;
    r0.w = t11.SampleCmpLevelZero(s9_s, r2.zw, r0.x).x;
    r0.y = r0.y + r0.z;
    r0.y = r0.y + r0.w;
    r2.xyzw = cb3[20].xxxx * float4(-0.286924005, 0.278052986, 0.772301197, 0.157332897) + r1.zwzw;
    r0.z = t11.SampleCmpLevelZero(s9_s, r2.xy, r0.x).x;
    r0.w = t11.SampleCmpLevelZero(s9_s, r2.zw, r0.x).x;
    r0.y = r0.y + r0.z;
    r0.y = r0.y + r0.w;
    r2.xyzw = cb3[20].xxxx * float4(0.378513008, 0.405219913, 0.463021696, -0.691461921) + r1.zwzw;
    r1.xyzw = cb3[20].xxxx * float4(0.423523009, 0.86302799, 0.855864286, -0.338255405) + r1.xyzw;
    r0.z = t11.SampleCmpLevelZero(s9_s, r2.xy, r0.x).x;
    r0.w = t11.SampleCmpLevelZero(s9_s, r2.zw, r0.x).x;
    r0.y = r0.y + r0.z;
    r0.y = r0.y + r0.w;
    r0.z = t11.SampleCmpLevelZero(s9_s, r1.xy, r0.x).x;
    r0.x = t11.SampleCmpLevelZero(s9_s, r1.zw, r0.x).x;
    r0.y = r0.y + r0.z;
    r0.x = r0.y + r0.x;
    r0.x = 0.0833333358 * r0.x;

    o0.xyzw = r0.x;
}