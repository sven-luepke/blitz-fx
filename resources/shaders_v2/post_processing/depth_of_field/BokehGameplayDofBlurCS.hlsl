#include "GameData.hlsli"
#include "Common.hlsli"
#include "CustomData.hlsli"

// octaweb kernel
#define DOF_SAMPLE_COUNT 49
static const float3 disc_kernel[DOF_SAMPLE_COUNT] =
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
    float3(0.666667, 0, 2),
    float3(0.61592, 0.255122, 2),
    float3(0.471404, 0.471405, 2),
    float3(0.255122, 0.61592, 2),
    float3(0, 0.666667, 2),
    float3(-0.255122, 0.61592, 2),
    float3(-0.471405, 0.471404, 2),
    float3(-0.61592, 0.255122, 2),
    float3(-0.666667, 0, 2),
    float3(-0.61592, -0.255123, 2),
    float3(-0.471404, -0.471405, 2),
    float3(-0.255122, -0.61592, 2),
    float3(0, -0.666667, 2),
    float3(0.255123, -0.61592, 2),
    float3(0.471405, -0.471404, 2),
    float3(0.61592, -0.255122, 2),
    float3(1, 0, 3),
    float3(0.965926, 0.258819, 3),
    float3(0.866025, 0.5, 3),
    float3(0.707107, 0.707107, 3),
    float3(0.5, 0.866025, 3),
    float3(0.258819, 0.965926, 3),
    float3(0, 1, 3),
    float3(-0.258819, 0.965926, 3),
    float3(-0.5, 0.866025, 3),
    float3(-0.707107, 0.707107, 3),
    float3(-0.866026, 0.5, 3),
    float3(-0.965926, 0.258819, 3),
    float3(-1, 0, 3),
    float3(-0.965926, -0.258819, 3),
    float3(-0.866025, -0.5, 3),
    float3(-0.707106, -0.707107, 3),
    float3(-0.5, -0.866026, 3),
    float3(-0.258819, -0.965926, 3),
    float3(0, -1, 3),
    float3(0.25882, -0.965926, 3),
    float3(0.5, -0.866025, 3),
    float3(0.707107, -0.707106, 3),
    float3(0.866026, -0.499999, 3),
    float3(0.965926, -0.258818, 3)
};

cbuffer cb3 : register(b3)
{
    float dof_far_focus_distance;
    float dof_far_blur_distance;
    float dof_intensity;
}

SamplerState _linear_sampler;

Texture2D<float4> half_res_color_coc_texture : register(t50);
Texture2D<float> half_res_min_coc_texture : register(t51);

RWTexture2D<float4> output : register(u0);

[numthreads(8, 8, 1)]
void CSMain(uint3 thread_id : SV_DispatchThreadID)
{
    float coc = half_res_min_coc_texture.Load(int3(thread_id.xy, 0));
    [branch]
    if (coc == 0)
    {
        output[thread_id.xy] = 0;
        return;
    }

    float4 accumulated_color_coc = 0;
    float2 center_tex_coord = ThreadIdToTexCoord(thread_id.xy, screenDimensions.zw * 2);

    float aspect_ratio = screenDimensions.y * screenDimensions.z;
    float intensity = enable_custom_gameplay_dof_params ? gameplay_dof_intensity : min(1, dof_intensity * gameplay_dof_intensity_scale);
    float blur_scale = coc * intensity * 0.01;
    for (int i = 0; i < DOF_SAMPLE_COUNT; i++)
    {
        float2 offset = disc_kernel[i].xy * blur_scale;
        offset.x *= aspect_ratio;
        float2 tex_coord = center_tex_coord + offset;
        float4 dof_sample = half_res_color_coc_texture.SampleLevel(_linear_sampler, tex_coord, 0);
        accumulated_color_coc.rgb += dof_sample * dof_sample.a;
        accumulated_color_coc.a += dof_sample.a * dof_sample.a;
    }

    if (accumulated_color_coc.a > 0.001)
    {
        accumulated_color_coc.rgb /= accumulated_color_coc.a;
    }
    else
    {
        accumulated_color_coc.rgb = 0;
    }

    float center_coc = half_res_color_coc_texture.Load(int3(thread_id.xy, 0)).a;

    // premultiply
    output[thread_id.xy] = float4(accumulated_color_coc.rgb * center_coc, center_coc);
}