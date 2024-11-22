#include "Common.hlsli"

cbuffer FrameCB : register(b0)
{
row_major float4x4 m_mModelViewProj3d : packoffset(c0);
row_major float4x4 m_mProjectionInverse3d : packoffset(c4);
row_major float4x4 m_mModelViewProj2d : packoffset(c8);
row_major float4x4 m_mCameraFacingMatrix : packoffset(c12);
float3 m_vCameraPosition : packoffset(c16);
float3 m_vCameraDirection : packoffset(c17);
float3 m_vLodRefPosition : packoffset(c18);
float2 m_vViewport : packoffset(c19);
float2 m_vViewportInverse : packoffset(c19.z);
float m_fFarClip : packoffset(c20);

struct
{
    float3 m_vAmbient;
    float3 m_vDiffuse;
    float3 m_vSpecular;
    float3 m_vTransmission;
    float3 m_vDir;
} m_vDirLight : packoffset(c21);


struct
{
    float4 m_vShadowMapRanges;
    float m_fFadeStartPercent;
    float m_fFadeInverseDistance;
    float m_fTerrainAmbientOcclusion;
    float4 m_avShadowSmoothingTable[3];
    float m_fShadowMapWritingActive;
    float2 m_vShadowMapTexelOffset;
    row_major float4x4 m_amLightModelViewProjs[4];
} m_sShadows : packoffset(c26);

float m_fWallTime : packoffset(c48);
}

cbuffer MaterialCB : register(b2)
{
float3 m_vAmbientColor : packoffset(c0);
float3 m_vDiffuseColor : packoffset(c1);
float3 m_vSpecularColor : packoffset(c2);
float3 m_vTransmissionColor : packoffset(c3);
float m_fShininess : packoffset(c3.w);
float m_fBranchSeamWeight : packoffset(c4);
float m_fOneMinusAmbientContrastFactor : packoffset(c4.y);
float m_fTransmissionShadowBrightness : packoffset(c4.z);
float m_fTransmissionViewDependency : packoffset(c4.w);
float m_fAlphaScalar : packoffset(c5);
float4 m_avEffectConfigFlags[5] : packoffset(c6);
float4 m_avWindConfigFlags[7] : packoffset(c11);
float4 m_avWindLodFlags[3] : packoffset(c18);
float4 m_vLavaCustomMaterialParams : packoffset(c21);
}

cbuffer SharedPixelConsts : register(b12)
{
float4 cameraPosition : packoffset(c0);
row_major float4x4 worldToView : packoffset(c1);
row_major float4x4 screenToView_UNUSED : packoffset(c5);
row_major float4x4 viewToWorld : packoffset(c9);
row_major float4x4 projectionMatrix : packoffset(c13);
row_major float4x4 screenToWorld : packoffset(c17);
float4 cameraNearFar : packoffset(c21);
float4 cameraDepthRange : packoffset(c22);
float4 screenDimensions : packoffset(c23);
float4 numTiles : packoffset(c24);
row_major float4x4 lastFrameViewReprojectionMatrix : packoffset(c25);
row_major float4x4 lastFrameProjectionMatrix : packoffset(c29);
float4 localReflectionParam0 : packoffset(c33);
float4 localReflectionParam1 : packoffset(c34);
float4 speedTreeRandomColorFallback : packoffset(c35);
float4 translucencyParams0 : packoffset(c36);
float4 translucencyParams1 : packoffset(c37);
float4 fogSunDir : packoffset(c38);
float4 fogColorFront : packoffset(c39);
float4 fogColorMiddle : packoffset(c40);
float4 fogColorBack : packoffset(c41);
float4 fogBaseParams : packoffset(c42);
float4 fogDensityParamsScene : packoffset(c43);
float4 fogDensityParamsSky : packoffset(c44);
float4 aerialColorFront : packoffset(c45);
float4 aerialColorMiddle : packoffset(c46);
float4 aerialColorBack : packoffset(c47);
float4 aerialParams : packoffset(c48);
float4 speedTreeBillboardsParams : packoffset(c49);
float4 speedTreeParams : packoffset(c50);
float4 speedTreeRandomColorLumWeightsTrees : packoffset(c51);
float4 speedTreeRandomColorParamsTrees0 : packoffset(c52);
float4 speedTreeRandomColorParamsTrees1 : packoffset(c53);
float4 speedTreeRandomColorParamsTrees2 : packoffset(c54);
float4 speedTreeRandomColorLumWeightsBranches : packoffset(c55);
float4 speedTreeRandomColorParamsBranches0 : packoffset(c56);
float4 speedTreeRandomColorParamsBranches1 : packoffset(c57);
float4 speedTreeRandomColorParamsBranches2 : packoffset(c58);
float4 speedTreeRandomColorLumWeightsGrass : packoffset(c59);
float4 speedTreeRandomColorParamsGrass0 : packoffset(c60);
float4 speedTreeRandomColorParamsGrass1 : packoffset(c61);
float4 speedTreeRandomColorParamsGrass2 : packoffset(c62);
float4 terrainPigmentParams : packoffset(c63);
float4 speedTreeBillboardsGrainParams0 : packoffset(c64);
float4 speedTreeBillboardsGrainParams1 : packoffset(c65);
float4 weatherAndPrescaleParams : packoffset(c66);
float4 windParams : packoffset(c67);
float4 skyboxShadingParams : packoffset(c68);
float4 ssaoParams : packoffset(c69);
float4 msaaParams : packoffset(c70);
float4 localLightsExtraParams : packoffset(c71);
float4 cascadesSize : packoffset(c72);
float4 surfaceDimensions : packoffset(c73);
int numCullingEnvProbeParams : packoffset(c74);

struct
{
    row_major float4x3 viewToLocal;
    float3 normalScale;
    uint probeIndex;
} cullingEnvProbeParams[6] : packoffset(c75);


struct
{
    float weight;
    float3 probePos;
    float3 areaMarginScale;
    row_major float4x4 areaWorldToLocal;
    float4 intensities;
    row_major float4x4 parallaxWorldToLocal;
    uint slotIndex;
} commonEnvProbeParams[7] : packoffset(c105);

float4 pbrSimpleParams0 : packoffset(c189);
float4 pbrSimpleParams1 : packoffset(c190);
float4 cameraFOV : packoffset(c191);
float4 ssaoClampParams0 : packoffset(c192);
float4 ssaoClampParams1 : packoffset(c193);
float4 fogCustomValuesEnv0 : packoffset(c194);
float4 fogCustomRangesEnv0 : packoffset(c195);
float4 fogCustomValuesEnv1 : packoffset(c196);
float4 fogCustomRangesEnv1 : packoffset(c197);
float4 mostImportantEnvsBlendParams : packoffset(c198);
float4 fogDensityParamsClouds : packoffset(c199);
float4 skyColor : packoffset(c200);
float4 skyColorHorizon : packoffset(c201);
float4 sunColorHorizon : packoffset(c202);
float4 sunBackHorizonColor : packoffset(c203);
float4 sunColorSky : packoffset(c204);
float4 moonColorHorizon : packoffset(c205);
float4 moonBackHorizonColor : packoffset(c206);
float4 moonColorSky : packoffset(c207);
float4 skyParams1 : packoffset(c208);
float4 skyParamsSun : packoffset(c209);
float4 skyParamsMoon : packoffset(c210);
float4 skyParamsInfluence : packoffset(c211);
row_major float4x4 screenToWorldRevProjAware : packoffset(c212);
row_major float4x4 pixelCoordToWorldRevProjAware : packoffset(c216);
row_major float4x4 pixelCoordToWorld : packoffset(c220);
float4 lightColorParams : packoffset(c224);
float4 halfScreenDimensions : packoffset(c225);
float4 halfSurfaceDimensions : packoffset(c226);
float4 colorGroups[40] : packoffset(c227);
}

SamplerState samStandard_s : register(s0);
Texture2D<float4> DiffuseMap : register(t0);
Texture2D<float4> NormalMap : register(t1);
Texture2D<float4> DetailDiffuseMap : register(t2);
Texture2D<float4> DetailNormalMap : register(t3);
Texture2D<float4> SpecularMaskMap : register(t4);
Texture2D<float4> DissolveMap : register(t11);

#define cmp -

void PSMain(
    float4 v0 : SV_POSITION0,
    float4 v1 : TEXCOORD0,
    float4 v2 : TEXCOORD1,
    float4 v3 : TEXCOORD2,
    float4 v4 : TEXCOORD3,
    float4 v5 : TEXCOORD4,
    float4 v6 : TEXCOORD5,
    float4 v7 : TEXCOORD6,
    float3 previous_frame_position: TEXCOORD7,
    float3 current_frame_position : TEXCOORD8,
    out float4 o0 : SV_Target0,
    out float4 o1 : SV_Target1,
    out float4 o2 : SV_Target2,
    out float2 motion_vector : SV_Target3)
{
    float4 r0, r1, r2, r3, r4, r5, r6;

    r0.xy = float2(0.0625, 0.0625) * v0.xy;
    r0.xy = floor(r0.xy);
    r0.xy = v0.xy * float2(0.0625, 0.0625) + -r0.xy;
    r0.x = DissolveMap.Sample(samStandard_s, r0.xy).x;
    r0.x = cmp(r0.x < v7.x);
    if (r0.x != 0)
        discard;
    r0.xyzw = DiffuseMap.Sample(samStandard_s, v1.xy).xyzw;
    r1.x = cmp(0.5 >= m_avEffectConfigFlags[4].y);
    r2.xyzw = cmp(float4(0.5, 0.5, 0.5, 1.5) < m_avEffectConfigFlags[2].wyxx);
    r1.x = (int)r1.x | (int)r2.x;
    r0.w = r0.w * v1.z + -0.100000001;
    r0.w = cmp(r0.w < 0);
    r0.w = r1.x ? r0.w : 0;
    if (r0.w != 0)
        discard;
    r1.xyzw = cmp(float4(0.5, 0.5, 0.5, 1.5) < m_avEffectConfigFlags[1].yzww);
    if (r1.x != 0)
    {
        r3.xyzw = DetailDiffuseMap.Sample(samStandard_s, float2(0, 0)).xyzw;
        r0.w = cmp(1.5 < m_avEffectConfigFlags[1].y);
        r2.x = v1.w * r3.w;
        r0.w = r0.w ? r2.x : r3.w;
        r3.xyz = r3.xyz + -r0.xyz;
        r0.xyz = r0.www * r3.xyz + r0.xyz;
    }
    if (r2.y != 0)
    {
        r0.xyz = DiffuseMap.Sample(samStandard_s, float2(0, 0)).xyz;
        if (r1.x != 0)
        {
            r3.xyzw = DetailDiffuseMap.Sample(samStandard_s, float2(0, 0)).xyzw;
            r0.w = cmp(1.5 < m_avEffectConfigFlags[1].y);
            r1.x = v1.w * r3.w;
            r0.w = r0.w ? r1.x : r3.w;
            r3.xyz = r3.xyz + -r0.xyz;
            r0.xyz = r0.www * r3.xyz + r0.xyz;
        }
    }
    r0.w = cmp(0.5 < m_avEffectConfigFlags[3].w);
    r3.xyz = v4.xyz + r0.xyz;
    r0.xyz = r0.www ? r3.xyz : r0.xyz;
    r0.w = 1 + -m_fOneMinusAmbientContrastFactor;
    r3.xyz = cmp(float3(0.500999987, 0.521000028, 0.510999978) < r0.www);
    if (r3.x != 0)
    {
        r1.x = cmp(0.521000028 < r0.w);
        if (r1.x != 0)
        {
            r1.x = dot(speedTreeRandomColorLumWeightsTrees.xyz, r0.xyz);
            r4.xyzw = speedTreeRandomColorParamsTrees1.xyzw * v5.yyyy;
            r4.xyzw = v5.xxxx * speedTreeRandomColorParamsTrees0.xyzw + r4.xyzw;
            r4.xyzw = v5.zzzz * speedTreeRandomColorParamsTrees2.xyzw + r4.xyzw;
            r4.xyz = float3(1, 1, 1) + -r4.xyz;
            r4.xyz = max(float3(0, 0, 0), r4.xyz);
            r5.xyz = max(float3(0, 0, 0), r0.xyz);
            r5.xyz = log2(r5.xyz);
            r5.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r5.xyz;
            r5.xyz = exp2(r5.xyz);
            r5.xyz = r5.xyz + -r1.xxx;
            r5.xyz = r5.xyz * r4.www + r1.xxx;
            r5.xyz = max(float3(0, 0, 0), r5.xyz);
            r4.xyz = r5.xyz * r4.xyz;
            r4.xyz = log2(r4.xyz);
            r4.xyz = float3(0.454545468, 0.454545468, 0.454545468) * r4.xyz;
            r4.xyz = exp2(r4.xyz);
        }
        else
        {
            r0.w = cmp(0.510999978 < r0.w);
            if (r0.w != 0)
            {
                r0.w = dot(speedTreeRandomColorLumWeightsBranches.xyz, r0.xyz);
                r5.xyzw = speedTreeRandomColorParamsBranches1.xyzw * v5.yyyy;
                r5.xyzw = v5.xxxx * speedTreeRandomColorParamsBranches0.xyzw + r5.xyzw;
                r5.xyzw = v5.zzzz * speedTreeRandomColorParamsBranches2.xyzw + r5.xyzw;
                r5.xyz = float3(1, 1, 1) + -r5.xyz;
                r5.xyz = max(float3(0, 0, 0), r5.xyz);
                r6.xyz = max(float3(0, 0, 0), r0.xyz);
                r6.xyz = log2(r6.xyz);
                r6.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r6.xyz;
                r6.xyz = exp2(r6.xyz);
                r6.xyz = r6.xyz + -r0.www;
                r6.xyz = r6.xyz * r5.www + r0.www;
                r6.xyz = max(float3(0, 0, 0), r6.xyz);
                r5.xyz = r6.xyz * r5.xyz;
                r5.xyz = log2(r5.xyz);
                r5.xyz = float3(0.454545468, 0.454545468, 0.454545468) * r5.xyz;
                r4.xyz = exp2(r5.xyz);
            }
            else
            {
                r0.w = dot(speedTreeRandomColorLumWeightsGrass.xyz, r0.xyz);
                r5.xyzw = speedTreeRandomColorParamsGrass1.xyzw * v5.yyyy;
                r5.xyzw = v5.xxxx * speedTreeRandomColorParamsGrass0.xyzw + r5.xyzw;
                r5.xyzw = v5.zzzz * speedTreeRandomColorParamsGrass2.xyzw + r5.xyzw;
                r5.xyz = float3(1, 1, 1) + -r5.xyz;
                r5.xyz = max(float3(0, 0, 0), r5.xyz);
                r6.xyz = max(float3(0, 0, 0), r0.xyz);
                r6.xyz = log2(r6.xyz);
                r6.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r6.xyz;
                r6.xyz = exp2(r6.xyz);
                r6.xyz = r6.xyz + -r0.www;
                r6.xyz = r6.xyz * r5.www + r0.www;
                r6.xyz = max(float3(0, 0, 0), r6.xyz);
                r5.xyz = r6.xyz * r5.xyz;
                r5.xyz = log2(r5.xyz);
                r5.xyz = float3(0.454545468, 0.454545468, 0.454545468) * r5.xyz;
                r4.xyz = exp2(r5.xyz);
            }
        }
    }
    else
    {
        r0.xyz = max(float3(0, 0, 0), r0.xyz);
        r0.xyz = log2(r0.xyz);
        r0.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r0.xyz;
        r0.xyz = exp2(r0.xyz);
        r0.xyz = speedTreeRandomColorFallback.xyz * r0.xyz;
        r0.xyz = log2(r0.xyz);
        r0.xyz = float3(0.454545468, 0.454545468, 0.454545468) * r0.xyz;
        r4.xyz = exp2(r0.xyz);
    }
    r0.xyz = m_vDiffuseColor.xyz * r4.xyz;
    r0.xyz = m_vDirLight.m_vDiffuse.xyz * r0.xyz;
    r0.w = cmp(0.5 < m_avEffectConfigFlags[0].w);
    r1.x = -1 + v2.w;
    r1.x = saturate(speedTreeParams.x * r1.x + 1);
    r4.xyz = r1.xxx * r0.xyz;
    o0.xyz = r0.www ? r4.xyz : r0.xyz;
    r0.xy = SpecularMaskMap.Sample(samStandard_s, v1.xy).yw;
    r0.y = m_vDirLight.m_vTransmission.x * r0.y;
    r0.y = m_vTransmissionColor.y * r0.y;
    r0.z = v1.w * r0.y;
    r0.y = r2.w ? r0.z : r0.y;
    o0.w = r2.z ? r0.y : 0;
    r0.yzw = NormalMap.Sample(samStandard_s, v1.xy).xyz;
    if (r1.y != 0)
    {
        r1.x = DetailDiffuseMap.Sample(samStandard_s, float2(0, 0)).w;
        r2.x = cmp(1.5 < m_avEffectConfigFlags[1].y);
        r2.z = v1.w * r1.x;
        r1.x = r2.x ? r2.z : r1.x;
        r2.xzw = DetailNormalMap.Sample(samStandard_s, float2(0, 0)).xyz;
        r2.xzw = r2.xzw + -r0.yzw;
        r0.yzw = r1.xxx * r2.xzw + r0.yzw;
    }
    if (r2.y != 0)
    {
        r2.xyz = NormalMap.Sample(samStandard_s, float2(0, 0)).xyz;
        if (r1.y != 0)
        {
            r1.x = DetailDiffuseMap.Sample(samStandard_s, float2(0, 0)).w;
            r1.y = cmp(1.5 < m_avEffectConfigFlags[1].y);
            r2.w = v1.w * r1.x;
            r1.x = r1.y ? r2.w : r1.x;
            r4.xyz = DetailNormalMap.Sample(samStandard_s, float2(0, 0)).xyz;
            r4.xyz = r4.xyz + -r2.xyz;
            r2.xyz = r1.xxx * r4.xyz + r2.xyz;
        }
        r2.xyz = r2.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
    }
    else
    {
        r2.xyz = r0.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
    }
    r0.yzw = v3.yzx * v2.zxy;
    r0.yzw = v2.yzx * v3.zxy + -r0.yzw;
    r0.yzw = r0.yzw * r2.yyy;
    r0.yzw = v3.xyz * r2.xxx + r0.yzw;
    r0.yzw = v2.xyz * r2.zzz + r0.yzw;
    r1.x = dot(r0.yzw, r0.yzw);
    r1.x = rsqrt(r1.x);
    r0.yzw = r1.xxx * r0.yzw;
    o1.xyz = r0.yzw * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
    r0.x = m_vDirLight.m_vSpecular.x * r0.x;
    r0.x = m_vSpecularColor.y * r0.x;
    r0.y = v1.w * r0.x;
    r0.x = r1.w ? r0.y : r0.x;
    o2.xyz = r1.zzz ? r0.xxx : 0;
    r0.x = r1.z ? m_fShininess : 30;
    r0.y = r3.z ? 4 : 1;
    r0.y = r3.y ? 2 : r0.y;
    r0.y = r3.x ? r0.y : 0;
    r0.y = (uint)r0.y;
    r0.y = 0.5 + r0.y;
    o2.w = 0.00392156886 * r0.y;
    o1.w = 0.0078125 * r0.x;

    motion_vector = GetObjectMotionVector(previous_frame_position, current_frame_position);
}
