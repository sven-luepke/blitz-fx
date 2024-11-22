#include "CustomData.hlsli"
#include "GameData.hlsli"
#include "GBuffer.hlsli"

Texture2D<float> motion_blur_mask : register(t51);
Texture2D<float3> hdr_scene : register(t52);

RWTexture2D<float3> target : register(u0);

#define NUM_MB_SAMPLES 16
#define MB_SAMPLE_STEP 2.0f / (NUM_MB_SAMPLES - 1)

SamplerState _point_sampler;
SamplerState _linear_sampler;

[numthreads(8, 8, 1)]
void CSMain(uint3 thread_id : SV_DispatchThreadID)
{
	float device_depth = _g_buffer_depth.Load(int3(thread_id.xy, 0));
	float3 center_color = hdr_scene.Load(int3(thread_id.xy, 0));

    float2 tex_coord = ThreadIdToTexCoord(thread_id.xy, screenDimensions.zw);
    float3 history_ndc = ComputeHistoryNdcUnjittered(tex_coord, device_depth);
	float3 ndc = float3(tex_coord * float2(2, -2) + float2(-1, 1), device_depth);

	float2 velocity_vector = float2(ndc.x, history_ndc.y) - float2(history_ndc.x, ndc.y);
	velocity_vector *= 0.125;
	velocity_vector *= motion_blur_mask.SampleLevel(_point_sampler, tex_coord, 0);

    float velocity_length = length(velocity_vector);
	// scale down velocity on small motions to avoid overblurring
    float motion_blur_scale = Rescale(0.002, 0.003, velocity_length);

	float4 accum = 0;
	[branch]
	if (motion_blur_scale > 0)
	{
        velocity_vector *= motion_blur_scale;

        // clamp velocity vector length
        float speed = length(velocity_vector);
        velocity_vector /= speed;
        speed = min(speed, 0.01);
        velocity_vector *= speed;

        tex_coord += (Checkerboard(thread_id.xy) < 0.5 ? MB_SAMPLE_STEP : -MB_SAMPLE_STEP) * 0.5 * velocity_vector;
		[unroll]
		for (float s = -1.0; s <= 1.0; s += MB_SAMPLE_STEP)
		{
			float2 sample_tex_coord = tex_coord - velocity_vector * s;
			// Apply masking
            float4 four = motion_blur_mask.GatherRed(_point_sampler, sample_tex_coord, 0);
            float motion_blur_mask_sample = Min4(four);
            float3 color_sample = SafeHdr(hdr_scene.SampleLevel(_linear_sampler, sample_tex_coord, 0));
            accum += float4(color_sample * motion_blur_mask_sample, motion_blur_mask_sample);
        }
        if (accum.w > 0.0001)
        {
            accum.rgb /= accum.w;
        }
		else
		{
            accum.rgb = center_color;
        }
    }
	else
	{
		accum.rgb = center_color;
	}

	target[thread_id.xy] = accum.rgb;
}
