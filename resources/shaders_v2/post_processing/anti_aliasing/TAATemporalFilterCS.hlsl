#include "GameData.hlsli"
#include "CustomData.hlsli"
#include "GBuffer.hlsli"
#include "TAACommon.hlsli"

Texture2D<float4> history_color_texture : register(t0);
Texture2D<float3> current_color_texture : register(t1);

Texture2D<float2> half_res_depth_mask_velocity_texture_0 : register(t4);
Texture2D<float2> half_res_depth_mask_velocity_texture_1 : register(t5);
Texture2D<float2> half_res_depth_mask_velocity_texture_2 : register(t6);

RWTexture2D<float4> output_texture : register(u0);

Texture2D<float> _responsive_aa_mask;

SamplerState _point_sampler;

#define TAA_CONVERGENCE_TIME_LOW 0.05
#define TAA_CONVERGENCE_TIME_HIGH 0.2
#define TAA_CONVERGENCE_TIME_FLICKER 1.0

#define FLT_EPS 0.00000001f

float3 ClipAABB(float3 aabb_min, float3 aabb_max, float3 p, float3 q)
{
    // source: https://github.com/playdeadgames/temporal
    float3 r = q - p;
    float3 rmax = aabb_max - p.xyz;
    float3 rmin = aabb_min - p.xyz;

    if (r.x > rmax.x + FLT_EPS)
        r *= (rmax.x / r.x);
    if (r.y > rmax.y + FLT_EPS)
        r *= (rmax.y / r.y);
    if (r.z > rmax.z + FLT_EPS)
        r *= (rmax.z / r.z);
    if (r.x < rmin.x - FLT_EPS)
        r *= (rmin.x / r.x);
    if (r.y < rmin.y - FLT_EPS)
        r *= (rmin.y / r.y);
    if (r.z < rmin.z - FLT_EPS)
        r *= (rmin.z / r.z);

    return p + r;
}

#define TAA_NEIGHBORHOOD_NORTH 0
#define TAA_NEIGHBORHOOD_EAST 1
#define TAA_NEIGHBORHOOD_SOUTH 2
#define TAA_NEIGHBORHOOD_WEST 3

float3 TAABicubicFilter(float3 current_neighborhood[4], float3 current_center_color, float3 previous_center_color,
                         float2 tex_coord, float4 rt_metrics, float sharpness_scale)
{
    // sharper history sampling
    float2 f = frac(rt_metrics.zw * tex_coord - 0.5);
    float c = 0.8 * sharpness_scale;
    float2 w = c * (f * f - f);

    float4 color = float4(lerp(current_neighborhood[TAA_NEIGHBORHOOD_WEST], current_neighborhood[TAA_NEIGHBORHOOD_EAST], f.x), 1.0) * w.x +
        float4(lerp(current_neighborhood[TAA_NEIGHBORHOOD_NORTH], current_neighborhood[TAA_NEIGHBORHOOD_SOUTH], f.y), 1.0) * w.y;
    color += float4((1.0 + color.a) * previous_center_color - color.a * current_center_color, 1.0);
    return color.rgb * rcp(color.a);
}

float LuminanceContrast(float luma_min, float luma_max)
{
    float min_luma_d = min(luma_min, 1 - luma_max);
    return 1 - (min_luma_d / luma_max);
}

/*
 * Temporal filter based on:
 * https://research.activision.com/publications/2020-03/dynamic-temporal-antialiasing-and-upsampling-in-call-of-duty
 * https://research.activision.com/publications/archives/filmic-smaasharp-morphological-and-temporal-antialiasing
 */
[numthreads(8, 8, 1)]
void CSMain(uint3 thread_id : SV_DispatchThreadID)
{
    float2 tex_coord = ThreadIdToTexCoord(thread_id.xy, screenDimensions.zw);

    float4 current_depth_mask_velocity = GetNearestVelocityDepth(half_res_depth_mask_velocity_texture_0, tex_coord);
    float current_scene_depth = current_depth_mask_velocity.x;
    float current_mask = current_depth_mask_velocity.y;
    float2 history_tex_coord = tex_coord + current_depth_mask_velocity.zw;

    float exposure = GetExposure();
    float3 current_color = TonemapReinhard(current_color_texture.Load(int3(thread_id.xy, 0)), exposure);

    // disable temporal filter on characters due to the lack of motion vectors
    uint stencil_bits = _g_buffer_stencil.Load(int3(thread_id.xy, 0)).y;
    float stencil_mask = stencil_bits & STENCIL_BIT_CHARACTER ? 1 : 0;
    bool is_history_invalid = any(history_tex_coord < 0 || history_tex_coord > 1) || stencil_mask || is_camera_cut;

    float4 history_depth_mask_velocity = GetNearestVelocityDepth(half_res_depth_mask_velocity_texture_1, history_tex_coord);
    float history_scene_depth = history_depth_mask_velocity.x;
    float history_mask = history_depth_mask_velocity.y;

    // check for disocclusion using depth and character mask
    is_history_invalid = is_history_invalid || current_scene_depth / history_scene_depth > 1.5 || current_mask != history_mask;

    float3 cross_neighbor_min = current_color;
    float3 cross_neighbor_max = current_color;
    float3 cross_average = current_color;

    float3 neighborhood[4];
    // top center
    float3 neighbor_color = current_color_texture.Load(int3(thread_id.xy + int2(0, -1), 0));
    neighbor_color = TonemapReinhard(neighbor_color, exposure);
    cross_neighbor_min = min(neighbor_color, cross_neighbor_min);
    cross_neighbor_max = max(neighbor_color, cross_neighbor_max);
    cross_average += neighbor_color;
    neighborhood[TAA_NEIGHBORHOOD_NORTH] = neighbor_color;
    // middle left
    neighbor_color = current_color_texture.Load(int3(thread_id.xy + int2(-1, 0), 0));
    neighbor_color = TonemapReinhard(neighbor_color, exposure);
    cross_neighbor_min = min(neighbor_color, cross_neighbor_min);
    cross_neighbor_max = max(neighbor_color, cross_neighbor_max);
    cross_average += neighbor_color;
    neighborhood[TAA_NEIGHBORHOOD_WEST] = neighbor_color;
    // middle right
    neighbor_color = current_color_texture.Load(int3(thread_id.xy + int2(1, 0), 0));
    neighbor_color = TonemapReinhard(neighbor_color, exposure);
    cross_neighbor_min = min(neighbor_color, cross_neighbor_min);
    cross_neighbor_max = max(neighbor_color, cross_neighbor_max);
    cross_average += neighbor_color;
    neighborhood[TAA_NEIGHBORHOOD_EAST] = neighbor_color;
    // bottom center
    neighbor_color = current_color_texture.Load(int3(thread_id.xy + int2(0, 1), 0));
    neighbor_color = TonemapReinhard(neighbor_color, exposure);
    cross_neighbor_min = min(neighbor_color, cross_neighbor_min);
    cross_neighbor_max = max(neighbor_color, cross_neighbor_max);
    cross_average += neighbor_color;
    neighborhood[TAA_NEIGHBORHOOD_SOUTH] = neighbor_color;

    float3 full_neighbor_min = cross_neighbor_min;
    float3 full_neighbor_max = cross_neighbor_max;
    float3 full_average = cross_average;

    // top left
    neighbor_color = current_color_texture.Load(int3(thread_id.xy + int2(-1, -1), 0));
    neighbor_color = TonemapReinhard(neighbor_color, exposure);
    full_neighbor_min = min(neighbor_color, full_neighbor_min);
    full_neighbor_max = max(neighbor_color, full_neighbor_max);
    full_average += neighbor_color;
    // top right
    neighbor_color = current_color_texture.Load(int3(thread_id.xy + int2(1, -1), 0));
    neighbor_color = TonemapReinhard(neighbor_color, exposure);
    full_neighbor_min = min(neighbor_color, full_neighbor_min);
    full_neighbor_max = max(neighbor_color, full_neighbor_max);
    full_average += neighbor_color;
    // bottom left
    neighbor_color = current_color_texture.Load(int3(thread_id.xy + int2(-1, 1), 0));
    neighbor_color = TonemapReinhard(neighbor_color, exposure);
    full_neighbor_min = min(neighbor_color, full_neighbor_min);
    full_neighbor_max = max(neighbor_color, full_neighbor_max);
    full_average += neighbor_color;
    // bottom right
    neighbor_color = current_color_texture.Load(int3(thread_id.xy + int2(1, 1), 0));
    neighbor_color = TonemapReinhard(neighbor_color, exposure);
    full_neighbor_min = min(neighbor_color, full_neighbor_min);
    full_neighbor_max = max(neighbor_color, full_neighbor_max);
    full_average += neighbor_color;

    float3 round_neighbor_min = (full_neighbor_min + cross_neighbor_min) * 0.5;
    float3 round_neighbor_max = (full_neighbor_max + cross_neighbor_max) * 0.5;
    full_average /= 9.0;
    cross_average /= 5.0;
    float3 round_average = (full_average + cross_average) * 0.5;

    float4 history_sample = history_color_texture.SampleLevel(_linear_sampler, history_tex_coord, 0);
    history_sample.rgb = TAABicubicFilter(
        neighborhood, current_color, history_sample.rgb, history_tex_coord, screenDimensions.zwxy, taa_history_sharpening);
    float3 history_color = history_sample.rgb;
    float history_spatial_contrast_weight = history_sample.a;

    // neighborhood clipping
    float3 rectified_history = ClipAABB(round_neighbor_min, round_neighbor_max,
                                         clamp(round_average, round_neighbor_min, round_neighbor_max), history_color);

    float luma_min = Luminance(full_neighbor_min);
    float luma_max = Luminance(full_neighbor_max);
    float current_spatial_contrast_weight = LuminanceContrast(luma_min, luma_max) * 2;

    float alpha;
    [branch]
    if (is_history_invalid)
    {
        alpha = 0;
    }
    else
    {
        // adjust temporal blend weight based on spatial and temporal contrast to maintain a sharp image
        float current_luminance = Luminance(current_color);
        float history_luminance = Luminance(rectified_history);
        float min_temporal_luma = min(current_luminance, history_luminance);
        float max_temporal_luma = max(current_luminance, history_luminance);
        float temporal_contrast = LuminanceContrast(min_temporal_luma, max_temporal_luma);
        float temporal_contrast_weight = Rescale(0.03, 1, temporal_contrast);
        float convergence_time = lerp(TAA_CONVERGENCE_TIME_LOW, TAA_CONVERGENCE_TIME_HIGH, temporal_contrast_weight);

        // detect temporal changes in spatial contrast (flickering)
        float spatio_temporal_contrast_weight = min(1, abs(current_spatial_contrast_weight - history_spatial_contrast_weight));
        convergence_time = lerp(convergence_time, TAA_CONVERGENCE_TIME_FLICKER, spatio_temporal_contrast_weight);

        convergence_time = lerp(convergence_time, 0.001, _responsive_aa_mask.Load(int3(thread_id.xy, 0)));

        // don't blend on low temporal contrast to avoid numerical diffusion
        alpha = temporal_contrast_weight <= 0 ? 0 : Alpha(convergence_time);
    }

    float3 temporally_filtered_color = lerp(saturate(current_color), saturate(rectified_history), alpha);

    output_texture[thread_id.xy] = float4(temporally_filtered_color, current_spatial_contrast_weight);
}
