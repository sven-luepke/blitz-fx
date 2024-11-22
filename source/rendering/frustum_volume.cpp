#include "frustum_volume.h"

using namespace w3;

float4 w3::ComputeFrustumVolumeDepthDistributionParams(float near_plane, float range, float depth_exponent,
	float depth_resolution)
{
	float4 params;
	params.y = (range - near_plane * exp2f((depth_resolution - 1) / depth_exponent)) / (range - near_plane);
	params.x = (1 - params.y) / near_plane;
	params.z = depth_exponent;
	params.w = 0;
	return params;
}
FrustumVolumeParams w3::ComputeFrustumVolumeParams(float3 resolution, float range, float depth_pack_exponent, float start_distance)
{
	FrustumVolumeParams params;
	params.resolution = resolution;
	params.range = range;
	params.resolution_reciprocal = {
		1.0f / params.resolution.x,
		1.0f / params.resolution.y,
		1.0f / params.resolution.z
	};
	params.depth_distribution_params = ComputeFrustumVolumeDepthDistributionParams(
		start_distance, params.range, depth_pack_exponent, params.resolution.z);
	return params;
}