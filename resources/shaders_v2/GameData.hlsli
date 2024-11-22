#ifndef GAME_FRAME_DATA_HLSLI
#define GAME_FRAME_DATA_HLSLI

cbuffer _GameFrameData
{
    float4 cameraPosition; // Offset: 0    Index: 0
    row_major float4x4 worldToView;                         // Offset: 16   Index: 1
    row_major float4x4 screenToView_UNUSED; // Offset:   80 Index:    5
    float4x4 viewToWorld; // Offset:  144 Index:    9
    float4x4 projectionMatrix; // Offset:  208 Index:    13
    float4x4 screenToWorld; // Offset:  272 Index:    17
    float4 cameraNearFar; // Offset:  336 Index:    21
    float2 cameraDepthRange; // Offset:  352 Index:    22
    float near_plane;
    float far_plane;
    float4 screenDimensions; // Offset:  368 Index:    23
    float4 numTiles; // Offset:  384 Index:    24
    row_major float4x4 lastFrameViewReprojectionMatrix; // Offset:  400 Index:    25
    row_major float4x4 lastFrameProjectionMatrix; // Offset:  464 Index:    29
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
    int numCullingEnvProbeParams; // Offset: 1184 Index:     74
   
    struct ShaderCullingEnvProbeParams
    {
       
        float4x3 viewToLocal; // Offset: 1200: Index 0
        float3 normalScale; // Offset: 1248 Index 3.xyz
        uint probeIndex; // Offset: 1260 Index 3.w

    } cullingEnvProbeParams[6]; // Offset: 1200 Size:   75
   
    struct ShaderCommonEnvProbeParams
    {
       
        float weight; // Offset: 1584 Index 0.x
        float3 probePos; // Offset: 1588 Index 0.xyw
        float3 areaMarginScale; // Offset: 1600 Index 1
        float4x4 areaWorldToLocal; // Offset: 1616 Index 2
        float4 intensities; // Offset: 1680 Index 6
        float4x4 parallaxWorldToLocal; // Offset: 1696 Index 7
        uint slotIndex; // Offset: 1760 Index 11

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
    float4x4 screenToWorldRevProjAware; // Offset: 3296 Index:    206
    float4x4 pixelCoordToWorldRevProjAware; // Offset: 3360 Index:    210
    float4x4 pixelCoordToWorld; // Offset: 3424 Index:    214
    float4 lightColorParams; // Offset: 3488 Index:    218
    float4 halfScreenDimensions; // Offset: 3504 Index:    219
    float4 halfSurfaceDimensions; // Offset: 3520 Index:    220
    float4 colorGroups[40]; // Offset: 3536 Index:   221
    float4 unknownData[7]; // Offset: 4176
}


cbuffer _GameLightingData
{
    float4 directional_light_direction; // 0
    float4 directional_light_color; // 1

    float4 unknown_00[2];

    row_major float4x4 directional_shadow_matrix;

    float4 cb13_8;
    float4 cb13_9;
    float4 cb13_10;

    struct CascadeShadowParams
    {
        float2 tex_coord_offset;
        float tex_coord_scale;
        float filter_radius;
    } cascade_shadow_params[4]; // 11

    float2 cb13_15_xy;
    float cascade_count; // 15.z
    float cb13_15_w;

    float4 cb13_16;
    float4 cb13_17;
    float4 cb13_18;

    struct SpeedTreeCascadeShadowParams
    {
        float filter_radius;
        float shadow_gradient;
        float2 unknown;
    } speed_tree_cascade_shadow_params[4]; // 19;

    float4 unknown_0000[10]; // 23

    float4 dimmer_params_0; // 33
    float4 dimmer_params_1; // 34

    int terrain_shadow_mip_count; // 35.x
    float3 unknown_1;
	
    float cb13_36_x;
    float terrain_shadow_distance; // 36.y
    float cb13_36_z;
    float cb13_36_w;
	
    float4 cb13_37;

    float terrain_height_scale; // 38
    float terrain_height_bias;
    float2 unknown_5;

	struct TerrainTexCoordParams
	{
        float2 offset;
        float2 scale;
    } terrain_tex_coord_params[5]; // 39
	
	
    float4 unknown[7]; // 44

    float4 sun_color_light_side; // 51
    float4 sun_color_light_opposite_side; // 52

    float4 unknown01[5]; // 53

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
    	
    } local_lights[64]; // 58
}

cbuffer _GameTerrainData
{
    float terrain_min_height;
    float terrain_max_height;
    float _unknown_terrain_data;
    float num_terrain_clipmap_levels;
    float game_terrain_size;
};

float3 NdcToWorldPosition(float3 ndc_position)
{
    float4 worldPosition = mul(screenToWorldRevProjAware, float4(ndc_position, 1));
    return worldPosition.xyz / worldPosition.w;
}

float3 ThreadIdDepthToNdc(int2 thread_id, float device_depth)
{
    float2 tex_coord = (thread_id.xy + 0.5) * screenDimensions.zw;
    return float3(tex_coord * float2(2, -2) + float2(-1, 1), device_depth);
}

float3 ThreadIdDeviceDepthToWorldPosition(int2 thread_id, float device_depth)
{
    float3 ndc = ThreadIdDepthToNdc(thread_id, device_depth);
    return NdcToWorldPosition(ndc);
}

float3 PixelToWorldPosition(float2 pixel_coord, float device_depth)
{
    float4 worldPosition = float4(pixel_coord, device_depth, 1.0);
    worldPosition = mul(pixelCoordToWorldRevProjAware, worldPosition);
    return worldPosition.xyz / worldPosition.w;
}
float2 SvPositionToTexCoord(float4 sv_position)
{
    // https://www.asawicki.info/news_1516_half-pixel_offset_in_directx_11
    return sv_position.xy * screenDimensions.zw;
}
float3 SvPositionToNdc(float4 sv_position)
{
    return float3(SvPositionToTexCoord(sv_position) * float2(2, -2) + float2(-1, 1), sv_position.z);
}
float DeviceToSceneDepth(float device_depth)
{
    float scene_depth = device_depth * cameraDepthRange.x + cameraDepthRange.y;
    scene_depth = scene_depth * cameraNearFar.x + cameraNearFar.y;
    scene_depth = rcp(max(0.0001, scene_depth));
    return scene_depth;
}
float4 DeviceToSceneDepth(float4 device_depth)
{
    float4 scene_depth = device_depth * cameraDepthRange.x + cameraDepthRange.y;
    scene_depth = scene_depth * cameraNearFar.x + cameraNearFar.y;
    scene_depth = rcp(max(0.0001, scene_depth));
    return scene_depth;
}
float SceneToDeviceDepth(float scene_depth)
{
    return 1 - ((scene_depth * projectionMatrix[2][2] + projectionMatrix[2][3]) / max(scene_depth, 0.0001));
}
float4 SceneToDeviceDepth(float4 scene_depth)
{
    return 1 - ((scene_depth * projectionMatrix[2][2] + projectionMatrix[2][3]) / max(scene_depth, 0.0001));
}

#endif