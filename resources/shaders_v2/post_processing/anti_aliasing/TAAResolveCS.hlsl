#include "GameData.hlsli"
#include "CustomData.hlsli"
#include "TAACommon.hlsli"

Texture2D<float3> current_color_texture : register(t0);
Texture2D<float3> previous_color_texture : register(t1);

Texture2D<float2> half_res_depth_mask_velocity_texture_0 : register(t4); // frame n (current)
Texture2D<float2> half_res_depth_mask_velocity_texture_1 : register(t5); // frame n - 1
Texture2D<float2> half_res_depth_mask_velocity_texture_2 : register(t6); // frame n - 2

Texture2D<float> luma_texture_0 : register(t10);
Texture2D<float> luma_texture_1 : register(t11);
Texture2D<float> luma_texture_2 : register(t12);
Texture2D<float> luma_texture_3 : register(t13);

Texture2D<float> _responsive_aa_mask;

RWTexture2D<float3> output_texture : register(u0);

#define MOTION_REJECTION_BIAS (screenDimensions.z)
#define MOTION_SENSIVITY 512.0f

#define RESOLVE_OUTER_FILTER_WEIGHT taa_resolve_outer_weight // BlackmanHarris(1.0)
#define RESOVLE_QUINCUNX_FILTER_WEIGHT taa_resolve_quincunx_weight // BlackmanHarris(sqrt(0.5))

float3 SamplePreviousTonemapped(float2 tex_coord, float exposure)
{
    float2 p = tex_coord * screenDimensions.xy + 0.5;
    float2 i = floor(p);
    float2 f = p - i;

    // Fast Smootheststep resampling
    float2 u = max(min((f - 0.2f) / (1 - 0.4f), 1), 0);
    f = u * u * (3 - 2 * u);
    p = i + f;
    p = (p - 0.5) * screenDimensions.zw;
    return TonemapReinhard(previous_color_texture.SampleLevel(_linear_sampler, p, 0), exposure);
}

float3 SampleCurrentTonemapped(float2 tex_coord, float exposure)
{
    return TonemapReinhard(current_color_texture.SampleLevel(_linear_sampler, tex_coord, 0), exposure);
}

float GetLumaSimilarity2x2(float4 lumas_0, float4 lumas_2, float color_weighting_scale)
{
    // for each of the current lumas find the closest match in the previous lumas and the difference
    float4 luma_0_2_min_diff = float4(
        Min4(abs(lumas_0.x - lumas_2)),
        Min4(abs(lumas_0.y - lumas_2)),
        Min4(abs(lumas_0.z - lumas_2)),
        Min4(abs(lumas_0.w - lumas_2))
    );
    // use contrast instead of difference for consistency in bright and dark areas of the image
    float4 luma_0_2_min_contrast = luma_0_2_min_diff / ((lumas_0.x + lumas_0.y + lumas_0.z + lumas_0.w) * 0.25);
    return 1 - min(1, color_weighting_scale * (luma_0_2_min_contrast.x + luma_0_2_min_contrast.y + luma_0_2_min_contrast.z + luma_0_2_min_contrast.w));
}

/*
 * Temporal resolve based on:
 * https://research.activision.com/publications/2020-03/dynamic-temporal-antialiasing-and-upsampling-in-call-of-duty
 * Michal Drobot, "Hybrid Reconstruction Antialiasing", GPU Pro 6
 */
[numthreads(8, 8, 1)]
void CSMain(uint3 thread_id : SV_DispatchThreadID)
{
    float2 tex_coord = ThreadIdToTexCoord(thread_id.xy, screenDimensions.zw);
    float4 depth_mask_velocity_0 = GetNearestVelocityDepth(half_res_depth_mask_velocity_texture_0, tex_coord);
    float depth_0 = depth_mask_velocity_0.x;
    float mask_0 = depth_mask_velocity_0.y;
    float2 velocity_0 = depth_mask_velocity_0.zw;
    float2 history_tex_coord_1 = tex_coord + velocity_0.xy;

    float4 depth_mask_velocity_1 = GetNearestVelocityDepth(half_res_depth_mask_velocity_texture_1, history_tex_coord_1);
    float depth_1 = depth_mask_velocity_1.x;
    float mask_1 = depth_mask_velocity_1.y;
    float2 velocity_1 = depth_mask_velocity_1.zw;
    float2 history_tex_coord_2 = history_tex_coord_1 + velocity_1.xy;

    float previous_sample_weight = 1;
    [flatten]
    if (any(history_tex_coord_1 <= 0 || history_tex_coord_1 >= 1) || mask_0 != mask_1 || is_camera_cut)
    {
        previous_sample_weight = 0;
    }

    bool is_character = mask_0 != 0;
    float color_weighting_scale = is_character ? 6 : 0.5;

    // color weighting comparing frame n and n-2
    float4 lumas_0 = luma_texture_0.GatherRed(_linear_sampler, tex_coord);
    float4 lumas_2 = luma_texture_2.GatherRed(_linear_sampler, history_tex_coord_2);
    float color_coherency_0 = GetLumaSimilarity2x2(lumas_0, lumas_2, color_weighting_scale);

    // color weighting comparing frame n-1 and n-3
    float4 lumas_1 = luma_texture_1.GatherRed(_linear_sampler, history_tex_coord_1);
    float4 depth_mask_velocity_2 = GetNearestVelocityDepth(half_res_depth_mask_velocity_texture_2, history_tex_coord_2);
    float2 velocity_2 = depth_mask_velocity_2.zw;
    float2 history_tex_coord_3 = history_tex_coord_2 + velocity_2.xy;
    float4 lumas_3 = luma_texture_3.GatherRed(_linear_sampler, history_tex_coord_3);
    float color_coherency_1 = GetLumaSimilarity2x2(lumas_1, lumas_3, color_weighting_scale);

    // velocity weighting
    float motion_delta = length(velocity_0.xy - velocity_1.xy);
    float motion_decoherency = saturate(MOTION_SENSIVITY * (motion_delta - MOTION_REJECTION_BIAS));

    // depth test
    float depth_ratio = depth_0 / depth_1;
    float depth_decoherency = saturate((depth_ratio - 1.05) * 20);

    previous_sample_weight *= 1 - motion_decoherency * depth_decoherency;

    // reduce blend weight on characters on high velocity because of the lack of motion vectors
    [branch]
    if (is_character)
    {
        float2 scaled_velocity = float2(velocity_0.x * screenDimensions.x * screenDimensions.w, velocity_0.y);
        float velocity_length = length(scaled_velocity);
        // don't blend when the velocity is larger than 2 pixels
        previous_sample_weight *= 1 - Rescale(screenDimensions.w * 1.5, screenDimensions.w * 2.0, velocity_length);
    }

    // load neighborhood
    float3 c = current_color_texture.Load(int3(thread_id.xy, 0));
    float3 lc = current_color_texture.Load(int3(thread_id.xy + int2(-1, 0), 0));
    float3 rc = current_color_texture.Load(int3(thread_id.xy + int2(1, 0), 0));
    float3 tc = current_color_texture.Load(int3(thread_id.xy + int2(0, -1), 0));
    float3 bc = current_color_texture.Load(int3(thread_id.xy + int2(0, 1), 0));
    float3 tl = current_color_texture.Load(int3(thread_id.xy + int2(-1, -1), 0));
    float3 tr = current_color_texture.Load(int3(thread_id.xy + int2(1, -1), 0));
    float3 bl = current_color_texture.Load(int3(thread_id.xy + int2(-1, 1), 0));
    float3 br = current_color_texture.Load(int3(thread_id.xy + int2(1, 1), 0));

    float exposure = GetExposure();

    float3 neighbor_min = min(br, min(bl, min(tr, min(tl, min(bc, min(tc, min(rc, min(lc, c))))))));
    neighbor_min = TonemapReinhard(neighbor_min, exposure);
    float3 neighbor_max = max(br, max(bl, max(tr, max(tl, max(bc, max(tc, max(rc, max(lc, c))))))));
    neighbor_max = TonemapReinhard(neighbor_max, exposure);

    // reconstruction filter weights
    float current_weight_sum = 0;
    float previous_weight_sum = 0;
    float current_weight;
    float previous_weight;

    float2 previous_tex_coord_offset;
    float2 current_tex_coord_offset;
    float2 quincunx_offset = screenDimensions.zw * 0.5;

    float3 previous_color = 0;
    float3 current_color = 0;

    [branch]
    if (taa_jitter.x > 0)
    {
        // quincunx samples are in the current frame
        // need to sample neighbors from the previous frame
        previous_color += SamplePreviousTonemapped(mad(screenDimensions.zw, float2(-1, 0), history_tex_coord_1), exposure);
        previous_color += SamplePreviousTonemapped(mad(screenDimensions.zw, float2(1, 0), history_tex_coord_1), exposure);
        previous_color += SamplePreviousTonemapped(mad(screenDimensions.zw, float2(0, -1), history_tex_coord_1), exposure);
        previous_color += SamplePreviousTonemapped(mad(screenDimensions.zw, float2(0, 1), history_tex_coord_1), exposure);
        previous_color *= RESOLVE_OUTER_FILTER_WEIGHT;
        previous_weight_sum += RESOLVE_OUTER_FILTER_WEIGHT * 4;

        previous_weight = 1;
        current_weight = RESOVLE_QUINCUNX_FILTER_WEIGHT * 4;

        previous_tex_coord_offset = 0;
        current_tex_coord_offset = quincunx_offset;
    }
    else
    {
        // quincunx samples are taken from the previous frame
        // can use neighbors from the current frame
        current_color += TonemapReinhard(lc, exposure);
        current_color += TonemapReinhard(rc, exposure);
        current_color += TonemapReinhard(tc, exposure);
        current_color += TonemapReinhard(bc, exposure);
        current_color *= RESOLVE_OUTER_FILTER_WEIGHT;
        current_weight_sum += RESOLVE_OUTER_FILTER_WEIGHT * 4;

        previous_weight = RESOVLE_QUINCUNX_FILTER_WEIGHT * 4;
        current_weight = 1;
        
        previous_tex_coord_offset = quincunx_offset;
        current_tex_coord_offset = 0;
    }
    current_color += SampleCurrentTonemapped(tex_coord + current_tex_coord_offset, exposure) * current_weight;
    current_weight_sum += current_weight;
    previous_color += SamplePreviousTonemapped(history_tex_coord_1 + previous_tex_coord_offset, exposure) * previous_weight;
    previous_weight_sum += previous_weight;

    float responsive_aa_value = _responsive_aa_mask.Load(int3(thread_id.xy, 0));
    previous_sample_weight *= lerp(1, color_coherency_0, responsive_aa_value);

    previous_weight_sum *= previous_sample_weight;
    previous_color *= previous_sample_weight;

    // clamp when colors don't match
    float color_coherency = color_coherency_0 * color_coherency_1;
    float3 clamped_previous_color = clamp(previous_color / max(previous_weight_sum, 0.0001), neighbor_min, neighbor_max);
    previous_color = lerp(clamped_previous_color * previous_weight_sum, previous_color, color_coherency);

    float weight_sum = current_weight_sum + previous_weight_sum;
    float3 resolved_color = (current_color + previous_color) / weight_sum;
    
    output_texture[thread_id.xy] = TonemapReinhardInverse(resolved_color, exposure);
}
