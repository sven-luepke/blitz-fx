#include "TonemapCommon.hlsli"
#include "CustomData.hlsli"
#include "GBuffer.hlsli"


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

Texture2D<float3> hdr_scene : register(t0);
Texture2D<float> average_luminance : register(t1);

float4 PSMain(float4 sv_position : SV_Position) : SV_Target0
{
    float avgLuminance = average_luminance.Load(int3(0, 0, 0));

    float2 uv = SvPositionToTexCoord(sv_position);

    float exposure = GetExposure(avgLuminance, cb3_v4.y, cb3_v4.z, cb3_v16.x, cb3_v16.z);
    exposure *= GetVignetteExposureScale(uv);

    float3 hdr_color = hdr_scene.Load(uint3(sv_position.xy, 0));

    // http://filmicworlds.com/blog/minimal-color-grading-tools/
    hdr_color *= hdr_color_filter; // TODO: bind color filter to env params
    float eps = 0.00001;
    hdr_color = EvalLogContrastFunc(hdr_color, eps, log2(avgLuminance + eps), hdr_contrast);

    float3 color = ApplyTonemap(shoulder_strength, linear_strength, linear_angle, toe_strength, toe_numerator,
         toe_denominator, exposure * hdr_color, cb3_v16.y);

    //color.b = 0;
    //color.rg = _g_buffer_velocity.Load(int3(sv_position.xy, 0));
    //if (color.r == 1 && color.g == 1)
    //{
    //    color = 0;
    //}
    //color *= 200;

    return float4(saturate(color), 1);
}
