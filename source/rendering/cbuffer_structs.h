#pragma once
#include "frustum_volume.h"
#include "shader_types.h"

#include "DirectXMath.h"

namespace w3
{
struct GameFrameData
{
    float4 camera_position;
    DirectX::XMFLOAT4X4 view_matrix;
    float unused_0[32];
    DirectX::XMFLOAT4X4 projection_matrix;
    float unused_1[22];
    float near_plane;
    float far_plane;
    float screen_width;
    float screen_height;
    float screen_width_rcp;
    float screen_height_rcp;

    float4 numTiles; // Offset:  384 Index:    24
    DirectX::XMFLOAT4X4 lastFrameViewReprojectionMatrix; // Offset:  400 Index:    25
    DirectX::XMFLOAT4X4 lastFrameProjectionMatrix; // Offset:  464 Index:    29
    float4 localReflectionParam0; // Offset:  528 Index:    33
    float4 localReflectionParam1; // Offset:  544 Index:    34
    float4 speedTreeRandomColorFallback; // Offset:  560 Index:    35
    float4 translucencyParams0; // Offset:  576 Index:    36
    float4 translucencyParams1; // Offset:  592 Index:    37
    float4 fogSunDir; // Offset:  608 Index:    38
    float4 fogColorFront; // Offset:  624 Index:    39
    float4 fogColorMiddle; // Offset:  640 Index:    40
    float4 fogColorBack; // Offset:  656 Index:    41
    float4 fogBaseParams; // Offset:  672 Index:    42
    float4 fogDensityParamsScene; // Offset:  688 Index:    43
    float4 fogDensityParamsSky; // Offset:  704 Index:    44
    float4 aerialColorFront; // Offset:  720 Index:    45
    float4 aerialColorMiddle; // Offset:  736 Index:    46
    float4 aerialColorBack; // Offset:  752 Index:    47
    float4 aerialParams; // Offset:  768 Index:    48
    float4 speedTreeBillboardsParams; // Offset:  784 Index:    49
    float4 speedTreeParams; // Offset:  800 Index:    50
    float4 speedTreeRandomColorLumWeightsTrees; // Offset:  816 Index:    51
    float4 speedTreeRandomColorParamsTrees0; // Offset:  832 Index:    52
    float4 speedTreeRandomColorParamsTrees1; // Offset:  848 Index:    53
    float4 speedTreeRandomColorParamsTrees2; // Offset:  864 Index:    54
    float4 speedTreeRandomColorLumWeightsBranches; // Offset:  880 Index:    55
    float4 speedTreeRandomColorParamsBranches0; // Offset:  896 Index:    56
    float4 speedTreeRandomColorParamsBranches1; // Offset:  912 Index:    57
    float4 speedTreeRandomColorParamsBranches2; // Offset:  928 Index:    58
    float4 speedTreeRandomColorLumWeightsGrass; // Offset:  944 Index:    59
    float4 speedTreeRandomColorParamsGrass0; // Offset:  960 Index:    60
    float4 speedTreeRandomColorParamsGrass1; // Offset:  976 Index:    61
    float4 speedTreeRandomColorParamsGrass2; // Offset:  992 Index:    62
    float4 terrainPigmentParams; // Offset: 1008 Index:    63
    float4 speedTreeBillboardsGrainParams0; // Offset: 1024 Index:    64
    float4 speedTreeBillboardsGrainParams1; // Offset: 1040 Index:    65
    float4 weatherAndPrescaleParams; // Offset: 1056 Index:    66
    float4 windParams; // Offset: 1072 Index:    67
    float4 skyboxShadingParams; // Offset: 1088 Index:    68
    float4 ssaoParams; // Offset: 1104 Index:    69
    float4 msaaParams; // Offset: 1120 Index:    70
    float4 localLightsExtraParams; // Offset: 1136 Index:    71
    float4 cascadesSize; // Offset: 1152 Index:    72
    float4 surfaceDimensions; // Offset: 1168 Index:    73

    // TODO: fix padding

    int numCullingEnvProbeParams; // Offset: 1184 Index:     74

    struct ShaderCullingEnvProbeParams
    {
        DirectX::XMFLOAT4X3 viewToLocal; // Offset: 1200: Index 0
        float3 normalScale; // Offset: 1248 Index 3.xyz
        uint32_t probeIndex; // Offset: 1260 Index 3.w
    } cullingEnvProbeParams[6]; // Offset: 1200 Size:   75

    struct ShaderCommonEnvProbeParams
    {
        float weight; // Offset: 1584 Index 0.x
        float3 probePos; // Offset: 1588 Index 0.xyw
        float3 areaMarginScale; // Offset: 1600 Index 1
        DirectX::XMFLOAT4X4 areaWorldToLocal; // Offset: 1616 Index 2
        float4 intensities; // Offset: 1680 Index 6
        DirectX::XMFLOAT4X4 parallaxWorldToLocal; // Offset: 1696 Index 7
        uint32_t slotIndex; // Offset: 1760 Index 11
    } commonEnvProbeParams[7]; // Offset: 1584 Index:  99
    float4 pbrSimpleParams0; // Offset: 2928 Index:    183
    float4 pbrSimpleParams1; // Offset: 2944 Index:    184
    float4 cameraFOV; // Offset: 2960 Index:    185
    float4 ssaoClampParams0; // Offset: 2976 Index:    186
    float4 ssaoClampParams1; // Offset: 2992 Index:    187
    float4 fogCustomValuesEnv0; // Offset: 3008     Index: 188
    float4 fogCustomRangesEnv0; // Offset: 3024     Index: 189
    float4 fogCustomValuesEnv1; // Offset: 3040     Index: 190
    float4 fogCustomRangesEnv1; // Offset: 3056     Index: 191
    float4 mostImportantEnvsBlendParams; // Offset: 3072 Index: 192
    float4 fogDensityParamsClouds; // Offset: 3088 Index:    193
    float4 skyColor; // Offset: 3104 Index:    194
    float4 skyColorHorizon; // Offset: 3120 Index:    195
    float4 sunColorHorizon; // Offset: 3136 Index:    196
    float4 sunBackHorizonColor; // Offset: 3152 Index:    197
    float4 sunColorSky; // Offset: 3168 Index:    198
    float4 moonColorHorizon; // Offset: 3184 Index:    199
    float4 moonBackHorizonColor; // Offset: 3200 Index:    200
    float4 moonColorSky; // Offset: 3216 Index:    201
    float4 skyParams1; // Offset: 3232 Index:    202
    float4 skyParamsSun; // Offset: 3248 Index:    203
    float4 skyParamsMoon; // Offset: 3264 Index:    204
    float4 skyParamsInfluence; // Offset: 3280 Index:    205
    DirectX::XMFLOAT4X4 screenToWorldRevProjAware; // Offset: 3296 Index:    206
    DirectX::XMFLOAT4X4 pixelCoordToWorldRevProjAware; // Offset: 3360 Index:    210
    DirectX::XMFLOAT4X4 pixelCoordToWorld; // Offset: 3424 Index:    214
    float4 lightColorParams; // Offset: 3488 Index:    218
    float4 halfScreenDimensions; // Offset: 3504 Index:    219
    float4 halfSurfaceDimensions; // Offset: 3520 Index:    220
    float4 colorGroups[40]; // Offset: 3536 Index:   221
    float4 unknownData[7]; // Offset: 4176
};

struct GameLightingData
{
    float4 directional_light_direction; // 0
    float4 directional_light_color; // 1

    float4 unknown_00[2];

    DirectX::XMFLOAT4X4 directional_shadow_matrix;

    float4 unknown_0[3]; // 8

    struct CascadeShadowParams
    {
        float2 tex_coord_offset;
        float tex_coord_scale;
        float filter_radius;
    } cascade_shadow_params[4];

    float4 unknown_000[20]; // 15

    int terrain_shadow_mip_count; // 35.x
    float3 unknown_1;

    float unknown_2;
    float terrain_shadow_distance; // 36.y
    float2 unknown_3;

    float4 unknown_4;

    float terrain_height_scale;
    float terrain_height_bias;
    float2 unknown_5;

    struct TerrainTexCoordParams
    {
        float2 offset;
        float2 scale;
    } terrain_tex_coord_params[5]; // 39

    float4 unknown[13];

    uint32_t local_light_count;
    float3 unknown0;

    struct LocalLight
    {
        float3 position;
        float radius;

        float4 unknown_0;

        float3 spot_direction;
        float unknown_1;

        float3 color;
        int flags;

        float4 spot_light_params;
        float4 unknown_2[4];
    } local_lights[128];
};

struct FrameCB
{
    DirectX::XMFLOAT4X4 projection_matrix;
    DirectX::XMFLOAT4X4 some_matrix_0;
    DirectX::XMFLOAT4X4 some_matrix_1;
    DirectX::XMFLOAT4X4 some_matrix_2;

    float4 camera_position;
    float4 camera_direction;

    float data[124];
};

struct GameTerrainData
{
    float terrain_min_height;
    float terrain_max_height;
    float unknown;
    float num_terrain_clipmap_levels;
    float terrain_size;
};

struct CustomFrameData
{
    uint32_t frame_counter = 0;
    float frame_time_seconds;

    float cascade_shadow_map_depth_scale;
    float cascade_penumbra_scale;

    // near plane for these matrices is hardcoded to 0.2
    DirectX::XMFLOAT4X4 frustum_volume_view_projection_matrix;
    DirectX::XMFLOAT4X4 frustum_volume_previous_view_projection_matrix;
    DirectX::XMFLOAT4X4 frustum_volume_projection_matrix;
    DirectX::XMFLOAT4X4 frustum_volume_inverse_view_projection_matrix;

    FrustumVolumeParams water_depth_volume_params;

    DirectX::XMFLOAT4X4 view_projection_matrix;
    DirectX::XMFLOAT4X4 inverse_view_projection_matrix;
    DirectX::XMFLOAT4X4 history_view_projection_matrix;
    DirectX::XMFLOAT4X4 history_view_projection_matrix_2;

    DirectX::XMFLOAT2 taa_jitter;
    float depth_similarity_sigma;
    float num_clipmap_levels;

    float terrain_size;
    float ambient_transmittance_attenuation = 0.05f;
    float sun_outer_space_luminance;
    float game_time;

    struct
    {
	    // values take from https://media.contentapi.ea.com/content/dam/eacom/frostbite/files/s2016-pbs-frostbite-sky-clouds-new.pdf
	    float3 rayleigh_scattering = { 5.8e-6f, 1.35e-5f, 3.31e-5f };
	    float mie_scattering = 2e-6f * 0.1f;
	    float3 absorbtion = { 0.20556e-5f, 0.49788e-5f, 0.002136e-5f };
	    float mie_absorbtion_scale = 1.01f;
	
	    float rayleigh_scale_height = 8000;
	    float mie_scale_height = 1200;

	    float padding[2];
    } atmosphere_params;

    float3 hdr_color_filter;
    float hdr_saturation;

    float bloom_scattering;
    uint32_t modify_tonemap;
    float exposure_scale;
    uint32_t enable_custom_sun_radius;

    float custom_sun_radius;
    uint32_t enable_parametric_color_balance;
    float cinematic_border;
    int debug_view_mode;

    float hdr_contrast;
    float vignette_intensity;
    float vignette_exponent;
    float vignette_start_offset;

    float sharpening;
    uint32_t is_camera_cut;
    float underwater_fog_diffusion_scale;
    int32_t hairworks_shadow_sample_count;

    float3 water_refracted_directional_light_direction;
    float water_refracted_directional_light_fraction;

    float3 water_scattering_coefficient;
    float underwater_fog_anisotropy;

    float3 water_absorbtion_coefficient;
    float water_depth_scale;

    float taa_history_sharpening;
    float taa_resolve_quincunx_weight;
    float taa_resolve_outer_weight;
    uint32_t enable_soft_shadows;

    float3 aurora_color_bottom;
    float aurora_brightness;
    float3 aurora_color_top;
    float gameplay_dof_intensity;

    float gameplay_dof_focus_distance;
    float gameplay_dof_blur_distance;
    uint32_t enable_custom_gameplay_dof_params;
    float gameplay_dof_intensity_scale;

    uint32_t enable_pbr_lighting;
    float pad[3];
};

struct PreviousFrameVegetationData
{
    float previous_m_fWallTime;
    float padding[3];
};

struct WindDynamicsCB
{
    float data[72];
};

struct GameWaterData
{
    float game_time;
    float padding_0[3];
    float4 unknown_water_data[10];
    float4 water_color; // 11
    float4 water_data_12;
    float4 water_data_13;
    float water_data_14_x;
    float underwater_fog_intensity;
    float padding;
};
}
