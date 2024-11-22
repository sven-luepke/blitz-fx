#include "GameData.hlsli"
#include "Common.hlsli"
#include "Noise.hlsli"
#include "ShadowCommon.hlsli"
#include "GBuffer.hlsli"

Texture2D<float> cascade_shadow_mask : register(t42);
Texture2D<float2> packed_ss_shadow_data : register(t43);

void UnpackNormalOpacity(in float packed, out float3 normal, out float opacity)
{
    uint packed_int = asuint(packed);

    uint opacity_int = packed_int & 255;
    opacity = opacity_int / 255.0f;

    uint3 normal_int = (packed_int >> uint3(8, 16, 24)) & 255;
    normal = normal_int / 255.0f;

    normal = DecompressGBufferNormal(normal);
}

SamplerState _point_border_sampler;

#define STEPS 16
#define THICKNESS_DEPTH_SCALE 0.008 

float ScreenSpaceShadows(float3 world_position, float noise_01, bool is_tree_sprite, float max_object_thickness, float bias_scale, float lighting, bool do_nms)
{
    // Compute ray step
    float3 ray_dir = directional_light_direction.xyz * 0.05; // scaled to prevent ray end from being in front of the near clipping plane
    // TODO: fix cutscene shadow flickering here?

    float4 ray_pos_clip = mul(view_projection_matrix, float4(world_position, 1));
    float4 ray_end_clip = mul(view_projection_matrix, float4(world_position + ray_dir, 1));

    float3 ray_pos_ndc = ray_pos_clip.xyz / ray_pos_clip.w;
    ray_pos_ndc.xy = ray_pos_ndc.xy * float2(0.5, -0.5) + 0.5;
    float3 ray_end_ndc = ray_end_clip.xyz / ray_end_clip.w;
    ray_end_ndc.xy = ray_end_ndc.xy * float2(0.5, -0.5) + 0.5;
    float3 ray_step_ndc = ray_end_ndc - ray_pos_ndc;

    // unify length in screen space
    float length_uv = max(length(ray_step_ndc.xy), 0.0001);

    const float pixels_per_step = 6;

    float resolution_scale = screenDimensions.y / 1920.0f;
    ray_step_ndc = (ray_step_ndc / length_uv) * screenDimensions.z * pixels_per_step * resolution_scale;

    float rotations[] = { 60.f, 300.f, 180.f, 240.f, 120.f, 0.f };
    //float rotation_01 = rotations[frame_counter % 6] * (1.0 / 360.0f);
    //float noise = frac(noise_01 + rotation_01);
    float noise = noise_01;

    float offset = noise;
    offset += is_tree_sprite ? -0.5 : 0.5;
    ray_pos_ndc += ray_step_ndc * offset;
   
    float bias = is_tree_sprite ? 0.0005 : 0.003;
    bias *= bias_scale;

    float max_light_amount = 0;
    float min_slope = 1;
    float nms_dot_sum = lighting;
    [unroll]
    for (uint i = 0; i < STEPS; i++)
    {
        float2 ray_uv = ray_pos_ndc.xy;

        // Compute the difference between the ray's and the camera's depth
        float2 packed_data = packed_ss_shadow_data.SampleLevel(_point_border_sampler, ray_uv, 0);
        float scene_depth = packed_data.x;

        float3 normal;
        float opacity;
        UnpackNormalOpacity(packed_data.y, normal, opacity);

        float ray_depth = DeviceToSceneDepth(ray_pos_ndc.z);

        ray_depth -= ray_depth * bias;

        if (abs(ray_depth - scene_depth) < 0.1) // TODO: improve this check
        {
            nms_dot_sum += dot(directional_light_direction.xyz, normal);
            if (nms_dot_sum < 0)
            {
                min_slope = 0; // TODO: add softness calculation (see NMS paper)
            }
        }        

        float depth_delta = ray_depth - scene_depth;

        float object_thickness = min(0.04f + ray_depth * THICKNESS_DEPTH_SCALE, max_object_thickness);
        float shadow_hardness = 400;

        float light_amount = saturate(depth_delta * shadow_hardness) * saturate((-depth_delta + object_thickness) * shadow_hardness);

        max_light_amount = max(max_light_amount, light_amount * opacity);

        ray_pos_ndc += ray_step_ndc;
    }

    float shadow_factor = 1 - max_light_amount;
    if (do_nms)
    {
        shadow_factor *= min_slope;
    }
    return shadow_factor;
}

bool DoScreenSpaceShadows(uint object_mask, uint stencil_bits)
{
    if (object_mask & G_BUFFER_OBJECT_MASK_HIGH_RES_TREE || object_mask == G_BUFFER_OBJECT_MASK_TRANSLUCENT || object_mask == G_BUFFER_OBJECT_MASK_HAIR)
    {
        return false;
    }
    return true;
}

RWTexture2D<float> screen_space_shadow_mask : register(u0);

[numthreads(8, 8, 1)]
void CSMain(uint3 thread_id : SV_DispatchThreadID)
{
    float cascade_shadow_factor = cascade_shadow_mask.Load(int3(thread_id.xy, 0));
    float shadow_factor = 1;
    [branch]
    if (cascade_shadow_factor > 0)
    {
        float device_depth = _g_buffer_depth.Load(int3(thread_id.xy, 0));
        uint object_mask = DecodeGBufferObjectMask(_g_buffer_specular_mask.Load(int3(thread_id.xy, 0)).w);
        uint stencil_bits = _g_buffer_stencil.Load(int3(thread_id.xy, 0)).y;

        bool do_sss = DoScreenSpaceShadows(object_mask, stencil_bits);
        [branch]
        if (device_depth > 0 && do_sss)
        {
            float2 packed_data = packed_ss_shadow_data.Load(int3(thread_id.xy, 0));

            float3 normal;
            float opacity;
            UnpackNormalOpacity(packed_data.y, normal, opacity);

            float3 world_position = NdcToWorldPosition(ThreadIdDepthToNdc(thread_id.xy, device_depth));
            float lighting = dot(normal, directional_light_direction.xyz);
            float n_dot_l = max(0, lighting);
        
            bool is_grass = object_mask & G_BUFFER_OBJECT_MASK_GRASS;
            if (is_grass)
            {
                // offset to prevent self shadowing
                world_position += directional_light_direction.xyz * 0.07;
            }

            bool do_nms = do_sss;
            bool is_character = stencil_bits & STENCIL_BIT_CHARACTER;
            bool is_tree_sprite = object_mask & G_BUFFER_OBJECT_MASK_TREE_SPRITE;
            if (lighting >= 0 || stencil_bits & STENCIL_BIT_CHARACTER || is_grass || opacity == 0 || is_tree_sprite)
            {
                
                float3 view_direction = normalize(cameraPosition.xyz - world_position);

                if (is_tree_sprite)
                {
                    world_position += view_direction * (max(0, dot(-view_direction.xy, directional_light_direction.xy) * 2 - 1)) * 3;
                }

                
                if (is_character)
                {
                    do_nms = false;
                }
                float max_object_thickness = is_character ? 0.1 : 4;
                float bias_scale = is_character ? 0.1 : 0.2 + (1 - n_dot_l) * 0.8;
                shadow_factor = ScreenSpaceShadows(world_position, GetStaticBlueNoise(thread_id.xy).r, is_tree_sprite, max_object_thickness, bias_scale, lighting, do_nms);
            }
        }
    }
    screen_space_shadow_mask[thread_id.xy] = shadow_factor;
}
