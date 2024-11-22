#ifndef WATER_COMMON_HLSLI
#define WATER_COMMON_HLSLI
#include "Common.hlsli"
#include "ScatteringCommon.hlsli"
#include "GameData.hlsli"
#include "CustomData.hlsli"
#include "FrustumVolumeCommon.hlsli"
#include "ShadowCommon.hlsli"

cbuffer cb0 : register(b0)
{
float4 cb0[15];
}

#define Time (cb0[0].x)

#define cmp -

Texture2D<float> _caustics_texture : register(t70);
Texture2D<float3> _unfogged_scene;
Texture2D<float3> _water_sky_ambient;
Texture2D<float3> _underwater_reflection_fallback_paraboloid;
Texture2D<float> _water_depth;
Texture3D<float> _water_depth_volume;

#define WATER_BASE_ABSORBTION (float3(0.35, 0.07, 0.03) * 0.1)
#define WATER_BASE_SCATTERING (float3(0.0007, 0.0021, 0.0025) * 0.1)

#define WATER_DEPTH_SCALE water_depth_scale

#define WATER_AMBIENT_ADD 0.1

#define WATER_SCATTERING_ANISOTROPY underwater_fog_anisotropy

SamplerState _linear_sampler;

cbuffer _GameWaterTextureParams
{
float _water_texture_param_0;
float water_wind_scale;
float _water_texture_param_2;
float _water_texture_param_3;
}

void GetWaterScatteringAbsorbtion(out float3 scattering_coefficient, out float3 absorbtion_coefficient)
{
    scattering_coefficient = water_scattering_coefficient;
    absorbtion_coefficient = water_absorbtion_coefficient;
}

SamplerState _linear_wrap_sampler;

float GetCaustics(float3 world_position, float3 light_direction, float strength, float time)
{
    [branch]
    if (strength == 0)
    {
        return 1;
    }
    float2 position = world_position.xy - light_direction.xy * world_position.z / light_direction.z;

    // TODO: align with wind direction
    float t = time * 0.05;
    float caustics = _caustics_texture.SampleLevel(_linear_wrap_sampler, position.xy * 0.2 + float2(1, 0.5) * t * 1.9, 0);
    float c2 = _caustics_texture.SampleLevel(_linear_wrap_sampler, position.xy * 0.2 + float2(-1, 0) * t + 0.1, 0);
    caustics = min(caustics, c2);
    return lerp(1, caustics * 6, strength);
}

float GetExteriorFactor(float2 dimmer_texture_sample, float3 world_position)
{
    float3 r5;
    float4 r9;
    float3 r10;
    float4 r11;
    float r7z;

    r9.xyz = -cameraPosition.xyz + world_position.xyz;
    r5.x = dot(r9.xyz, r9.xyz);
    r5.x = sqrt(r5.x);
    r10.x = worldToView[0].z;
    r10.y = worldToView[1].z;
    r10.z = worldToView[2].z;
    r5.z = dot(r10.xyz, r9.xyz);
    r7z = 1 / cameraNearFar.y;
    r7z = r7z * r5.x;
    r5.z = r7z / r5.z;
    r5.z = r5.x + -r5.z;
    r5.z = saturate(dimmer_params_0.w * r5.z);
    r5.z = dimmer_params_0.z * r5.z;
    r5.z = max(0.00100000005, r5.z);
    r5.x = r5.x / dimmer_params_1.z;
    if (dimmer_texture_sample.x < dimmer_texture_sample.y)
    {
        // camera outside interior
        r9.y = dimmer_params_1.z * dimmer_texture_sample.x + -dimmer_params_1.x;
        r9.y = saturate(-r9.y * dimmer_params_1.y + 1);
        r9.z = r5.x + -dimmer_texture_sample.x;
        r9.z = dimmer_params_1.z * r9.z;
        r9.z = saturate(r9.z / r5.z);

        r11.y = r9.y * r9.z;
        r11.x = 1;
        r9.xy = r5.x < dimmer_texture_sample.x || dimmer_texture_sample.y < r5.x ? float2(0, 1) : r11.xy;
    }
    else
    {
        // camera inside interior
        r7z = cmp(dimmer_texture_sample.y < dimmer_texture_sample.x);
        r9.z = cmp(r5.x < dimmer_texture_sample.y);
        r9.w = cmp(dimmer_texture_sample.x < r5.x);

        dimmer_texture_sample.x = dimmer_params_1.z * dimmer_texture_sample.x + -dimmer_params_1.x;
        r11.y = saturate(-dimmer_texture_sample.x * dimmer_params_1.y + 1);
        dimmer_texture_sample.x = r5.x + -dimmer_texture_sample.y;
        dimmer_texture_sample.x = dimmer_params_1.z * dimmer_texture_sample.x;
        dimmer_texture_sample.x = saturate(dimmer_texture_sample.x / r5.z);

        r11.w = 1 + -dimmer_texture_sample.x;
        r11.xz = float2(1, 1);
        float2 tmp = r9.ww ? r11.xy : r11.zw;
        tmp = r9.zz ? float2(1, 1) : tmp;
        r9.xy = r7z ? tmp : float2(0, 1);
    }
    float2 dimmer = r9.xy;

    float exterior_factor = dimmer.x * -dimmer.y + 1;
    return exterior_factor;
}

struct RaymarchWaterParams
{
    float3 ray_start;
    float3 ray_direction;
    float surface_height;
    float total_ray_length;
    float step_size;
    float step_increment;
    float3 slice_scattering;
    float3 slice_extinction;
    float3 ambient_scattering;
    float3 ambient_scattering_add;
    bool is_underwater;
    float2 interior_dimmer_sample;
};

void RaymarchDirectionalWaterScattering(
    RaymarchWaterParams params, out float3 accum_scattering, out float3 accum_transmittance
)
{
    accum_scattering = 0;
    accum_transmittance = 1;
    float current_ray_length = 0;
    bool is_last_step = false;
    float3 ray_position = params.ray_start;
    float ambient_transmittance_depth_scale = 0.25;
    float rcp_light_direction = rcp(abs(water_refracted_directional_light_direction.z));

    CloudShadowArgs cloud_shadow_args;
    cloud_shadow_args.shadow_map = _cloud_shadow_map;
    cloud_shadow_args.shadow_sampler = _linear_wrap_sampler;
    while (true)
    {
        current_ray_length += params.step_size;
        [branch]
        if (current_ray_length >= params.total_ray_length)
        {
            params.step_size = params.total_ray_length - (current_ray_length - params.step_size);
            current_ray_length = params.total_ray_length;
            is_last_step = true;
        }
        ray_position += params.step_size * params.ray_direction;

        float ray_to_surface_distance = max(0, params.surface_height - ray_position.z);

        float ray_to_surface_sun_distance = ray_to_surface_distance * rcp_light_direction;
        float3 ray_to_sun_transmittance = water_refracted_directional_light_fraction * exp(
            -ray_to_surface_sun_distance * params.slice_extinction);

        float3 in_scattering = params.slice_scattering * ray_to_sun_transmittance;

        float ambient_caustics_scale = 1; // scale directional lighting && ambient
#ifdef UNDERWATER_RAYMARCH_FULL_QUALITY
        if (params.is_underwater)
        {
            ambient_caustics_scale = GetExteriorFactor(params.interior_dimmer_sample, ray_position);
        }

        // fade out caustics in the distance
        float caustic_strength = 1 - Rescale(20, 25, current_ray_length);
        float caustics = GetCaustics(ray_position, water_refracted_directional_light_direction, caustic_strength, game_time);
        in_scattering *= caustics * ambient_caustics_scale; // TODO: scale directional lighting with volumetric shadow factor

        cloud_shadow_args.world_position = ray_position;
        in_scattering *= ComputeCloudShadow(cloud_shadow_args);
#endif

        float3 ambient_transmittance = exp(-ray_to_surface_distance * params.slice_extinction * ambient_transmittance_depth_scale);
        in_scattering += params.ambient_scattering * ambient_transmittance * ambient_caustics_scale * 0.5; // scale sky ambient by 0.5 to account for total internal reflection
        in_scattering += params.ambient_scattering_add;

        ScatteringIntegrationStep(accum_scattering, accum_transmittance, in_scattering, params.slice_extinction, params.step_size);

        if (is_last_step || all(accum_transmittance < 0.0001))
        {
            break;
        }
        params.step_size *= params.step_increment;
    }
}

float FresnelSchlick(float cosTheta, float F0)
{
    return F0 + (1.0 - F0) * pow(clamp(1.0 - cosTheta, 0.0, 1.0), 5.0);
}
float3 FresnelSchlick(float cosTheta, float3 F0)
{
    return F0 + (1.0 - F0) * pow(clamp(1.0 - cosTheta, 0.0, 1.0), 5.0);
}

float DistributionGGX(float3 N, float3 H, float roughness)
{
    float a = roughness * roughness;
    float a2 = a * a;
    float NdotH = max(dot(N, H), 0.0);
    float NdotH2 = NdotH * NdotH;

    float num = a2;
    float denom = (NdotH2 * (a2 - 1.0) + 1.0);
    denom = PI * denom * denom;

    return num / denom;
}

float GeometrySchlickGGX(float NdotV, float roughness)
{
    float r = (roughness + 1.0);
    float k = (r * r) / 8.0;

    float num = NdotV;
    float denom = NdotV * (1.0 - k) + k;

    return num / denom;
}
float GeometrySmith(float3 N, float3 V, float3 L, float roughness)
{
    float NdotV = max(dot(N, V), 0.00001);
    float NdotL = max(dot(N, L), 0.0);
    float ggx2 = GeometrySchlickGGX(NdotV, roughness);
    float ggx1 = GeometrySchlickGGX(NdotL, roughness);

    return ggx1 * ggx2;
}

float mip_map_level(in float2 texture_coordinate) // in texel units
{
    float2 dx_vtc = ddx(texture_coordinate);
    float2 dy_vtc = ddy(texture_coordinate);
    float delta_max_sqr = max(dot(dx_vtc, dx_vtc), dot(dy_vtc, dy_vtc));
    return 0.5 * log2(delta_max_sqr);
}

float3 ComputeDirectionalLighting(float3 normal, float3 albedo, float shadow_factor, float3 world_position)
{
    float3 direct_lighting = max(0, dot(normal, directional_light_direction.xyz)) * PI_RCP;

    float r1 = distance(cameraPosition.xy, world_position.xy);

    float tmp3 = saturate(world_position.z * lightColorParams.z + lightColorParams.w);
    float3 r10 = -sun_color_light_opposite_side.xyz + sun_color_light_side.xyz;
    r10.xyz = tmp3 * r10.xyz + sun_color_light_opposite_side.xyz;
    r1.x = saturate(r1.x * lightColorParams.x + lightColorParams.y);
    r10.xyz = -directional_light_color.rgb + r10.xyz;
    float3 light_color = r1.xxx * r10.xyz + directional_light_color.rgb;

    return direct_lighting * light_color * albedo * shadow_factor;
}

float2 ComputeRefractionTexCoord(float2 tex_coord, float3 world_position, float3 n, float3 v, float surface_to_scene_depth,
                                 bool is_above_water)
{
    float ior = is_above_water ? 0.7519 : 1.33;

    // compute view ray refraction as if the water surface was view directly from above
    // this creates a somewhat realistic refraction while avoiding artifacts due to limited screen space data
    float3 refracted_view_vector = refract(float3(0, 0, -1), n, ior);
    float water_to_scene_depth = min(surface_to_scene_depth, 1.5);
    float3 delta_vector = (normalize(refracted_view_vector) - float3(0, 0, -1)) * water_to_scene_depth;
    float3 refracted_world_position = world_position.xyz + delta_vector;

    float4 refracted_ndc = mul(view_projection_matrix, float4(refracted_world_position, 1));
    float2 refracted_tex_coord = NdcXYToTexCoord(refracted_ndc.xy / refracted_ndc.w);

    // clamp tex coord offset
    float2 offset = refracted_tex_coord - tex_coord;
    float offset_distance = length(float2(offset.x * screenDimensions.y * screenDimensions.z, offset.y));
    offset /= offset_distance;
    offset *= min(0.05, offset_distance);
    refracted_tex_coord = tex_coord + offset;

    return refracted_tex_coord;
}

float3 GetUnderwaterDirectionalLightScale(float water_depth, float3 world_position)
{
    [branch]
    if (water_depth <= 0)
    {
        return 1;
    }

    water_depth = max(0, water_depth);
    float3 scattering_coefficient, absorbtion_coefficient;
    GetWaterScatteringAbsorbtion(scattering_coefficient, absorbtion_coefficient);
    float3 extinction_coefficient = absorbtion_coefficient + scattering_coefficient;
    float sun_to_floor_distance = water_depth / abs(water_refracted_directional_light_direction.z);
    float caustics = GetCaustics(world_position.xyz, water_refracted_directional_light_direction, 1, game_time);
    caustics = lerp(1, caustics, saturate(water_depth * 1.5));
    float3 directional_light_scale = exp(-sun_to_floor_distance * extinction_coefficient) *
        water_refracted_directional_light_fraction;
    directional_light_scale *= caustics;

    return lerp(1, directional_light_scale, Rescale(0.01, 0.05, water_depth));
}

void UnderwaterModifyAmbientLighting(in float water_depth, in float exterior_lighting_scale, inout float3 diffuse_ambient_lighting, inout float3 specular_ambient_lighting)
{
    [branch]
    if (water_depth <= 0)
    {
        return;
    }

    // reduce ambient lighting under water due to total internal reflection
    float underwater_ambient_factor = smoothstep(0.0, 3, water_depth);
    float ambient_light_scale = 1 - 0.5 * underwater_ambient_factor;
    diffuse_ambient_lighting *= ambient_light_scale;
    specular_ambient_lighting *= ambient_light_scale;

    // add ambient lighting caused by reflection off the water surface
    float3 underwater_fog_color = _underwater_reflection_fallback_paraboloid.SampleLevel(_linear_sampler, 0.5, 0) * exterior_lighting_scale * 0.25 * (1 - underwater_fog_anisotropy);
   
    underwater_fog_color *= underwater_ambient_factor;
    diffuse_ambient_lighting += underwater_fog_color;
    specular_ambient_lighting += underwater_fog_color;

    float3 extinction = water_scattering_coefficient + water_absorbtion_coefficient;
    float3 ambient_transmittance = exp(-max(0, water_depth * 0.25) * extinction);
    diffuse_ambient_lighting *= ambient_transmittance;
    specular_ambient_lighting *= ambient_transmittance;
}

cbuffer _WaterCb4
{
    float4 water_cb4[51];
}
Texture2DArray<float> _water_geometry_atlas;
Texture2D<float4> _water_wave_texture;
Texture2DArray<float> _terrain_height_map;
Texture2D<float4> _terrain_lut;

// Compute the depth of a point beneath the water surface
float ComputeWaterDepth(float3 world_position)
{
    float4 r0, r1, r4, r6, r7, r8, r9, r10, r11;
    float4 fDest;

    _terrain_lut.GetDimensions(0, fDest.x, fDest.y, fDest.z);
    r4.w = fDest.x;
    r4.w = (int) r4.w;
    r9.yzw = float3(0, 0, 0);
    r6.y = 0;
    r7.zw = float2(0, 0);
    r8.w = 0;
    while (true)
    {
        r10.x = cmp((int) r7.w >= (int) r4.w);
        r8.w = 0;
        if (r10.x != 0)
            break;
        r9.x = r7.w;
        r10.xyzw = _terrain_lut.Load(r9.xyz).xyzw;
        r10.xy = cmp(r10.xy < world_position.xy);
        r10.zw = cmp(world_position.xy < r10.zw);
        r9.x = r10.z ? r10.x : 0;
        r9.x = r10.y ? r9.x : 0;
        r9.x = r10.w ? r9.x : 0;
        if (r9.x != 0)
        {
            r7.z = r7.w;
            r8.w = -1;
            break;
        }
        r6.x = (int) r7.w + 1;
        r7.zw = r6.yx;
        r8.w = r9.x;
    }
    r9.x = r8.w ? r7.z : -1;
    r4.w = cmp((int) r9.x >= 0);
    if (r4.w != 0)
    {
        r9.yzw = float3(1, 0, 0);
        r10.xyzw = _terrain_lut.Load(r9.xww).xyzw;
        r11.xyzw = _terrain_lut.Load(r9.xyz).xyzw;
        _terrain_height_map.GetDimensions(0, fDest.x, fDest.y, fDest.z, fDest.w);
        r6.xy = fDest.xy;
        r7.zw = world_position.xy + -r10.xy;
        r9.yz = r10.zw + -r10.xy;
        r7.zw = r7.zw / r9.yz;
        r6.xy = float2(0.5, 0.5) / r6.xy;
        r6.xy = abs(r7.zw) + r6.xy;
        r7.zw = r11.zw + -r11.xy;
        r10.xy = r6.xy * r7.zw + r11.xy;
        r10.z = (int) r9.x;
        r4.w = _terrain_height_map.SampleLevel(_linear_sampler, r10.xyz, 0).x;
        r4.w = saturate(r4.w);
        r6.x = terrain_max_height - terrain_min_height;
        r4.w = r4.w * r6.x + terrain_min_height;
    }
    else
    {
        r4.w = -10;
    }

    float w1 = r4.w;

    r0.xy = float2(0, 0);
    while (true)
    {
        r0.z = cmp((int) r0.y >= asint(water_cb4[6].x));
        if (r0.z != 0)
            break;
        r0.zw = -water_cb4[r0.y + 7].xy + world_position.xy;
        r1.xy = r0.zw / water_cb4[r0.y + 7].zw;
        r1.z = (int) r0.y;
        r0.z = _water_geometry_atlas.SampleLevel(_linear_sampler, r1.xyz, 0).x;
        r0.w = cmp(0.00100000005 < abs(r0.z));
        if (r0.w != 0)
        {
            r0.x = r0.z;
            break;
        }
        r0.y = (int) r0.y + 1;
        r0.xy = r0.zy;
    }
    float d = r0.x;
    r0.y = -w1.x + r0.x;
    r0.z = -0.100000001 + abs(r0.y);
    r0.yzw = saturate(float3(-0.100000001, 0.204081625, 0.526315808) * r0.yzz);
    r0.zw = r0.zw * float2(0.699999988, 0.399999976) + float2(0.300000012, 0.600000024);
    r1.xyzw = world_position.xyxy / water_cb4[0].xxyy;
    r1.x = _water_wave_texture.SampleLevel(_linear_sampler, r1.xy, 0).w;
    r1.y = _water_wave_texture.SampleLevel(_linear_sampler, r1.zw, 0).w;
    r0.zw = water_cb4[1].xy * r0.zw;
    r0.w = r0.w * r1.y;
    r0.z = r0.z * r1.x + r0.w;
    r0.y = 1 + -r0.y;
    r0.y = r0.y * 0.899999976 + 0.100000001;
    r0.x = r0.y * r0.z + r0.x;

    float water_depth = max(r0.x - world_position.z, -10);

    return water_depth;
}

float SampleWaterDepthVolume(float3 world_position)
{
    float3 uv = WorldPositionToFrustumVolumeUV(world_position, water_depth_volume_params);
    return _water_depth_volume.SampleLevel(_linear_sampler, uv, 0);
}

#endif
