#ifndef BLOOM_COMMON_HLSLI
#define BLOOM_COMMON_HLSLI
#include "Common.hlsli"

cbuffer _PostProcessingParams
{
    float4 source_texture_size;
    float4 target_texture_size;
    float bloom_upscale_weight_0;
    float bloom_upscale_weight_1;
}

SamplerState _linear_clamp_sampler;

float3 BloomUpsample(Texture2D<float3> tex, float2 uv, float2 offset)
{
    float3 color = tex.SampleLevel(_linear_clamp_sampler, uv + offset * int2(0, 0), 0) / 4.0f;
    color += tex.SampleLevel(_linear_clamp_sampler, uv + offset * int2(-1, 0), 0) / 8.0f;
    color += tex.SampleLevel(_linear_clamp_sampler, uv + offset * int2(1, 0), 0) / 8.0f;
    color += tex.SampleLevel(_linear_clamp_sampler, uv + offset * int2(0, -1), 0) / 8.0f;
    color += tex.SampleLevel(_linear_clamp_sampler, uv + offset * int2(0, 1), 0) / 8.0f;
    color += tex.SampleLevel(_linear_clamp_sampler, uv + offset * int2(-1, -1), 0) / 16.0f;
    color += tex.SampleLevel(_linear_clamp_sampler, uv + offset * int2(1, -1), 0) / 16.0f;
    color += tex.SampleLevel(_linear_clamp_sampler, uv + offset * int2(-1, 1), 0) / 16.0f;
    color += tex.SampleLevel(_linear_clamp_sampler, uv + offset * int2(1, 1), 0) / 16.0f;
    return color;
}

#endif