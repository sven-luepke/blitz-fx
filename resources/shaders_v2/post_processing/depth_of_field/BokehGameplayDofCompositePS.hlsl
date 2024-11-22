#include "CustomData.hlsli"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb12 : register(b12)
{
    float4 cb12[214];
}

cbuffer cb3 : register(b3)
{
    float dof_far_focus_distance;
    float dof_far_blur_distance;
    float dof_intensity;
}

Texture2D<float4> blurred_color_coc_texture : register(t50);
Texture2D<float> coc_texture : register(t52);

SamplerState _linear_sampler;
SamplerState _point_sampler;

#define UPSCALE_SAMPLE_COUNT 9
static const float3 disc_kernel[UPSCALE_SAMPLE_COUNT] =
{
    float3(0, 0, 0),
    float3(0.333333, 0, 1),
    float3(0.235702, 0.235702, 1),
    float3(0, 0.333333, 1),
    float3(-0.235702, 0.235702, 1),
    float3(-0.333333, 0, 1),
    float3(-0.235702, -0.235702, 1),
    float3(0, -0.333333, 1),
    float3(0.235702, -0.235702, 1),
};

void PSMain(
  float4 sv_position : SV_Position0,
  out float4 o0 : SV_Target0,
  out float sv_depth : SV_Depth)
{
    float2 center_tex_coord = SvPositionToTexCoord(sv_position);

    float full_res_coc = coc_texture.Load(int3(sv_position.xy, 0));

    float aspect_ratio = screenDimensions.y * screenDimensions.z;
    float intensity = enable_custom_gameplay_dof_params ? gameplay_dof_intensity : min(1, dof_intensity * gameplay_dof_intensity_scale);
    float blur_scale = full_res_coc * intensity * 0.005;
    float4 upscaled_color_coc = 0;
    for (int i = 0; i < UPSCALE_SAMPLE_COUNT; i++)
    {
        float2 offset = disc_kernel[i].xy * blur_scale;
        offset.x *= aspect_ratio;
        float2 tex_coord = center_tex_coord + offset;
        float4 dof_sample = blurred_color_coc_texture.SampleLevel(_linear_sampler, tex_coord, 0);
        upscaled_color_coc.rgb += dof_sample * dof_sample.a;
        upscaled_color_coc.a += dof_sample.a * dof_sample.a;
    }

    if (upscaled_color_coc.a > 0.001)
    {
        upscaled_color_coc.rgb /= upscaled_color_coc.a;
    }
    else
    {
        upscaled_color_coc.rgb = 0;
    }

    o0.rgb = upscaled_color_coc;

    o0.a = smoothstep(0.01, 0.2, full_res_coc * intensity);

    // overwrite sv_depth to disable depth culling
    sv_depth = 1.0f;
}