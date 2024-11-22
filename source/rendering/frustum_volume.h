#pragma once
#include "shader_types.h"

namespace w3
{
struct FrustumVolumeParams
{
	float3 resolution;
	float _padding = 0;
	float3 resolution_reciprocal;
	float range;
	float4 depth_distribution_params;
};

float4 ComputeFrustumVolumeDepthDistributionParams(float near_plane, float range, float depth_exponent,
                                                   float depth_resolution);
FrustumVolumeParams ComputeFrustumVolumeParams(float3 resolution, float range, float depth_pack_exponent, float start_distance);
}
