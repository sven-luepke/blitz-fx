#include "CustomData.hlsli"
#include "GameData.hlsli"
#include "GBuffer.hlsli"

RWTexture2D<float> motion_blur_mask : register(u0);

[numthreads(8, 8, 1)]
void CSMain( uint3 thread_id : SV_DispatchThreadID )
{
    float device_depth = _g_buffer_depth.Load(int3(thread_id.xy, 0));
    float scene_depth = DeviceToSceneDepth(device_depth);

    uint stencil_mask_sample = _g_buffer_stencil.Load(int3(thread_id.xy, 0)).y;
    bool is_dynamic_object = stencil_mask_sample & 2;
    float motion_blur_mask_value = is_dynamic_object ? saturate(scene_depth * 0.2 - 1) : 1;

    motion_blur_mask[thread_id.xy] = motion_blur_mask_value;
}