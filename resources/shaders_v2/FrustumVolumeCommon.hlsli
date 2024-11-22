#ifndef FRUSTUM_VOLUME_COMMON_HLSLI
#define FRUSTUM_VOLUME_COMMON_HLSLI

#include "CustomData.hlsli"

float SceneDepthFromFrustumVolumeZSlice(float z_slice, FrustumVolumeParams frustum_volume_params)
{
    float3 fog_z_params = frustum_volume_params.depth_distribution_params.xyz;
    float slice_depth = (exp2(z_slice / fog_z_params.z) - fog_z_params.y) / fog_z_params.x;
    return slice_depth;
}
float FrustumVolumeDeviceToSceneDepth(float device_depth)
{
    return frustum_volume_projection_matrix[2][3] / max(device_depth - frustum_volume_projection_matrix[2][2], 0.0001);
}
float FrustumVolumeSceneToDeviceDepth(float scene_depth)
{
    return (scene_depth * frustum_volume_projection_matrix[2][2] + frustum_volume_projection_matrix[2][3]) / max(scene_depth, 0.0001);
}
float3 ComputeFrustumVolumeWorldPosition(uint3 thread_id, float3 offset, FrustumVolumeParams frustum_volume_params)
{
    float2 volume_ndc = (thread_id.xy + offset.xy) * float2(2.0, -2.0) * frustum_volume_params.resolution_reciprocal.xy;
    volume_ndc += float2(-1, 1);

    float scene_depth = SceneDepthFromFrustumVolumeZSlice(thread_id.z + offset.z, frustum_volume_params);

    float device_depth = FrustumVolumeSceneToDeviceDepth(scene_depth);
	
    float4 world_position = mul(frustum_volume_inverse_view_projection_matrix, float4(volume_ndc, device_depth, 1));
    return world_position.xyz / world_position.w;
}
float ComputeFrustumVolumeZCoord(float scene_depth, FrustumVolumeParams frustum_volume_params)
{
    float3 fog_z_params = frustum_volume_params.depth_distribution_params.xyz;
    return log2(scene_depth * fog_z_params.x + fog_z_params.y) * fog_z_params.z * frustum_volume_params.resolution_reciprocal.z;
}
float3 WorldPositionToFrustumVolumeUV(float3 world_position, FrustumVolumeParams frustum_volume_params)
{
    float4 ndc = mul(frustum_volume_view_projection_matrix, float4(world_position, 1));
    ndc.xyz /= ndc.w;

    float scene_depth = FrustumVolumeDeviceToSceneDepth(ndc.z);
    return float3(ndc.xy * float2(0.5, -0.5) + float2(0.5, 0.5), ComputeFrustumVolumeZCoord(scene_depth, frustum_volume_params));
}

#endif