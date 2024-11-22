#include "GBuffer.hlsli"
#include "GameData.hlsli"
#include "Common.hlsli"
#include "CustomData.hlsli"

cbuffer cb3 : register(b3)
{
    float dof_far_focus_distance;
    float dof_far_blur_distance;
    float dof_intensity;
}

Texture2D<float3> color_texture : register(t50);
Texture2D<float> coc_texture : register(t52);

RWTexture2D<float4> half_res_color_coc_texture : register(u0);
RWTexture2D<float> half_res_min_coc_texture : register(u1);

SamplerState _linear_sampler;

[numthreads(8, 8, 1)]
void CSMain(uint3 thread_id : SV_DispatchThreadID)
{
    float2 tex_coord = ThreadIdToTexCoord(thread_id.xy, screenDimensions.zw * 2);

    float4 cocs = coc_texture.GatherRed(_linear_sampler, tex_coord);
    
    float4 color_r = color_texture.GatherRed(_linear_sampler, tex_coord);
    float4 color_g = color_texture.GatherGreen(_linear_sampler, tex_coord);
    float4 color_b = color_texture.GatherBlue(_linear_sampler, tex_coord);

    float3 premultiplied_final_color;
    float final_coc;
    premultiplied_final_color.r = dot(color_r, cocs) * 0.25;
    premultiplied_final_color.g = dot(color_g, cocs) * 0.25;
    premultiplied_final_color.b = dot(color_b, cocs) * 0.25;
    final_coc = (cocs.r + cocs.g + cocs.b + cocs.a) * 0.25;

    float min_coc = Max4(cocs); // yes this is intended

    half_res_color_coc_texture[thread_id.xy] = float4(premultiplied_final_color, final_coc);
    half_res_min_coc_texture[thread_id.xy] = min_coc;
}
