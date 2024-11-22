#ifndef SHADOW_COMMON_HLSLI
#define SHADOW_COMMON_HLSLI
#include "Common.hlsli"
#include "CustomData.hlsli"
#include "GameData.hlsli"

#define GOLDEN_ANGLE 2.39996f

float2 VogelDiskSample(int sample_index, float rcp_sample_clount, float phi, float scale)
{
    float r = sqrt((sample_index + 0.5) * rcp_sample_clount) * scale;
    float theta = sample_index * GOLDEN_ANGLE + phi;

    float sine, cosine;
    sincos(theta, sine, cosine);

    return float2(cosine, sine) * r;
}

SamplerState _point_sampler;

Texture2DArray<float> _cascade_shadow_map;
Texture2DArray<float> _cloud_shadow_map;
Texture2DArray<float> _terrain_shadow_height_map;

struct CascadeShadowArgs
{
    Texture2DArray<float> shadow_map;
    SamplerComparisonState shadow_sampler;
    float3 world_position;
    float noise_01;
    bool is_vegetation_shadow;
};

float ComputeCascadeShadowPCSS(CascadeShadowArgs args, const int shadow_sample_count)
{
    const float4 icb[] =
    {
        {1.000000, 0, 0, 0},
        {0, 1.000000, 0, 0},
        {0, 0, 1.000000, 0},
        {0, 0, 0, 1.000000}
    };

    float4 r3;
    float4 r4;
    float4 r5;

    float3 shadow_space_position = mul(float4(args.world_position, 1), directional_shadow_matrix);

    if (abs(shadow_space_position.z) >= 0.999)
    {
        return 1;
    }
    r3.xyzw = shadow_space_position.x - cb13_8.xyzw;
    r4.xyzw = shadow_space_position.y - cb13_9.xyzw;
    r3.xyzw = max(abs(r4.xyzw), abs(r3.xyzw));
    r4.xyzw = r3.xyzw < cb13_10.xyzw ? 1 : 0;
    r5.xyzw = float4(0.5, 1.5, 2.5, 3.5) < cascade_count ? 1 : 0;

    float num_cascades_in_range = dot(r4.xyzw, r5.xyzw);
    [branch]
    if (num_cascades_in_range < 0.5)
    {
        return 1;
    }

    r3.xyzw /= cb13_10.xyzw;
    r5.xyzw = 1 - cb13_17.xyzw;
    r3.xyzw -= r5.xyzw;
    r3.xyzw = saturate(r3.xyzw / cb13_17.xyzw);

    // had to fix this instruction
    // https://docs.microsoft.com/en-us/windows/win32/direct3dhlsl/ubfe--sm5---asm-

    uint cascade_index = cascade_count - num_cascades_in_range;
    uint max_cascade_index = cascade_count - 1;
    uint cascade_index_dither = args.noise_01 < dot(r3.xyzw, icb[cascade_index].xyzw) ? 1 : 0;
    cascade_index = min(cascade_index + cascade_index_dither, max_cascade_index);

    r4.zw = cascade_shadow_params[cascade_index].tex_coord_scale * float2(1, -1);
    float2 shadow_tex_coord = shadow_space_position.xy * r4.zw + cascade_shadow_params[cascade_index].tex_coord_offset;

    float filter_radius = args.is_vegetation_shadow
                              ? speed_tree_cascade_shadow_params[cascade_index].filter_radius
                              : cascade_shadow_params[cascade_index].filter_radius;
    float speed_tree_shadow_gradient = args.is_vegetation_shadow
                                           ? speed_tree_cascade_shadow_params[cascade_index].shadow_gradient
                                           : 0;
    float shadow_map_depth = shadow_space_position.z;
    float noise = args.noise_01 * PI_2;
    float cascade_penumbra_relative_scale
        = cascade_shadow_params[cascade_index].tex_coord_scale / cascade_shadow_params[0].tex_coord_scale;
    cascade_penumbra_relative_scale *= cascade_penumbra_scale;

    const float max_scale = 0.01;
    const float rcp_sample_count = 1.0f / shadow_sample_count;
    const float vegetation_offset_scale = 16.0f / shadow_sample_count;

    [branch]
    if (enable_soft_shadows)
    {
        float avgBlockersDepth = 0.0f;
        uint blockersCount = 0.0f;
        
        float blocker_search_radius = cascade_penumbra_relative_scale * max_scale;

        float center_sample_depth = args.shadow_map.SampleLevel(_point_sampler, float3(shadow_tex_coord, cascade_index), 0);
        [flatten]
        if (center_sample_depth < shadow_map_depth)
        {
            avgBlockersDepth += center_sample_depth;
            blockersCount += 1;
        }

#ifndef LOOP_SHADOW_SAMPLES
        [unroll]
#endif
        for (int i = 0; i < shadow_sample_count; i++)
        {
            float2 sample_offset = VogelDiskSample(i, rcp_sample_count, noise, blocker_search_radius);
            float2 offset_tex_coord = shadow_tex_coord + sample_offset;
            float4 sample_depths = args.shadow_map.GatherRed(_point_sampler, float3(offset_tex_coord, cascade_index), 0);
            float4 is_blocker = sample_depths < shadow_map_depth;
            avgBlockersDepth += dot(is_blocker, sample_depths);
            blockersCount += is_blocker.x + is_blocker.y + is_blocker.z + is_blocker.w;
        }

        [branch]
        if (blockersCount == 0)
        {
            return 1;
        }
        [branch]
        if (blockersCount == 4 * shadow_sample_count + 1 && !args.is_vegetation_shadow)
        {
            return 0;
        }

        avgBlockersDepth /= blockersCount;
        const float penumbra_scale = 32;
        float penumbra = cascade_shadow_map_depth_scale * penumbra_scale * (shadow_map_depth - avgBlockersDepth) / avgBlockersDepth;
        penumbra = min(penumbra, 1);

        filter_radius = max(filter_radius * 0.5, penumbra * cascade_penumbra_relative_scale * max_scale);
    }
   

    float shadow_factor;
    {
        shadow_factor = 0;
#ifndef LOOP_SHADOW_SAMPLES
        [unroll]
#endif
        for (int i = 0; i < shadow_sample_count; i++)
        {
            float2 sample_offset = VogelDiskSample(i, rcp_sample_count, noise, filter_radius);
            float2 offset_tex_coord = shadow_tex_coord + sample_offset;
            float depth_offset = speed_tree_shadow_gradient * 0.0370370373 * i * vegetation_offset_scale;

            // TODO: sample second mip level (exponential shadow) on penumbra > 0.4
            shadow_factor += args.shadow_map.SampleCmpLevelZero(args.shadow_sampler, float3(offset_tex_coord, cascade_index),
                                                                shadow_map_depth - depth_offset);
        }
        shadow_factor *= rcp_sample_count;
    }

    float distance_fade_factor = cascade_index >= max_cascade_index ? 1 : 0;
    shadow_factor += distance_fade_factor * dot(r3.xyzw, icb[max_cascade_index].xyzw);
    return min(1, shadow_factor);
}

struct CloudShadowArgs
{
    Texture2DArray<float> shadow_map;
    SamplerState shadow_sampler;
    float3 world_position;
};

float ComputeCloudShadow(CloudShadowArgs args)
{
    float3 r0;
    float4 r1;
    float4 r2;
    float4 r3;
    float3 r4;

    r0.y = 20 * weatherAndPrescaleParams.x;
    r2.zw = trunc(skyboxShadingParams.xy);
    r3.xyz = -cameraPosition.xyz + args.world_position;
    r0.z = dot(r3.xyz, r3.xyz);
    r0.z = sqrt(r0.z);
    r3.xy = windParams.xy;
    r3.z = 0;
    r3.xyz = r3.xyz + args.world_position;
    r3.xyz = float3(0.00999999978, 0.00999999978, 0.00999999978) * r3.xyz;
    r3.xyz = r3.xyz / weatherAndPrescaleParams.xxx;
    r4.xy = float2(20, 20) * windParams.xy;
    r4.z = 0;
    r1.xyz = r4.xyz + args.world_position;
    r1.xyz = float3(0.00999999978, 0.00999999978, 0.00999999978) * r1.xyz;
    r1.xyz = r1.xyz / r0.yyy;
    r3.zw = directional_light_direction.xy * r3.zz;
    r3.zw = r3.zw / directional_light_direction.zz;
    r2.xy = r3.xy + -r3.zw;
    r1.zw = directional_light_direction.xy * r1.zz;
    r1.zw = r1.zw / directional_light_direction.zz;
    r1.xy = r1.xy + -r1.zw;
    r0.y = args.shadow_map.SampleLevel(args.shadow_sampler, r2.xyz, 1).x;
    r2.x = args.shadow_map.SampleLevel(args.shadow_sampler, r2.xyw, 1).x;
    r2.x = r2.x + -r0.y;
    r0.y = weatherAndPrescaleParams.w * r2.x + r0.y;
    r1.zw = r2.zw;
    r1.z = args.shadow_map.SampleLevel(args.shadow_sampler, r1.xyz, 1).x;
    r1.x = args.shadow_map.SampleLevel(args.shadow_sampler, r1.xyw, 1).x;
    r1.x = r1.x + -r1.z;
    r1.x = weatherAndPrescaleParams.w * r1.x + r1.z;
    r1.y = -0.25 + directional_light_direction.z;
    r1.y = saturate(10 * r1.y);
    r0.z = -100 + r0.z;
    r0.z = saturate(0.00666666683 * r0.z);
    r1.x = r1.x + -r0.y;
    r0.y = r0.z * r1.x + r0.y;
    r0.y = -r1.y * r0.y + 1;

    return r0.y;
}


struct TerrainShadowArgs
{
    Texture2DArray<float> shadow_height_map;
    SamplerState shadow_sampler;
    float3 world_position;
    bool is_on_terrain;
    float2 bias_offset_scale;
};

float ComputeTerrainShadow(TerrainShadowArgs args)
{
    float4 r0;
    float4 r1;
    float3 r2;
    float4 r3;
    float2 r4;
    float4 r5;

    r2.xy = args.is_on_terrain ? args.bias_offset_scale : float2(-10000, 0);

    r0.w = distance(args.world_position.xy, cameraPosition.xy);
    r1.w = distance(args.world_position.xyz, cameraPosition.xyz);
    if (r0.w < terrain_shadow_distance)
    {
        r2.y = max(0.1, r2.y);
        r2.y = 1 / r2.y;
        r2.z = cb13_37.z * r0.w;
        r2.z = max(1, r2.z);
        r2.z = cb13_36_x / r2.z;
        r2.y = min(r2.y, r2.z);
        r1.w = r1.w * 0.02 + 0.05;
        r0.w = cb13_36_z + r0.w;
        r0.w = saturate(cb13_36_w * r0.w);
        r3.y = args.world_position.z;

        for (int i = 0; i < terrain_shadow_mip_count; i++)
        {
            r4.xy = -terrain_tex_coord_params[i].offset + args.world_position.xy;
            r5.xy = terrain_tex_coord_params[i].scale * r4.xy;

            [branch]
            if (all(r5.xy >= 0 && r5.xy <= 1))
            {
                r5.z = i;
                r5.w = 1 - r4.y * terrain_tex_coord_params[i].scale.y;
                r3.w = args.shadow_height_map.SampleLevel(args.shadow_sampler, r5.xwz, 0).x;
                r3.w = terrain_height_scale * r3.w + terrain_height_bias;
                r4.x = -r3.y + r2.x;
                r4.x = abs(r4.x) < r1.w ? r2.x : r3.y;
                r3.w = -0.1 + r3.w;
                r3.w = r3.w + -r4.x;
                r3.w = saturate(r3.w * r2.y);
                r3.w = 1 + -r3.w;
                r4.x = 1 + -r3.w;
                r3.w = r0.w * r4.x + r3.w;
                return r3.w;
            }
        }
    }
    return 1;
}

struct DirectionalShadowArgs
{
    float3 world_position;

    Texture2DArray<float> cascade_shadow_map;
    SamplerComparisonState cascade_shadow_sampler;
    float noise_01;
    bool is_vegetation_shadow;

    Texture2DArray<float> cloud_shadow_map;
    SamplerState cloud_shadow_sampler;

    Texture2DArray<float> terrain_shadow_height_map;
    SamplerState terrain_shadow_sampler;
};

float ComputeDirectionalShadow(DirectionalShadowArgs args, const int cascade_shadow_sample_count)
{
    TerrainShadowArgs terrain_shadow_args;
    terrain_shadow_args.shadow_height_map = args.terrain_shadow_height_map;
    terrain_shadow_args.shadow_sampler = args.terrain_shadow_sampler;
    terrain_shadow_args.world_position = args.world_position;
    terrain_shadow_args.is_on_terrain = false;
    terrain_shadow_args.bias_offset_scale = 0;
    float shadow_factor = ComputeTerrainShadow(terrain_shadow_args);

    [branch]
    if (shadow_factor > 0)
    {
        CascadeShadowArgs cascade_shadow_args;
        cascade_shadow_args.shadow_map = args.cascade_shadow_map;
        cascade_shadow_args.shadow_sampler = args.cascade_shadow_sampler;
        cascade_shadow_args.world_position = args.world_position;
        cascade_shadow_args.noise_01 = args.noise_01;
        cascade_shadow_args.is_vegetation_shadow = false;
        shadow_factor *= ComputeCascadeShadowPCSS(cascade_shadow_args, cascade_shadow_sample_count);

        CloudShadowArgs cloud_shadow_args;
        cloud_shadow_args.shadow_map = args.cloud_shadow_map;
        cloud_shadow_args.shadow_sampler = args.cloud_shadow_sampler;
        cloud_shadow_args.world_position = args.world_position;
        shadow_factor *= ComputeCloudShadow(cloud_shadow_args);
    }
    return shadow_factor;
}


#endif
