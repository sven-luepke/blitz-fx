#include "ShadowCommon.hlsli"
#include "GBuffer.hlsli"
#include "Noise.hlsli"
#include "GameData.hlsli"

Texture2DArray<float> cascaded_shadow_map : register(t8);
SamplerComparisonState shadow_map_sampler : register(s9);

RWTexture2D<float> cascade_shadow_mask : register(u0);

[numthreads(8, 8, 1)]
void CSMain( uint3 thread_id : SV_DispatchThreadID )
{
    float device_depth = _g_buffer_depth.Load(int3(thread_id.xy, 0));
    [branch]
    if (device_depth == 0)
    {
        return;
    }
    float3 normal = _g_buffer_normal_roughness.Load(int3(thread_id.xy, 0)).xyz;
    normal -= 0.5;
    normal = normalize(normal);

    [branch]
    if (dot(normal, directional_light_direction.xyz) < 0)
    {
        float translucency = _g_buffer_albedo_translucency.Load(int3(thread_id.xy, 0)).w;
        uint stencil_bits = _g_buffer_stencil.Load(int3(thread_id.xy, 0)).y;
        if (translucency == 0 && (stencil_bits & STENCIL_BIT_CHARACTER) == 0)
        {
            cascade_shadow_mask[thread_id.xy] = 0;
            return;
        }
    }

    float3 world_position = NdcToWorldPosition(ThreadIdDepthToNdc(thread_id.xy, device_depth));

    uint g_buffer_mask = DecodeGBufferObjectMask(_g_buffer_specular_mask.Load(int3(thread_id.xy, 0)).w);

    // this works way better than using a golden ratio sequence
    // taken from GTAO presentation: https://blog.selfshadow.com/publications/s2016-shading-course/activision/s2016_pbs_activision_occlusion.pdf
    //
    // the reason for this is that the golden ratio samples are not evenly distributed
    // especially for low sample counts
    // TODO: formulate this a bit more acedemically/mathemaically
    float rotations[] = { 60.f, 300.f, 180.f, 240.f, 120.f, 0.f };

    float rotation_01 = rotations[frame_counter % 6] * (1.0 / 360.0f);
    float noise = frac(GetStaticBlueNoise(thread_id.xy) + rotation_01);

    CascadeShadowArgs cascade_shadow_args;
    cascade_shadow_args.shadow_map = cascaded_shadow_map;
    cascade_shadow_args.shadow_sampler = shadow_map_sampler;
    cascade_shadow_args.world_position = world_position;
    cascade_shadow_args.noise_01 = noise;
    cascade_shadow_args.is_vegetation_shadow = g_buffer_mask & 26;

    cascade_shadow_mask[thread_id.xy] = ComputeCascadeShadowPCSS(cascade_shadow_args, 16);
}