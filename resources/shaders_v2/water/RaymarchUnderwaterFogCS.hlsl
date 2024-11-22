#define UNDERWATER_RAYMARCH_FULL_QUALITY

#include "WaterCommon.hlsli"
#include "Common.hlsli"
#include "Noise.hlsli"

Texture2D<float2> under_water_mask_texture : register(t2);
Texture2D<float> depth_texture : register(t14);

Texture2D<float2> _interior_dimmer_texture;

RWTexture2D<float3> in_scattering_texture : register(u0);

float GetBayerMatrix2x2(uint2 position)
{
    position = position & 1;
    float4 values = float4(0, 2, 3, 1);
    return values[position.x + position.y * 2] * 0.25;
}
float GetBayerMatrix4x4(uint2 position)
{
    position = position & 3;
    float value = GetBayerMatrix2x2(floor(position / 2.0f)) + GetBayerMatrix2x2(position % 2) * 4;
    return value * 0.25;
}

[numthreads(8, 8, 1)]
void CSMain( uint3 thread_id : SV_DispatchThreadID )
{
    float2 tex_coord = ThreadIdToTexCoord(thread_id.xy, screenDimensions.zw * 2);

    float2 underwater_mask = under_water_mask_texture.SampleLevel(_linear_sampler, tex_coord, 0).xy;
    [branch]
    if (underwater_mask.x <= 0)
    {
        in_scattering_texture[thread_id.xy] = 0;
        return;
    }

    float device_depth = depth_texture.Load(int3(thread_id.xy, 0));

    float3 ndc = float3(tex_coord * float2(2, -2) + float2(-1, 1), device_depth);

    float3 ray_end_world_position = NdcToWorldPosition(ndc);
    float ray_end_water_depth = ComputeWaterDepth(ray_end_world_position);
    float3 ray_direction = ray_end_world_position - cameraPosition.xyz;

    float total_ray_length = length(ray_direction);
    ray_direction /= total_ray_length;

    float3 scattering_coefficient, absorbtion_coefficient;
    GetWaterScatteringAbsorbtion(scattering_coefficient, absorbtion_coefficient);

    float3 slice_extinction = absorbtion_coefficient + scattering_coefficient;

    float3 slice_scattering = directional_light_color.rgb * scattering_coefficient;
    slice_scattering *= HenyeyGreensteinPhase(WATER_SCATTERING_ANISOTROPY, dot(ray_direction, water_refracted_directional_light_direction));

    // raymarch
    float3 accum_view_scattering;
    float3 accum_view_transmittance;
    RaymarchWaterParams params;
    params.ray_start = cameraPosition.xyz;
    params.surface_height = ray_end_world_position.z + ray_end_water_depth;
    params.ray_direction = ray_direction;
    params.total_ray_length = total_ray_length;
    params.step_size = 2.0;
    params.step_increment = 1.0;
    params.ray_start += GetBayerMatrix4x4(thread_id.xy) * params.ray_direction * params.step_size;
    params.slice_scattering = slice_scattering;
    params.slice_extinction = slice_extinction;
    params.ambient_scattering = _water_sky_ambient.Load(int3(0, 0, 0)) * scattering_coefficient;
    params.ambient_scattering_add = scattering_coefficient * WATER_AMBIENT_ADD;
    params.is_underwater = true;
    params.interior_dimmer_sample = _interior_dimmer_texture.SampleLevel(_linear_sampler, tex_coord, 0);
    RaymarchDirectionalWaterScattering(params, accum_view_scattering, accum_view_transmittance);

    in_scattering_texture[thread_id.xy] = accum_view_scattering;
}