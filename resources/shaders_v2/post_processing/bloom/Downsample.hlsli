#include "Common.hlsli"
#include "BloomCommon.hlsli"

Texture2D<float3> source : register(t77);
RWTexture2D<float3> target : register(u0);

float3 BoxDownsample(float3 sample_0, float3 sample_1, float3 sample_2, float3 sample_3)
{
    float3 samples[] =
    {
    	sample_0, sample_1, sample_2, sample_3
    };
    float3 color = 0;
#ifdef ANTI_FLICKER
    float4 weights;
    for (int i = 0; i < 4; i++)
    {
        weights[i] = 1.0 / (1.0 + 0.1 * Luminance(samples[i]));
        color += samples[i] * weights[i];
    }
    return color / (weights.x + weights.y + weights.z + weights.w);
#else
    color += samples[0] * 0.25;
    color += samples[1] * 0.25;
    color += samples[2] * 0.25;
    color += samples[3] * 0.25;
    return color;
#endif
}

#ifdef ANTI_FLICKER
#define SAFE_HDR(x) SafeHdr(x)
#else
#define SAFE_HDR(x) x
#endif

[numthreads(8, 8, 1)]
void CSMain( uint3 thread_id : SV_DispatchThreadID )
{
    float2 uv = float2(thread_id.xy + 0.5) / float2(target_texture_size.xy);

    // source: Jorge Jimenez: Next Generation Post Processing in Call of Duty: Advanced Warfare
	
    float3 color_0 = SAFE_HDR(source.SampleLevel(_linear_clamp_sampler, uv, 0, int2(-1, -1))) * 0.5;
    float3 color_1 = SAFE_HDR(source.SampleLevel(_linear_clamp_sampler, uv, 0, int2(1, -1))) * 0.5;
    float3 color_2 = SAFE_HDR(source.SampleLevel(_linear_clamp_sampler, uv, 0, int2(-1, 1))) * 0.5;
    float3 color_3 = SAFE_HDR(source.SampleLevel(_linear_clamp_sampler, uv, 0, int2(1, 1))) * 0.5;
    float3 color = BoxDownsample(color_0, color_1, color_2, color_3);

    float3 color_00 = SAFE_HDR(source.SampleLevel(_linear_clamp_sampler, uv, 0, int2(-2, -2))) * 0.125;
    float3 color_10 = SAFE_HDR(source.SampleLevel(_linear_clamp_sampler, uv, 0, int2(0, -2))) * 0.125;
    float3 color_20 = SAFE_HDR(source.SampleLevel(_linear_clamp_sampler, uv, 0, int2(2, -2))) * 0.125;
    float3 color_01 = SAFE_HDR(source.SampleLevel(_linear_clamp_sampler, uv, 0, int2(-2, 0))) * 0.125;
    float3 color_11 = SAFE_HDR(source.SampleLevel(_linear_clamp_sampler, uv, 0, int2(0, 0))) * 0.125;
    float3 color_21 = SAFE_HDR(source.SampleLevel(_linear_clamp_sampler, uv, 0, int2(2, 0))) * 0.125;
    float3 color_02 = SAFE_HDR(source.SampleLevel(_linear_clamp_sampler, uv, 0, int2(-2, 2))) * 0.125;
    float3 color_12 = SAFE_HDR(source.SampleLevel(_linear_clamp_sampler, uv, 0, int2(0, 2))) * 0.125;
    float3 color_22 = SAFE_HDR(source.SampleLevel(_linear_clamp_sampler, uv, 0, int2(2, 2))) * 0.125;

	color += BoxDownsample(color_00, color_10, color_01, color_11);
    color += BoxDownsample(color_10, color_20, color_11, color_21);
    color += BoxDownsample(color_11, color_21, color_12, color_22);
    color += BoxDownsample(color_01, color_11, color_02, color_12);

    target[thread_id.xy] = color;
}