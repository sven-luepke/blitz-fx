#include "Common.hlsli"
#include "TonemapCommon.hlsli"

Texture2D<float3> color_buffer : register(t0);
Texture2D<float> avg_luma_texture : register(t1);

RWTexture2D<float> output : register(u0);
RWTexture2D<float> out_exposure_texture : register(u1);

cbuffer cBuffer : register(b3)
{
float4 cb3_v0;
float4 cb3_v1;
float4 cb3_v2;
float4 cb3_v3;
float4 cb3_v4;
float4 cb3_v5;
float4 cb3_v6;

float shoulder_strength;
float linear_strength;
float linear_angle;
float _pad_0;

float toe_strength;
float toe_numerator;
float toe_denominator;
float _pad_1;

float4 cb3_v9;
float4 cb3_v10;
float4 cb3_v11;
float4 cb3_v12;
float4 cb3_v13;
float4 cb3_v14;
float4 cb3_v15;
float4 cb3_v16, cb3_v17;
}

[numthreads(8, 8, 1)]
void CSMain(uint3 thread_id : SV_DispatchThreadID)
{
    float avg_luma = avg_luma_texture.Load(int3(0, 0, 0));
    float exposure = GetExposure(avg_luma, cb3_v4.y, cb3_v4.z, cb3_v16.x, cb3_v16.z);

    float3 color = color_buffer.Load(int3(thread_id.xy, 0));

    float3 color_tonemapped = ApplyTonemap(shoulder_strength, linear_strength, linear_angle, toe_strength, toe_numerator,
                                           toe_denominator, exposure * color, cb3_v16.y);

    float luma = Luminance(color_tonemapped);
    output[thread_id.xy] = saturate(luma);

    if (thread_id.x == 0 && thread_id.y == 0)
    {
        out_exposure_texture[int2(0, 0)] = exposure;
    }
}
