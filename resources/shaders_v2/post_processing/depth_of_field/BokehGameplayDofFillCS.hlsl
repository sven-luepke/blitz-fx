#include "GameData.hlsli"
#include "Common.hlsli"
#include "CustomData.hlsli"

// octaweb kernel
#define DOF_SAMPLE_COUNT 9
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

    float2 center_tex_coord = ThreadIdToTexCoord(thread_id.xy, screenDimensions.zw * 2);

    float aspect_ratio = screenDimensions.y * screenDimensions.z;
    float intensity = enable_custom_gameplay_dof_params ? gameplay_dof_intensity : min(1, dof_intensity * gameplay_dof_intensity_scale);
    float blur_scale = coc * intensity * 0.01;
    float3 max_color = 0;
    for (int i = 0; i < DOF_SAMPLE_COUNT; i++)
    {
        float2 offset = disc_kernel[i].xy * blur_scale;
        offset.x *= aspect_ratio;
        float2 tex_coord = center_tex_coord + offset;
        float4 dof_sample = half_res_color_coc_texture.SampleLevel(_linear_sampler, tex_coord, 0);

        if (dof_sample.a == 0)
        {
            continue;
        }
        float3 normalized_color = dof_sample.rgb / dof_sample.a;
        max_color = max(max_color, normalized_color);
    }

    float center_coc = half_res_color_coc_texture.Load(int3(thread_id.xy, 0)).a;

    // premultiply
    output[thread_id.xy] = float4(max_color.rgb * center_coc, center_coc);
}