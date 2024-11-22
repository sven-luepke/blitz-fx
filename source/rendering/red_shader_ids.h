#pragma once

namespace w3
{
enum class RedVertexShaderId
{
    VEGETATION_SHADOW_0,
    VEGETATION_SHADOW_1,
    VEGETATION_SHADOW_2,
    VEGETATION_BRANCH,
    FOLIAGE_0,
    FOLIAGE_1,
    FOLIAGE_2,
    GRASS,
    TREE_BILLBOARD,
    SUN,
    HAIR,
    CLOUD_DOME,
    CLOUD_DOME_STORM,
    CLOUD_SPRITE,
    WATER,
    HAIR_TRANSPARENCY,
    SMOKE_SPRITE,
    UNKNOWN,
};

enum class RedHullShaderId
{
    TERRAIN_0,
    TERRAIN_1,
    UNKNOWN
};

enum class RedDomainShaderId
{
    HAIRWORKS_0,
    UNKNOWN
};

enum class RedPixelShaderId
{
    REFLECTION_PROBE_SHADOW,
    REFLECTION_PROBE_FOG_AMBIENT,
    // renders ambient lighting and fog to a reflection probe
    IRRADIANCE_PROBE,
    REFLECTION_PROBE_BLUR,
    TERRAIN_NOVIGRAD,
    UNDERWATER_MODIFY_GBUFFER,
    SHADOW,
    SHADOW_ANSEL,
    DEFERRED_POINT_LIGHT_0,
    DEFERRED_POINT_LIGHT_1,
    DEFERRED_POINT_LIGHT_2,
    DEFERRED_POINT_LIGHT_3,
    DEFERRED_POINT_LIGHT_SHADOWED_0,
    DEFERRED_POINT_LIGHT_SHADOWED_1,
    DEFERRED_POINT_LIGHT_SHADOWED_2,
    DEFERRED_POINT_LIGHT_SHADOWED_3,
    DEFERRED_POINT_LIGHT_SHADOWED_4,
    DEFERRED_POINT_LIGHT_UNKNOWN,
    // seems to be our own shader ???
    HAIR,
    HAIRWORKS,
    HAIRWORKS_POST_RESOLVE,
    FOG,
    SKY,
    SKY_BOB,
    SUN,
    CLOUD_DOME,
    // standard cirrus/altostratus
    CLOUD_DOME_STORM,
    // altostratus during storms
    CLOUD_SPRITE,
    WATER,
    WATER_SKY_REFLECTION_PARABOLOID,
    WATER_REFLECTION_FALLBACK_0,
    WATER_REFLECTION_FALLBACK_1,
    UNDERWATER_MASK,
    UNDERWATER_FOG,
    HAIR_TRANSPARENCY,
    FIRE_SPARK,
    RAIN_DROPS,
    RAIN_DROPS_BOB,
    TONEMAP_0,
    TONEMAP_1,
    DOF_GAMEPLAY_SETUP,
    DOF_GAMEPLAY_BLUR,
    DOF_CUTSCENE_BLUR,
    DOF_CUTSCENE_COMBINE,
    ANTI_ALIASING,
    UNKNOWN,
};

enum class RedComputeShaderId
{
    WATER_FFT_INIT,
    WATER_FFT_TO_TEXTURE,
    DEFERRED_LIGHTING,
    UNKNOWN,
};

struct RedShaderBinding
{
    RedVertexShaderId vertex_shader;
    RedHullShaderId hull_shader;
    RedPixelShaderId pixel_shader;
    RedComputeShaderId compute_shader;
};
}
