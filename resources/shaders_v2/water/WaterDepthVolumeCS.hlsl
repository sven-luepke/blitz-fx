#include "FrustumVolumeCommon.hlsli"
#include "WaterCommon.hlsli"

RWTexture3D<float> output : register(u4);

[numthreads(4, 4, 4)]
void CSMain( uint3 thread_id : SV_DispatchThreadID )
{
    float3 world_position = ComputeFrustumVolumeWorldPosition(thread_id, 0, water_depth_volume_params);

    output[thread_id.xyz] = ComputeWaterDepth(world_position);
}