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

cbuffer BaseTreeCB : register(b1)
{
float m_f3dLodHighDetailDist : packoffset(c0);
float m_f3dLodRange : packoffset(c0.y);
float m_f3dGrassStartDist : packoffset(c0.z);
float m_f3dGrassRange : packoffset(c0.w);
float m_fBillboardHorzFade : packoffset(c1);
float m_fOneMinusBillboardHorzFade : packoffset(c1.y);
float m_fBillboardStartDist : packoffset(c1.z);
float m_fBillboardRange : packoffset(c1.w);
float m_fHueVariationByPos : packoffset(c2);
float m_fHueVariationByVertex : packoffset(c2.y);
float3 m_vHueVariationColor : packoffset(c3);
float m_fAmbientImageScalar : packoffset(c3.w);
float m_fNumBillboards : packoffset(c4);
float m_fRadiansPerImage : packoffset(c4.y);
float4 m_avBillboardTexCoords[24] : packoffset(c5);
float4 m_vLavaCustomBaseTreeParams : packoffset(c29);
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

cbuffer WindDynamicsCB : register(b3)
{
float3 m_vDirection : packoffset(c0);
float m_fStrength : packoffset(c0.w);
float3 m_vAnchor : packoffset(c1);

struct
{
    float m_fTime;
    float m_fDistance;
    float m_fHeight;
    float m_fHeightExponent;
    float m_fAdherence;
} m_sGlobal : packoffset(c2);


struct
{
    float m_fTime;
    float m_fDistance;
    float m_fTwitch;
    float m_fTwitchFreqScale;
    float m_fWhip;
    float m_fDirectionAdherence;
    float m_fTurbulence;
} m_sBranch1 : packoffset(c4);


struct
{
    float m_fTime;
    float m_fDistance;
    float m_fTwitch;
    float m_fTwitchFreqScale;
    float m_fWhip;
    float m_fDirectionAdherence;
    float m_fTurbulence;
} m_sBranch2 : packoffset(c6);


struct
{
    float m_fRippleTime;
    float m_fRippleDistance;
    float m_fLeewardScalar;
    float m_fTumbleTime;
    float m_fTumbleFlip;
    float m_fTumbleTwist;
    float m_fTumbleDirectionAdherence;
    float m_fTwitchThrow;
    float m_fTwitchSharpness;
    float m_fTwitchTime;
} m_sLeaf1 : packoffset(c8);


struct
{
    float m_fRippleTime;
    float m_fRippleDistance;
    float m_fLeewardScalar;
    float m_fTumbleTime;
    float m_fTumbleFlip;
    float m_fTumbleTwist;
    float m_fTumbleDirectionAdherence;
    float m_fTwitchThrow;
    float m_fTwitchSharpness;
    float m_fTwitchTime;
} m_sLeaf2 : packoffset(c11);


struct
{
    float m_fTime;
    float m_fDistance;
    float m_fTile;
    float m_fLightingScalar;
} m_sFrondRipple : packoffset(c14);


struct
{
    float m_fBranchFieldMin;
    float m_fBranchLightingAdjust;
    float m_fBranchVerticalOffset;
    float m_fLeafRippleMin;
    float m_fLeafTumbleMin;
    float m_fNoisePeriod;
    float m_fNoiseSize;
    float m_fNoiseTurbulence;
    float m_fNoiseTwist;
    float2 m_vOffset;
} m_sRolling : packoffset(c15);

}

cbuffer PreviousWindDynamicsCB : register(b4)
{
    float3 previous_m_vDirection : packoffset(c0);
    float previous_m_fStrength : packoffset(c0.w);
    float3 previous_m_vAnchor : packoffset(c1);

    struct
    {
        float m_fTime;
        float m_fDistance;
        float m_fHeight;
        float m_fHeightExponent;
        float m_fAdherence;
    } previous_m_sGlobal : packoffset(c2);


    struct
    {
        float m_fTime;
        float m_fDistance;
        float m_fTwitch;
        float m_fTwitchFreqScale;
        float m_fWhip;
        float m_fDirectionAdherence;
        float m_fTurbulence;
    } previous_m_sBranch1 : packoffset(c4);


    struct
    {
        float m_fTime;
        float m_fDistance;
        float m_fTwitch;
        float m_fTwitchFreqScale;
        float m_fWhip;
        float m_fDirectionAdherence;
        float m_fTurbulence;
    } previous_m_sBranch2 : packoffset(c6);


    struct
    {
        float m_fRippleTime;
        float m_fRippleDistance;
        float m_fLeewardScalar;
        float m_fTumbleTime;
        float m_fTumbleFlip;
        float m_fTumbleTwist;
        float m_fTumbleDirectionAdherence;
        float m_fTwitchThrow;
        float m_fTwitchSharpness;
        float m_fTwitchTime;
    } previous_m_sLeaf1 : packoffset(c8);


    struct
    {
        float m_fRippleTime;
        float m_fRippleDistance;
        float m_fLeewardScalar;
        float m_fTumbleTime;
        float m_fTumbleFlip;
        float m_fTumbleTwist;
        float m_fTumbleDirectionAdherence;
        float m_fTwitchThrow;
        float m_fTwitchSharpness;
        float m_fTwitchTime;
    } previous_m_sLeaf2 : packoffset(c11);


    struct
    {
        float m_fTime;
        float m_fDistance;
        float m_fTile;
        float m_fLightingScalar;
    } previous_m_sFrondRipple : packoffset(c14);


    struct
    {
        float m_fBranchFieldMin;
        float m_fBranchLightingAdjust;
        float m_fBranchVerticalOffset;
        float m_fLeafRippleMin;
        float m_fLeafTumbleMin;
        float m_fNoisePeriod;
        float m_fNoiseSize;
        float m_fNoiseTurbulence;
        float m_fNoiseTwist;
        float2 m_vOffset;
    } previous_m_sRolling : packoffset(c15);
}

SamplerState samStandard_s : register(s0);
Texture2D<float4> PerlinNoiseKernel : register(t9);

#define cmp -

float3 ComputePreviousFramePosition(float4 v0, float4 v1, float4 v2, float4 v3, float4 v4, float4 v5, float4 v6, float4 v7, float4 v8,
                                    float4 v9)
{
    float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10;

    r0.xyz = v8.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
    r1.xyz = v9.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
    r0.w = floor(v1.w);
    r1.w = v1.w + -r0.w;
    r1.w = 1.33333337 * r1.w;
    r0.w = v3.x + v3.y;
    r2.xyz = v2.yzx * v1.zxy;
    r2.xyz = v1.yzx * v2.zxy + -r2.xyz;
    r2.w = dot(r2.xyz, r2.xyz);
    r2.w = rsqrt(r2.w);
    r2.xyz = r2.xyz * r2.www;
    r3.xyz = v3.yyy * r2.xyz;
    r3.xyz = v2.xyz * v3.xxx + r3.xyz;
    r3.xyz = v1.xyz * v3.zzz + r3.xyz;
    r4.xyz = r2.xyz * r0.yyy;
    r4.xyz = v2.xyz * r0.xxx + r4.xyz;
    r4.xyz = v1.xyz * r0.zzz + r4.xyz;
    r2.xyz = r2.xyz * r1.yyy;
    r2.xyz = v2.xyz * r1.xxx + r2.xyz;
    r1.x = v4.z + v3.w;
    r0.w = r1.x + r0.w;
    r1.x = cmp(0.5 < m_avWindConfigFlags[0].x);
    r1.y = dot(r3.xyz, r3.xyz);
    r1.y = sqrt(r1.y);
    r1.z = 1 / previous_m_sGlobal.m_fHeight;
    r1.z = -r1.z * 0.25 + r3.z;
    r1.z = max(0, r1.z);
    r1.z = previous_m_sGlobal.m_fHeight * r1.z;
    r2.x = cmp(r1.z != 0.000000);
    r2.y = log2(abs(r1.z));
    r2.y = previous_m_sGlobal.m_fHeightExponent * r2.y;
    r2.y = exp2(r2.y);
    r1.z = r2.x ? r2.y : r1.z;
    r2.x = previous_m_sGlobal.m_fTime + v0.x;
    r2.y = previous_m_sGlobal.m_fTime * 0.800000012 + v0.y;
    r2.xy = float2(0.5, 0.5) + r2.xy;
    r2.xy = frac(r2.xy);
    r2.xy = r2.xy * float2(2, 2) + float2(-1, -1);
    r2.zw = abs(r2.xy) * abs(r2.xy);
    r2.xy = -abs(r2.xy) * float2(2, 2) + float2(3, 3);
    r2.xy = r2.zw * r2.xy + float2(-0.5, -0.5);
    r2.xy = r2.xy + r2.xy;
    r2.x = r2.y * r2.y + r2.x;
    r2.y = previous_m_sGlobal.m_fAdherence / previous_m_sGlobal.m_fHeight;
    r2.x = previous_m_sGlobal.m_fDistance * r2.x + r2.y;
    r1.z = r2.x * r1.z;
    r2.xy = previous_m_vDirection.xy * r1.zz + r3.xy;
    r2.z = r3.z;
    r1.z = dot(r2.xyz, r2.xyz);
    r1.z = rsqrt(r1.z);
    r2.xyz = r2.xyz * r1.zzz;
    r2.xyz = r2.xyz * r1.yyy + -r3.xyz;
    r1.xyz = r1.xxx ? r2.xyz : 0;
    r2.x = cmp(0.5 < m_avWindLodFlags[2].w);
    if (r2.x != 0)
    {
        r2.x = cmp(0.5 < m_avWindConfigFlags[0].z);
        if (r2.x != 0)
        {
            r2.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[1].zw);
            r5.xyz = float3(0.0625, 1, 16) * v6.yyy;
            r5.xyz = frac(r5.xyz);
            r5.xyz = r5.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
            r5.xyz = v6.xxx * r5.xyz;
            r2.z = v0.x + v0.y;
            r2.z = previous_m_sBranch1.m_fTime + r2.z;
            if (r2.y != 0)
            {
                r6.x = v6.y + r2.z;
                r6.y = r2.z * previous_m_sBranch1.m_fTwitchFreqScale + v6.y;
                r2.y = previous_m_sBranch1.m_fTwitchFreqScale * r6.x;
                r6.z = 0.5 * r2.y;
                r6.w = -v6.x + r6.x;
                r7.xyzw = float4(0.5, 0.5, 0.5, 1.5) + r6.xyzw;
                r7.xyzw = frac(r7.xyzw);
                r7.xyzw = r7.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
                r8.xyzw = abs(r7.xyzw) * abs(r7.xyzw);
                r7.xyzw = -abs(r7.xyzw) * float4(2, 2, 2, 2) + float4(3, 3, 3, 3);
                r7.xyzw = r8.xyzw * r7.xyzw + float4(-0.5, -0.5, -0.5, -0.5);
                r7.xyzw = r7.xyzw + r7.xyzw;
                r6.xyz = float3(0.5, 0.5, 0.5) + r6.xyz;
                r6.xyz = frac(r6.xyz);
                r6.xyz = r6.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                r8.xyz = abs(r6.xyz) * abs(r6.xyz);
                r6.xyz = -abs(r6.xyz) * float3(2, 2, 2) + float3(3, 3, 3);
                r6.xyz = r8.xyz * r6.xyz;
                r6.w = 0;
                r6.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r6.xyzw;
                r6.xyzw = r6.xyzw + r6.xyzw;
                r6.xyzw = r2.xxxx ? r7.xyzw : r6.xyzw;
                r7.w = r6.y * r6.z;
                r2.y = cmp(r7.w < 0);
                r7.y = -r7.w;
                r7.xz = float2(-1, 1);
                r2.yw = r2.yy ? r7.xy : r7.zw;
                r3.w = -r6.y * r6.z + r2.y;
                r3.w = r2.w * r3.w + r7.w;
                r2.y = -r3.w + r2.y;
                r2.y = r2.w * r2.y + r3.w;
                r2.y = previous_m_sBranch1.m_fTwitch * r2.y;
                r2.w = 1 + -previous_m_fStrength;
                r3.w = 1 + -previous_m_sBranch1.m_fTwitch;
                r3.w = r6.x * r3.w;
                r2.y = r2.y * r2.w + r3.w;
                r2.w = previous_m_sBranch1.m_fWhip * r6.w;
                r2.w = r2.w * v6.x + 1;
                r2.w = r2.y * r2.w;
                r2.y = r2.x ? r2.w : r2.y;
            }
            else
            {
                r6.x = v6.y + r2.z;
                r6.y = r2.z * 0.68900001 + v6.y;
                r6.z = -v6.x + r6.x;
                r7.xyz = float3(0.5, 0.5, 1.5) + r6.xyz;
                r7.xyz = frac(r7.xyz);
                r7.xyz = r7.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                r8.xyz = abs(r7.xyz) * abs(r7.xyz);
                r7.xyz = -abs(r7.xyz) * float3(2, 2, 2) + float3(3, 3, 3);
                r7.xyz = r8.xyz * r7.xyz + float3(-0.5, -0.5, -0.5);
                r7.xyz = r7.xyz + r7.xyz;
                r2.zw = float2(0.5, 0.5) + r6.xy;
                r2.zw = frac(r2.zw);
                r2.zw = r2.zw * float2(2, 2) + float2(-1, -1);
                r6.xy = abs(r2.zw) * abs(r2.zw);
                r2.zw = -abs(r2.zw) * float2(2, 2) + float2(3, 3);
                r6.xy = r6.xy * r2.zw;
                r6.z = 0;
                r6.xyz = float3(-0.5, -0.5, -0.5) + r6.xyz;
                r6.xyz = r6.xyz + r6.xyz;
                r6.xyz = r2.xxx ? r7.xyz : r6.xyz;
                r2.z = r6.y * r6.x + r6.x;
                r2.w = previous_m_sBranch1.m_fWhip * r6.z;
                r2.w = r2.w * v6.x + 1;
                r2.w = r2.z * r2.w;
                r2.y = r2.x ? r2.w : r2.z;
            }
            r2.xyz = r5.xyz * r2.yyy;
            r2.xyz = r2.xyz * previous_m_sBranch1.m_fDistance + r3.xyz;
        }
        else
        {
            r2.w = cmp(0.5 < m_avWindConfigFlags[0].w);
            if (r2.w != 0)
            {
                r5.xyz = cmp(float3(0.5, 0.5, 0.5) < m_avWindConfigFlags[1].zwy);
                r6.xyz = float3(0.0625, 1, 16) * v6.yyy;
                r6.xyz = frac(r6.xyz);
                r6.xyz = r6.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                r6.xyz = v6.xxx * r6.xyz;
                r2.w = v0.x + v0.y;
                r2.w = previous_m_sBranch1.m_fTime + r2.w;
                if (r5.y != 0)
                {
                    r7.x = v6.y + r2.w;
                    r7.y = r2.w * previous_m_sBranch1.m_fTwitchFreqScale + v6.y;
                    r3.w = previous_m_sBranch1.m_fTwitchFreqScale * r7.x;
                    r7.z = 0.5 * r3.w;
                    r7.w = -v6.x + r7.x;
                    r8.xyzw = float4(0.5, 0.5, 0.5, 1.5) + r7.xyzw;
                    r8.xyzw = frac(r8.xyzw);
                    r8.xyzw = r8.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
                    r9.xyzw = abs(r8.xyzw) * abs(r8.xyzw);
                    r8.xyzw = -abs(r8.xyzw) * float4(2, 2, 2, 2) + float4(3, 3, 3, 3);
                    r8.xyzw = r9.xyzw * r8.xyzw + float4(-0.5, -0.5, -0.5, -0.5);
                    r8.xyzw = r8.xyzw + r8.xyzw;
                    r7.xyz = float3(0.5, 0.5, 0.5) + r7.xyz;
                    r7.xyz = frac(r7.xyz);
                    r7.xyz = r7.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                    r9.xyz = abs(r7.xyz) * abs(r7.xyz);
                    r7.xyz = -abs(r7.xyz) * float3(2, 2, 2) + float3(3, 3, 3);
                    r7.xyz = r9.xyz * r7.xyz;
                    r7.w = 0;
                    r7.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r7.xyzw;
                    r7.xyzw = r7.xyzw + r7.xyzw;
                    r7.xyzw = r5.xxxx ? r8.wxyz : r7.wxyz;
                    r8.w = r7.z * r7.w;
                    r3.w = cmp(r8.w < 0);
                    r8.y = -r8.w;
                    r8.xz = float2(-1, 1);
                    r5.yw = r3.ww ? r8.xy : r8.zw;
                    r3.w = -r7.z * r7.w + r5.y;
                    r3.w = r5.w * r3.w + r8.w;
                    r4.w = r5.y + -r3.w;
                    r3.w = r5.w * r4.w + r3.w;
                    r3.w = previous_m_sBranch1.m_fTwitch * r3.w;
                    r4.w = 1 + -previous_m_fStrength;
                    r5.y = 1 + -previous_m_sBranch1.m_fTwitch;
                    r5.y = r7.y * r5.y;
                    r3.w = r3.w * r4.w + r5.y;
                    r4.w = previous_m_sBranch1.m_fWhip * r7.x;
                    r4.w = r4.w * v6.x + 1;
                    r4.w = r4.w * r3.w;
                    r3.w = r5.x ? r4.w : r3.w;
                }
                else
                {
                    r8.x = v6.y + r2.w;
                    r8.y = r2.w * 0.68900001 + v6.y;
                    r8.z = -v6.x + r8.x;
                    r9.xyz = float3(0.5, 0.5, 1.5) + r8.xyz;
                    r9.xyz = frac(r9.xyz);
                    r9.xyz = r9.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                    r10.xyz = abs(r9.xyz) * abs(r9.xyz);
                    r9.xyz = -abs(r9.xyz) * float3(2, 2, 2) + float3(3, 3, 3);
                    r9.xyz = r10.xyz * r9.xyz + float3(-0.5, -0.5, -0.5);
                    r9.xyz = r9.xyz + r9.xyz;
                    r5.yw = float2(0.5, 0.5) + r8.xy;
                    r5.yw = frac(r5.yw);
                    r5.yw = r5.yw * float2(2, 2) + float2(-1, -1);
                    r8.xy = abs(r5.yw) * abs(r5.yw);
                    r5.yw = -abs(r5.yw) * float2(2, 2) + float2(3, 3);
                    r8.xy = r8.xy * r5.yw;
                    r8.z = 0;
                    r8.xyz = float3(-0.5, -0.5, -0.5) + r8.xyz;
                    r8.xyz = r8.xyz + r8.xyz;
                    r7.xyz = r5.xxx ? r9.zxy : r8.zxy;
                    r4.w = r7.z * r7.y + r7.y;
                    r5.y = previous_m_sBranch1.m_fWhip * r7.x;
                    r5.y = r5.y * v6.x + 1;
                    r5.y = r5.y * r4.w;
                    r3.w = r5.x ? r5.y : r4.w;
                }
                r6.xyz = r6.xyz * r3.www;
                r6.xyz = r6.xyz * previous_m_sBranch1.m_fDistance + r3.xyz;
                r8.x = r2.w * 0.100000001 + v6.y;
                r2.w = previous_m_sBranch1.m_fTurbulence * m_fWallTime;
                r8.y = r2.w * 0.100000001 + v6.y;
                r5.yw = float2(0.5, 0.5) + r8.xy;
                r5.yw = frac(r5.yw);
                r5.yw = r5.yw * float2(2, 2) + float2(-1, -1);
                r7.yz = abs(r5.yw) * abs(r5.yw);
                r5.yw = -abs(r5.yw) * float2(2, 2) + float2(3, 3);
                r5.yw = r7.yz * r5.yw + float2(-0.5, -0.5);
                r5.yw = r5.yw + r5.yw;
                r5.yw = r5.yw * r5.yw;
                r2.w = r5.w * r5.y;
                r2.w = -r2.w * previous_m_sBranch1.m_fTurbulence + 1;
                r2.w = r5.z ? r2.w : 1;
                r3.w = previous_m_fStrength * r7.x;
                r3.w = r3.w * previous_m_sBranch1.m_fWhip + r2.w;
                r2.w = r5.x ? r3.w : r2.w;
                r5.xyz = previous_m_sBranch1.m_fDirectionAdherence * previous_m_vDirection.xyz;
                r5.xyz = r5.xyz * r2.www;
                r2.xyz = r5.xyz * v6.xxx + r6.xyz;
            }
            else
            {
                r2.w = cmp(0.5 < m_avWindConfigFlags[1].x);
                if (r2.w != 0)
                {
                    r5.xyz = cmp(float3(0.5, 0.5, 0.5) < m_avWindConfigFlags[1].zwy);
                    r6.xyz = float3(0.0625, 1, 16) * v6.yyy;
                    r6.xyz = frac(r6.xyz);
                    r6.xyz = r6.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                    r6.xyz = v6.xxx * r6.xyz;
                    r2.w = v0.x + v0.y;
                    r2.w = previous_m_sBranch1.m_fTime + r2.w;
                    if (r5.y != 0)
                    {
                        r7.x = v6.y + r2.w;
                        r7.y = r2.w * previous_m_sBranch1.m_fTwitchFreqScale + v6.y;
                        r3.w = previous_m_sBranch1.m_fTwitchFreqScale * r7.x;
                        r7.z = 0.5 * r3.w;
                        r7.w = -v6.x + r7.x;
                        r8.xyzw = float4(0.5, 0.5, 0.5, 1.5) + r7.xyzw;
                        r8.xyzw = frac(r8.xyzw);
                        r8.xyzw = r8.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
                        r9.xyzw = abs(r8.xyzw) * abs(r8.xyzw);
                        r8.xyzw = -abs(r8.xyzw) * float4(2, 2, 2, 2) + float4(3, 3, 3, 3);
                        r8.xyzw = r9.xyzw * r8.xyzw + float4(-0.5, -0.5, -0.5, -0.5);
                        r8.xyzw = r8.xyzw + r8.xyzw;
                        r7.xyz = float3(0.5, 0.5, 0.5) + r7.xyz;
                        r7.xyz = frac(r7.xyz);
                        r7.xyz = r7.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                        r9.xyz = abs(r7.xyz) * abs(r7.xyz);
                        r7.xyz = -abs(r7.xyz) * float3(2, 2, 2) + float3(3, 3, 3);
                        r7.xyz = r9.xyz * r7.xyz;
                        r7.w = 0;
                        r7.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r7.xyzw;
                        r7.xyzw = r7.xyzw + r7.xyzw;
                        r7.xyzw = r5.xxxx ? r8.wxyz : r7.wxyz;
                        r8.w = r7.z * r7.w;
                        r3.w = cmp(r8.w < 0);
                        r8.y = -r8.w;
                        r8.xz = float2(-1, 1);
                        r5.yw = r3.ww ? r8.xy : r8.zw;
                        r3.w = -r7.z * r7.w + r5.y;
                        r3.w = r5.w * r3.w + r8.w;
                        r4.w = r5.y + -r3.w;
                        r3.w = r5.w * r4.w + r3.w;
                        r3.w = previous_m_sBranch1.m_fTwitch * r3.w;
                        r4.w = 1 + -previous_m_fStrength;
                        r5.y = 1 + -previous_m_sBranch1.m_fTwitch;
                        r5.y = r7.y * r5.y;
                        r3.w = r3.w * r4.w + r5.y;
                        r4.w = previous_m_sBranch1.m_fWhip * r7.x;
                        r4.w = r4.w * v6.x + 1;
                        r4.w = r4.w * r3.w;
                        r3.w = r5.x ? r4.w : r3.w;
                    }
                    else
                    {
                        r8.x = v6.y + r2.w;
                        r8.y = r2.w * 0.68900001 + v6.y;
                        r8.z = -v6.x + r8.x;
                        r9.xyz = float3(0.5, 0.5, 1.5) + r8.xyz;
                        r9.xyz = frac(r9.xyz);
                        r9.xyz = r9.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                        r10.xyz = abs(r9.xyz) * abs(r9.xyz);
                        r9.xyz = -abs(r9.xyz) * float3(2, 2, 2) + float3(3, 3, 3);
                        r9.xyz = r10.xyz * r9.xyz + float3(-0.5, -0.5, -0.5);
                        r9.xyz = r9.xyz + r9.xyz;
                        r5.yw = float2(0.5, 0.5) + r8.xy;
                        r5.yw = frac(r5.yw);
                        r5.yw = r5.yw * float2(2, 2) + float2(-1, -1);
                        r8.xy = abs(r5.yw) * abs(r5.yw);
                        r5.yw = -abs(r5.yw) * float2(2, 2) + float2(3, 3);
                        r8.xy = r8.xy * r5.yw;
                        r8.z = 0;
                        r8.xyz = float3(-0.5, -0.5, -0.5) + r8.xyz;
                        r8.xyz = r8.xyz + r8.xyz;
                        r7.xyz = r5.xxx ? r9.zxy : r8.zxy;
                        r4.w = r7.z * r7.y + r7.y;
                        r5.y = previous_m_sBranch1.m_fWhip * r7.x;
                        r5.y = r5.y * v6.x + 1;
                        r5.y = r5.y * r4.w;
                        r3.w = r5.x ? r5.y : r4.w;
                    }
                    r6.xyz = r6.xyz * r3.www;
                    r6.xyz = r6.xyz * previous_m_sBranch1.m_fDistance + r3.xyz;
                    r8.x = r2.w * 0.100000001 + v6.y;
                    r2.w = previous_m_sBranch1.m_fTurbulence * m_fWallTime;
                    r8.y = r2.w * 0.100000001 + v6.y;
                    r5.yw = float2(0.5, 0.5) + r8.xy;
                    r5.yw = frac(r5.yw);
                    r5.yw = r5.yw * float2(2, 2) + float2(-1, -1);
                    r7.yz = abs(r5.yw) * abs(r5.yw);
                    r5.yw = -abs(r5.yw) * float2(2, 2) + float2(3, 3);
                    r5.yw = r7.yz * r5.yw + float2(-0.5, -0.5);
                    r5.yw = r5.yw + r5.yw;
                    r5.yw = r5.yw * r5.yw;
                    r2.w = r5.w * r5.y;
                    r2.w = -r2.w * previous_m_sBranch1.m_fTurbulence + 1;
                    r2.w = r5.z ? r2.w : 1;
                    r3.w = previous_m_fStrength * r7.x;
                    r3.w = r3.w * previous_m_sBranch1.m_fWhip + r2.w;
                    r2.w = r5.x ? r3.w : r2.w;
                    r5.xyz = previous_m_vAnchor.xyz + -r6.xyz;
                    r5.xyz = previous_m_sBranch1.m_fDirectionAdherence * r5.xyz;
                    r5.xyz = r5.xyz * r2.www;
                    r2.xyz = r5.xyz * v6.xxx + r6.xyz;
                }
                else
                {
                    r2.xyz = r3.xyz;
                }
            }
        }
        r2.w = cmp(0.5 < m_avWindConfigFlags[2].x);
        if (r2.w != 0)
        {
            r5.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[3].xy);
            r6.xyz = float3(0.0625, 1, 16) * v6.www;
            r6.xyz = frac(r6.xyz);
            r6.xyz = r6.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
            r6.xyz = v6.zzz * r6.xyz;
            r2.w = v0.x + v0.y;
            r2.w = previous_m_sBranch2.m_fTime + r2.w;
            if (r5.y != 0)
            {
                r7.x = v6.w + r2.w;
                r7.y = r2.w * previous_m_sBranch2.m_fTwitchFreqScale + v6.w;
                r3.w = previous_m_sBranch2.m_fTwitchFreqScale * r7.x;
                r7.z = 0.5 * r3.w;
                r7.w = -v6.z + r7.x;
                r8.xyzw = float4(0.5, 0.5, 0.5, 1.5) + r7.xyzw;
                r8.xyzw = frac(r8.xyzw);
                r8.xyzw = r8.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
                r9.xyzw = abs(r8.xyzw) * abs(r8.xyzw);
                r8.xyzw = -abs(r8.xyzw) * float4(2, 2, 2, 2) + float4(3, 3, 3, 3);
                r8.xyzw = r9.xyzw * r8.xyzw + float4(-0.5, -0.5, -0.5, -0.5);
                r8.xyzw = r8.xyzw + r8.xyzw;
                r5.yzw = float3(0.5, 0.5, 0.5) + r7.xyz;
                r5.yzw = frac(r5.yzw);
                r5.yzw = r5.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
                r7.xyz = abs(r5.yzw) * abs(r5.yzw);
                r5.yzw = -abs(r5.yzw) * float3(2, 2, 2) + float3(3, 3, 3);
                r7.xyz = r7.xyz * r5.yzw;
                r7.w = 0;
                r7.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r7.xyzw;
                r7.xyzw = r7.xyzw + r7.xyzw;
                r7.xyzw = r5.xxxx ? r8.xyzw : r7.xyzw;
                r8.w = r7.y * r7.z;
                r3.w = cmp(r8.w < 0);
                r8.y = -r8.w;
                r8.xz = float2(-1, 1);
                r5.yz = r3.ww ? r8.xy : r8.zw;
                r3.w = -r7.y * r7.z + r5.y;
                r3.w = r5.z * r3.w + r8.w;
                r4.w = r5.y + -r3.w;
                r3.w = r5.z * r4.w + r3.w;
                r3.w = previous_m_sBranch2.m_fTwitch * r3.w;
                r4.w = 1 + -previous_m_fStrength;
                r5.y = 1 + -previous_m_sBranch2.m_fTwitch;
                r5.y = r7.x * r5.y;
                r3.w = r3.w * r4.w + r5.y;
                r4.w = previous_m_sBranch2.m_fWhip * r7.w;
                r4.w = r4.w * v6.z + 1;
                r4.w = r4.w * r3.w;
                r3.w = r5.x ? r4.w : r3.w;
            }
            else
            {
                r7.x = v6.w + r2.w;
                r7.y = r2.w * 0.68900001 + v6.w;
                r7.z = -v6.z + r7.x;
                r5.yzw = float3(0.5, 0.5, 1.5) + r7.xyz;
                r5.yzw = frac(r5.yzw);
                r5.yzw = r5.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
                r8.xyz = abs(r5.yzw) * abs(r5.yzw);
                r5.yzw = -abs(r5.yzw) * float3(2, 2, 2) + float3(3, 3, 3);
                r5.yzw = r8.xyz * r5.yzw + float3(-0.5, -0.5, -0.5);
                r5.yzw = r5.yzw + r5.yzw;
                r7.xy = float2(0.5, 0.5) + r7.xy;
                r7.xy = frac(r7.xy);
                r7.xy = r7.xy * float2(2, 2) + float2(-1, -1);
                r7.zw = abs(r7.xy) * abs(r7.xy);
                r7.xy = -abs(r7.xy) * float2(2, 2) + float2(3, 3);
                r7.xy = r7.zw * r7.xy;
                r7.z = 0;
                r7.xyz = float3(-0.5, -0.5, -0.5) + r7.xyz;
                r7.xyz = r7.xyz + r7.xyz;
                r5.yzw = r5.xxx ? r5.yzw : r7.xyz;
                r2.w = r5.z * r5.y + r5.y;
                r4.w = previous_m_sBranch2.m_fWhip * r5.w;
                r4.w = r4.w * v6.z + 1;
                r4.w = r4.w * r2.w;
                r3.w = r5.x ? r4.w : r2.w;
            }
            r5.xyz = r6.xyz * r3.www;
            r2.xyz = r5.xyz * previous_m_sBranch2.m_fDistance + r2.xyz;
        }
        else
        {
            r2.w = cmp(0.5 < m_avWindConfigFlags[2].y);
            if (r2.w != 0)
            {
                r5.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[3].xy);
                r2.w = cmp(0.5 < m_avWindConfigFlags[2].w);
                r6.xyz = float3(0.0625, 1, 16) * v6.www;
                r6.xyz = frac(r6.xyz);
                r6.xyz = r6.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                r6.xyz = v6.zzz * r6.xyz;
                r3.w = v0.x + v0.y;
                r3.w = previous_m_sBranch2.m_fTime + r3.w;
                if (r5.y != 0)
                {
                    r7.x = v6.w + r3.w;
                    r7.y = r3.w * previous_m_sBranch2.m_fTwitchFreqScale + v6.w;
                    r4.w = previous_m_sBranch2.m_fTwitchFreqScale * r7.x;
                    r7.z = 0.5 * r4.w;
                    r7.w = -v6.z + r7.x;
                    r8.xyzw = float4(0.5, 0.5, 0.5, 1.5) + r7.xyzw;
                    r8.xyzw = frac(r8.xyzw);
                    r8.xyzw = r8.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
                    r9.xyzw = abs(r8.xyzw) * abs(r8.xyzw);
                    r8.xyzw = -abs(r8.xyzw) * float4(2, 2, 2, 2) + float4(3, 3, 3, 3);
                    r8.xyzw = r9.xyzw * r8.xyzw + float4(-0.5, -0.5, -0.5, -0.5);
                    r8.xyzw = r8.xyzw + r8.xyzw;
                    r5.yzw = float3(0.5, 0.5, 0.5) + r7.xyz;
                    r5.yzw = frac(r5.yzw);
                    r5.yzw = r5.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
                    r7.xyz = abs(r5.yzw) * abs(r5.yzw);
                    r5.yzw = -abs(r5.yzw) * float3(2, 2, 2) + float3(3, 3, 3);
                    r7.xyz = r7.xyz * r5.yzw;
                    r7.w = 0;
                    r7.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r7.xyzw;
                    r7.xyzw = r7.xyzw + r7.xyzw;
                    r7.xyzw = r5.xxxx ? r8.wxyz : r7.wxyz;
                    r8.w = r7.z * r7.w;
                    r4.w = cmp(r8.w < 0);
                    r8.y = -r8.w;
                    r8.xz = float2(-1, 1);
                    r5.yz = r4.ww ? r8.xy : r8.zw;
                    r4.w = -r7.z * r7.w + r5.y;
                    r4.w = r5.z * r4.w + r8.w;
                    r5.y = r5.y + -r4.w;
                    r4.w = r5.z * r5.y + r4.w;
                    r4.w = previous_m_sBranch2.m_fTwitch * r4.w;
                    r5.y = 1 + -previous_m_fStrength;
                    r5.z = 1 + -previous_m_sBranch2.m_fTwitch;
                    r5.z = r7.y * r5.z;
                    r4.w = r4.w * r5.y + r5.z;
                    r5.y = previous_m_sBranch2.m_fWhip * r7.x;
                    r5.y = r5.y * v6.z + 1;
                    r5.y = r5.y * r4.w;
                    r4.w = r5.x ? r5.y : r4.w;
                }
                else
                {
                    r8.x = v6.w + r3.w;
                    r8.y = r3.w * 0.68900001 + v6.w;
                    r8.z = -v6.z + r8.x;
                    r5.yzw = float3(0.5, 0.5, 1.5) + r8.xyz;
                    r5.yzw = frac(r5.yzw);
                    r5.yzw = r5.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
                    r9.xyz = abs(r5.yzw) * abs(r5.yzw);
                    r5.yzw = -abs(r5.yzw) * float3(2, 2, 2) + float3(3, 3, 3);
                    r5.yzw = r9.xyz * r5.yzw + float3(-0.5, -0.5, -0.5);
                    r5.yzw = r5.yzw + r5.yzw;
                    r8.xy = float2(0.5, 0.5) + r8.xy;
                    r8.xy = frac(r8.xy);
                    r8.xy = r8.xy * float2(2, 2) + float2(-1, -1);
                    r8.zw = abs(r8.xy) * abs(r8.xy);
                    r8.xy = -abs(r8.xy) * float2(2, 2) + float2(3, 3);
                    r8.xy = r8.zw * r8.xy;
                    r8.z = 0;
                    r8.xyz = float3(-0.5, -0.5, -0.5) + r8.xyz;
                    r8.xyz = r8.xyz + r8.xyz;
                    r7.xyz = r5.xxx ? r5.wyz : r8.zxy;
                    r5.y = r7.z * r7.y + r7.y;
                    r5.z = previous_m_sBranch2.m_fWhip * r7.x;
                    r5.z = r5.z * v6.z + 1;
                    r5.z = r5.y * r5.z;
                    r4.w = r5.x ? r5.z : r5.y;
                }
                r5.yzw = r6.xyz * r4.www;
                r5.yzw = r5.yzw * previous_m_sBranch2.m_fDistance + r2.xyz;
                r6.x = r3.w * 0.100000001 + v6.w;
                r3.w = previous_m_sBranch2.m_fTurbulence * m_fWallTime;
                r6.y = r3.w * 0.100000001 + v6.w;
                r6.xy = float2(0.5, 0.5) + r6.xy;
                r6.xy = frac(r6.xy);
                r6.xy = r6.xy * float2(2, 2) + float2(-1, -1);
                r6.zw = abs(r6.xy) * abs(r6.xy);
                r6.xy = -abs(r6.xy) * float2(2, 2) + float2(3, 3);
                r6.xy = r6.zw * r6.xy + float2(-0.5, -0.5);
                r6.xy = r6.xy + r6.xy;
                r6.xy = r6.xy * r6.xy;
                r3.w = r6.y * r6.x;
                r3.w = -r3.w * previous_m_sBranch2.m_fTurbulence + 1;
                r2.w = r2.w ? r3.w : 1;
                r3.w = previous_m_fStrength * r7.x;
                r3.w = r3.w * previous_m_sBranch2.m_fWhip + r2.w;
                r2.w = r5.x ? r3.w : r2.w;
                r6.xyz = previous_m_sBranch2.m_fDirectionAdherence * previous_m_vDirection.xyz;
                r6.xyz = r6.xyz * r2.www;
                r2.xyz = r6.xyz * v6.zzz + r5.yzw;
            }
            else
            {
                r2.w = cmp(0.5 < m_avWindConfigFlags[2].z);
                if (r2.w != 0)
                {
                    r5.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[3].xy);
                    r2.w = cmp(0.5 < m_avWindConfigFlags[2].w);
                    r6.xyz = float3(0.0625, 1, 16) * v6.www;
                    r6.xyz = frac(r6.xyz);
                    r6.xyz = r6.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                    r6.xyz = v6.zzz * r6.xyz;
                    r3.w = v0.x + v0.y;
                    r3.w = previous_m_sBranch2.m_fTime + r3.w;
                    if (r5.y != 0)
                    {
                        r7.x = v6.w + r3.w;
                        r7.y = r3.w * previous_m_sBranch2.m_fTwitchFreqScale + v6.w;
                        r4.w = previous_m_sBranch2.m_fTwitchFreqScale * r7.x;
                        r7.z = 0.5 * r4.w;
                        r7.w = -v6.z + r7.x;
                        r8.xyzw = float4(0.5, 0.5, 0.5, 1.5) + r7.xyzw;
                        r8.xyzw = frac(r8.xyzw);
                        r8.xyzw = r8.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
                        r9.xyzw = abs(r8.xyzw) * abs(r8.xyzw);
                        r8.xyzw = -abs(r8.xyzw) * float4(2, 2, 2, 2) + float4(3, 3, 3, 3);
                        r8.xyzw = r9.xyzw * r8.xyzw + float4(-0.5, -0.5, -0.5, -0.5);
                        r8.xyzw = r8.xyzw + r8.xyzw;
                        r5.yzw = float3(0.5, 0.5, 0.5) + r7.xyz;
                        r5.yzw = frac(r5.yzw);
                        r5.yzw = r5.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
                        r7.xyz = abs(r5.yzw) * abs(r5.yzw);
                        r5.yzw = -abs(r5.yzw) * float3(2, 2, 2) + float3(3, 3, 3);
                        r7.xyz = r7.xyz * r5.yzw;
                        r7.w = 0;
                        r7.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r7.xyzw;
                        r7.xyzw = r7.xyzw + r7.xyzw;
                        r7.xyzw = r5.xxxx ? r8.wxyz : r7.wxyz;
                        r8.w = r7.z * r7.w;
                        r4.w = cmp(r8.w < 0);
                        r8.y = -r8.w;
                        r8.xz = float2(-1, 1);
                        r5.yz = r4.ww ? r8.xy : r8.zw;
                        r4.w = -r7.z * r7.w + r5.y;
                        r4.w = r5.z * r4.w + r8.w;
                        r5.y = r5.y + -r4.w;
                        r4.w = r5.z * r5.y + r4.w;
                        r4.w = previous_m_sBranch2.m_fTwitch * r4.w;
                        r5.y = 1 + -previous_m_fStrength;
                        r5.z = 1 + -previous_m_sBranch2.m_fTwitch;
                        r5.z = r7.y * r5.z;
                        r4.w = r4.w * r5.y + r5.z;
                        r5.y = previous_m_sBranch2.m_fWhip * r7.x;
                        r5.y = r5.y * v6.z + 1;
                        r5.y = r5.y * r4.w;
                        r4.w = r5.x ? r5.y : r4.w;
                    }
                    else
                    {
                        r8.x = v6.w + r3.w;
                        r8.y = r3.w * 0.68900001 + v6.w;
                        r8.z = -v6.z + r8.x;
                        r5.yzw = float3(0.5, 0.5, 1.5) + r8.xyz;
                        r5.yzw = frac(r5.yzw);
                        r5.yzw = r5.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
                        r9.xyz = abs(r5.yzw) * abs(r5.yzw);
                        r5.yzw = -abs(r5.yzw) * float3(2, 2, 2) + float3(3, 3, 3);
                        r5.yzw = r9.xyz * r5.yzw + float3(-0.5, -0.5, -0.5);
                        r5.yzw = r5.yzw + r5.yzw;
                        r8.xy = float2(0.5, 0.5) + r8.xy;
                        r8.xy = frac(r8.xy);
                        r8.xy = r8.xy * float2(2, 2) + float2(-1, -1);
                        r8.zw = abs(r8.xy) * abs(r8.xy);
                        r8.xy = -abs(r8.xy) * float2(2, 2) + float2(3, 3);
                        r8.xy = r8.zw * r8.xy;
                        r8.z = 0;
                        r8.xyz = float3(-0.5, -0.5, -0.5) + r8.xyz;
                        r8.xyz = r8.xyz + r8.xyz;
                        r7.xyz = r5.xxx ? r5.wyz : r8.zxy;
                        r5.y = r7.z * r7.y + r7.y;
                        r5.z = previous_m_sBranch2.m_fWhip * r7.x;
                        r5.z = r5.z * v6.z + 1;
                        r5.z = r5.y * r5.z;
                        r4.w = r5.x ? r5.z : r5.y;
                    }
                    r5.yzw = r6.xyz * r4.www;
                    r5.yzw = r5.yzw * previous_m_sBranch2.m_fDistance + r2.xyz;
                    r6.x = r3.w * 0.100000001 + v6.w;
                    r3.w = previous_m_sBranch2.m_fTurbulence * m_fWallTime;
                    r6.y = r3.w * 0.100000001 + v6.w;
                    r6.xy = float2(0.5, 0.5) + r6.xy;
                    r6.xy = frac(r6.xy);
                    r6.xy = r6.xy * float2(2, 2) + float2(-1, -1);
                    r6.zw = abs(r6.xy) * abs(r6.xy);
                    r6.xy = -abs(r6.xy) * float2(2, 2) + float2(3, 3);
                    r6.xy = r6.zw * r6.xy + float2(-0.5, -0.5);
                    r6.xy = r6.xy + r6.xy;
                    r6.xy = r6.xy * r6.xy;
                    r3.w = r6.y * r6.x;
                    r3.w = -r3.w * previous_m_sBranch2.m_fTurbulence + 1;
                    r2.w = r2.w ? r3.w : 1;
                    r3.w = previous_m_fStrength * r7.x;
                    r3.w = r3.w * previous_m_sBranch2.m_fWhip + r2.w;
                    r2.w = r5.x ? r3.w : r2.w;
                    r6.xyz = previous_m_vAnchor.xyz + -r5.yzw;
                    r6.xyz = previous_m_sBranch2.m_fDirectionAdherence * r6.xyz;
                    r6.xyz = r6.xyz * r2.www;
                    r2.xyz = r6.xyz * v6.zzz + r5.yzw;
                }
            }
        }
        r2.xyz = r2.xyz + -r3.xyz;
    }
    else
    {
        r2.xyz = float3(0, 0, 0);
    }
    r2.w = cmp(0 < v7.x);
    if (r2.w != 0)
    {
        r5.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[5].wx);
        r2.w = dot(r3.xy, r3.xy);
        r2.w = rsqrt(r2.w);
        r5.zw = r3.xy * r2.ww;
        r2.w = dot(-r5.zw, previous_m_vDirection.xy);
        r2.w = 1 + r2.w;
        r2.w = 0.5 * r2.w;
        r3.w = 1 + -previous_m_sLeaf2.m_fLeewardScalar;
        r2.w = r2.w * r3.w + previous_m_sLeaf2.m_fLeewardScalar;
        r2.w = v5.y * r2.w;
        r2.w = r5.x ? r2.w : v5.y;
        r3.w = cmp(0.5 < m_avWindConfigFlags[6].w);
        if (r3.w != 0)
        {
            r5.xz = v0.xy + r3.xy;
            r5.xz = -previous_m_sRolling.m_vOffset.xy + r5.xz;
            r5.xz = previous_m_sRolling.m_fNoiseSize * r5.xz;
            r3.w = 5 * previous_m_sRolling.m_fNoisePeriod;
            r3.w = dot(r5.xz, r3.ww);
            r4.w = previous_m_sRolling.m_fNoiseTurbulence;
            r5.w = 0;
            while (true)
            {
                r6.x = cmp(r4.w < 1);
                if (r6.x != 0)
                    break;
                r6.xy = r5.xz / r4.ww;
                r6.xy = frac(r6.xy);
                r6.xyzw = PerlinNoiseKernel.SampleLevel(samStandard_s, r6.xy, 0).xyzw;
                r6.x = dot(r6.xyzw, float4(0.25, 0.25, 0.25, 0.25));
                r5.w = r6.x * r4.w + r5.w;
                r4.w = 0.5 * r4.w;
            }
            r4.w = 0.5 * r5.w;
            r4.w = r4.w / previous_m_sRolling.m_fNoiseTurbulence;
            r3.w = previous_m_sRolling.m_fNoiseTwist * r4.w + r3.w;
            r3.w = 3.14159274 * r3.w;
            r3.w = sin(r3.w);
            r3.w = 1 + -abs(r3.w);
            r4.w = 1 + -previous_m_sRolling.m_fLeafRippleMin;
            r3.w = r3.w * r4.w + previous_m_sRolling.m_fLeafRippleMin;
        }
        else
        {
            r3.w = 1;
        }
        r4.w = cmp(0.5 < m_avWindConfigFlags[4].w);
        r2.w = r3.w * r2.w;
        r3.w = previous_m_sLeaf2.m_fRippleTime + r0.w;
        r3.w = 0.5 + r3.w;
        r3.w = frac(r3.w);
        r3.w = r3.w * 2 + -1;
        r5.x = abs(r3.w) * abs(r3.w);
        r3.w = -abs(r3.w) * 2 + 3;
        r3.w = r5.x * r3.w + -0.5;
        r3.w = dot(r3.ww, previous_m_sLeaf2.m_fRippleDistance);
        r5.xzw = r4.xyz * r3.www;
        r5.xzw = r5.xzw * r2.www + r3.xyz;
        r6.xyz = float3(0.0625, 1, 16) * v5.www;
        r6.xyz = frac(r6.xyz);
        r6.xyz = r6.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
        r6.xyz = r6.xyz * r3.www;
        r6.xyz = r6.xyz * r2.www + r3.xyz;
        r6.xyz = r5.yyy ? r6.xyz : r3.xyz;
        r5.xyz = r4.www ? r5.xzw : r6.xyz;
        r5.xyz = r5.xyz + -r3.xyz;
    }
    else
    {
        r2.w = cmp(0.5 < m_avWindConfigFlags[4].z);
        r3.w = dot(r3.xy, r3.xy);
        r3.w = rsqrt(r3.w);
        r6.xy = r3.xy * r3.ww;
        r3.w = dot(-r6.xy, previous_m_vDirection.xy);
        r3.w = 1 + r3.w;
        r3.w = 0.5 * r3.w;
        r4.w = 1 + -previous_m_sLeaf1.m_fLeewardScalar;
        r3.w = r3.w * r4.w + previous_m_sLeaf1.m_fLeewardScalar;
        r3.w = v5.y * r3.w;
        r2.w = r2.w ? r3.w : v5.y;
        r3.w = cmp(0.5 < m_avWindConfigFlags[6].w);
        if (r3.w != 0)
        {
            r6.xy = v0.xy + r3.xy;
            r6.xy = -previous_m_sRolling.m_vOffset.xy + r6.xy;
            r6.xy = previous_m_sRolling.m_fNoiseSize * r6.xy;
            r3.w = 5 * previous_m_sRolling.m_fNoisePeriod;
            r3.w = dot(r6.xy, r3.ww);
            r4.w = previous_m_sRolling.m_fNoiseTurbulence;
            r5.w = 0;
            while (true)
            {
                r6.z = cmp(r4.w < 1);
                if (r6.z != 0)
                    break;
                r6.zw = r6.xy / r4.ww;
                r6.zw = frac(r6.zw);
                r7.xyzw = PerlinNoiseKernel.SampleLevel(samStandard_s, r6.zw, 0).xyzw;
                r6.z = dot(r7.xyzw, float4(0.25, 0.25, 0.25, 0.25));
                r5.w = r6.z * r4.w + r5.w;
                r4.w = 0.5 * r4.w;
            }
            r4.w = 0.5 * r5.w;
            r4.w = r4.w / previous_m_sRolling.m_fNoiseTurbulence;
            r3.w = previous_m_sRolling.m_fNoiseTwist * r4.w + r3.w;
            r3.w = 3.14159274 * r3.w;
            r3.w = sin(r3.w);
            r3.w = 1 + -abs(r3.w);
            r4.w = 1 + -previous_m_sRolling.m_fLeafRippleMin;
            r3.w = r3.w * r4.w + previous_m_sRolling.m_fLeafRippleMin;
        }
        else
        {
            r3.w = 1;
        }
        r2.w = r3.w * r2.w;
        r0.w = previous_m_sLeaf1.m_fRippleTime + r0.w;
        r0.w = 0.5 + r0.w;
        r0.w = frac(r0.w);
        r0.w = r0.w * 2 + -1;
        r3.w = abs(r0.w) * abs(r0.w);
        r0.w = -abs(r0.w) * 2 + 3;
        r0.w = r3.w * r0.w + -0.5;
        r0.w = dot(r0.ww, previous_m_sLeaf1.m_fRippleDistance);
        r6.xyz = r4.xyz * r0.www;
        r6.xyz = r6.xyz * r2.www + r3.xyz;
        r7.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[3].zw);
        r8.xyz = float3(0.0625, 1, 16) * v5.www;
        r8.xyz = frac(r8.xyz);
        r8.xyz = r8.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
        r8.xyz = r8.xyz * r0.www;
        r8.xyz = r8.xyz * r2.www + r3.xyz;
        r7.yzw = r7.yyy ? r8.xyz : r3.xyz;
        r6.xyz = r7.xxx ? r6.xyz : r7.yzw;
        r5.xyz = r6.xyz + -r3.xyz;
    }
    r0.w = cmp(0.5 < m_avWindLodFlags[0].w);
    if (r0.w != 0)
    {
        r6.xyz = r1.xyz * r1.www + r3.xyz;
    }
    else
    {
        r0.w = cmp(0.5 < m_avWindLodFlags[1].x);
        if (r0.w != 0)
        {
            r7.xyz = r2.xyz + r1.xyz;
            r6.xyz = r7.xyz * r1.www + r3.xyz;
        }
        else
        {
            r0.w = cmp(0.5 < m_avWindLodFlags[1].y);
            if (r0.w != 0)
            {
                r7.xyz = r2.xyz + r1.xyz;
                r7.xyz = r7.xyz + r5.xyz;
                r6.xyz = r7.xyz * r1.www + r3.xyz;
            }
            else
            {
                r0.w = cmp(0.5 < m_avWindLodFlags[1].z);
                if (r0.w != 0)
                {
                    r7.xyz = r2.xyz * r1.www + r1.xyz;
                    r6.xyz = r7.xyz + r3.xyz;
                }
                else
                {
                    r0.w = cmp(0.5 < m_avWindLodFlags[1].w);
                    r7.xyz = r5.xyz + r2.xyz;
                    r7.xyz = r7.xyz * r1.www + r1.xyz;
                    r7.xyz = r7.xyz + r3.xyz;
                    r2.w = cmp(0.5 < m_avWindLodFlags[2].x);
                    r2.xyz = r2.xyz + r1.xyz;
                    r8.xyz = r5.xyz * r1.www + r2.xyz;
                    r8.xyz = r8.xyz + r3.xyz;
                    r1.xyz = r3.xyz + r1.xyz;
                    r9.xyz = r3.xyz + r2.xyz;
                    r10.xyz = cmp(float3(0.5, 0.5, 0.5) < m_avWindLodFlags[0].xyz);
                    r2.xyz = r2.xyz + r5.xyz;
                    r2.xyz = r3.xyz + r2.xyz;
                    r2.xyz = r10.zzz ? r2.xyz : r3.xyz;
                    r2.xyz = r10.yyy ? r9.xyz : r2.xyz;
                    r1.xyz = r10.xxx ? r1.xyz : r2.xyz;
                    r1.xyz = r2.www ? r8.xyz : r1.xyz;
                    r6.xyz = r0.www ? r7.xyz : r1.xyz;
                }
            }
        }
    }
    r0.w = cmp(0.5 < m_avEffectConfigFlags[2].z);
    r1.x = 1 + -v5.x;
    r1.x = r1.w * r1.x + v5.x;
    r2.x = v3.w;
    r2.y = v4.z;
    r1.xy = r2.xy * r1.xx;
    r2.xy = r0.ww ? r1.xy : r2.xy;
    r2.z = -r2.x;
    r2.w = 1;
    r1.x = dot(m_mCameraFacingMatrix._m02_m01_m03, r2.yzw);
    r2.xyz = float3(-1, 1, 1) * r2.xyw;
    r1.y = dot(m_mCameraFacingMatrix._m11_m12_m13, r2.xyz);
    r1.z = dot(m_mCameraFacingMatrix._m21_m22_m23, r2.xyz);
    r1.xyz = r6.xyz + r1.xyz;
    r1.xyz = v4.www * m_vCameraDirection.xyz + r1.xyz;
    r1.xyz = r1.xyz * v0.www + v0.xyz;
    r0.w = saturate(-v2.w);
    r0.w = 1 + -r0.w;
    r2.xyz = cmp(v2.xyz >= -v2.xyz);
    r3.xyz = frac(abs(v2.xyz));
    r2.xyz = r2.xyz ? r3.xyz : -r3.xyz;
    r2.xyz = m_fHueVariationByPos * r2.xyz;
    r0.xyz = float3(20, 20, 20) * r0.xyz;
    r0.xyz = sin(r0.xyz);
    r0.xyz = m_fHueVariationByVertex * r0.xyz;
    r0.xyz = m_vHueVariationColor.xyz * r0.xyz;
    r0.xyz = r2.xyz * m_vHueVariationColor.xyz + r0.xyz;
    r0.w = cmp(1.5 < m_avEffectConfigFlags[3].w);
    r2.xyz = saturate(r1.www * r0.xyz);
    r0.xyz = v2.xxx * float3(0.5, 0.5, 0.5) + float3(0.5, 0.166669995, -0.166660011);
    r0.w = saturate(3 * r0.x);
    r0.x = 1 + -r0.x;
    r0.x = saturate(3 * r0.x);
    r0.xy = -abs(r0.yz) * float2(3, 3) + float2(1, 1);
    r0.xyz = -m_vCameraPosition.xyz + r1.xyz;
    r0.w = 1;

    float3 position;

    position.x = dot(m_mModelViewProj3d._m00_m01_m02_m03, r0.xyzw);
    position.y = dot(m_mModelViewProj3d._m10_m11_m12_m13, r0.xyzw);
    //o0.z = dot(m_mModelViewProj3d._m20_m21_m22_m23, r0.xyzw);
    //o0.w = dot(m_mModelViewProj3d._m30_m31_m32_m33, r0.xyzw);
    position.z = dot(m_mModelViewProj3d._m30_m31_m32_m33, r0.xyzw);

    return position;
}

void VSMain(
    float4 v0 : TEXCOORD0,
    float4 v1 : TEXCOORD1,
    float4 v2 : TEXCOORD2,
    float4 v3 : POSITION0,
    float4 v4 : TEXCOORD3,
    float4 v5 : TEXCOORD4,
    float4 v6 : TEXCOORD5,
    float4 v7 : TEXCOORD6,
    float4 v8 : TEXCOORD7,
    float4 v9 : TEXCOORD8,
    out float4 o0 : SV_POSITION0,
    out float4 o1 : TEXCOORD0,
    out float4 o2 : TEXCOORD1,
    out float4 o3 : TEXCOORD2,
    out float4 o4 : TEXCOORD3,
    out float4 o5 : TEXCOORD4,
    out float4 o6 : TEXCOORD5,
    out float4 o7 : TEXCOORD6,
    out float3 previous_frame_position : TEXCOORD7,
    out float3 current_frame_position : TEXCOORD8)
{
    float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10;

    r0.xyz = v8.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
    r1.xyz = v9.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
    r0.w = floor(v1.w);
    r1.w = v1.w + -r0.w;
    r1.w = 1.33333337 * r1.w;
    o7.x = 0.00392156886 * r0.w;
    r0.w = v3.x + v3.y;
    r2.xyz = v2.yzx * v1.zxy;
    r2.xyz = v1.yzx * v2.zxy + -r2.xyz;
    r2.w = dot(r2.xyz, r2.xyz);
    r2.w = rsqrt(r2.w);
    r2.xyz = r2.xyz * r2.www;
    r3.xyz = v3.yyy * r2.xyz;
    r3.xyz = v2.xyz * v3.xxx + r3.xyz;
    r3.xyz = v1.xyz * v3.zzz + r3.xyz;
    r4.xyz = r2.xyz * r0.yyy;
    r4.xyz = v2.xyz * r0.xxx + r4.xyz;
    r4.xyz = v1.xyz * r0.zzz + r4.xyz;
    r2.xyz = r2.xyz * r1.yyy;
    r2.xyz = v2.xyz * r1.xxx + r2.xyz;
    o3.xyz = v1.xyz * r1.zzz + r2.xyz;
    r1.x = v4.z + v3.w;
    r0.w = r1.x + r0.w;
    r1.x = cmp(0.5 < m_avWindConfigFlags[0].x);
    r1.y = dot(r3.xyz, r3.xyz);
    r1.y = sqrt(r1.y);
    r1.z = 1 / m_sGlobal.m_fHeight;
    r1.z = -r1.z * 0.25 + r3.z;
    r1.z = max(0, r1.z);
    r1.z = m_sGlobal.m_fHeight * r1.z;
    r2.x = cmp(r1.z != 0.000000);
    r2.y = log2(abs(r1.z));
    r2.y = m_sGlobal.m_fHeightExponent * r2.y;
    r2.y = exp2(r2.y);
    r1.z = r2.x ? r2.y : r1.z;
    r2.x = m_sGlobal.m_fTime + v0.x;
    r2.y = m_sGlobal.m_fTime * 0.800000012 + v0.y;
    r2.xy = float2(0.5, 0.5) + r2.xy;
    r2.xy = frac(r2.xy);
    r2.xy = r2.xy * float2(2, 2) + float2(-1, -1);
    r2.zw = abs(r2.xy) * abs(r2.xy);
    r2.xy = -abs(r2.xy) * float2(2, 2) + float2(3, 3);
    r2.xy = r2.zw * r2.xy + float2(-0.5, -0.5);
    r2.xy = r2.xy + r2.xy;
    r2.x = r2.y * r2.y + r2.x;
    r2.y = m_sGlobal.m_fAdherence / m_sGlobal.m_fHeight;
    r2.x = m_sGlobal.m_fDistance * r2.x + r2.y;
    r1.z = r2.x * r1.z;
    r2.xy = m_vDirection.xy * r1.zz + r3.xy;
    r2.z = r3.z;
    r1.z = dot(r2.xyz, r2.xyz);
    r1.z = rsqrt(r1.z);
    r2.xyz = r2.xyz * r1.zzz;
    r2.xyz = r2.xyz * r1.yyy + -r3.xyz;
    r1.xyz = r1.xxx ? r2.xyz : 0;
    r2.x = cmp(0.5 < m_avWindLodFlags[2].w);
    if (r2.x != 0)
    {
        r2.x = cmp(0.5 < m_avWindConfigFlags[0].z);
        if (r2.x != 0)
        {
            r2.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[1].zw);
            r5.xyz = float3(0.0625, 1, 16) * v6.yyy;
            r5.xyz = frac(r5.xyz);
            r5.xyz = r5.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
            r5.xyz = v6.xxx * r5.xyz;
            r2.z = v0.x + v0.y;
            r2.z = m_sBranch1.m_fTime + r2.z;
            if (r2.y != 0)
            {
                r6.x = v6.y + r2.z;
                r6.y = r2.z * m_sBranch1.m_fTwitchFreqScale + v6.y;
                r2.y = m_sBranch1.m_fTwitchFreqScale * r6.x;
                r6.z = 0.5 * r2.y;
                r6.w = -v6.x + r6.x;
                r7.xyzw = float4(0.5, 0.5, 0.5, 1.5) + r6.xyzw;
                r7.xyzw = frac(r7.xyzw);
                r7.xyzw = r7.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
                r8.xyzw = abs(r7.xyzw) * abs(r7.xyzw);
                r7.xyzw = -abs(r7.xyzw) * float4(2, 2, 2, 2) + float4(3, 3, 3, 3);
                r7.xyzw = r8.xyzw * r7.xyzw + float4(-0.5, -0.5, -0.5, -0.5);
                r7.xyzw = r7.xyzw + r7.xyzw;
                r6.xyz = float3(0.5, 0.5, 0.5) + r6.xyz;
                r6.xyz = frac(r6.xyz);
                r6.xyz = r6.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                r8.xyz = abs(r6.xyz) * abs(r6.xyz);
                r6.xyz = -abs(r6.xyz) * float3(2, 2, 2) + float3(3, 3, 3);
                r6.xyz = r8.xyz * r6.xyz;
                r6.w = 0;
                r6.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r6.xyzw;
                r6.xyzw = r6.xyzw + r6.xyzw;
                r6.xyzw = r2.xxxx ? r7.xyzw : r6.xyzw;
                r7.w = r6.y * r6.z;
                r2.y = cmp(r7.w < 0);
                r7.y = -r7.w;
                r7.xz = float2(-1, 1);
                r2.yw = r2.yy ? r7.xy : r7.zw;
                r3.w = -r6.y * r6.z + r2.y;
                r3.w = r2.w * r3.w + r7.w;
                r2.y = -r3.w + r2.y;
                r2.y = r2.w * r2.y + r3.w;
                r2.y = m_sBranch1.m_fTwitch * r2.y;
                r2.w = 1 + -m_fStrength;
                r3.w = 1 + -m_sBranch1.m_fTwitch;
                r3.w = r6.x * r3.w;
                r2.y = r2.y * r2.w + r3.w;
                r2.w = m_sBranch1.m_fWhip * r6.w;
                r2.w = r2.w * v6.x + 1;
                r2.w = r2.y * r2.w;
                r2.y = r2.x ? r2.w : r2.y;
            }
            else
            {
                r6.x = v6.y + r2.z;
                r6.y = r2.z * 0.68900001 + v6.y;
                r6.z = -v6.x + r6.x;
                r7.xyz = float3(0.5, 0.5, 1.5) + r6.xyz;
                r7.xyz = frac(r7.xyz);
                r7.xyz = r7.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                r8.xyz = abs(r7.xyz) * abs(r7.xyz);
                r7.xyz = -abs(r7.xyz) * float3(2, 2, 2) + float3(3, 3, 3);
                r7.xyz = r8.xyz * r7.xyz + float3(-0.5, -0.5, -0.5);
                r7.xyz = r7.xyz + r7.xyz;
                r2.zw = float2(0.5, 0.5) + r6.xy;
                r2.zw = frac(r2.zw);
                r2.zw = r2.zw * float2(2, 2) + float2(-1, -1);
                r6.xy = abs(r2.zw) * abs(r2.zw);
                r2.zw = -abs(r2.zw) * float2(2, 2) + float2(3, 3);
                r6.xy = r6.xy * r2.zw;
                r6.z = 0;
                r6.xyz = float3(-0.5, -0.5, -0.5) + r6.xyz;
                r6.xyz = r6.xyz + r6.xyz;
                r6.xyz = r2.xxx ? r7.xyz : r6.xyz;
                r2.z = r6.y * r6.x + r6.x;
                r2.w = m_sBranch1.m_fWhip * r6.z;
                r2.w = r2.w * v6.x + 1;
                r2.w = r2.z * r2.w;
                r2.y = r2.x ? r2.w : r2.z;
            }
            r2.xyz = r5.xyz * r2.yyy;
            r2.xyz = r2.xyz * m_sBranch1.m_fDistance + r3.xyz;
        }
        else
        {
            r2.w = cmp(0.5 < m_avWindConfigFlags[0].w);
            if (r2.w != 0)
            {
                r5.xyz = cmp(float3(0.5, 0.5, 0.5) < m_avWindConfigFlags[1].zwy);
                r6.xyz = float3(0.0625, 1, 16) * v6.yyy;
                r6.xyz = frac(r6.xyz);
                r6.xyz = r6.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                r6.xyz = v6.xxx * r6.xyz;
                r2.w = v0.x + v0.y;
                r2.w = m_sBranch1.m_fTime + r2.w;
                if (r5.y != 0)
                {
                    r7.x = v6.y + r2.w;
                    r7.y = r2.w * m_sBranch1.m_fTwitchFreqScale + v6.y;
                    r3.w = m_sBranch1.m_fTwitchFreqScale * r7.x;
                    r7.z = 0.5 * r3.w;
                    r7.w = -v6.x + r7.x;
                    r8.xyzw = float4(0.5, 0.5, 0.5, 1.5) + r7.xyzw;
                    r8.xyzw = frac(r8.xyzw);
                    r8.xyzw = r8.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
                    r9.xyzw = abs(r8.xyzw) * abs(r8.xyzw);
                    r8.xyzw = -abs(r8.xyzw) * float4(2, 2, 2, 2) + float4(3, 3, 3, 3);
                    r8.xyzw = r9.xyzw * r8.xyzw + float4(-0.5, -0.5, -0.5, -0.5);
                    r8.xyzw = r8.xyzw + r8.xyzw;
                    r7.xyz = float3(0.5, 0.5, 0.5) + r7.xyz;
                    r7.xyz = frac(r7.xyz);
                    r7.xyz = r7.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                    r9.xyz = abs(r7.xyz) * abs(r7.xyz);
                    r7.xyz = -abs(r7.xyz) * float3(2, 2, 2) + float3(3, 3, 3);
                    r7.xyz = r9.xyz * r7.xyz;
                    r7.w = 0;
                    r7.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r7.xyzw;
                    r7.xyzw = r7.xyzw + r7.xyzw;
                    r7.xyzw = r5.xxxx ? r8.wxyz : r7.wxyz;
                    r8.w = r7.z * r7.w;
                    r3.w = cmp(r8.w < 0);
                    r8.y = -r8.w;
                    r8.xz = float2(-1, 1);
                    r5.yw = r3.ww ? r8.xy : r8.zw;
                    r3.w = -r7.z * r7.w + r5.y;
                    r3.w = r5.w * r3.w + r8.w;
                    r4.w = r5.y + -r3.w;
                    r3.w = r5.w * r4.w + r3.w;
                    r3.w = m_sBranch1.m_fTwitch * r3.w;
                    r4.w = 1 + -m_fStrength;
                    r5.y = 1 + -m_sBranch1.m_fTwitch;
                    r5.y = r7.y * r5.y;
                    r3.w = r3.w * r4.w + r5.y;
                    r4.w = m_sBranch1.m_fWhip * r7.x;
                    r4.w = r4.w * v6.x + 1;
                    r4.w = r4.w * r3.w;
                    r3.w = r5.x ? r4.w : r3.w;
                }
                else
                {
                    r8.x = v6.y + r2.w;
                    r8.y = r2.w * 0.68900001 + v6.y;
                    r8.z = -v6.x + r8.x;
                    r9.xyz = float3(0.5, 0.5, 1.5) + r8.xyz;
                    r9.xyz = frac(r9.xyz);
                    r9.xyz = r9.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                    r10.xyz = abs(r9.xyz) * abs(r9.xyz);
                    r9.xyz = -abs(r9.xyz) * float3(2, 2, 2) + float3(3, 3, 3);
                    r9.xyz = r10.xyz * r9.xyz + float3(-0.5, -0.5, -0.5);
                    r9.xyz = r9.xyz + r9.xyz;
                    r5.yw = float2(0.5, 0.5) + r8.xy;
                    r5.yw = frac(r5.yw);
                    r5.yw = r5.yw * float2(2, 2) + float2(-1, -1);
                    r8.xy = abs(r5.yw) * abs(r5.yw);
                    r5.yw = -abs(r5.yw) * float2(2, 2) + float2(3, 3);
                    r8.xy = r8.xy * r5.yw;
                    r8.z = 0;
                    r8.xyz = float3(-0.5, -0.5, -0.5) + r8.xyz;
                    r8.xyz = r8.xyz + r8.xyz;
                    r7.xyz = r5.xxx ? r9.zxy : r8.zxy;
                    r4.w = r7.z * r7.y + r7.y;
                    r5.y = m_sBranch1.m_fWhip * r7.x;
                    r5.y = r5.y * v6.x + 1;
                    r5.y = r5.y * r4.w;
                    r3.w = r5.x ? r5.y : r4.w;
                }
                r6.xyz = r6.xyz * r3.www;
                r6.xyz = r6.xyz * m_sBranch1.m_fDistance + r3.xyz;
                r8.x = r2.w * 0.100000001 + v6.y;
                r2.w = m_sBranch1.m_fTurbulence * m_fWallTime;
                r8.y = r2.w * 0.100000001 + v6.y;
                r5.yw = float2(0.5, 0.5) + r8.xy;
                r5.yw = frac(r5.yw);
                r5.yw = r5.yw * float2(2, 2) + float2(-1, -1);
                r7.yz = abs(r5.yw) * abs(r5.yw);
                r5.yw = -abs(r5.yw) * float2(2, 2) + float2(3, 3);
                r5.yw = r7.yz * r5.yw + float2(-0.5, -0.5);
                r5.yw = r5.yw + r5.yw;
                r5.yw = r5.yw * r5.yw;
                r2.w = r5.w * r5.y;
                r2.w = -r2.w * m_sBranch1.m_fTurbulence + 1;
                r2.w = r5.z ? r2.w : 1;
                r3.w = m_fStrength * r7.x;
                r3.w = r3.w * m_sBranch1.m_fWhip + r2.w;
                r2.w = r5.x ? r3.w : r2.w;
                r5.xyz = m_sBranch1.m_fDirectionAdherence * m_vDirection.xyz;
                r5.xyz = r5.xyz * r2.www;
                r2.xyz = r5.xyz * v6.xxx + r6.xyz;
            }
            else
            {
                r2.w = cmp(0.5 < m_avWindConfigFlags[1].x);
                if (r2.w != 0)
                {
                    r5.xyz = cmp(float3(0.5, 0.5, 0.5) < m_avWindConfigFlags[1].zwy);
                    r6.xyz = float3(0.0625, 1, 16) * v6.yyy;
                    r6.xyz = frac(r6.xyz);
                    r6.xyz = r6.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                    r6.xyz = v6.xxx * r6.xyz;
                    r2.w = v0.x + v0.y;
                    r2.w = m_sBranch1.m_fTime + r2.w;
                    if (r5.y != 0)
                    {
                        r7.x = v6.y + r2.w;
                        r7.y = r2.w * m_sBranch1.m_fTwitchFreqScale + v6.y;
                        r3.w = m_sBranch1.m_fTwitchFreqScale * r7.x;
                        r7.z = 0.5 * r3.w;
                        r7.w = -v6.x + r7.x;
                        r8.xyzw = float4(0.5, 0.5, 0.5, 1.5) + r7.xyzw;
                        r8.xyzw = frac(r8.xyzw);
                        r8.xyzw = r8.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
                        r9.xyzw = abs(r8.xyzw) * abs(r8.xyzw);
                        r8.xyzw = -abs(r8.xyzw) * float4(2, 2, 2, 2) + float4(3, 3, 3, 3);
                        r8.xyzw = r9.xyzw * r8.xyzw + float4(-0.5, -0.5, -0.5, -0.5);
                        r8.xyzw = r8.xyzw + r8.xyzw;
                        r7.xyz = float3(0.5, 0.5, 0.5) + r7.xyz;
                        r7.xyz = frac(r7.xyz);
                        r7.xyz = r7.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                        r9.xyz = abs(r7.xyz) * abs(r7.xyz);
                        r7.xyz = -abs(r7.xyz) * float3(2, 2, 2) + float3(3, 3, 3);
                        r7.xyz = r9.xyz * r7.xyz;
                        r7.w = 0;
                        r7.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r7.xyzw;
                        r7.xyzw = r7.xyzw + r7.xyzw;
                        r7.xyzw = r5.xxxx ? r8.wxyz : r7.wxyz;
                        r8.w = r7.z * r7.w;
                        r3.w = cmp(r8.w < 0);
                        r8.y = -r8.w;
                        r8.xz = float2(-1, 1);
                        r5.yw = r3.ww ? r8.xy : r8.zw;
                        r3.w = -r7.z * r7.w + r5.y;
                        r3.w = r5.w * r3.w + r8.w;
                        r4.w = r5.y + -r3.w;
                        r3.w = r5.w * r4.w + r3.w;
                        r3.w = m_sBranch1.m_fTwitch * r3.w;
                        r4.w = 1 + -m_fStrength;
                        r5.y = 1 + -m_sBranch1.m_fTwitch;
                        r5.y = r7.y * r5.y;
                        r3.w = r3.w * r4.w + r5.y;
                        r4.w = m_sBranch1.m_fWhip * r7.x;
                        r4.w = r4.w * v6.x + 1;
                        r4.w = r4.w * r3.w;
                        r3.w = r5.x ? r4.w : r3.w;
                    }
                    else
                    {
                        r8.x = v6.y + r2.w;
                        r8.y = r2.w * 0.68900001 + v6.y;
                        r8.z = -v6.x + r8.x;
                        r9.xyz = float3(0.5, 0.5, 1.5) + r8.xyz;
                        r9.xyz = frac(r9.xyz);
                        r9.xyz = r9.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                        r10.xyz = abs(r9.xyz) * abs(r9.xyz);
                        r9.xyz = -abs(r9.xyz) * float3(2, 2, 2) + float3(3, 3, 3);
                        r9.xyz = r10.xyz * r9.xyz + float3(-0.5, -0.5, -0.5);
                        r9.xyz = r9.xyz + r9.xyz;
                        r5.yw = float2(0.5, 0.5) + r8.xy;
                        r5.yw = frac(r5.yw);
                        r5.yw = r5.yw * float2(2, 2) + float2(-1, -1);
                        r8.xy = abs(r5.yw) * abs(r5.yw);
                        r5.yw = -abs(r5.yw) * float2(2, 2) + float2(3, 3);
                        r8.xy = r8.xy * r5.yw;
                        r8.z = 0;
                        r8.xyz = float3(-0.5, -0.5, -0.5) + r8.xyz;
                        r8.xyz = r8.xyz + r8.xyz;
                        r7.xyz = r5.xxx ? r9.zxy : r8.zxy;
                        r4.w = r7.z * r7.y + r7.y;
                        r5.y = m_sBranch1.m_fWhip * r7.x;
                        r5.y = r5.y * v6.x + 1;
                        r5.y = r5.y * r4.w;
                        r3.w = r5.x ? r5.y : r4.w;
                    }
                    r6.xyz = r6.xyz * r3.www;
                    r6.xyz = r6.xyz * m_sBranch1.m_fDistance + r3.xyz;
                    r8.x = r2.w * 0.100000001 + v6.y;
                    r2.w = m_sBranch1.m_fTurbulence * m_fWallTime;
                    r8.y = r2.w * 0.100000001 + v6.y;
                    r5.yw = float2(0.5, 0.5) + r8.xy;
                    r5.yw = frac(r5.yw);
                    r5.yw = r5.yw * float2(2, 2) + float2(-1, -1);
                    r7.yz = abs(r5.yw) * abs(r5.yw);
                    r5.yw = -abs(r5.yw) * float2(2, 2) + float2(3, 3);
                    r5.yw = r7.yz * r5.yw + float2(-0.5, -0.5);
                    r5.yw = r5.yw + r5.yw;
                    r5.yw = r5.yw * r5.yw;
                    r2.w = r5.w * r5.y;
                    r2.w = -r2.w * m_sBranch1.m_fTurbulence + 1;
                    r2.w = r5.z ? r2.w : 1;
                    r3.w = m_fStrength * r7.x;
                    r3.w = r3.w * m_sBranch1.m_fWhip + r2.w;
                    r2.w = r5.x ? r3.w : r2.w;
                    r5.xyz = m_vAnchor.xyz + -r6.xyz;
                    r5.xyz = m_sBranch1.m_fDirectionAdherence * r5.xyz;
                    r5.xyz = r5.xyz * r2.www;
                    r2.xyz = r5.xyz * v6.xxx + r6.xyz;
                }
                else
                {
                    r2.xyz = r3.xyz;
                }
            }
        }
        r2.w = cmp(0.5 < m_avWindConfigFlags[2].x);
        if (r2.w != 0)
        {
            r5.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[3].xy);
            r6.xyz = float3(0.0625, 1, 16) * v6.www;
            r6.xyz = frac(r6.xyz);
            r6.xyz = r6.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
            r6.xyz = v6.zzz * r6.xyz;
            r2.w = v0.x + v0.y;
            r2.w = m_sBranch2.m_fTime + r2.w;
            if (r5.y != 0)
            {
                r7.x = v6.w + r2.w;
                r7.y = r2.w * m_sBranch2.m_fTwitchFreqScale + v6.w;
                r3.w = m_sBranch2.m_fTwitchFreqScale * r7.x;
                r7.z = 0.5 * r3.w;
                r7.w = -v6.z + r7.x;
                r8.xyzw = float4(0.5, 0.5, 0.5, 1.5) + r7.xyzw;
                r8.xyzw = frac(r8.xyzw);
                r8.xyzw = r8.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
                r9.xyzw = abs(r8.xyzw) * abs(r8.xyzw);
                r8.xyzw = -abs(r8.xyzw) * float4(2, 2, 2, 2) + float4(3, 3, 3, 3);
                r8.xyzw = r9.xyzw * r8.xyzw + float4(-0.5, -0.5, -0.5, -0.5);
                r8.xyzw = r8.xyzw + r8.xyzw;
                r5.yzw = float3(0.5, 0.5, 0.5) + r7.xyz;
                r5.yzw = frac(r5.yzw);
                r5.yzw = r5.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
                r7.xyz = abs(r5.yzw) * abs(r5.yzw);
                r5.yzw = -abs(r5.yzw) * float3(2, 2, 2) + float3(3, 3, 3);
                r7.xyz = r7.xyz * r5.yzw;
                r7.w = 0;
                r7.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r7.xyzw;
                r7.xyzw = r7.xyzw + r7.xyzw;
                r7.xyzw = r5.xxxx ? r8.xyzw : r7.xyzw;
                r8.w = r7.y * r7.z;
                r3.w = cmp(r8.w < 0);
                r8.y = -r8.w;
                r8.xz = float2(-1, 1);
                r5.yz = r3.ww ? r8.xy : r8.zw;
                r3.w = -r7.y * r7.z + r5.y;
                r3.w = r5.z * r3.w + r8.w;
                r4.w = r5.y + -r3.w;
                r3.w = r5.z * r4.w + r3.w;
                r3.w = m_sBranch2.m_fTwitch * r3.w;
                r4.w = 1 + -m_fStrength;
                r5.y = 1 + -m_sBranch2.m_fTwitch;
                r5.y = r7.x * r5.y;
                r3.w = r3.w * r4.w + r5.y;
                r4.w = m_sBranch2.m_fWhip * r7.w;
                r4.w = r4.w * v6.z + 1;
                r4.w = r4.w * r3.w;
                r3.w = r5.x ? r4.w : r3.w;
            }
            else
            {
                r7.x = v6.w + r2.w;
                r7.y = r2.w * 0.68900001 + v6.w;
                r7.z = -v6.z + r7.x;
                r5.yzw = float3(0.5, 0.5, 1.5) + r7.xyz;
                r5.yzw = frac(r5.yzw);
                r5.yzw = r5.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
                r8.xyz = abs(r5.yzw) * abs(r5.yzw);
                r5.yzw = -abs(r5.yzw) * float3(2, 2, 2) + float3(3, 3, 3);
                r5.yzw = r8.xyz * r5.yzw + float3(-0.5, -0.5, -0.5);
                r5.yzw = r5.yzw + r5.yzw;
                r7.xy = float2(0.5, 0.5) + r7.xy;
                r7.xy = frac(r7.xy);
                r7.xy = r7.xy * float2(2, 2) + float2(-1, -1);
                r7.zw = abs(r7.xy) * abs(r7.xy);
                r7.xy = -abs(r7.xy) * float2(2, 2) + float2(3, 3);
                r7.xy = r7.zw * r7.xy;
                r7.z = 0;
                r7.xyz = float3(-0.5, -0.5, -0.5) + r7.xyz;
                r7.xyz = r7.xyz + r7.xyz;
                r5.yzw = r5.xxx ? r5.yzw : r7.xyz;
                r2.w = r5.z * r5.y + r5.y;
                r4.w = m_sBranch2.m_fWhip * r5.w;
                r4.w = r4.w * v6.z + 1;
                r4.w = r4.w * r2.w;
                r3.w = r5.x ? r4.w : r2.w;
            }
            r5.xyz = r6.xyz * r3.www;
            r2.xyz = r5.xyz * m_sBranch2.m_fDistance + r2.xyz;
        }
        else
        {
            r2.w = cmp(0.5 < m_avWindConfigFlags[2].y);
            if (r2.w != 0)
            {
                r5.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[3].xy);
                r2.w = cmp(0.5 < m_avWindConfigFlags[2].w);
                r6.xyz = float3(0.0625, 1, 16) * v6.www;
                r6.xyz = frac(r6.xyz);
                r6.xyz = r6.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                r6.xyz = v6.zzz * r6.xyz;
                r3.w = v0.x + v0.y;
                r3.w = m_sBranch2.m_fTime + r3.w;
                if (r5.y != 0)
                {
                    r7.x = v6.w + r3.w;
                    r7.y = r3.w * m_sBranch2.m_fTwitchFreqScale + v6.w;
                    r4.w = m_sBranch2.m_fTwitchFreqScale * r7.x;
                    r7.z = 0.5 * r4.w;
                    r7.w = -v6.z + r7.x;
                    r8.xyzw = float4(0.5, 0.5, 0.5, 1.5) + r7.xyzw;
                    r8.xyzw = frac(r8.xyzw);
                    r8.xyzw = r8.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
                    r9.xyzw = abs(r8.xyzw) * abs(r8.xyzw);
                    r8.xyzw = -abs(r8.xyzw) * float4(2, 2, 2, 2) + float4(3, 3, 3, 3);
                    r8.xyzw = r9.xyzw * r8.xyzw + float4(-0.5, -0.5, -0.5, -0.5);
                    r8.xyzw = r8.xyzw + r8.xyzw;
                    r5.yzw = float3(0.5, 0.5, 0.5) + r7.xyz;
                    r5.yzw = frac(r5.yzw);
                    r5.yzw = r5.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
                    r7.xyz = abs(r5.yzw) * abs(r5.yzw);
                    r5.yzw = -abs(r5.yzw) * float3(2, 2, 2) + float3(3, 3, 3);
                    r7.xyz = r7.xyz * r5.yzw;
                    r7.w = 0;
                    r7.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r7.xyzw;
                    r7.xyzw = r7.xyzw + r7.xyzw;
                    r7.xyzw = r5.xxxx ? r8.wxyz : r7.wxyz;
                    r8.w = r7.z * r7.w;
                    r4.w = cmp(r8.w < 0);
                    r8.y = -r8.w;
                    r8.xz = float2(-1, 1);
                    r5.yz = r4.ww ? r8.xy : r8.zw;
                    r4.w = -r7.z * r7.w + r5.y;
                    r4.w = r5.z * r4.w + r8.w;
                    r5.y = r5.y + -r4.w;
                    r4.w = r5.z * r5.y + r4.w;
                    r4.w = m_sBranch2.m_fTwitch * r4.w;
                    r5.y = 1 + -m_fStrength;
                    r5.z = 1 + -m_sBranch2.m_fTwitch;
                    r5.z = r7.y * r5.z;
                    r4.w = r4.w * r5.y + r5.z;
                    r5.y = m_sBranch2.m_fWhip * r7.x;
                    r5.y = r5.y * v6.z + 1;
                    r5.y = r5.y * r4.w;
                    r4.w = r5.x ? r5.y : r4.w;
                }
                else
                {
                    r8.x = v6.w + r3.w;
                    r8.y = r3.w * 0.68900001 + v6.w;
                    r8.z = -v6.z + r8.x;
                    r5.yzw = float3(0.5, 0.5, 1.5) + r8.xyz;
                    r5.yzw = frac(r5.yzw);
                    r5.yzw = r5.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
                    r9.xyz = abs(r5.yzw) * abs(r5.yzw);
                    r5.yzw = -abs(r5.yzw) * float3(2, 2, 2) + float3(3, 3, 3);
                    r5.yzw = r9.xyz * r5.yzw + float3(-0.5, -0.5, -0.5);
                    r5.yzw = r5.yzw + r5.yzw;
                    r8.xy = float2(0.5, 0.5) + r8.xy;
                    r8.xy = frac(r8.xy);
                    r8.xy = r8.xy * float2(2, 2) + float2(-1, -1);
                    r8.zw = abs(r8.xy) * abs(r8.xy);
                    r8.xy = -abs(r8.xy) * float2(2, 2) + float2(3, 3);
                    r8.xy = r8.zw * r8.xy;
                    r8.z = 0;
                    r8.xyz = float3(-0.5, -0.5, -0.5) + r8.xyz;
                    r8.xyz = r8.xyz + r8.xyz;
                    r7.xyz = r5.xxx ? r5.wyz : r8.zxy;
                    r5.y = r7.z * r7.y + r7.y;
                    r5.z = m_sBranch2.m_fWhip * r7.x;
                    r5.z = r5.z * v6.z + 1;
                    r5.z = r5.y * r5.z;
                    r4.w = r5.x ? r5.z : r5.y;
                }
                r5.yzw = r6.xyz * r4.www;
                r5.yzw = r5.yzw * m_sBranch2.m_fDistance + r2.xyz;
                r6.x = r3.w * 0.100000001 + v6.w;
                r3.w = m_sBranch2.m_fTurbulence * m_fWallTime;
                r6.y = r3.w * 0.100000001 + v6.w;
                r6.xy = float2(0.5, 0.5) + r6.xy;
                r6.xy = frac(r6.xy);
                r6.xy = r6.xy * float2(2, 2) + float2(-1, -1);
                r6.zw = abs(r6.xy) * abs(r6.xy);
                r6.xy = -abs(r6.xy) * float2(2, 2) + float2(3, 3);
                r6.xy = r6.zw * r6.xy + float2(-0.5, -0.5);
                r6.xy = r6.xy + r6.xy;
                r6.xy = r6.xy * r6.xy;
                r3.w = r6.y * r6.x;
                r3.w = -r3.w * m_sBranch2.m_fTurbulence + 1;
                r2.w = r2.w ? r3.w : 1;
                r3.w = m_fStrength * r7.x;
                r3.w = r3.w * m_sBranch2.m_fWhip + r2.w;
                r2.w = r5.x ? r3.w : r2.w;
                r6.xyz = m_sBranch2.m_fDirectionAdherence * m_vDirection.xyz;
                r6.xyz = r6.xyz * r2.www;
                r2.xyz = r6.xyz * v6.zzz + r5.yzw;
            }
            else
            {
                r2.w = cmp(0.5 < m_avWindConfigFlags[2].z);
                if (r2.w != 0)
                {
                    r5.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[3].xy);
                    r2.w = cmp(0.5 < m_avWindConfigFlags[2].w);
                    r6.xyz = float3(0.0625, 1, 16) * v6.www;
                    r6.xyz = frac(r6.xyz);
                    r6.xyz = r6.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                    r6.xyz = v6.zzz * r6.xyz;
                    r3.w = v0.x + v0.y;
                    r3.w = m_sBranch2.m_fTime + r3.w;
                    if (r5.y != 0)
                    {
                        r7.x = v6.w + r3.w;
                        r7.y = r3.w * m_sBranch2.m_fTwitchFreqScale + v6.w;
                        r4.w = m_sBranch2.m_fTwitchFreqScale * r7.x;
                        r7.z = 0.5 * r4.w;
                        r7.w = -v6.z + r7.x;
                        r8.xyzw = float4(0.5, 0.5, 0.5, 1.5) + r7.xyzw;
                        r8.xyzw = frac(r8.xyzw);
                        r8.xyzw = r8.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
                        r9.xyzw = abs(r8.xyzw) * abs(r8.xyzw);
                        r8.xyzw = -abs(r8.xyzw) * float4(2, 2, 2, 2) + float4(3, 3, 3, 3);
                        r8.xyzw = r9.xyzw * r8.xyzw + float4(-0.5, -0.5, -0.5, -0.5);
                        r8.xyzw = r8.xyzw + r8.xyzw;
                        r5.yzw = float3(0.5, 0.5, 0.5) + r7.xyz;
                        r5.yzw = frac(r5.yzw);
                        r5.yzw = r5.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
                        r7.xyz = abs(r5.yzw) * abs(r5.yzw);
                        r5.yzw = -abs(r5.yzw) * float3(2, 2, 2) + float3(3, 3, 3);
                        r7.xyz = r7.xyz * r5.yzw;
                        r7.w = 0;
                        r7.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r7.xyzw;
                        r7.xyzw = r7.xyzw + r7.xyzw;
                        r7.xyzw = r5.xxxx ? r8.wxyz : r7.wxyz;
                        r8.w = r7.z * r7.w;
                        r4.w = cmp(r8.w < 0);
                        r8.y = -r8.w;
                        r8.xz = float2(-1, 1);
                        r5.yz = r4.ww ? r8.xy : r8.zw;
                        r4.w = -r7.z * r7.w + r5.y;
                        r4.w = r5.z * r4.w + r8.w;
                        r5.y = r5.y + -r4.w;
                        r4.w = r5.z * r5.y + r4.w;
                        r4.w = m_sBranch2.m_fTwitch * r4.w;
                        r5.y = 1 + -m_fStrength;
                        r5.z = 1 + -m_sBranch2.m_fTwitch;
                        r5.z = r7.y * r5.z;
                        r4.w = r4.w * r5.y + r5.z;
                        r5.y = m_sBranch2.m_fWhip * r7.x;
                        r5.y = r5.y * v6.z + 1;
                        r5.y = r5.y * r4.w;
                        r4.w = r5.x ? r5.y : r4.w;
                    }
                    else
                    {
                        r8.x = v6.w + r3.w;
                        r8.y = r3.w * 0.68900001 + v6.w;
                        r8.z = -v6.z + r8.x;
                        r5.yzw = float3(0.5, 0.5, 1.5) + r8.xyz;
                        r5.yzw = frac(r5.yzw);
                        r5.yzw = r5.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
                        r9.xyz = abs(r5.yzw) * abs(r5.yzw);
                        r5.yzw = -abs(r5.yzw) * float3(2, 2, 2) + float3(3, 3, 3);
                        r5.yzw = r9.xyz * r5.yzw + float3(-0.5, -0.5, -0.5);
                        r5.yzw = r5.yzw + r5.yzw;
                        r8.xy = float2(0.5, 0.5) + r8.xy;
                        r8.xy = frac(r8.xy);
                        r8.xy = r8.xy * float2(2, 2) + float2(-1, -1);
                        r8.zw = abs(r8.xy) * abs(r8.xy);
                        r8.xy = -abs(r8.xy) * float2(2, 2) + float2(3, 3);
                        r8.xy = r8.zw * r8.xy;
                        r8.z = 0;
                        r8.xyz = float3(-0.5, -0.5, -0.5) + r8.xyz;
                        r8.xyz = r8.xyz + r8.xyz;
                        r7.xyz = r5.xxx ? r5.wyz : r8.zxy;
                        r5.y = r7.z * r7.y + r7.y;
                        r5.z = m_sBranch2.m_fWhip * r7.x;
                        r5.z = r5.z * v6.z + 1;
                        r5.z = r5.y * r5.z;
                        r4.w = r5.x ? r5.z : r5.y;
                    }
                    r5.yzw = r6.xyz * r4.www;
                    r5.yzw = r5.yzw * m_sBranch2.m_fDistance + r2.xyz;
                    r6.x = r3.w * 0.100000001 + v6.w;
                    r3.w = m_sBranch2.m_fTurbulence * m_fWallTime;
                    r6.y = r3.w * 0.100000001 + v6.w;
                    r6.xy = float2(0.5, 0.5) + r6.xy;
                    r6.xy = frac(r6.xy);
                    r6.xy = r6.xy * float2(2, 2) + float2(-1, -1);
                    r6.zw = abs(r6.xy) * abs(r6.xy);
                    r6.xy = -abs(r6.xy) * float2(2, 2) + float2(3, 3);
                    r6.xy = r6.zw * r6.xy + float2(-0.5, -0.5);
                    r6.xy = r6.xy + r6.xy;
                    r6.xy = r6.xy * r6.xy;
                    r3.w = r6.y * r6.x;
                    r3.w = -r3.w * m_sBranch2.m_fTurbulence + 1;
                    r2.w = r2.w ? r3.w : 1;
                    r3.w = m_fStrength * r7.x;
                    r3.w = r3.w * m_sBranch2.m_fWhip + r2.w;
                    r2.w = r5.x ? r3.w : r2.w;
                    r6.xyz = m_vAnchor.xyz + -r5.yzw;
                    r6.xyz = m_sBranch2.m_fDirectionAdherence * r6.xyz;
                    r6.xyz = r6.xyz * r2.www;
                    r2.xyz = r6.xyz * v6.zzz + r5.yzw;
                }
            }
        }
        r2.xyz = r2.xyz + -r3.xyz;
    }
    else
    {
        r2.xyz = float3(0, 0, 0);
    }
    r2.w = cmp(0 < v7.x);
    if (r2.w != 0)
    {
        r5.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[5].wx);
        r2.w = dot(r3.xy, r3.xy);
        r2.w = rsqrt(r2.w);
        r5.zw = r3.xy * r2.ww;
        r2.w = dot(-r5.zw, m_vDirection.xy);
        r2.w = 1 + r2.w;
        r2.w = 0.5 * r2.w;
        r3.w = 1 + -m_sLeaf2.m_fLeewardScalar;
        r2.w = r2.w * r3.w + m_sLeaf2.m_fLeewardScalar;
        r2.w = v5.y * r2.w;
        r2.w = r5.x ? r2.w : v5.y;
        r3.w = cmp(0.5 < m_avWindConfigFlags[6].w);
        if (r3.w != 0)
        {
            r5.xz = v0.xy + r3.xy;
            r5.xz = -m_sRolling.m_vOffset.xy + r5.xz;
            r5.xz = m_sRolling.m_fNoiseSize * r5.xz;
            r3.w = 5 * m_sRolling.m_fNoisePeriod;
            r3.w = dot(r5.xz, r3.ww);
            r4.w = m_sRolling.m_fNoiseTurbulence;
            r5.w = 0;
            while (true)
            {
                r6.x = cmp(r4.w < 1);
                if (r6.x != 0)
                    break;
                r6.xy = r5.xz / r4.ww;
                r6.xy = frac(r6.xy);
                r6.xyzw = PerlinNoiseKernel.SampleLevel(samStandard_s, r6.xy, 0).xyzw;
                r6.x = dot(r6.xyzw, float4(0.25, 0.25, 0.25, 0.25));
                r5.w = r6.x * r4.w + r5.w;
                r4.w = 0.5 * r4.w;
            }
            r4.w = 0.5 * r5.w;
            r4.w = r4.w / m_sRolling.m_fNoiseTurbulence;
            r3.w = m_sRolling.m_fNoiseTwist * r4.w + r3.w;
            r3.w = 3.14159274 * r3.w;
            r3.w = sin(r3.w);
            r3.w = 1 + -abs(r3.w);
            r4.w = 1 + -m_sRolling.m_fLeafRippleMin;
            r3.w = r3.w * r4.w + m_sRolling.m_fLeafRippleMin;
        }
        else
        {
            r3.w = 1;
        }
        r4.w = cmp(0.5 < m_avWindConfigFlags[4].w);
        r2.w = r3.w * r2.w;
        r3.w = m_sLeaf2.m_fRippleTime + r0.w;
        r3.w = 0.5 + r3.w;
        r3.w = frac(r3.w);
        r3.w = r3.w * 2 + -1;
        r5.x = abs(r3.w) * abs(r3.w);
        r3.w = -abs(r3.w) * 2 + 3;
        r3.w = r5.x * r3.w + -0.5;
        r3.w = dot(r3.ww, m_sLeaf2.m_fRippleDistance);
        r5.xzw = r4.xyz * r3.www;
        r5.xzw = r5.xzw * r2.www + r3.xyz;
        r6.xyz = float3(0.0625, 1, 16) * v5.www;
        r6.xyz = frac(r6.xyz);
        r6.xyz = r6.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
        r6.xyz = r6.xyz * r3.www;
        r6.xyz = r6.xyz * r2.www + r3.xyz;
        r6.xyz = r5.yyy ? r6.xyz : r3.xyz;
        r5.xyz = r4.www ? r5.xzw : r6.xyz;
        r5.xyz = r5.xyz + -r3.xyz;
    }
    else
    {
        r2.w = cmp(0.5 < m_avWindConfigFlags[4].z);
        r3.w = dot(r3.xy, r3.xy);
        r3.w = rsqrt(r3.w);
        r6.xy = r3.xy * r3.ww;
        r3.w = dot(-r6.xy, m_vDirection.xy);
        r3.w = 1 + r3.w;
        r3.w = 0.5 * r3.w;
        r4.w = 1 + -m_sLeaf1.m_fLeewardScalar;
        r3.w = r3.w * r4.w + m_sLeaf1.m_fLeewardScalar;
        r3.w = v5.y * r3.w;
        r2.w = r2.w ? r3.w : v5.y;
        r3.w = cmp(0.5 < m_avWindConfigFlags[6].w);
        if (r3.w != 0)
        {
            r6.xy = v0.xy + r3.xy;
            r6.xy = -m_sRolling.m_vOffset.xy + r6.xy;
            r6.xy = m_sRolling.m_fNoiseSize * r6.xy;
            r3.w = 5 * m_sRolling.m_fNoisePeriod;
            r3.w = dot(r6.xy, r3.ww);
            r4.w = m_sRolling.m_fNoiseTurbulence;
            r5.w = 0;
            while (true)
            {
                r6.z = cmp(r4.w < 1);
                if (r6.z != 0)
                    break;
                r6.zw = r6.xy / r4.ww;
                r6.zw = frac(r6.zw);
                r7.xyzw = PerlinNoiseKernel.SampleLevel(samStandard_s, r6.zw, 0).xyzw;
                r6.z = dot(r7.xyzw, float4(0.25, 0.25, 0.25, 0.25));
                r5.w = r6.z * r4.w + r5.w;
                r4.w = 0.5 * r4.w;
            }
            r4.w = 0.5 * r5.w;
            r4.w = r4.w / m_sRolling.m_fNoiseTurbulence;
            r3.w = m_sRolling.m_fNoiseTwist * r4.w + r3.w;
            r3.w = 3.14159274 * r3.w;
            r3.w = sin(r3.w);
            r3.w = 1 + -abs(r3.w);
            r4.w = 1 + -m_sRolling.m_fLeafRippleMin;
            r3.w = r3.w * r4.w + m_sRolling.m_fLeafRippleMin;
        }
        else
        {
            r3.w = 1;
        }
        r2.w = r3.w * r2.w;
        r0.w = m_sLeaf1.m_fRippleTime + r0.w;
        r0.w = 0.5 + r0.w;
        r0.w = frac(r0.w);
        r0.w = r0.w * 2 + -1;
        r3.w = abs(r0.w) * abs(r0.w);
        r0.w = -abs(r0.w) * 2 + 3;
        r0.w = r3.w * r0.w + -0.5;
        r0.w = dot(r0.ww, m_sLeaf1.m_fRippleDistance);
        r6.xyz = r4.xyz * r0.www;
        r6.xyz = r6.xyz * r2.www + r3.xyz;
        r7.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[3].zw);
        r8.xyz = float3(0.0625, 1, 16) * v5.www;
        r8.xyz = frac(r8.xyz);
        r8.xyz = r8.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
        r8.xyz = r8.xyz * r0.www;
        r8.xyz = r8.xyz * r2.www + r3.xyz;
        r7.yzw = r7.yyy ? r8.xyz : r3.xyz;
        r6.xyz = r7.xxx ? r6.xyz : r7.yzw;
        r5.xyz = r6.xyz + -r3.xyz;
    }
    r0.w = cmp(0.5 < m_avWindLodFlags[0].w);
    if (r0.w != 0)
    {
        r6.xyz = r1.xyz * r1.www + r3.xyz;
    }
    else
    {
        r0.w = cmp(0.5 < m_avWindLodFlags[1].x);
        if (r0.w != 0)
        {
            r7.xyz = r2.xyz + r1.xyz;
            r6.xyz = r7.xyz * r1.www + r3.xyz;
        }
        else
        {
            r0.w = cmp(0.5 < m_avWindLodFlags[1].y);
            if (r0.w != 0)
            {
                r7.xyz = r2.xyz + r1.xyz;
                r7.xyz = r7.xyz + r5.xyz;
                r6.xyz = r7.xyz * r1.www + r3.xyz;
            }
            else
            {
                r0.w = cmp(0.5 < m_avWindLodFlags[1].z);
                if (r0.w != 0)
                {
                    r7.xyz = r2.xyz * r1.www + r1.xyz;
                    r6.xyz = r7.xyz + r3.xyz;
                }
                else
                {
                    r0.w = cmp(0.5 < m_avWindLodFlags[1].w);
                    r7.xyz = r5.xyz + r2.xyz;
                    r7.xyz = r7.xyz * r1.www + r1.xyz;
                    r7.xyz = r7.xyz + r3.xyz;
                    r2.w = cmp(0.5 < m_avWindLodFlags[2].x);
                    r2.xyz = r2.xyz + r1.xyz;
                    r8.xyz = r5.xyz * r1.www + r2.xyz;
                    r8.xyz = r8.xyz + r3.xyz;
                    r1.xyz = r3.xyz + r1.xyz;
                    r9.xyz = r3.xyz + r2.xyz;
                    r10.xyz = cmp(float3(0.5, 0.5, 0.5) < m_avWindLodFlags[0].xyz);
                    r2.xyz = r2.xyz + r5.xyz;
                    r2.xyz = r3.xyz + r2.xyz;
                    r2.xyz = r10.zzz ? r2.xyz : r3.xyz;
                    r2.xyz = r10.yyy ? r9.xyz : r2.xyz;
                    r1.xyz = r10.xxx ? r1.xyz : r2.xyz;
                    r1.xyz = r2.www ? r8.xyz : r1.xyz;
                    r6.xyz = r0.www ? r7.xyz : r1.xyz;
                }
            }
        }
    }
    r0.w = cmp(0.5 < m_avEffectConfigFlags[2].z);
    r1.x = 1 + -v5.x;
    r1.x = r1.w * r1.x + v5.x;
    r2.x = v3.w;
    r2.y = v4.z;
    r1.xy = r2.xy * r1.xx;
    r2.xy = r0.ww ? r1.xy : r2.xy;
    r2.z = -r2.x;
    r2.w = 1;
    r1.x = dot(m_mCameraFacingMatrix._m02_m01_m03, r2.yzw);
    r2.xyz = float3(-1, 1, 1) * r2.xyw;
    r1.y = dot(m_mCameraFacingMatrix._m11_m12_m13, r2.xyz);
    r1.z = dot(m_mCameraFacingMatrix._m21_m22_m23, r2.xyz);
    r1.xyz = r6.xyz + r1.xyz;
    r1.xyz = v4.www * m_vCameraDirection.xyz + r1.xyz;
    r1.xyz = r1.xyz * v0.www + v0.xyz;
    r0.w = saturate(-v2.w);
    r0.w = 1 + -r0.w;
    o1.z = m_fAlphaScalar * r0.w;
    r2.xyz = cmp(v2.xyz >= -v2.xyz);
    r3.xyz = frac(abs(v2.xyz));
    r2.xyz = r2.xyz ? r3.xyz : -r3.xyz;
    r2.xyz = m_fHueVariationByPos * r2.xyz;
    r0.xyz = float3(20, 20, 20) * r0.xyz;
    r0.xyz = sin(r0.xyz);
    r0.xyz = m_fHueVariationByVertex * r0.xyz;
    r0.xyz = m_vHueVariationColor.xyz * r0.xyz;
    r0.xyz = r2.xyz * m_vHueVariationColor.xyz + r0.xyz;
    r0.w = cmp(1.5 < m_avEffectConfigFlags[3].w);
    r2.xyz = saturate(r1.www * r0.xyz);
    o4.xyz = r0.www ? r2.xyz : r0.xyz;
    r0.xyz = v2.xxx * float3(0.5, 0.5, 0.5) + float3(0.5, 0.166669995, -0.166660011);
    r0.w = saturate(3 * r0.x);
    r0.x = 1 + -r0.x;
    r0.x = saturate(3 * r0.x);
    o5.x = -r0.w * r0.x + 1;
    r0.xy = -abs(r0.yz) * float2(3, 3) + float2(1, 1);
    o5.yz = max(float2(0, 0), r0.xy);

    r0.xyz = -m_vCameraPosition.xyz + r1.xyz;
    float distance_squared = dot(r0.xyz, r0.xyz);

    r0.w = 1;
    o0.x = dot(m_mModelViewProj3d._m00_m01_m02_m03, r0.xyzw);
    o0.y = dot(m_mModelViewProj3d._m10_m11_m12_m13, r0.xyzw);
    o0.z = dot(m_mModelViewProj3d._m20_m21_m22_m23, r0.xyzw);
    o0.w = dot(m_mModelViewProj3d._m30_m31_m32_m33, r0.xyzw);
    o1.xy = v4.xy;
    o1.w = r1.w;
    o2.w = v8.w * 2 + -1;
    o2.xyz = r4.xyz;
    o5.w = 1;
    o6.w = v3.z;
    o6.xyz = r1.xyz;
    o7.yzw = float3(0, 0, 0);

    current_frame_position = o0.xyw;

    [branch]
    if (distance_squared < 16384) // Square(128)
    {
        previous_frame_position = ComputePreviousFramePosition(v0, v1, v2, v3, v4, v5, v6, v7, v8, v9);
    }
    else
    {
        previous_frame_position = current_frame_position;
    }
}
