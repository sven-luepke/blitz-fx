#ifndef SCATTERING_COMMON_HLSLI
#define SCATTERING_COMMON_HLSLI
#include "Common.hlsli"

float HenyeyGreensteinPhase(float g, float cos_theta)
{
    float g_squared = Square(g);
    float numerator = 1 - g_squared;
    float denominator = 4 * PI * pow(1 + g_squared - 2 * g * cos_theta, 1.5);
    return numerator / denominator;
}

void ScatteringIntegrationStep(inout float3 accum_scattering, inout float accum_transmittance, float3 slice_scattering, float slice_extinction,
                              float slice_depth)
{
	// improve energy conserving integration: https://www.ea.com/frostbite/news/physically-based-unified-volumetric-rendering-in-frostbite
    float sliceTransmittance = exp(-slice_extinction * slice_depth);
    float3 scattering_over_slice = ((1 - sliceTransmittance) / max(slice_extinction, 0.00001)) * slice_scattering;
    accum_scattering += scattering_over_slice * accum_transmittance;
    accum_transmittance *= sliceTransmittance;
}

void ScatteringIntegrationStep(inout float3 accum_scattering, inout float3 accum_transmittance, float3 slice_scattering, float3 slice_extinction,
                              float slice_depth)
{
	// improve energy conserving integration: https://www.ea.com/frostbite/news/physically-based-unified-volumetric-rendering-in-frostbite
    float3 sliceTransmittance = exp(-slice_extinction * slice_depth);
    float3 scattering_over_slice = ((1 - sliceTransmittance) / max(slice_extinction, 0.00001)) * slice_scattering;
    accum_scattering += scattering_over_slice * accum_transmittance;
    accum_transmittance *= sliceTransmittance;
}

#endif