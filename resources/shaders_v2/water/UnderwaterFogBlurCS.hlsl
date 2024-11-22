#include "GameData.hlsli"

cbuffer _WaterRenderingParams
{
    float4 underwater_fog_blur_direction;
}

Texture2D<float> depth_texture : register(t14);
Texture2D<float3> in_scattering_texture : register(t16);

RWTexture2D<float3> output : register(u0);

float GetDepthWeight(float reference_depth, float other_depth)
{
    float4 max_depths = max(reference_depth, other_depth);
    float4 min_depths = min(reference_depth, other_depth);
    return 1 - saturate((max_depths / min_depths - 1.1) * 10);
}

[numthreads(8, 8, 1)]
void CSMain( uint3 thread_id : SV_DispatchThreadID )
{
    float3 sample_sum = 0;
    float weight_sum = 0;
    float4 gaussian_weights = float4(1.0, 0.8, 0.4, 0.1);
    float center_depth = DeviceToSceneDepth(depth_texture.Load(int3(thread_id.xy, 0)));
    [unroll]
    for (int i = -3; i <= 3; i++)
    {
        int2 position = thread_id.xy + i * underwater_fog_blur_direction.xy;
        float3 in_scattering_sample = in_scattering_texture.Load(int3(position, 0));
        float weight = gaussian_weights[abs(i)];

        float depth_sample = DeviceToSceneDepth(depth_texture.Load(int3(position, 0)));
        weight *= GetDepthWeight(center_depth, depth_sample);

        sample_sum += in_scattering_sample * weight;
        weight_sum += weight;
    }

    output[thread_id.xy] = sample_sum / weight_sum;
}