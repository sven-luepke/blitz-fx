#include "GameData.hlsli"

Texture2D<float> depth_buffer : register(t0);

RWTexture2D<float> scene_depth : register(u0);

[numthreads(8, 8, 1)]
void CSMain( uint3 thread_id : SV_DispatchThreadID )
{
    scene_depth[thread_id.xy] = DeviceToSceneDepth(depth_buffer.Load(int3(thread_id.xy, 0)));
}