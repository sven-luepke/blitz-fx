#include "GBuffer.hlsli"
#include "Noise.hlsli"
#include "Common.hlsli"

#define PLANET_RADIUS 6000000
#define AURORA_START_ALTITUDE 60000
#define AURORA_END_ALTITUDE 120000

Texture2D<float> aurora_shape_texture : register(t0);
Texture2D<float2> aurora_detail_texture : register(t1);

SamplerState _linear_mirror_sampler;
SamplerState _linear_wrap_sampler;

float GetBands(float2 position)
{
    return Rescale(0.5, 1, Square((sin(position.x) * 0.5 + 0.5)));
}

#define EXP_0_POINT_8 2.22554f // exp(0.8)

float3 ComputeAurora(float3 view_direction, float offset_noise)
{
    float3 planet_center = float3(0, 0, -PLANET_RADIUS);
    bool intersects;
    float start_intersection_distance;
    float3 ray_start_position;
    RaySphereIntersect(cameraPosition.xyz, view_direction, planet_center, PLANET_RADIUS + AURORA_START_ALTITUDE, intersects,
			                   start_intersection_distance,
			                   ray_start_position);

    float end_intersection_distance;
    float3 ray_end_position;
    RaySphereIntersect(cameraPosition.xyz, view_direction, planet_center, PLANET_RADIUS + AURORA_END_ALTITUDE, intersects,
			                   end_intersection_distance,
			                   ray_end_position);

    float step_count = 24;
    float step_size = (end_intersection_distance - start_intersection_distance) / step_count;

    float3 ray_position = ray_start_position;
    float3 ray_step = view_direction * step_size;
    ray_position += ray_step * (offset_noise - 0.5);
    float3 accumulated_aurora = 0;
    [loop]
    for (int i = 0; i < step_count; i++)
    {
        float2 detail_offset = aurora_detail_texture.SampleLevel(_linear_wrap_sampler, ray_position.xy * 0.000025, 0);
        float noise = aurora_shape_texture.SampleLevel(_linear_mirror_sampler, ray_position.xy * 0.0000005 + 0.5 + detail_offset, 0);
        float aurora_shape = max(0, noise * 9 - 8);
           
        [branch]
        if (aurora_shape > 0)
        {
            float alitude = distance(planet_center, ray_position) - PLANET_RADIUS;
            float aurora_layer_height_fraction = Rescale(AURORA_START_ALTITUDE, AURORA_END_ALTITUDE, alitude);

            float f = exp(-aurora_layer_height_fraction * 4);
            aurora_shape *= min(1, Square(f) * EXP_0_POINT_8);
            float3 aurora_color = aurora_shape * lerp(aurora_color_top, aurora_color_bottom, f);
            accumulated_aurora += aurora_color;
        }
        
        ray_position += ray_step;
    }
    accumulated_aurora *= aurora_brightness;
    return accumulated_aurora / step_count;
}

float chapman_h(double X, float h, float coschi)
{
	// source: "An Approximation to the Chapman Grazing-Incidence Function for Atmospheric Scattering", GPU Pro 3

	// The approximate Chapman function
	// Ch(X+h,chi) times exp(-h)
	// X - altitude of unit density
	// h - observer altitude relative to X
	// coschi - cosine of incidence angle chi
    float c = sqrt(X + h);
	[branch]
    if (coschi >= 0)
    {
		// chi above horizon
        return c / (c * coschi + 1) * exp(-h);
    }

	// chi below horizon , must use identity
	// TODO: avoid double here
    double x0 = sqrt(1.0 - coschi * coschi) * (X + h);
    float c0 = sqrt(x0);
    return
		2.0 * c0 * exp(X - x0) -
		c / (1.0 - c * coschi) * exp(-h);
}

SamplerState _linear_sampler;

RWTexture2D<float3> output : register(u0);

[numthreads(8, 8, 1)]
void CSMain( uint3 thread_id : SV_DispatchThreadID )
{
    float2 tex_coord = ThreadIdToTexCoord(thread_id.xy, screenDimensions.zw * 2);
    float4 device_depths = _g_buffer_depth.GatherRed(_linear_sampler, tex_coord);

    [branch]
    if (any(device_depths > 0))
    {
        output[thread_id.xy] = 0;
        return;
    }

    float3 ndc = float3(tex_coord * float2(2, -2) + float2(-1, 1), 0);
    float3 ray_end_world_position = NdcToWorldPosition(ndc);

    float3 ray_direction = normalize(ray_end_world_position - cameraPosition.xyz);

    float cos_view_zenith = ray_direction.z;
    float altitude = cameraPosition.z;
    float X = PLANET_RADIUS;
    float H_rayleigh = atmosphere_params.rayleigh_scale_height;
    float3 extinction_rayleigh = atmosphere_params.rayleigh_scattering + atmosphere_params.absorbtion;
    float h_rayleigh = altitude / atmosphere_params.rayleigh_scale_height;
    float3 rayleigh_transmittance = exp(-extinction_rayleigh * H_rayleigh * chapman_h(X, h_rayleigh, cos_view_zenith));
    float3 transmittance = rayleigh_transmittance;

    float3 aurora_color = ComputeAurora(ray_direction, GetAnimatedBlueNoise(thread_id.xy).x) * transmittance.g;
    output[thread_id.xy] = aurora_color;
}