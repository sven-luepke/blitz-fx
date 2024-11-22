#include "GBuffer.hlsli"
#include "GameData.hlsli"
#include "CustomData.hlsli"

cbuffer cb3 : register(b3)
{
    float dof_far_focus_distance;
    float dof_far_blur_distance;
    float dof_intensity;
}

RWTexture2D<float> coc_texture : register(u0);

[numthreads(8, 8, 1)]
void CSMain(uint3 thread_id : SV_DispatchThreadID)
{
    float scene_depth = DeviceToSceneDepth(_g_buffer_depth.Load(int3(thread_id.xy, 0)));

    float focus_distance = enable_custom_gameplay_dof_params ? gameplay_dof_focus_distance : dof_far_focus_distance;
    float blur_distance = enable_custom_gameplay_dof_params ? gameplay_dof_blur_distance : dof_far_blur_distance;

    float circle_of_confusion = Rescale(focus_distance, blur_distance, scene_depth);

    coc_texture[thread_id.xy] = circle_of_confusion;
}