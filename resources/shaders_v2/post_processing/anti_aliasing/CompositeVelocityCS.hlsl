#include "GameData.hlsli"
#include "CustomData.hlsli"
#include "GBuffer.hlsli"
#include "TAACommon.hlsli"

RWTexture2D<float2> half_res_depth_mask_velocity_texture : register(u0);

/*
 * Composite camera and object motion vectors at half resolution
 * Store the nearest velocity, depth and character mask of each 2x2 full resolution block
 */
[numthreads(8, 8, 1)]
void CSMain( uint3 thread_id : SV_DispatchThreadID )
{
    float2 tex_coord = ThreadIdToTexCoord(thread_id.xy, screenDimensions.zw * 2);
    float4 device_depths = _g_buffer_depth.GatherRed(_linear_sampler, tex_coord);

    float nearest_device_depth = -1;
    int nearest_depth_index = 0;
    [unroll]
    for (int i = 0; i < 4; i++)
    {
        if (device_depths[i] > nearest_device_depth)
        {
            nearest_device_depth = device_depths[i];
            nearest_depth_index = i;
        }
    }
    float4 per_object_velocities_x = _g_buffer_velocity.GatherRed(_linear_sampler, tex_coord);
    float4 per_object_velocities_y = _g_buffer_velocity.GatherGreen(_linear_sampler, tex_coord);

    float2 per_object_velocity = float2(per_object_velocities_x[nearest_depth_index], per_object_velocities_y[nearest_depth_index]);

    if (per_object_velocity.x == 1 && per_object_velocity.y == 1)
    {
        per_object_velocity = 0;
    }

    uint2 offsets[] =
    {
        { 0, 1 },
        { 1, 1 },
        { 1, 0 },
        { 0, 0 }
    };
    uint2 nearest_depth_full_res_thread_id = thread_id.xy * 2 + offsets[nearest_depth_index];
    float2 nearest_depth_tex_coord = ThreadIdToTexCoord(nearest_depth_full_res_thread_id, screenDimensions.zw);

    float2 camera_velocity_vector = ComputeTemporalReprojectionVector(nearest_depth_tex_coord, nearest_device_depth);

    uint4 stencil_bits = _g_buffer_stencil.GatherGreen(_linear_sampler, tex_coord);
    float nearest_mask = stencil_bits[nearest_depth_index] & STENCIL_BIT_CHARACTER ? 1 : 0;
    float2 velocity_vector = camera_velocity_vector + per_object_velocity;

    float scene_depth = DeviceToSceneDepth(nearest_device_depth);

    half_res_depth_mask_velocity_texture[thread_id.xy] = PackDepthMaskVelocityR32G32(scene_depth, nearest_mask, velocity_vector);
}