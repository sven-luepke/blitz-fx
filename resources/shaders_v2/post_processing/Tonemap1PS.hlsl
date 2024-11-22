#include "TonemapCommon.hlsli"
#include "CustomData.hlsli"

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
    float avg_luminance = average_luminance.Load(int3(0, 0, 0));

    float exposure_0 = GetExposure(avg_luminance, cb3_v9.y, cb3_v9.z, cb3_v17.x, cb3_v17.z);
    float exposure_1 = GetExposure(avg_luminance, cb3_v4.y, cb3_v4.z, cb3_v16.x, cb3_v16.z);

    float2 uv = SvPositionToTexCoord(sv_position);
    float vignette = GetVignetteExposureScale(uv);
    exposure_0 *= vignette;
    exposure_1 *= vignette;

    float3 hdr_color = hdr_scene.Load(uint3(sv_position.xy, 0));

    // TODO: bind color filter to env params
    // http://filmicworlds.com/blog/minimal-color-grading-tools/
    hdr_color *= hdr_color_filter;

    float eps = 0.00001;
    hdr_color = EvalLogContrastFunc(hdr_color, eps, log2(avg_luminance + eps), hdr_contrast);

    float3 color_0 = ApplyTonemap(cb3_v11.x, cb3_v11.y, cb3_v11.z, cb3_v12.x, cb3_v12.y,
         cb3_v12.z, exposure_0 * hdr_color, cb3_v17.y);
    float3 color_1 = ApplyTonemap(shoulder_strength, linear_strength, linear_angle, toe_strength, toe_numerator,
         toe_denominator, exposure_1 * hdr_color, cb3_v16.y);
    float3 color = lerp(color_1, color_0, cb3_v13.x);
    return float4(saturate(color), 1);
}
