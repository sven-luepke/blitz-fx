#include "Common.hlsli"
#include "GameData.hlsli"
#include "BloomCommon.hlsli"
#include "CustomData.hlsli"

Texture2D<float3> _underwater_fog_transmittance_texture;

Texture2D<float> _bloom_intensity_tex : register(t50);

Texture2D<float3> bloomed_hdr_scene : register(t51);
Texture2D<float3> hdr_scene : register(t52);

RWTexture2D<float3> result : register(u0);

SamplerState _linear_sampler;

[numthreads(8, 8, 1)]
void CSMain( uint3 thread_id : SV_DispatchThreadID )
{
    float2 uv = ThreadIdToTexCoord(thread_id.xy, screenDimensions.zw);
	
    float3 bloomed_hdr_color = SafeHdr(BloomUpsample(bloomed_hdr_scene, uv, source_texture_size.zw));

    float3 hdr_color = hdr_scene.Load(int3(thread_id.xy, 0));

	// fake diffusion in dense fog
    //float bloom_intensity = _bloom_intensity_tex.Load(int3(thread_id.xy, 0));

    float3 underwater_fog_transmittance = _underwater_fog_transmittance_texture.Load(int3(thread_id.xy, 0));
    float underwater_fog_diffusion = (1 - Luminance(underwater_fog_transmittance)) * underwater_fog_diffusion_scale;

    float bloom_intensity = max(bloom_scattering, underwater_fog_diffusion);

    hdr_color = lerp(hdr_color, bloomed_hdr_color, bloom_intensity);

    result[thread_id.xy] = hdr_color;
}