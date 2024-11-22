#ifndef TAA_COMMON_HLSLI
#define TAA_COMMON_HLSLI
#include "Common.hlsli"

SamplerState _linear_sampler;

Texture2D<float> exposure_texture : register(t14);

float2 PackDepthMaskVelocityR32G32(float scene_depth, float mask, float2 velocity)
{
    scene_depth *= 4.0f;
    velocity = sqrt(abs(velocity)) * sign(velocity) * 65504.0f;

    uint2 packed;
    packed.x = f32tof16(scene_depth) << 16 | f32tof16(mask);
    packed.y = f32tof16(velocity.x) << 16 | f32tof16(velocity.y);
    return asfloat(packed);
}

float4 UnpackDepthMaskVelocityR32G32(in uint2 packed)
{
    float scene_depth = f16tof32(packed.x >> 16);
    scene_depth /= 4.0f;

    float mask = f16tof32(packed.x);

    float2 velocity = float2(f16tof32(packed.y >> 16), f16tof32(packed.y));
    velocity = velocity / 65504.0f;
    velocity = Square(velocity) * sign(velocity);

    return float4(scene_depth, mask, velocity);
}

float4 GetNearestVelocityDepth(Texture2D<float2> half_res_depth_mask_velocity_buffers, float2 tex_coord)
{
    uint4 depth_masks = asuint(half_res_depth_mask_velocity_buffers.GatherRed(_linear_sampler, tex_coord));
    uint nearest_depth_mask = depth_masks[0];
    uint nearest_index = 0;
    [unroll]
    for (uint i = 1; i < 4; i++)
    {
        if (depth_masks[i] < nearest_depth_mask)
        {
            nearest_depth_mask = depth_masks[i];
            nearest_index = i;
        }
    }
    uint nearest_velocity_xy = asuint(half_res_depth_mask_velocity_buffers.GatherGreen(_linear_sampler, tex_coord)[nearest_index]);
    return UnpackDepthMaskVelocityR32G32(uint2(nearest_depth_mask, nearest_velocity_xy));
}

float GetExposure()
{
    return exposure_texture.Load(int3(0, 0, 0));
}

float3 TonemapReinhard(float3 color, float exposure)
{
    color *= exposure;
    return color * rcp(1 + Max3(color));
}
float3 TonemapReinhardWeighted(float3 color, float exposure, float weight)
{
    color *= exposure;
    return color * (weight * rcp(1 + Max3(color)));
}
float3 TonemapReinhardInverse(float3 color, float exposure)
{
    return color * rcp(mad(-Max3(color), exposure, exposure));
}

#endif