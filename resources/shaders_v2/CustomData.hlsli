#ifndef CUSTOM_FRAME_DATA_HLSLI
#define CUSTOM_FRAME_DATA_HLSLI
#include "Common.hlsli"
#include "GameData.hlsli"

struct FrustumVolumeParams
{
    float3 resolution;
    float3 resolution_reciprocal;
    float range;
    float4 depth_distribution_params;
};

cbuffer _CustomFrameData
{
    uint frame_counter;
    float frame_time_seconds;

    float cascade_shadow_map_depth_scale;
    float cascade_penumbra_scale;

	// near plane for these matrices is hardcoded to 0.2
    row_major float4x4 frustum_volume_view_projection_matrix;
    row_major float4x4 frustum_volume_previous_view_projection_matrix;
    row_major float4x4 frustum_volume_projection_matrix;
    row_major float4x4 frustum_volume_inverse_view_projection_matrix;

    FrustumVolumeParams water_depth_volume_params;
    
    row_major float4x4 view_projection_matrix;
    row_major float4x4 inverse_view_projection_matrix;
    row_major float4x4 history_view_projection_matrix;
    row_major float4x4 history_view_projection_matrix_2;

    float2 taa_jitter;
    float depth_similarity_sigma;
	float num_clipmap_levels;
	
    float terrain_size;
    float ambient_transmittance_attenuation;
    float sun_outer_space_luminance;
    float game_time;
	
    struct AtmosphereParams
    {
        float3 rayleigh_scattering;
        float mie_scattering;
        float3 absorbtion;
        float mie_absorbtion_scale;
	
        float rayleigh_scale_height;
        float mie_scale_height;
    } atmosphere_params;

    float3 hdr_color_filter;
    float hdr_saturation;

    float bloom_scattering;
    bool modify_tonemap;
    float exposure_scale;
    bool enable_custom_sun_radius;

    float custom_sun_radius;
    bool enable_parametric_color_balance;
    float cinematic_border;
    int debug_view_mode;

    float hdr_contrast;
    float vignette_intensity;
    float vignette_exponent;
    float vignette_start_offset;

    float sharpening;
    bool is_camera_cut;
    float underwater_fog_diffusion_scale;
    int hairworks_shadow_sample_count;

    float3 water_refracted_directional_light_direction;
    float water_refracted_directional_light_fraction;

    float3 water_scattering_coefficient;
    float underwater_fog_anisotropy;

    float3 water_absorbtion_coefficient;
    float water_depth_scale;

    float taa_history_sharpening;
    float taa_resolve_quincunx_weight;
    float taa_resolve_outer_weight;
    bool enable_soft_shadows;

    float3 aurora_color_bottom;
    float aurora_brightness;
    float3 aurora_color_top;
    float gameplay_dof_intensity;

    float gameplay_dof_focus_distance;
    float gameplay_dof_blur_distance;
    bool enable_custom_gameplay_dof_params;
    float gameplay_dof_intensity_scale;

    bool enable_pbr_lighting;
}

#define DEBUG_VIEW_MODE_OFF 0
#define DEBUG_VIEW_MODE_DEPTH 1
#define DEBUG_VIEW_MODE_ALBEDO 2
#define DEBUG_VIEW_MODE_NORMAL 3
#define DEBUG_VIEW_MODE_ROUGHNESS 4
#define DEBUG_VIEW_MODE_SPECULAR 5
#define DEBUG_VIEW_MODE_AO 6
#define DEBUG_VIEW_MODE_SHADOW 7

float GetDepthSimilarity(float center_depth, float sample_depth, float threshold_scale)
{
    float depth_difference = abs(center_depth - sample_depth);
    float sigma = depth_similarity_sigma * center_depth * threshold_scale;
    return exp(-Square(depth_difference) / Square(sigma));
}

float4 GetDepthSimilarity(float center_depth, float4 sample_depths, float threshold_scale)
{
    float4 depth_difference = abs(center_depth - sample_depths);
    float sigma = depth_similarity_sigma * center_depth * threshold_scale;
    return exp(-Square(depth_difference) / Square(sigma));
}

float3 ComputeHistoryNdc(float2 tex_coord, float device_depth)
{
    float4 world_position = float4(tex_coord * float2(2, -2) + float2(-1, 1), device_depth, 1);
    world_position = mul(inverse_view_projection_matrix, world_position);
    world_position.xyz /= world_position.w;

    float4 history_clip = mul(history_view_projection_matrix, float4(world_position.xyz, 1));
    float3 history_ndc = history_clip.xyz / history_clip.w;
    return history_ndc;
}

/*
 * Most precise but expensive method.
 */
float2 ComputeTemporalReprojectionVector(float2 tex_coord, float device_depth)
{
    float3 world_position = NdcToWorldPosition(float3(tex_coord * float2(2, -2) + float2(-1, 1), device_depth));

    float4 history_clip = mul(history_view_projection_matrix, float4(world_position.xyz, 1));
    float3 history_ndc = history_clip.xyz / history_clip.w;
    float2 history_tex_coord = NdcXYToTexCoord(history_ndc.xy);

    float4 clip = mul(view_projection_matrix, float4(world_position.xyz, 1));
    float3 ndc = clip.xyz / clip.w;
    float2 tex_coord_current = NdcXYToTexCoord(ndc.xy);

    return history_tex_coord - tex_coord_current;
}

float3 ComputeTemporalReprojectionVectorWithDepth(float2 tex_coord, float device_depth)
{
    float3 world_position = NdcToWorldPosition(float3(tex_coord * float2(2, -2) + float2(-1, 1), device_depth));

    float4 history_clip = mul(history_view_projection_matrix, float4(world_position.xyz, 1));
    float3 history_ndc = history_clip.xyz / history_clip.w;
    float2 history_tex_coord = NdcXYToTexCoord(history_ndc.xy);

    float4 clip = mul(view_projection_matrix, float4(world_position.xyz, 1));
    float3 ndc = clip.xyz / clip.w;
    float2 tex_coord_current = NdcXYToTexCoord(ndc.xy);

    return float3(history_tex_coord - tex_coord_current, history_ndc.z - ndc.z);
}

float3 ComputeHistoryNdcUnjittered(float2 tex_coord, float device_depth)
{
    float4 world_position = float4(tex_coord * float2(2, -2) + float2(-1, 1), device_depth, 1);
    world_position = mul(inverse_view_projection_matrix, world_position);
    world_position.xyz /= world_position.w;

    float4 history_clip = mul(history_view_projection_matrix, float4(world_position.xyz, 1));
    float3 history_ndc = history_clip.xyz / history_clip.w;
    history_ndc.xy -= taa_jitter * 0.5;
    return history_ndc;
}

float Alpha(float convergence_time)
{
    return exp(-frame_time_seconds / convergence_time);
}

#endif