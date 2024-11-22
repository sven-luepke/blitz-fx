#include "Common.hlsli"
#include "CustomData.hlsli"

float3 Uncharted2Tonemap(float A, float B, float C, float D, float E, float F, float3 x)
{
    return ((x * (A * x + C * B) + D * E) / (x * (A * x + B) + D * F)) - E / F;
}

float3 TonemapHable(float A, float B, float C, float D, float E, float F, float3 color)
{
    float3 numerator = Uncharted2Tonemap(A, B, C, D, E, F, color);

    float3 denominator = Uncharted2Tonemap(A, B, C, D, E, F, 11.2);
    denominator = max(denominator, 0.0001);

    return numerator / denominator;
}

float3 HableTonemapWitcher(float A, float B, float C, float D, float E, float F, float3 color, float post_scale)
{
    float3 numerator = Uncharted2Tonemap(A, B, C, D, E, F, color);
    numerator = max(numerator, 0);
    numerator.rgb *= post_scale;
   
    float3 denominator = Uncharted2Tonemap(A, B, C, D, E, F, 11.2);
    denominator = max(denominator, 0.0001);
   
    return numerator / denominator;
}

static const float3 AP1_RGB2Y =
{
    0.2722287168, //AP1_2_XYZ_MAT[0][1],
	0.6740817658, //AP1_2_XYZ_MAT[1][1],
	0.0536895174, //AP1_2_XYZ_MAT[2][1]
};

float3 HableTonemapBlitz(float A, float B, float C, float D, float E, float F, float3 color, float post_scale)
{
    // highlight desaturation based on ACES tonemap
    color = lerp(dot(color, AP1_RGB2Y), color, hdr_saturation);
    return HableTonemapWitcher(A, B, C, D, E, F, color, post_scale);
}

float GetExposure(float avg_luminance, float luminance_limit_min, float luminance_limit_max, float middleGray, float luminance_limit_shape)
{
    avg_luminance = clamp(avg_luminance, luminance_limit_min, luminance_limit_max);
    avg_luminance = max(avg_luminance, 1e-4);
   
    float scaledWhitePoint = middleGray * 11.2;
   
    float luma = avg_luminance / scaledWhitePoint;   

    luma = pow(luma, luminance_limit_shape);
   
    luma = luma * scaledWhitePoint;
    float exposure = middleGray / luma;
    return exposure * exposure_scale;
}

float3 EvalLogContrastFunc(float3 color, float eps, float logMidpoint, float contrast)
{
    // source: http://filmicworlds.com/blog/minimal-color-grading-tools/
    float3 logX = log2(color + eps);
    float3 adjX = logMidpoint + (logX - logMidpoint) * contrast;
    return max(0.0f, exp2(adjX) - eps);
}

float3 ApplyTonemap(float shoulder_strength, float linear_strength, float linear_angle, float toe_strength, float toe_numerator,
         float toe_denominator, float3 color, float post_scale)
{
    [branch]
    if (modify_tonemap)
    {
        color *= post_scale;
        post_scale = 1;
    }

    return HableTonemapBlitz(shoulder_strength, linear_strength, linear_angle, toe_strength, toe_numerator, toe_denominator, color, post_scale);
}

#define VIGNETTE_INTENSITY vignette_intensity
#define VIGNETTE_EXPONENT vignette_exponent
#define VIGNETTE_START_OFFSET vignette_start_offset

float GetVignetteExposureScale(in float2 uv)
{
    [branch]
    if (VIGNETTE_INTENSITY == 0)
    {
        return 1;
    }

    float x = length(uv - float2(0.5, 0.5)) / 0.70710678118;
    x *= 0.98;
    float vignette = pow(max((x - VIGNETTE_START_OFFSET) / (1 - VIGNETTE_START_OFFSET), 0), VIGNETTE_EXPONENT);
    vignette *= VIGNETTE_INTENSITY;
    return max(1 - vignette, 0);
}