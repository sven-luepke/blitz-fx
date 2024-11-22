#include "Common.hlsli"
#include "WaterCommon.hlsli"

RWTexture2D<float3> output : register(u0);

[numthreads(8, 8, 1)]
void CSMain( uint3 thread_id : SV_DispatchThreadID )
{
    float2 tex_coord = ThreadIdToTexCoord(thread_id.xy, 1.0 / 64.0);

    float3 ray_direction = GetParaboloidDirection(tex_coord);

    float3 scattering_coefficient, absorbtion_coefficient;
    GetWaterScatteringAbsorbtion(scattering_coefficient, absorbtion_coefficient);

    float3 slice_extinction = absorbtion_coefficient + scattering_coefficient;

    float3 slice_scattering = directional_light_color.rgb * scattering_coefficient;

    slice_scattering *= rcp(PI * 4);

    // attenuate lighting based on cloud shadow
    // TODO: sample the lowest cloud shadow mip level instead
    slice_scattering *= 1 - saturate(lerp(skyboxShadingParams.x, skyboxShadingParams.y, weatherAndPrescaleParams.w) * 0.25);

    // raymarch
    RaymarchWaterParams params;
    params.ray_start = 0;
    params.surface_height = 0;
    params.ray_direction = ray_direction;
    params.total_ray_length = 32;
    params.step_size = 0.5;
    params.step_increment = 2;
    params.slice_scattering = slice_scattering;
    params.slice_extinction = slice_extinction;
    params.ambient_scattering = _water_sky_ambient.Load(int3(0, 0, 0)) * scattering_coefficient;
    params.ambient_scattering_add = scattering_coefficient * WATER_AMBIENT_ADD;
    params.is_underwater = false;
    params.interior_dimmer_sample = 0;
    float3 accum_scattering = 0;
    float3 accum_transmittance = 1;
    RaymarchDirectionalWaterScattering(params, accum_scattering, accum_transmittance);

    output[thread_id.xy] = accum_scattering;
}