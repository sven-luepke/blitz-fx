#include "GBuffer.hlsli"
#include "GameData.hlsli"
#include "WaterCommon.hlsli"

RWTexture2D<float> output : register(u4);

[numthreads(8, 8, 1)]
void CSMain(uint3 thread_id : SV_DispatchThreadID)
{
    float device_depth = _g_buffer_depth.Load(int3(thread_id.xy, 0));
    float3 ndc = ThreadIdDepthToNdc(thread_id.xy, device_depth);
    float3 world_position = NdcToWorldPosition(ndc);

    output[thread_id.xy] = ComputeWaterDepth(world_position);
}