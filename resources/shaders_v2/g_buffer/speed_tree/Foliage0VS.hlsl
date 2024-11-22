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
    float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18;

    r0.xyz = v8.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
    r1.xyz = v9.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
    r0.w = floor(v1.w);
    r1.w = v1.w + -r0.w;
    r1.w = 1.33333337 * r1.w;
    r0.w = v3.x + v3.y;
    r2.x = cmp(0.5 < m_avEffectConfigFlags[2].z);
    r3.x = v3.w;
    r3.yz = v4.zw;
    r2.yzw = v3.xyz + -r3.xyz;
    r2.yzw = r1.www * r2.yzw + r3.xyz;
    r2.xyz = r2.xxx ? r2.yzw : v3.xyz;
    r3.xyz = v2.yzx * v1.zxy;
    r3.xyz = v1.yzx * v2.zxy + -r3.xyz;
    r2.w = dot(r3.xyz, r3.xyz);
    r2.w = rsqrt(r2.w);
    r3.xyz = r3.xyz * r2.www;
    r4.xyz = r3.xyz * r2.yyy;
    r2.xyw = v2.xyz * r2.xxx + r4.xyz;
    r2.xyz = v1.xyz * r2.zzz + r2.xyw;
    r4.xyz = r3.xyz * r0.yyy;
    r4.xyz = v2.xyz * r0.xxx + r4.xyz;
    r4.xyz = v1.xyz * r0.zzz + r4.xyz;
    r5.xyz = r3.xyz * r1.yyy;
    r5.xyz = v2.xyz * r1.xxx + r5.xyz;
    r1.x = cmp(0.5 < m_avWindConfigFlags[0].x);
    r1.y = dot(r2.xyz, r2.xyz);
    r1.y = sqrt(r1.y);
    r1.z = 1 / previous_m_sGlobal.m_fHeight;
    r1.z = -r1.z * 0.25 + r2.z;
    r1.z = max(0, r1.z);
    r1.z = previous_m_sGlobal.m_fHeight * r1.z;
    r2.w = cmp(r1.z != 0.000000);
    r3.w = log2(abs(r1.z));
    r3.w = previous_m_sGlobal.m_fHeightExponent * r3.w;
    r3.w = exp2(r3.w);
    r1.z = r2.w ? r3.w : r1.z;
    r5.x = previous_m_sGlobal.m_fTime + v0.x;
    r5.y = previous_m_sGlobal.m_fTime * 0.800000012 + v0.y;
    r5.xy = float2(0.5, 0.5) + r5.xy;
    r5.xy = frac(r5.xy);
    r5.xy = r5.xy * float2(2, 2) + float2(-1, -1);
    r5.zw = abs(r5.xy) * abs(r5.xy);
    r5.xy = -abs(r5.xy) * float2(2, 2) + float2(3, 3);
    r5.xy = r5.zw * r5.xy + float2(-0.5, -0.5);
    r5.xy = r5.xy + r5.xy;
    r2.w = r5.y * r5.y + r5.x;
    r3.w = previous_m_sGlobal.m_fAdherence / previous_m_sGlobal.m_fHeight;
    r2.w = previous_m_sGlobal.m_fDistance * r2.w + r3.w;
    r1.z = r2.w * r1.z;
    r5.xy = previous_m_vDirection.xy * r1.zz + r2.xy;
    r5.z = r2.z;
    r1.z = dot(r5.xyz, r5.xyz);
    r1.z = rsqrt(r1.z);
    r5.xyz = r5.xyz * r1.zzz;
    r5.xyz = r5.xyz * r1.yyy + -r2.xyz;
    r1.xyz = r1.xxx ? r5.xyz : 0;
    r2.w = cmp(0.5 < m_avWindLodFlags[2].w);
    if (r2.w != 0)
    {
        r2.w = cmp(0.5 < m_avWindConfigFlags[0].z);
        if (r2.w != 0)
        {
            r5.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[1].zw);
            r6.xyz = float3(0.0625, 1, 16) * v5.yyy;
            r6.xyz = frac(r6.xyz);
            r6.xyz = r6.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
            r6.xyz = v5.xxx * r6.xyz;
            r2.w = v0.x + v0.y;
            r2.w = previous_m_sBranch1.m_fTime + r2.w;
            if (r5.y != 0)
            {
                r7.x = v5.y + r2.w;
                r7.y = r2.w * previous_m_sBranch1.m_fTwitchFreqScale + v5.y;
                r3.w = previous_m_sBranch1.m_fTwitchFreqScale * r7.x;
                r7.z = 0.5 * r3.w;
                r7.w = -v5.x + r7.x;
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
                r5.y = r5.y + -r3.w;
                r3.w = r5.z * r5.y + r3.w;
                r3.w = previous_m_sBranch1.m_fTwitch * r3.w;
                r5.y = 1 + -previous_m_fStrength;
                r5.z = 1 + -previous_m_sBranch1.m_fTwitch;
                r5.z = r7.x * r5.z;
                r3.w = r3.w * r5.y + r5.z;
                r5.y = previous_m_sBranch1.m_fWhip * r7.w;
                r5.y = r5.y * v5.x + 1;
                r5.y = r5.y * r3.w;
                r3.w = r5.x ? r5.y : r3.w;
            }
            else
            {
                r7.x = v5.y + r2.w;
                r7.y = r2.w * 0.68900001 + v5.y;
                r7.z = -v5.x + r7.x;
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
                r5.y = previous_m_sBranch1.m_fWhip * r5.w;
                r5.y = r5.y * v5.x + 1;
                r5.y = r5.y * r2.w;
                r3.w = r5.x ? r5.y : r2.w;
            }
            r5.xyz = r6.xyz * r3.www;
            r5.xyz = r5.xyz * previous_m_sBranch1.m_fDistance + r2.xyz;
        }
        else
        {
            r2.w = cmp(0.5 < m_avWindConfigFlags[0].w);
            if (r2.w != 0)
            {
                r6.xyz = cmp(float3(0.5, 0.5, 0.5) < m_avWindConfigFlags[1].zwy);
                r7.xyz = float3(0.0625, 1, 16) * v5.yyy;
                r7.xyz = frac(r7.xyz);
                r7.xyz = r7.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                r7.xyz = v5.xxx * r7.xyz;
                r2.w = v0.x + v0.y;
                r2.w = previous_m_sBranch1.m_fTime + r2.w;
                if (r6.y != 0)
                {
                    r8.x = v5.y + r2.w;
                    r8.y = r2.w * previous_m_sBranch1.m_fTwitchFreqScale + v5.y;
                    r3.w = previous_m_sBranch1.m_fTwitchFreqScale * r8.x;
                    r8.z = 0.5 * r3.w;
                    r8.w = -v5.x + r8.x;
                    r9.xyzw = float4(0.5, 0.5, 0.5, 1.5) + r8.xyzw;
                    r9.xyzw = frac(r9.xyzw);
                    r9.xyzw = r9.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
                    r10.xyzw = abs(r9.xyzw) * abs(r9.xyzw);
                    r9.xyzw = -abs(r9.xyzw) * float4(2, 2, 2, 2) + float4(3, 3, 3, 3);
                    r9.xyzw = r10.xyzw * r9.xyzw + float4(-0.5, -0.5, -0.5, -0.5);
                    r9.xyzw = r9.xyzw + r9.xyzw;
                    r8.xyz = float3(0.5, 0.5, 0.5) + r8.xyz;
                    r8.xyz = frac(r8.xyz);
                    r8.xyz = r8.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                    r10.xyz = abs(r8.xyz) * abs(r8.xyz);
                    r8.xyz = -abs(r8.xyz) * float3(2, 2, 2) + float3(3, 3, 3);
                    r8.xyz = r10.xyz * r8.xyz;
                    r8.w = 0;
                    r8.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r8.xyzw;
                    r8.xyzw = r8.xyzw + r8.xyzw;
                    r8.xyzw = r6.xxxx ? r9.wxyz : r8.wxyz;
                    r9.w = r8.z * r8.w;
                    r3.w = cmp(r9.w < 0);
                    r9.y = -r9.w;
                    r9.xz = float2(-1, 1);
                    r6.yw = r3.ww ? r9.xy : r9.zw;
                    r3.w = -r8.z * r8.w + r6.y;
                    r3.w = r6.w * r3.w + r9.w;
                    r5.w = r6.y + -r3.w;
                    r3.w = r6.w * r5.w + r3.w;
                    r3.w = previous_m_sBranch1.m_fTwitch * r3.w;
                    r5.w = 1 + -previous_m_fStrength;
                    r6.y = 1 + -previous_m_sBranch1.m_fTwitch;
                    r6.y = r8.y * r6.y;
                    r3.w = r3.w * r5.w + r6.y;
                    r5.w = previous_m_sBranch1.m_fWhip * r8.x;
                    r5.w = r5.w * v5.x + 1;
                    r5.w = r5.w * r3.w;
                    r3.w = r6.x ? r5.w : r3.w;
                }
                else
                {
                    r9.x = v5.y + r2.w;
                    r9.y = r2.w * 0.68900001 + v5.y;
                    r9.z = -v5.x + r9.x;
                    r10.xyz = float3(0.5, 0.5, 1.5) + r9.xyz;
                    r10.xyz = frac(r10.xyz);
                    r10.xyz = r10.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                    r11.xyz = abs(r10.xyz) * abs(r10.xyz);
                    r10.xyz = -abs(r10.xyz) * float3(2, 2, 2) + float3(3, 3, 3);
                    r10.xyz = r11.xyz * r10.xyz + float3(-0.5, -0.5, -0.5);
                    r10.xyz = r10.xyz + r10.xyz;
                    r6.yw = float2(0.5, 0.5) + r9.xy;
                    r6.yw = frac(r6.yw);
                    r6.yw = r6.yw * float2(2, 2) + float2(-1, -1);
                    r9.xy = abs(r6.yw) * abs(r6.yw);
                    r6.yw = -abs(r6.yw) * float2(2, 2) + float2(3, 3);
                    r9.xy = r9.xy * r6.yw;
                    r9.z = 0;
                    r9.xyz = float3(-0.5, -0.5, -0.5) + r9.xyz;
                    r9.xyz = r9.xyz + r9.xyz;
                    r8.xyz = r6.xxx ? r10.zxy : r9.zxy;
                    r5.w = r8.z * r8.y + r8.y;
                    r6.y = previous_m_sBranch1.m_fWhip * r8.x;
                    r6.y = r6.y * v5.x + 1;
                    r6.y = r6.y * r5.w;
                    r3.w = r6.x ? r6.y : r5.w;
                }
                r7.xyz = r7.xyz * r3.www;
                r7.xyz = r7.xyz * previous_m_sBranch1.m_fDistance + r2.xyz;
                r9.x = r2.w * 0.100000001 + v5.y;
                r2.w = previous_m_sBranch1.m_fTurbulence * m_fWallTime;
                r9.y = r2.w * 0.100000001 + v5.y;
                r6.yw = float2(0.5, 0.5) + r9.xy;
                r6.yw = frac(r6.yw);
                r6.yw = r6.yw * float2(2, 2) + float2(-1, -1);
                r8.yz = abs(r6.yw) * abs(r6.yw);
                r6.yw = -abs(r6.yw) * float2(2, 2) + float2(3, 3);
                r6.yw = r8.yz * r6.yw + float2(-0.5, -0.5);
                r6.yw = r6.yw + r6.yw;
                r6.yw = r6.yw * r6.yw;
                r2.w = r6.w * r6.y;
                r2.w = -r2.w * previous_m_sBranch1.m_fTurbulence + 1;
                r2.w = r6.z ? r2.w : 1;
                r3.w = previous_m_fStrength * r8.x;
                r3.w = r3.w * previous_m_sBranch1.m_fWhip + r2.w;
                r2.w = r6.x ? r3.w : r2.w;
                r6.xyz = previous_m_sBranch1.m_fDirectionAdherence * previous_m_vDirection.xyz;
                r6.xyz = r6.xyz * r2.www;
                r5.xyz = r6.xyz * v5.xxx + r7.xyz;
            }
            else
            {
                r2.w = cmp(0.5 < m_avWindConfigFlags[1].x);
                if (r2.w != 0)
                {
                    r6.xyz = cmp(float3(0.5, 0.5, 0.5) < m_avWindConfigFlags[1].zwy);
                    r7.xyz = float3(0.0625, 1, 16) * v5.yyy;
                    r7.xyz = frac(r7.xyz);
                    r7.xyz = r7.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                    r7.xyz = v5.xxx * r7.xyz;
                    r2.w = v0.x + v0.y;
                    r2.w = previous_m_sBranch1.m_fTime + r2.w;
                    if (r6.y != 0)
                    {
                        r8.x = v5.y + r2.w;
                        r8.y = r2.w * previous_m_sBranch1.m_fTwitchFreqScale + v5.y;
                        r3.w = previous_m_sBranch1.m_fTwitchFreqScale * r8.x;
                        r8.z = 0.5 * r3.w;
                        r8.w = -v5.x + r8.x;
                        r9.xyzw = float4(0.5, 0.5, 0.5, 1.5) + r8.xyzw;
                        r9.xyzw = frac(r9.xyzw);
                        r9.xyzw = r9.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
                        r10.xyzw = abs(r9.xyzw) * abs(r9.xyzw);
                        r9.xyzw = -abs(r9.xyzw) * float4(2, 2, 2, 2) + float4(3, 3, 3, 3);
                        r9.xyzw = r10.xyzw * r9.xyzw + float4(-0.5, -0.5, -0.5, -0.5);
                        r9.xyzw = r9.xyzw + r9.xyzw;
                        r8.xyz = float3(0.5, 0.5, 0.5) + r8.xyz;
                        r8.xyz = frac(r8.xyz);
                        r8.xyz = r8.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                        r10.xyz = abs(r8.xyz) * abs(r8.xyz);
                        r8.xyz = -abs(r8.xyz) * float3(2, 2, 2) + float3(3, 3, 3);
                        r8.xyz = r10.xyz * r8.xyz;
                        r8.w = 0;
                        r8.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r8.xyzw;
                        r8.xyzw = r8.xyzw + r8.xyzw;
                        r8.xyzw = r6.xxxx ? r9.wxyz : r8.wxyz;
                        r9.w = r8.z * r8.w;
                        r3.w = cmp(r9.w < 0);
                        r9.y = -r9.w;
                        r9.xz = float2(-1, 1);
                        r6.yw = r3.ww ? r9.xy : r9.zw;
                        r3.w = -r8.z * r8.w + r6.y;
                        r3.w = r6.w * r3.w + r9.w;
                        r5.w = r6.y + -r3.w;
                        r3.w = r6.w * r5.w + r3.w;
                        r3.w = previous_m_sBranch1.m_fTwitch * r3.w;
                        r5.w = 1 + -previous_m_fStrength;
                        r6.y = 1 + -previous_m_sBranch1.m_fTwitch;
                        r6.y = r8.y * r6.y;
                        r3.w = r3.w * r5.w + r6.y;
                        r5.w = previous_m_sBranch1.m_fWhip * r8.x;
                        r5.w = r5.w * v5.x + 1;
                        r5.w = r5.w * r3.w;
                        r3.w = r6.x ? r5.w : r3.w;
                    }
                    else
                    {
                        r9.x = v5.y + r2.w;
                        r9.y = r2.w * 0.68900001 + v5.y;
                        r9.z = -v5.x + r9.x;
                        r10.xyz = float3(0.5, 0.5, 1.5) + r9.xyz;
                        r10.xyz = frac(r10.xyz);
                        r10.xyz = r10.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                        r11.xyz = abs(r10.xyz) * abs(r10.xyz);
                        r10.xyz = -abs(r10.xyz) * float3(2, 2, 2) + float3(3, 3, 3);
                        r10.xyz = r11.xyz * r10.xyz + float3(-0.5, -0.5, -0.5);
                        r10.xyz = r10.xyz + r10.xyz;
                        r6.yw = float2(0.5, 0.5) + r9.xy;
                        r6.yw = frac(r6.yw);
                        r6.yw = r6.yw * float2(2, 2) + float2(-1, -1);
                        r9.xy = abs(r6.yw) * abs(r6.yw);
                        r6.yw = -abs(r6.yw) * float2(2, 2) + float2(3, 3);
                        r9.xy = r9.xy * r6.yw;
                        r9.z = 0;
                        r9.xyz = float3(-0.5, -0.5, -0.5) + r9.xyz;
                        r9.xyz = r9.xyz + r9.xyz;
                        r8.xyz = r6.xxx ? r10.zxy : r9.zxy;
                        r5.w = r8.z * r8.y + r8.y;
                        r6.y = previous_m_sBranch1.m_fWhip * r8.x;
                        r6.y = r6.y * v5.x + 1;
                        r6.y = r6.y * r5.w;
                        r3.w = r6.x ? r6.y : r5.w;
                    }
                    r7.xyz = r7.xyz * r3.www;
                    r7.xyz = r7.xyz * previous_m_sBranch1.m_fDistance + r2.xyz;
                    r9.x = r2.w * 0.100000001 + v5.y;
                    r2.w = previous_m_sBranch1.m_fTurbulence * m_fWallTime;
                    r9.y = r2.w * 0.100000001 + v5.y;
                    r6.yw = float2(0.5, 0.5) + r9.xy;
                    r6.yw = frac(r6.yw);
                    r6.yw = r6.yw * float2(2, 2) + float2(-1, -1);
                    r8.yz = abs(r6.yw) * abs(r6.yw);
                    r6.yw = -abs(r6.yw) * float2(2, 2) + float2(3, 3);
                    r6.yw = r8.yz * r6.yw + float2(-0.5, -0.5);
                    r6.yw = r6.yw + r6.yw;
                    r6.yw = r6.yw * r6.yw;
                    r2.w = r6.w * r6.y;
                    r2.w = -r2.w * previous_m_sBranch1.m_fTurbulence + 1;
                    r2.w = r6.z ? r2.w : 1;
                    r3.w = previous_m_fStrength * r8.x;
                    r3.w = r3.w * previous_m_sBranch1.m_fWhip + r2.w;
                    r2.w = r6.x ? r3.w : r2.w;
                    r6.xyz = previous_m_vAnchor.xyz + -r7.xyz;
                    r6.xyz = previous_m_sBranch1.m_fDirectionAdherence * r6.xyz;
                    r6.xyz = r6.xyz * r2.www;
                    r5.xyz = r6.xyz * v5.xxx + r7.xyz;
                }
                else
                {
                    r5.xyz = r2.xyz;
                }
            }
        }
        r2.w = cmp(0.5 < m_avWindConfigFlags[2].x);
        if (r2.w != 0)
        {
            r6.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[3].xy);
            r7.xyz = float3(0.0625, 1, 16) * v5.www;
            r7.xyz = frac(r7.xyz);
            r7.xyz = r7.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
            r7.xyz = v5.zzz * r7.xyz;
            r2.w = v0.x + v0.y;
            r2.w = previous_m_sBranch2.m_fTime + r2.w;
            if (r6.y != 0)
            {
                r8.x = v5.w + r2.w;
                r8.y = r2.w * previous_m_sBranch2.m_fTwitchFreqScale + v5.w;
                r3.w = previous_m_sBranch2.m_fTwitchFreqScale * r8.x;
                r8.z = 0.5 * r3.w;
                r8.w = -v5.z + r8.x;
                r9.xyzw = float4(0.5, 0.5, 0.5, 1.5) + r8.xyzw;
                r9.xyzw = frac(r9.xyzw);
                r9.xyzw = r9.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
                r10.xyzw = abs(r9.xyzw) * abs(r9.xyzw);
                r9.xyzw = -abs(r9.xyzw) * float4(2, 2, 2, 2) + float4(3, 3, 3, 3);
                r9.xyzw = r10.xyzw * r9.xyzw + float4(-0.5, -0.5, -0.5, -0.5);
                r9.xyzw = r9.xyzw + r9.xyzw;
                r6.yzw = float3(0.5, 0.5, 0.5) + r8.xyz;
                r6.yzw = frac(r6.yzw);
                r6.yzw = r6.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
                r8.xyz = abs(r6.yzw) * abs(r6.yzw);
                r6.yzw = -abs(r6.yzw) * float3(2, 2, 2) + float3(3, 3, 3);
                r8.xyz = r8.xyz * r6.yzw;
                r8.w = 0;
                r8.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r8.xyzw;
                r8.xyzw = r8.xyzw + r8.xyzw;
                r8.xyzw = r6.xxxx ? r9.xyzw : r8.xyzw;
                r9.w = r8.y * r8.z;
                r3.w = cmp(r9.w < 0);
                r9.y = -r9.w;
                r9.xz = float2(-1, 1);
                r6.yz = r3.ww ? r9.xy : r9.zw;
                r3.w = -r8.y * r8.z + r6.y;
                r3.w = r6.z * r3.w + r9.w;
                r5.w = r6.y + -r3.w;
                r3.w = r6.z * r5.w + r3.w;
                r3.w = previous_m_sBranch2.m_fTwitch * r3.w;
                r5.w = 1 + -previous_m_fStrength;
                r6.y = 1 + -previous_m_sBranch2.m_fTwitch;
                r6.y = r8.x * r6.y;
                r3.w = r3.w * r5.w + r6.y;
                r5.w = previous_m_sBranch2.m_fWhip * r8.w;
                r5.w = r5.w * v5.z + 1;
                r5.w = r5.w * r3.w;
                r3.w = r6.x ? r5.w : r3.w;
            }
            else
            {
                r8.x = v5.w + r2.w;
                r8.y = r2.w * 0.68900001 + v5.w;
                r8.z = -v5.z + r8.x;
                r6.yzw = float3(0.5, 0.5, 1.5) + r8.xyz;
                r6.yzw = frac(r6.yzw);
                r6.yzw = r6.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
                r9.xyz = abs(r6.yzw) * abs(r6.yzw);
                r6.yzw = -abs(r6.yzw) * float3(2, 2, 2) + float3(3, 3, 3);
                r6.yzw = r9.xyz * r6.yzw + float3(-0.5, -0.5, -0.5);
                r6.yzw = r6.yzw + r6.yzw;
                r8.xy = float2(0.5, 0.5) + r8.xy;
                r8.xy = frac(r8.xy);
                r8.xy = r8.xy * float2(2, 2) + float2(-1, -1);
                r8.zw = abs(r8.xy) * abs(r8.xy);
                r8.xy = -abs(r8.xy) * float2(2, 2) + float2(3, 3);
                r8.xy = r8.zw * r8.xy;
                r8.z = 0;
                r8.xyz = float3(-0.5, -0.5, -0.5) + r8.xyz;
                r8.xyz = r8.xyz + r8.xyz;
                r6.yzw = r6.xxx ? r6.yzw : r8.xyz;
                r2.w = r6.z * r6.y + r6.y;
                r5.w = previous_m_sBranch2.m_fWhip * r6.w;
                r5.w = r5.w * v5.z + 1;
                r5.w = r5.w * r2.w;
                r3.w = r6.x ? r5.w : r2.w;
            }
            r6.xyz = r7.xyz * r3.www;
            r5.xyz = r6.xyz * previous_m_sBranch2.m_fDistance + r5.xyz;
        }
        else
        {
            r2.w = cmp(0.5 < m_avWindConfigFlags[2].y);
            if (r2.w != 0)
            {
                r6.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[3].xy);
                r2.w = cmp(0.5 < m_avWindConfigFlags[2].w);
                r7.xyz = float3(0.0625, 1, 16) * v5.www;
                r7.xyz = frac(r7.xyz);
                r7.xyz = r7.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                r7.xyz = v5.zzz * r7.xyz;
                r3.w = v0.x + v0.y;
                r3.w = previous_m_sBranch2.m_fTime + r3.w;
                if (r6.y != 0)
                {
                    r8.x = v5.w + r3.w;
                    r8.y = r3.w * previous_m_sBranch2.m_fTwitchFreqScale + v5.w;
                    r5.w = previous_m_sBranch2.m_fTwitchFreqScale * r8.x;
                    r8.z = 0.5 * r5.w;
                    r8.w = -v5.z + r8.x;
                    r9.xyzw = float4(0.5, 0.5, 0.5, 1.5) + r8.xyzw;
                    r9.xyzw = frac(r9.xyzw);
                    r9.xyzw = r9.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
                    r10.xyzw = abs(r9.xyzw) * abs(r9.xyzw);
                    r9.xyzw = -abs(r9.xyzw) * float4(2, 2, 2, 2) + float4(3, 3, 3, 3);
                    r9.xyzw = r10.xyzw * r9.xyzw + float4(-0.5, -0.5, -0.5, -0.5);
                    r9.xyzw = r9.xyzw + r9.xyzw;
                    r6.yzw = float3(0.5, 0.5, 0.5) + r8.xyz;
                    r6.yzw = frac(r6.yzw);
                    r6.yzw = r6.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
                    r8.xyz = abs(r6.yzw) * abs(r6.yzw);
                    r6.yzw = -abs(r6.yzw) * float3(2, 2, 2) + float3(3, 3, 3);
                    r8.xyz = r8.xyz * r6.yzw;
                    r8.w = 0;
                    r8.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r8.xyzw;
                    r8.xyzw = r8.xyzw + r8.xyzw;
                    r8.xyzw = r6.xxxx ? r9.wxyz : r8.wxyz;
                    r9.w = r8.z * r8.w;
                    r5.w = cmp(r9.w < 0);
                    r9.y = -r9.w;
                    r9.xz = float2(-1, 1);
                    r6.yz = r5.ww ? r9.xy : r9.zw;
                    r5.w = -r8.z * r8.w + r6.y;
                    r5.w = r6.z * r5.w + r9.w;
                    r6.y = r6.y + -r5.w;
                    r5.w = r6.z * r6.y + r5.w;
                    r5.w = previous_m_sBranch2.m_fTwitch * r5.w;
                    r6.y = 1 + -previous_m_fStrength;
                    r6.z = 1 + -previous_m_sBranch2.m_fTwitch;
                    r6.z = r8.y * r6.z;
                    r5.w = r5.w * r6.y + r6.z;
                    r6.y = previous_m_sBranch2.m_fWhip * r8.x;
                    r6.y = r6.y * v5.z + 1;
                    r6.y = r6.y * r5.w;
                    r5.w = r6.x ? r6.y : r5.w;
                }
                else
                {
                    r9.x = v5.w + r3.w;
                    r9.y = r3.w * 0.68900001 + v5.w;
                    r9.z = -v5.z + r9.x;
                    r6.yzw = float3(0.5, 0.5, 1.5) + r9.xyz;
                    r6.yzw = frac(r6.yzw);
                    r6.yzw = r6.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
                    r10.xyz = abs(r6.yzw) * abs(r6.yzw);
                    r6.yzw = -abs(r6.yzw) * float3(2, 2, 2) + float3(3, 3, 3);
                    r6.yzw = r10.xyz * r6.yzw + float3(-0.5, -0.5, -0.5);
                    r6.yzw = r6.yzw + r6.yzw;
                    r9.xy = float2(0.5, 0.5) + r9.xy;
                    r9.xy = frac(r9.xy);
                    r9.xy = r9.xy * float2(2, 2) + float2(-1, -1);
                    r9.zw = abs(r9.xy) * abs(r9.xy);
                    r9.xy = -abs(r9.xy) * float2(2, 2) + float2(3, 3);
                    r9.xy = r9.zw * r9.xy;
                    r9.z = 0;
                    r9.xyz = float3(-0.5, -0.5, -0.5) + r9.xyz;
                    r9.xyz = r9.xyz + r9.xyz;
                    r8.xyz = r6.xxx ? r6.wyz : r9.zxy;
                    r6.y = r8.z * r8.y + r8.y;
                    r6.z = previous_m_sBranch2.m_fWhip * r8.x;
                    r6.z = r6.z * v5.z + 1;
                    r6.z = r6.y * r6.z;
                    r5.w = r6.x ? r6.z : r6.y;
                }
                r6.yzw = r7.xyz * r5.www;
                r6.yzw = r6.yzw * previous_m_sBranch2.m_fDistance + r5.xyz;
                r7.x = r3.w * 0.100000001 + v5.w;
                r3.w = previous_m_sBranch2.m_fTurbulence * m_fWallTime;
                r7.y = r3.w * 0.100000001 + v5.w;
                r7.xy = float2(0.5, 0.5) + r7.xy;
                r7.xy = frac(r7.xy);
                r7.xy = r7.xy * float2(2, 2) + float2(-1, -1);
                r7.zw = abs(r7.xy) * abs(r7.xy);
                r7.xy = -abs(r7.xy) * float2(2, 2) + float2(3, 3);
                r7.xy = r7.zw * r7.xy + float2(-0.5, -0.5);
                r7.xy = r7.xy + r7.xy;
                r7.xy = r7.xy * r7.xy;
                r3.w = r7.y * r7.x;
                r3.w = -r3.w * previous_m_sBranch2.m_fTurbulence + 1;
                r2.w = r2.w ? r3.w : 1;
                r3.w = previous_m_fStrength * r8.x;
                r3.w = r3.w * previous_m_sBranch2.m_fWhip + r2.w;
                r2.w = r6.x ? r3.w : r2.w;
                r7.xyz = previous_m_sBranch2.m_fDirectionAdherence * previous_m_vDirection.xyz;
                r7.xyz = r7.xyz * r2.www;
                r5.xyz = r7.xyz * v5.zzz + r6.yzw;
            }
            else
            {
                r2.w = cmp(0.5 < m_avWindConfigFlags[2].z);
                if (r2.w != 0)
                {
                    r6.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[3].xy);
                    r2.w = cmp(0.5 < m_avWindConfigFlags[2].w);
                    r7.xyz = float3(0.0625, 1, 16) * v5.www;
                    r7.xyz = frac(r7.xyz);
                    r7.xyz = r7.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                    r7.xyz = v5.zzz * r7.xyz;
                    r3.w = v0.x + v0.y;
                    r3.w = previous_m_sBranch2.m_fTime + r3.w;
                    if (r6.y != 0)
                    {
                        r8.x = v5.w + r3.w;
                        r8.y = r3.w * previous_m_sBranch2.m_fTwitchFreqScale + v5.w;
                        r5.w = previous_m_sBranch2.m_fTwitchFreqScale * r8.x;
                        r8.z = 0.5 * r5.w;
                        r8.w = -v5.z + r8.x;
                        r9.xyzw = float4(0.5, 0.5, 0.5, 1.5) + r8.xyzw;
                        r9.xyzw = frac(r9.xyzw);
                        r9.xyzw = r9.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
                        r10.xyzw = abs(r9.xyzw) * abs(r9.xyzw);
                        r9.xyzw = -abs(r9.xyzw) * float4(2, 2, 2, 2) + float4(3, 3, 3, 3);
                        r9.xyzw = r10.xyzw * r9.xyzw + float4(-0.5, -0.5, -0.5, -0.5);
                        r9.xyzw = r9.xyzw + r9.xyzw;
                        r6.yzw = float3(0.5, 0.5, 0.5) + r8.xyz;
                        r6.yzw = frac(r6.yzw);
                        r6.yzw = r6.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
                        r8.xyz = abs(r6.yzw) * abs(r6.yzw);
                        r6.yzw = -abs(r6.yzw) * float3(2, 2, 2) + float3(3, 3, 3);
                        r8.xyz = r8.xyz * r6.yzw;
                        r8.w = 0;
                        r8.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r8.xyzw;
                        r8.xyzw = r8.xyzw + r8.xyzw;
                        r8.xyzw = r6.xxxx ? r9.wxyz : r8.wxyz;
                        r9.w = r8.z * r8.w;
                        r5.w = cmp(r9.w < 0);
                        r9.y = -r9.w;
                        r9.xz = float2(-1, 1);
                        r6.yz = r5.ww ? r9.xy : r9.zw;
                        r5.w = -r8.z * r8.w + r6.y;
                        r5.w = r6.z * r5.w + r9.w;
                        r6.y = r6.y + -r5.w;
                        r5.w = r6.z * r6.y + r5.w;
                        r5.w = previous_m_sBranch2.m_fTwitch * r5.w;
                        r6.y = 1 + -previous_m_fStrength;
                        r6.z = 1 + -previous_m_sBranch2.m_fTwitch;
                        r6.z = r8.y * r6.z;
                        r5.w = r5.w * r6.y + r6.z;
                        r6.y = previous_m_sBranch2.m_fWhip * r8.x;
                        r6.y = r6.y * v5.z + 1;
                        r6.y = r6.y * r5.w;
                        r5.w = r6.x ? r6.y : r5.w;
                    }
                    else
                    {
                        r9.x = v5.w + r3.w;
                        r9.y = r3.w * 0.68900001 + v5.w;
                        r9.z = -v5.z + r9.x;
                        r6.yzw = float3(0.5, 0.5, 1.5) + r9.xyz;
                        r6.yzw = frac(r6.yzw);
                        r6.yzw = r6.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
                        r10.xyz = abs(r6.yzw) * abs(r6.yzw);
                        r6.yzw = -abs(r6.yzw) * float3(2, 2, 2) + float3(3, 3, 3);
                        r6.yzw = r10.xyz * r6.yzw + float3(-0.5, -0.5, -0.5);
                        r6.yzw = r6.yzw + r6.yzw;
                        r9.xy = float2(0.5, 0.5) + r9.xy;
                        r9.xy = frac(r9.xy);
                        r9.xy = r9.xy * float2(2, 2) + float2(-1, -1);
                        r9.zw = abs(r9.xy) * abs(r9.xy);
                        r9.xy = -abs(r9.xy) * float2(2, 2) + float2(3, 3);
                        r9.xy = r9.zw * r9.xy;
                        r9.z = 0;
                        r9.xyz = float3(-0.5, -0.5, -0.5) + r9.xyz;
                        r9.xyz = r9.xyz + r9.xyz;
                        r8.xyz = r6.xxx ? r6.wyz : r9.zxy;
                        r6.y = r8.z * r8.y + r8.y;
                        r6.z = previous_m_sBranch2.m_fWhip * r8.x;
                        r6.z = r6.z * v5.z + 1;
                        r6.z = r6.y * r6.z;
                        r5.w = r6.x ? r6.z : r6.y;
                    }
                    r6.yzw = r7.xyz * r5.www;
                    r6.yzw = r6.yzw * previous_m_sBranch2.m_fDistance + r5.xyz;
                    r7.x = r3.w * 0.100000001 + v5.w;
                    r3.w = previous_m_sBranch2.m_fTurbulence * m_fWallTime;
                    r7.y = r3.w * 0.100000001 + v5.w;
                    r7.xy = float2(0.5, 0.5) + r7.xy;
                    r7.xy = frac(r7.xy);
                    r7.xy = r7.xy * float2(2, 2) + float2(-1, -1);
                    r7.zw = abs(r7.xy) * abs(r7.xy);
                    r7.xy = -abs(r7.xy) * float2(2, 2) + float2(3, 3);
                    r7.xy = r7.zw * r7.xy + float2(-0.5, -0.5);
                    r7.xy = r7.xy + r7.xy;
                    r7.xy = r7.xy * r7.xy;
                    r3.w = r7.y * r7.x;
                    r3.w = -r3.w * previous_m_sBranch2.m_fTurbulence + 1;
                    r2.w = r2.w ? r3.w : 1;
                    r3.w = previous_m_fStrength * r8.x;
                    r3.w = r3.w * previous_m_sBranch2.m_fWhip + r2.w;
                    r2.w = r6.x ? r3.w : r2.w;
                    r7.xyz = previous_m_vAnchor.xyz + -r6.yzw;
                    r7.xyz = previous_m_sBranch2.m_fDirectionAdherence * r7.xyz;
                    r7.xyz = r7.xyz * r2.www;
                    r5.xyz = r7.xyz * v5.zzz + r6.yzw;
                }
            }
        }
        r5.xyz = r5.xyz + -r2.xyz;
    }
    else
    {
        r5.xyz = float3(0, 0, 0);
    }
    r3.xyz = v7.yyy * r3.xyz;
    r3.xyz = v2.xyz * v7.xxx + r3.xyz;
    r3.xyz = v1.xyz * v7.zzz + r3.xyz;
    r2.w = cmp(0 < v6.w);
    if (r2.w != 0)
    {
        r6.xyz = cmp(float3(0.5, 0.5, 0.5) < m_avWindConfigFlags[5].wxy);
        r2.w = dot(r3.xy, r3.xy);
        r2.w = rsqrt(r2.w);
        r7.xy = r3.xy * r2.ww;
        r2.w = dot(-r7.xy, previous_m_vDirection.xy);
        r2.w = 1 + r2.w;
        r2.w = 0.5 * r2.w;
        r3.w = 1 + -previous_m_sLeaf2.m_fLeewardScalar;
        r2.w = r2.w * r3.w + previous_m_sLeaf2.m_fLeewardScalar;
        r2.w = v6.x * r2.w;
        r2.w = r6.x ? r2.w : v6.x;
        r3.w = cmp(0.5 < m_avWindConfigFlags[6].w);
        if (r3.w != 0)
        {
            r6.xw = v0.xy + r3.xy;
            r6.xw = -previous_m_sRolling.m_vOffset.xy + r6.xw;
            r6.xw = previous_m_sRolling.m_fNoiseSize * r6.xw;
            r3.w = 5 * previous_m_sRolling.m_fNoisePeriod;
            r3.w = dot(r6.xw, r3.ww);
            r5.w = previous_m_sRolling.m_fNoiseTurbulence;
            r7.x = 0;
            while (true)
            {
                r7.y = cmp(r5.w < 1);
                if (r7.y != 0)
                    break;
                r7.yz = r6.xw / r5.ww;
                r7.yz = frac(r7.yz);
                r8.xyzw = PerlinNoiseKernel.SampleLevel(samStandard_s, r7.yz, 0).xyzw;
                r7.y = dot(r8.xyzw, float4(0.25, 0.25, 0.25, 0.25));
                r7.x = r7.y * r5.w + r7.x;
                r5.w = 0.5 * r5.w;
            }
            r5.w = 0.5 * r7.x;
            r5.w = r5.w / previous_m_sRolling.m_fNoiseTurbulence;
            r3.w = previous_m_sRolling.m_fNoiseTwist * r5.w + r3.w;
            r3.w = 3.14159274 * r3.w;
            r3.w = sin(r3.w);
            r3.w = 1 + -abs(r3.w);
            r5.w = 1 + -previous_m_sRolling.m_fLeafRippleMin;
            r7.x = r3.w * r5.w + previous_m_sRolling.m_fLeafRippleMin;
            r5.w = 1 + -previous_m_sRolling.m_fLeafTumbleMin;
            r7.y = r3.w * r5.w + previous_m_sRolling.m_fLeafTumbleMin;
        }
        else
        {
            r7.xy = float2(1, 1);
        }
        r3.w = cmp(0.5 < m_avWindConfigFlags[4].w);
        r5.w = r7.x * r2.w;
        r6.x = previous_m_sLeaf2.m_fRippleTime + r0.w;
        r6.x = 0.5 + r6.x;
        r6.x = frac(r6.x);
        r6.x = r6.x * 2 + -1;
        r6.w = abs(r6.x) * abs(r6.x);
        r6.x = -abs(r6.x) * 2 + 3;
        r6.x = r6.w * r6.x + -0.5;
        r6.x = dot(r6.xx, previous_m_sLeaf2.m_fRippleDistance);
        r7.xzw = r6.xxx * r4.xyz;
        r7.xzw = r7.xzw * r5.www + r2.xyz;
        r8.xyz = float3(0.0625, 1, 16) * v6.zzz;
        r8.xyz = frac(r8.xyz);
        r8.xyz = r8.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
        r8.xyz = r8.xyz * r6.xxx;
        r8.xyz = r8.xyz * r5.www + r2.xyz;
        r6.xyw = r6.yyy ? r8.xyz : r2.xyz;
        r6.xyw = r3.www ? r7.xzw : r6.xyw;
        if (r6.z != 0)
        {
            r7.xzw = float3(0.0625, 1, 16) * v6.yyy;
            r7.xzw = frac(r7.xzw);
            r7.xzw = r7.xzw * float3(2, 2, 2) + float3(-1, -1, -1);
            r2.w = r7.y * r2.w;
            r3.w = cmp(0.5 < m_avWindConfigFlags[5].z);
            r8.xyz = r3.xyz + r0.www;
            r8.xyz = float3(30.2999992, 30.2999992, 30.2999992) * r8.xyz;
            r8.xyz = frac(r8.xyz);
            r5.w = r8.x + r8.y;
            r5.w = r5.w + r8.z;
            r8.y = previous_m_sLeaf2.m_fTumbleTime + r5.w;
            r8.x = previous_m_sLeaf2.m_fTumbleTime * 0.75 + -r5.w;
            r8.xy = float2(0.5, 0.5) + r8.xy;
            r8.xy = frac(r8.xy);
            r8.xy = r8.xy * float2(2, 2) + float2(-1, -1);
            r8.zw = abs(r8.xy) * abs(r8.xy);
            r8.xy = -abs(r8.xy) * float2(2, 2) + float2(3, 3);
            r8.xy = r8.zw * r8.xy + float2(-0.5, -0.5);
            r8.xy = r8.xy + r8.xy;
            r9.xyz = r6.xyw + -r3.xyz;
            r6.z = dot(r9.xyz, r9.xyz);
            r6.z = sqrt(r6.z);
            r7.y = r8.x * r8.x + r8.y;
            r8.z = previous_m_sLeaf2.m_fTumbleTwist * r2.w;
            r7.y = r8.z * r7.y;
            sincos(r7.y, r10.x, r11.x);
            r7.y = 1 + -r11.x;
            r12.xyzw = r7.yyyy * r7.xxxz;
            r10.xyz = r10.xxx * r7.wxz;
            r13.xy = r12.zy * r7.wz + r10.zx;
            r14.xy = r12.xw * r7.xz + r11.xx;
            r13.z = r12.w * r7.w + -r10.y;
            r15.xy = r12.yz * r7.zw + -r10.xz;
            r15.z = r12.w * r7.w + r10.y;
            r8.z = r7.w * r7.w;
            r15.w = r8.z * r7.y + r11.x;
            r10.xyz = previous_m_vDirection.yzx * r7.wxz;
            r10.xyz = r7.zwx * previous_m_vDirection.zxy + -r10.xyz;
            r7.x = dot(previous_m_vDirection.xyz, r7.xzw);
            r7.x = max(-1, r7.x);
            r7.x = min(1, r7.x);
            r10.w = r10.z + r7.x;
            r7.y = dot(r10.xyw, r10.xyw);
            r7.y = rsqrt(r7.y);
            r7.yzw = r10.wxy * r7.yyy;
            r8.z = 1 + -abs(r7.x);
            r8.z = sqrt(r8.z);
            r8.w = abs(r7.x) * -0.0187292993 + 0.0742610022;
            r8.w = r8.w * abs(r7.x) + -0.212114394;
            r8.w = r8.w * abs(r7.x) + 1.57072878;
            r9.w = r8.w * r8.z;
            r9.w = r9.w * -2 + 3.14159274;
            r7.x = cmp(r7.x < -r7.x);
            r7.x = r7.x ? r9.w : 0;
            r7.x = r8.w * r8.z + r7.x;
            r8.x = -r8.y * r8.y + r8.x;
            r5.w = previous_m_sLeaf2.m_fTwitchTime + r5.w;
            r10.x = r0.w * r0.w + r5.w;
            r10.y = r5.w * 0.870000005 + r0.w;
            r8.yz = float2(0.5, 0.5) + r10.xy;
            r8.yz = frac(r8.yz);
            r8.yz = r8.yz * float2(2, 2) + float2(-1, -1);
            r10.xy = abs(r8.yz) * abs(r8.yz);
            r8.yz = -abs(r8.yz) * float2(2, 2) + float2(3, 3);
            r8.yz = r10.xy * r8.yz + float2(-0.5, -0.5);
            r8.yz = r8.yz + r8.yz;
            r5.w = r8.z * r8.z;
            r5.w = r5.w * r8.y + 1;
            r5.w = saturate(0.5 * r5.w);
            r5.w = log2(r5.w);
            r5.w = previous_m_sLeaf2.m_fTwitchSharpness * r5.w;
            r5.w = exp2(r5.w);
            r5.w = previous_m_sLeaf2.m_fTwitchThrow * r5.w;
            r3.w = r3.w ? r5.w : 0;
            r5.w = previous_m_sLeaf2.m_fTumbleFlip * r8.x;
            r5.w = r7.x * previous_m_sLeaf2.m_fTumbleDirectionAdherence + r5.w;
            r3.w = r5.w + r3.w;
            r2.w = r3.w * r2.w;
            sincos(r2.w, r7.x, r8.x);
            r2.w = 1 + -r8.x;
            r10.xyzw = r2.wwww * r7.zzzw;
            r8.yzw = r7.xxx * r7.yzw;
            r11.xy = r10.zy * r7.yw + r8.wy;
            r12.xy = r10.xw * r7.zw + r8.xx;
            r11.z = r10.w * r7.y + -r8.z;
            r16.xy = r10.yz * r7.wy + -r8.yw;
            r16.z = r10.w * r7.y + r8.z;
            r3.w = r7.y * r7.y;
            r11.w = r3.w * r2.w + r8.x;
            r14.z = r15.x;
            r14.w = r13.x;
            r12.z = r11.y;
            r12.w = r16.y;
            r7.x = dot(r14.xzw, r12.xzw);
            r16.w = r12.y;
            r7.y = dot(r14.xwz, r16.xzw);
            r7.z = dot(r14.xzw, r11.xzw);
            r13.w = r14.y;
            r8.x = dot(r13.ywz, r12.xzw);
            r8.y = dot(r13.yzw, r16.xzw);
            r8.z = dot(r13.ywz, r11.xzw);
            r10.x = dot(r15.yzw, r12.xzw);
            r10.y = dot(r15.ywz, r16.xzw);
            r10.z = dot(r15.yzw, r11.xzw);
            r11.x = dot(r7.xyz, r4.xyz);
            r11.y = dot(r8.xyz, r4.xyz);
            r11.z = dot(r10.xyz, r4.xyz);
            r7.x = dot(r7.xyz, r9.xyz);
            r7.y = dot(r8.xyz, r9.xyz);
            r7.z = dot(r10.xyz, r9.xyz);
            r2.w = dot(r7.xyz, r7.xyz);
            r2.w = rsqrt(r2.w);
            r7.xyz = r7.xyz * r2.www;
            r6.xyw = r7.xyz * r6.zzz + r3.xyz;
            r4.xyz = r11.xyz;
        }
        r6.xyz = r6.xyw + -r2.xyz;
    }
    else
    {
        r7.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[4].zx);
        r2.w = dot(r3.xy, r3.xy);
        r2.w = rsqrt(r2.w);
        r7.zw = r3.xy * r2.ww;
        r2.w = dot(-r7.zw, previous_m_vDirection.xy);
        r2.w = 1 + r2.w;
        r2.w = 0.5 * r2.w;
        r3.w = 1 + -previous_m_sLeaf1.m_fLeewardScalar;
        r2.w = r2.w * r3.w + previous_m_sLeaf1.m_fLeewardScalar;
        r2.w = v6.x * r2.w;
        r2.w = r7.x ? r2.w : v6.x;
        r3.w = cmp(0.5 < m_avWindConfigFlags[6].w);
        if (r3.w != 0)
        {
            r7.xz = v0.xy + r3.xy;
            r7.xz = -previous_m_sRolling.m_vOffset.xy + r7.xz;
            r7.xz = previous_m_sRolling.m_fNoiseSize * r7.xz;
            r3.w = 5 * previous_m_sRolling.m_fNoisePeriod;
            r3.w = dot(r7.xz, r3.ww);
            r5.w = previous_m_sRolling.m_fNoiseTurbulence;
            r6.w = 0;
            while (true)
            {
                r7.w = cmp(r5.w < 1);
                if (r7.w != 0)
                    break;
                r8.xy = r7.xz / r5.ww;
                r8.xy = frac(r8.xy);
                r8.xyzw = PerlinNoiseKernel.SampleLevel(samStandard_s, r8.xy, 0).xyzw;
                r7.w = dot(r8.xyzw, float4(0.25, 0.25, 0.25, 0.25));
                r6.w = r7.w * r5.w + r6.w;
                r5.w = 0.5 * r5.w;
            }
            r5.w = 0.5 * r6.w;
            r5.w = r5.w / previous_m_sRolling.m_fNoiseTurbulence;
            r3.w = previous_m_sRolling.m_fNoiseTwist * r5.w + r3.w;
            r3.w = 3.14159274 * r3.w;
            r3.w = sin(r3.w);
            r3.w = 1 + -abs(r3.w);
            r5.w = 1 + -previous_m_sRolling.m_fLeafRippleMin;
            r8.x = r3.w * r5.w + previous_m_sRolling.m_fLeafRippleMin;
            r5.w = 1 + -previous_m_sRolling.m_fLeafTumbleMin;
            r8.y = r3.w * r5.w + previous_m_sRolling.m_fLeafTumbleMin;
        }
        else
        {
            r8.xy = float2(1, 1);
        }
        r3.w = r8.x * r2.w;
        r5.w = previous_m_sLeaf1.m_fRippleTime + r0.w;
        r5.w = 0.5 + r5.w;
        r5.w = frac(r5.w);
        r5.w = r5.w * 2 + -1;
        r6.w = abs(r5.w) * abs(r5.w);
        r5.w = -abs(r5.w) * 2 + 3;
        r5.w = r6.w * r5.w + -0.5;
        r5.w = dot(r5.ww, previous_m_sLeaf1.m_fRippleDistance);
        r7.xzw = r5.www * r4.xyz;
        r7.xzw = r7.xzw * r3.www + r2.xyz;
        r8.xz = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[3].zw);
        r9.xyz = float3(0.0625, 1, 16) * v6.zzz;
        r9.xyz = frac(r9.xyz);
        r9.xyz = r9.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
        r9.xyz = r9.xyz * r5.www;
        r9.xyz = r9.xyz * r3.www + r2.xyz;
        r9.xyz = r8.zzz ? r9.xyz : r2.xyz;
        r7.xzw = r8.xxx ? r7.xzw : r9.xyz;
        if (r7.y != 0)
        {
            r8.xzw = float3(0.0625, 1, 16) * v6.yyy;
            r8.xzw = frac(r8.xzw);
            r8.xzw = r8.xzw * float3(2, 2, 2) + float3(-1, -1, -1);
            r2.w = r8.y * r2.w;
            r3.w = cmp(0.5 < m_avWindConfigFlags[4].y);
            r9.xyz = r3.xyz + r0.www;
            r9.xyz = float3(30.2999992, 30.2999992, 30.2999992) * r9.xyz;
            r9.xyz = frac(r9.xyz);
            r5.w = r9.x + r9.y;
            r5.w = r5.w + r9.z;
            r9.y = previous_m_sLeaf1.m_fTumbleTime + r5.w;
            r9.x = previous_m_sLeaf1.m_fTumbleTime * 0.75 + -r5.w;
            r9.xy = float2(0.5, 0.5) + r9.xy;
            r9.xy = frac(r9.xy);
            r9.xy = r9.xy * float2(2, 2) + float2(-1, -1);
            r9.zw = abs(r9.xy) * abs(r9.xy);
            r9.xy = -abs(r9.xy) * float2(2, 2) + float2(3, 3);
            r9.xy = r9.zw * r9.xy + float2(-0.5, -0.5);
            r9.xy = r9.xy + r9.xy;
            r10.xyz = r7.xzw + -r3.xyz;
            r6.w = dot(r10.xyz, r10.xyz);
            r6.w = sqrt(r6.w);
            r7.y = r9.x * r9.x + r9.y;
            r8.y = previous_m_sLeaf1.m_fTumbleTwist * r2.w;
            r7.y = r8.y * r7.y;
            sincos(r7.y, r11.x, r12.x);
            r7.y = 1 + -r12.x;
            r13.xyzw = r7.yyyy * r8.xxxz;
            r11.xyz = r11.xxx * r8.wxz;
            r14.xy = r13.zy * r8.wz + r11.zx;
            r15.xy = r13.xw * r8.xz + r12.xx;
            r14.z = r13.w * r8.w + -r11.y;
            r16.xy = r13.yz * r8.zw + -r11.xz;
            r16.z = r13.w * r8.w + r11.y;
            r8.y = r8.w * r8.w;
            r16.w = r8.y * r7.y + r12.x;
            r11.xyz = previous_m_vDirection.yzx * r8.wxz;
            r11.xyz = r8.zwx * previous_m_vDirection.zxy + -r11.xyz;
            r7.y = dot(previous_m_vDirection.xyz, r8.xzw);
            r7.y = max(-1, r7.y);
            r7.y = min(1, r7.y);
            r11.w = r11.z + r7.y;
            r8.x = dot(r11.xyw, r11.xyw);
            r8.x = rsqrt(r8.x);
            r8.xyz = r11.wxy * r8.xxx;
            r8.w = 1 + -abs(r7.y);
            r8.w = sqrt(r8.w);
            r9.z = abs(r7.y) * -0.0187292993 + 0.0742610022;
            r9.z = r9.z * abs(r7.y) + -0.212114394;
            r9.z = r9.z * abs(r7.y) + 1.57072878;
            r9.w = r9.z * r8.w;
            r9.w = r9.w * -2 + 3.14159274;
            r7.y = cmp(r7.y < -r7.y);
            r7.y = r7.y ? r9.w : 0;
            r7.y = r9.z * r8.w + r7.y;
            r8.w = -r9.y * r9.y + r9.x;
            r5.w = previous_m_sLeaf1.m_fTwitchTime + r5.w;
            r9.x = r0.w * r0.w + r5.w;
            r9.y = r5.w * 0.870000005 + r0.w;
            r9.xy = float2(0.5, 0.5) + r9.xy;
            r9.xy = frac(r9.xy);
            r9.xy = r9.xy * float2(2, 2) + float2(-1, -1);
            r9.zw = abs(r9.xy) * abs(r9.xy);
            r9.xy = -abs(r9.xy) * float2(2, 2) + float2(3, 3);
            r9.xy = r9.zw * r9.xy + float2(-0.5, -0.5);
            r9.xy = r9.xy + r9.xy;
            r0.w = r9.y * r9.y;
            r0.w = r0.w * r9.x + 1;
            r0.w = saturate(0.5 * r0.w);
            r0.w = log2(r0.w);
            r0.w = previous_m_sLeaf1.m_fTwitchSharpness * r0.w;
            r0.w = exp2(r0.w);
            r0.w = previous_m_sLeaf1.m_fTwitchThrow * r0.w;
            r0.w = r3.w ? r0.w : 0;
            r3.w = previous_m_sLeaf1.m_fTumbleFlip * r8.w;
            r3.w = r7.y * previous_m_sLeaf1.m_fTumbleDirectionAdherence + r3.w;
            r0.w = r3.w + r0.w;
            r0.w = r2.w * r0.w;
            sincos(r0.w, r9.x, r11.x);
            r0.w = 1 + -r11.x;
            r12.xyzw = r0.wwww * r8.yyyz;
            r9.xyz = r9.xxx * r8.xyz;
            r13.xy = r12.zy * r8.xz + r9.zx;
            r17.xy = r12.xw * r8.yz + r11.xx;
            r13.z = r12.w * r8.x + -r9.y;
            r18.xy = r12.yz * r8.zx + -r9.xz;
            r18.z = r12.w * r8.x + r9.y;
            r2.w = r8.x * r8.x;
            r13.w = r2.w * r0.w + r11.x;
            r15.z = r16.x;
            r15.w = r14.x;
            r17.z = r13.y;
            r17.w = r18.y;
            r8.x = dot(r15.xzw, r17.xzw);
            r18.w = r17.y;
            r8.y = dot(r15.xwz, r18.xzw);
            r8.z = dot(r15.xzw, r13.xzw);
            r14.w = r15.y;
            r9.x = dot(r14.ywz, r17.xzw);
            r9.y = dot(r14.yzw, r18.xzw);
            r9.z = dot(r14.ywz, r13.xzw);
            r11.x = dot(r16.yzw, r17.xzw);
            r11.y = dot(r16.ywz, r18.xzw);
            r11.z = dot(r16.yzw, r13.xzw);
            r12.x = dot(r8.xyz, r4.xyz);
            r12.y = dot(r9.xyz, r4.xyz);
            r12.z = dot(r11.xyz, r4.xyz);
            r8.x = dot(r8.xyz, r10.xyz);
            r8.y = dot(r9.xyz, r10.xyz);
            r8.z = dot(r11.xyz, r10.xyz);
            r0.w = dot(r8.xyz, r8.xyz);
            r0.w = rsqrt(r0.w);
            r8.xyz = r8.xyz * r0.www;
            r7.xzw = r8.xyz * r6.www + r3.xyz;
            r4.xyz = r12.xyz;
        }
        r6.xyz = r7.xzw + -r2.xyz;
    }
    r0.w = cmp(0.5 < m_avWindLodFlags[0].w);
    if (r0.w != 0)
    {
        r3.xyz = r1.xyz * r1.www + r2.xyz;
    }
    else
    {
        r0.w = cmp(0.5 < m_avWindLodFlags[1].x);
        if (r0.w != 0)
        {
            r7.xyz = r5.xyz + r1.xyz;
            r3.xyz = r7.xyz * r1.www + r2.xyz;
        }
        else
        {
            r0.w = cmp(0.5 < m_avWindLodFlags[1].y);
            if (r0.w != 0)
            {
                r7.xyz = r5.xyz + r1.xyz;
                r7.xyz = r7.xyz + r6.xyz;
                r3.xyz = r7.xyz * r1.www + r2.xyz;
            }
            else
            {
                r0.w = cmp(0.5 < m_avWindLodFlags[1].z);
                if (r0.w != 0)
                {
                    r7.xyz = r5.xyz * r1.www + r1.xyz;
                    r3.xyz = r7.xyz + r2.xyz;
                }
                else
                {
                    r0.w = cmp(0.5 < m_avWindLodFlags[1].w);
                    r7.xyz = r6.xyz + r5.xyz;
                    r7.xyz = r7.xyz * r1.www + r1.xyz;
                    r7.xyz = r7.xyz + r2.xyz;
                    r2.w = cmp(0.5 < m_avWindLodFlags[2].x);
                    r5.xyz = r5.xyz + r1.xyz;
                    r8.xyz = r6.xyz * r1.www + r5.xyz;
                    r8.xyz = r8.xyz + r2.xyz;
                    r1.xyz = r2.xyz + r1.xyz;
                    r9.xyz = r5.xyz + r2.xyz;
                    r10.xyz = cmp(float3(0.5, 0.5, 0.5) < m_avWindLodFlags[0].xyz);
                    r5.xyz = r5.xyz + r6.xyz;
                    r5.xyz = r5.xyz + r2.xyz;
                    r2.xyz = r10.zzz ? r5.xyz : r2.xyz;
                    r2.xyz = r10.yyy ? r9.xyz : r2.xyz;
                    r1.xyz = r10.xxx ? r1.xyz : r2.xyz;
                    r1.xyz = r2.www ? r8.xyz : r1.xyz;
                    r3.xyz = r0.www ? r7.xyz : r1.xyz;
                }
            }
        }
    }
    r1.xyz = r3.xyz * v0.www + v0.xyz;
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
    float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18;

    r0.xyz = v8.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
    r1.xyz = v9.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
    r0.w = floor(v1.w);
    r1.w = v1.w + -r0.w;
    r1.w = 1.33333337 * r1.w;
    o7.x = 0.00392156886 * r0.w;
    r0.w = v3.x + v3.y;
    r2.x = cmp(0.5 < m_avEffectConfigFlags[2].z);
    r3.x = v3.w;
    r3.yz = v4.zw;
    r2.yzw = v3.xyz + -r3.xyz;
    r2.yzw = r1.www * r2.yzw + r3.xyz;
    r2.xyz = r2.xxx ? r2.yzw : v3.xyz;
    r3.xyz = v2.yzx * v1.zxy;
    r3.xyz = v1.yzx * v2.zxy + -r3.xyz;
    r2.w = dot(r3.xyz, r3.xyz);
    r2.w = rsqrt(r2.w);
    r3.xyz = r3.xyz * r2.www;
    r4.xyz = r3.xyz * r2.yyy;
    r2.xyw = v2.xyz * r2.xxx + r4.xyz;
    r2.xyz = v1.xyz * r2.zzz + r2.xyw;
    r4.xyz = r3.xyz * r0.yyy;
    r4.xyz = v2.xyz * r0.xxx + r4.xyz;
    r4.xyz = v1.xyz * r0.zzz + r4.xyz;
    r5.xyz = r3.xyz * r1.yyy;
    r5.xyz = v2.xyz * r1.xxx + r5.xyz;
    o3.xyz = v1.xyz * r1.zzz + r5.xyz;
    r1.x = cmp(0.5 < m_avWindConfigFlags[0].x);
    r1.y = dot(r2.xyz, r2.xyz);
    r1.y = sqrt(r1.y);
    r1.z = 1 / m_sGlobal.m_fHeight;
    r1.z = -r1.z * 0.25 + r2.z;
    r1.z = max(0, r1.z);
    r1.z = m_sGlobal.m_fHeight * r1.z;
    r2.w = cmp(r1.z != 0.000000);
    r3.w = log2(abs(r1.z));
    r3.w = m_sGlobal.m_fHeightExponent * r3.w;
    r3.w = exp2(r3.w);
    r1.z = r2.w ? r3.w : r1.z;
    r5.x = m_sGlobal.m_fTime + v0.x;
    r5.y = m_sGlobal.m_fTime * 0.800000012 + v0.y;
    r5.xy = float2(0.5, 0.5) + r5.xy;
    r5.xy = frac(r5.xy);
    r5.xy = r5.xy * float2(2, 2) + float2(-1, -1);
    r5.zw = abs(r5.xy) * abs(r5.xy);
    r5.xy = -abs(r5.xy) * float2(2, 2) + float2(3, 3);
    r5.xy = r5.zw * r5.xy + float2(-0.5, -0.5);
    r5.xy = r5.xy + r5.xy;
    r2.w = r5.y * r5.y + r5.x;
    r3.w = m_sGlobal.m_fAdherence / m_sGlobal.m_fHeight;
    r2.w = m_sGlobal.m_fDistance * r2.w + r3.w;
    r1.z = r2.w * r1.z;
    r5.xy = m_vDirection.xy * r1.zz + r2.xy;
    r5.z = r2.z;
    r1.z = dot(r5.xyz, r5.xyz);
    r1.z = rsqrt(r1.z);
    r5.xyz = r5.xyz * r1.zzz;
    r5.xyz = r5.xyz * r1.yyy + -r2.xyz;
    r1.xyz = r1.xxx ? r5.xyz : 0;
    r2.w = cmp(0.5 < m_avWindLodFlags[2].w);
    if (r2.w != 0)
    {
        r2.w = cmp(0.5 < m_avWindConfigFlags[0].z);
        if (r2.w != 0)
        {
            r5.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[1].zw);
            r6.xyz = float3(0.0625, 1, 16) * v5.yyy;
            r6.xyz = frac(r6.xyz);
            r6.xyz = r6.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
            r6.xyz = v5.xxx * r6.xyz;
            r2.w = v0.x + v0.y;
            r2.w = m_sBranch1.m_fTime + r2.w;
            if (r5.y != 0)
            {
                r7.x = v5.y + r2.w;
                r7.y = r2.w * m_sBranch1.m_fTwitchFreqScale + v5.y;
                r3.w = m_sBranch1.m_fTwitchFreqScale * r7.x;
                r7.z = 0.5 * r3.w;
                r7.w = -v5.x + r7.x;
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
                r5.y = r5.y + -r3.w;
                r3.w = r5.z * r5.y + r3.w;
                r3.w = m_sBranch1.m_fTwitch * r3.w;
                r5.y = 1 + -m_fStrength;
                r5.z = 1 + -m_sBranch1.m_fTwitch;
                r5.z = r7.x * r5.z;
                r3.w = r3.w * r5.y + r5.z;
                r5.y = m_sBranch1.m_fWhip * r7.w;
                r5.y = r5.y * v5.x + 1;
                r5.y = r5.y * r3.w;
                r3.w = r5.x ? r5.y : r3.w;
            }
            else
            {
                r7.x = v5.y + r2.w;
                r7.y = r2.w * 0.68900001 + v5.y;
                r7.z = -v5.x + r7.x;
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
                r5.y = m_sBranch1.m_fWhip * r5.w;
                r5.y = r5.y * v5.x + 1;
                r5.y = r5.y * r2.w;
                r3.w = r5.x ? r5.y : r2.w;
            }
            r5.xyz = r6.xyz * r3.www;
            r5.xyz = r5.xyz * m_sBranch1.m_fDistance + r2.xyz;
        }
        else
        {
            r2.w = cmp(0.5 < m_avWindConfigFlags[0].w);
            if (r2.w != 0)
            {
                r6.xyz = cmp(float3(0.5, 0.5, 0.5) < m_avWindConfigFlags[1].zwy);
                r7.xyz = float3(0.0625, 1, 16) * v5.yyy;
                r7.xyz = frac(r7.xyz);
                r7.xyz = r7.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                r7.xyz = v5.xxx * r7.xyz;
                r2.w = v0.x + v0.y;
                r2.w = m_sBranch1.m_fTime + r2.w;
                if (r6.y != 0)
                {
                    r8.x = v5.y + r2.w;
                    r8.y = r2.w * m_sBranch1.m_fTwitchFreqScale + v5.y;
                    r3.w = m_sBranch1.m_fTwitchFreqScale * r8.x;
                    r8.z = 0.5 * r3.w;
                    r8.w = -v5.x + r8.x;
                    r9.xyzw = float4(0.5, 0.5, 0.5, 1.5) + r8.xyzw;
                    r9.xyzw = frac(r9.xyzw);
                    r9.xyzw = r9.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
                    r10.xyzw = abs(r9.xyzw) * abs(r9.xyzw);
                    r9.xyzw = -abs(r9.xyzw) * float4(2, 2, 2, 2) + float4(3, 3, 3, 3);
                    r9.xyzw = r10.xyzw * r9.xyzw + float4(-0.5, -0.5, -0.5, -0.5);
                    r9.xyzw = r9.xyzw + r9.xyzw;
                    r8.xyz = float3(0.5, 0.5, 0.5) + r8.xyz;
                    r8.xyz = frac(r8.xyz);
                    r8.xyz = r8.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                    r10.xyz = abs(r8.xyz) * abs(r8.xyz);
                    r8.xyz = -abs(r8.xyz) * float3(2, 2, 2) + float3(3, 3, 3);
                    r8.xyz = r10.xyz * r8.xyz;
                    r8.w = 0;
                    r8.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r8.xyzw;
                    r8.xyzw = r8.xyzw + r8.xyzw;
                    r8.xyzw = r6.xxxx ? r9.wxyz : r8.wxyz;
                    r9.w = r8.z * r8.w;
                    r3.w = cmp(r9.w < 0);
                    r9.y = -r9.w;
                    r9.xz = float2(-1, 1);
                    r6.yw = r3.ww ? r9.xy : r9.zw;
                    r3.w = -r8.z * r8.w + r6.y;
                    r3.w = r6.w * r3.w + r9.w;
                    r5.w = r6.y + -r3.w;
                    r3.w = r6.w * r5.w + r3.w;
                    r3.w = m_sBranch1.m_fTwitch * r3.w;
                    r5.w = 1 + -m_fStrength;
                    r6.y = 1 + -m_sBranch1.m_fTwitch;
                    r6.y = r8.y * r6.y;
                    r3.w = r3.w * r5.w + r6.y;
                    r5.w = m_sBranch1.m_fWhip * r8.x;
                    r5.w = r5.w * v5.x + 1;
                    r5.w = r5.w * r3.w;
                    r3.w = r6.x ? r5.w : r3.w;
                }
                else
                {
                    r9.x = v5.y + r2.w;
                    r9.y = r2.w * 0.68900001 + v5.y;
                    r9.z = -v5.x + r9.x;
                    r10.xyz = float3(0.5, 0.5, 1.5) + r9.xyz;
                    r10.xyz = frac(r10.xyz);
                    r10.xyz = r10.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                    r11.xyz = abs(r10.xyz) * abs(r10.xyz);
                    r10.xyz = -abs(r10.xyz) * float3(2, 2, 2) + float3(3, 3, 3);
                    r10.xyz = r11.xyz * r10.xyz + float3(-0.5, -0.5, -0.5);
                    r10.xyz = r10.xyz + r10.xyz;
                    r6.yw = float2(0.5, 0.5) + r9.xy;
                    r6.yw = frac(r6.yw);
                    r6.yw = r6.yw * float2(2, 2) + float2(-1, -1);
                    r9.xy = abs(r6.yw) * abs(r6.yw);
                    r6.yw = -abs(r6.yw) * float2(2, 2) + float2(3, 3);
                    r9.xy = r9.xy * r6.yw;
                    r9.z = 0;
                    r9.xyz = float3(-0.5, -0.5, -0.5) + r9.xyz;
                    r9.xyz = r9.xyz + r9.xyz;
                    r8.xyz = r6.xxx ? r10.zxy : r9.zxy;
                    r5.w = r8.z * r8.y + r8.y;
                    r6.y = m_sBranch1.m_fWhip * r8.x;
                    r6.y = r6.y * v5.x + 1;
                    r6.y = r6.y * r5.w;
                    r3.w = r6.x ? r6.y : r5.w;
                }
                r7.xyz = r7.xyz * r3.www;
                r7.xyz = r7.xyz * m_sBranch1.m_fDistance + r2.xyz;
                r9.x = r2.w * 0.100000001 + v5.y;
                r2.w = m_sBranch1.m_fTurbulence * m_fWallTime;
                r9.y = r2.w * 0.100000001 + v5.y;
                r6.yw = float2(0.5, 0.5) + r9.xy;
                r6.yw = frac(r6.yw);
                r6.yw = r6.yw * float2(2, 2) + float2(-1, -1);
                r8.yz = abs(r6.yw) * abs(r6.yw);
                r6.yw = -abs(r6.yw) * float2(2, 2) + float2(3, 3);
                r6.yw = r8.yz * r6.yw + float2(-0.5, -0.5);
                r6.yw = r6.yw + r6.yw;
                r6.yw = r6.yw * r6.yw;
                r2.w = r6.w * r6.y;
                r2.w = -r2.w * m_sBranch1.m_fTurbulence + 1;
                r2.w = r6.z ? r2.w : 1;
                r3.w = m_fStrength * r8.x;
                r3.w = r3.w * m_sBranch1.m_fWhip + r2.w;
                r2.w = r6.x ? r3.w : r2.w;
                r6.xyz = m_sBranch1.m_fDirectionAdherence * m_vDirection.xyz;
                r6.xyz = r6.xyz * r2.www;
                r5.xyz = r6.xyz * v5.xxx + r7.xyz;
            }
            else
            {
                r2.w = cmp(0.5 < m_avWindConfigFlags[1].x);
                if (r2.w != 0)
                {
                    r6.xyz = cmp(float3(0.5, 0.5, 0.5) < m_avWindConfigFlags[1].zwy);
                    r7.xyz = float3(0.0625, 1, 16) * v5.yyy;
                    r7.xyz = frac(r7.xyz);
                    r7.xyz = r7.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                    r7.xyz = v5.xxx * r7.xyz;
                    r2.w = v0.x + v0.y;
                    r2.w = m_sBranch1.m_fTime + r2.w;
                    if (r6.y != 0)
                    {
                        r8.x = v5.y + r2.w;
                        r8.y = r2.w * m_sBranch1.m_fTwitchFreqScale + v5.y;
                        r3.w = m_sBranch1.m_fTwitchFreqScale * r8.x;
                        r8.z = 0.5 * r3.w;
                        r8.w = -v5.x + r8.x;
                        r9.xyzw = float4(0.5, 0.5, 0.5, 1.5) + r8.xyzw;
                        r9.xyzw = frac(r9.xyzw);
                        r9.xyzw = r9.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
                        r10.xyzw = abs(r9.xyzw) * abs(r9.xyzw);
                        r9.xyzw = -abs(r9.xyzw) * float4(2, 2, 2, 2) + float4(3, 3, 3, 3);
                        r9.xyzw = r10.xyzw * r9.xyzw + float4(-0.5, -0.5, -0.5, -0.5);
                        r9.xyzw = r9.xyzw + r9.xyzw;
                        r8.xyz = float3(0.5, 0.5, 0.5) + r8.xyz;
                        r8.xyz = frac(r8.xyz);
                        r8.xyz = r8.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                        r10.xyz = abs(r8.xyz) * abs(r8.xyz);
                        r8.xyz = -abs(r8.xyz) * float3(2, 2, 2) + float3(3, 3, 3);
                        r8.xyz = r10.xyz * r8.xyz;
                        r8.w = 0;
                        r8.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r8.xyzw;
                        r8.xyzw = r8.xyzw + r8.xyzw;
                        r8.xyzw = r6.xxxx ? r9.wxyz : r8.wxyz;
                        r9.w = r8.z * r8.w;
                        r3.w = cmp(r9.w < 0);
                        r9.y = -r9.w;
                        r9.xz = float2(-1, 1);
                        r6.yw = r3.ww ? r9.xy : r9.zw;
                        r3.w = -r8.z * r8.w + r6.y;
                        r3.w = r6.w * r3.w + r9.w;
                        r5.w = r6.y + -r3.w;
                        r3.w = r6.w * r5.w + r3.w;
                        r3.w = m_sBranch1.m_fTwitch * r3.w;
                        r5.w = 1 + -m_fStrength;
                        r6.y = 1 + -m_sBranch1.m_fTwitch;
                        r6.y = r8.y * r6.y;
                        r3.w = r3.w * r5.w + r6.y;
                        r5.w = m_sBranch1.m_fWhip * r8.x;
                        r5.w = r5.w * v5.x + 1;
                        r5.w = r5.w * r3.w;
                        r3.w = r6.x ? r5.w : r3.w;
                    }
                    else
                    {
                        r9.x = v5.y + r2.w;
                        r9.y = r2.w * 0.68900001 + v5.y;
                        r9.z = -v5.x + r9.x;
                        r10.xyz = float3(0.5, 0.5, 1.5) + r9.xyz;
                        r10.xyz = frac(r10.xyz);
                        r10.xyz = r10.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                        r11.xyz = abs(r10.xyz) * abs(r10.xyz);
                        r10.xyz = -abs(r10.xyz) * float3(2, 2, 2) + float3(3, 3, 3);
                        r10.xyz = r11.xyz * r10.xyz + float3(-0.5, -0.5, -0.5);
                        r10.xyz = r10.xyz + r10.xyz;
                        r6.yw = float2(0.5, 0.5) + r9.xy;
                        r6.yw = frac(r6.yw);
                        r6.yw = r6.yw * float2(2, 2) + float2(-1, -1);
                        r9.xy = abs(r6.yw) * abs(r6.yw);
                        r6.yw = -abs(r6.yw) * float2(2, 2) + float2(3, 3);
                        r9.xy = r9.xy * r6.yw;
                        r9.z = 0;
                        r9.xyz = float3(-0.5, -0.5, -0.5) + r9.xyz;
                        r9.xyz = r9.xyz + r9.xyz;
                        r8.xyz = r6.xxx ? r10.zxy : r9.zxy;
                        r5.w = r8.z * r8.y + r8.y;
                        r6.y = m_sBranch1.m_fWhip * r8.x;
                        r6.y = r6.y * v5.x + 1;
                        r6.y = r6.y * r5.w;
                        r3.w = r6.x ? r6.y : r5.w;
                    }
                    r7.xyz = r7.xyz * r3.www;
                    r7.xyz = r7.xyz * m_sBranch1.m_fDistance + r2.xyz;
                    r9.x = r2.w * 0.100000001 + v5.y;
                    r2.w = m_sBranch1.m_fTurbulence * m_fWallTime;
                    r9.y = r2.w * 0.100000001 + v5.y;
                    r6.yw = float2(0.5, 0.5) + r9.xy;
                    r6.yw = frac(r6.yw);
                    r6.yw = r6.yw * float2(2, 2) + float2(-1, -1);
                    r8.yz = abs(r6.yw) * abs(r6.yw);
                    r6.yw = -abs(r6.yw) * float2(2, 2) + float2(3, 3);
                    r6.yw = r8.yz * r6.yw + float2(-0.5, -0.5);
                    r6.yw = r6.yw + r6.yw;
                    r6.yw = r6.yw * r6.yw;
                    r2.w = r6.w * r6.y;
                    r2.w = -r2.w * m_sBranch1.m_fTurbulence + 1;
                    r2.w = r6.z ? r2.w : 1;
                    r3.w = m_fStrength * r8.x;
                    r3.w = r3.w * m_sBranch1.m_fWhip + r2.w;
                    r2.w = r6.x ? r3.w : r2.w;
                    r6.xyz = m_vAnchor.xyz + -r7.xyz;
                    r6.xyz = m_sBranch1.m_fDirectionAdherence * r6.xyz;
                    r6.xyz = r6.xyz * r2.www;
                    r5.xyz = r6.xyz * v5.xxx + r7.xyz;
                }
                else
                {
                    r5.xyz = r2.xyz;
                }
            }
        }
        r2.w = cmp(0.5 < m_avWindConfigFlags[2].x);
        if (r2.w != 0)
        {
            r6.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[3].xy);
            r7.xyz = float3(0.0625, 1, 16) * v5.www;
            r7.xyz = frac(r7.xyz);
            r7.xyz = r7.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
            r7.xyz = v5.zzz * r7.xyz;
            r2.w = v0.x + v0.y;
            r2.w = m_sBranch2.m_fTime + r2.w;
            if (r6.y != 0)
            {
                r8.x = v5.w + r2.w;
                r8.y = r2.w * m_sBranch2.m_fTwitchFreqScale + v5.w;
                r3.w = m_sBranch2.m_fTwitchFreqScale * r8.x;
                r8.z = 0.5 * r3.w;
                r8.w = -v5.z + r8.x;
                r9.xyzw = float4(0.5, 0.5, 0.5, 1.5) + r8.xyzw;
                r9.xyzw = frac(r9.xyzw);
                r9.xyzw = r9.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
                r10.xyzw = abs(r9.xyzw) * abs(r9.xyzw);
                r9.xyzw = -abs(r9.xyzw) * float4(2, 2, 2, 2) + float4(3, 3, 3, 3);
                r9.xyzw = r10.xyzw * r9.xyzw + float4(-0.5, -0.5, -0.5, -0.5);
                r9.xyzw = r9.xyzw + r9.xyzw;
                r6.yzw = float3(0.5, 0.5, 0.5) + r8.xyz;
                r6.yzw = frac(r6.yzw);
                r6.yzw = r6.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
                r8.xyz = abs(r6.yzw) * abs(r6.yzw);
                r6.yzw = -abs(r6.yzw) * float3(2, 2, 2) + float3(3, 3, 3);
                r8.xyz = r8.xyz * r6.yzw;
                r8.w = 0;
                r8.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r8.xyzw;
                r8.xyzw = r8.xyzw + r8.xyzw;
                r8.xyzw = r6.xxxx ? r9.xyzw : r8.xyzw;
                r9.w = r8.y * r8.z;
                r3.w = cmp(r9.w < 0);
                r9.y = -r9.w;
                r9.xz = float2(-1, 1);
                r6.yz = r3.ww ? r9.xy : r9.zw;
                r3.w = -r8.y * r8.z + r6.y;
                r3.w = r6.z * r3.w + r9.w;
                r5.w = r6.y + -r3.w;
                r3.w = r6.z * r5.w + r3.w;
                r3.w = m_sBranch2.m_fTwitch * r3.w;
                r5.w = 1 + -m_fStrength;
                r6.y = 1 + -m_sBranch2.m_fTwitch;
                r6.y = r8.x * r6.y;
                r3.w = r3.w * r5.w + r6.y;
                r5.w = m_sBranch2.m_fWhip * r8.w;
                r5.w = r5.w * v5.z + 1;
                r5.w = r5.w * r3.w;
                r3.w = r6.x ? r5.w : r3.w;
            }
            else
            {
                r8.x = v5.w + r2.w;
                r8.y = r2.w * 0.68900001 + v5.w;
                r8.z = -v5.z + r8.x;
                r6.yzw = float3(0.5, 0.5, 1.5) + r8.xyz;
                r6.yzw = frac(r6.yzw);
                r6.yzw = r6.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
                r9.xyz = abs(r6.yzw) * abs(r6.yzw);
                r6.yzw = -abs(r6.yzw) * float3(2, 2, 2) + float3(3, 3, 3);
                r6.yzw = r9.xyz * r6.yzw + float3(-0.5, -0.5, -0.5);
                r6.yzw = r6.yzw + r6.yzw;
                r8.xy = float2(0.5, 0.5) + r8.xy;
                r8.xy = frac(r8.xy);
                r8.xy = r8.xy * float2(2, 2) + float2(-1, -1);
                r8.zw = abs(r8.xy) * abs(r8.xy);
                r8.xy = -abs(r8.xy) * float2(2, 2) + float2(3, 3);
                r8.xy = r8.zw * r8.xy;
                r8.z = 0;
                r8.xyz = float3(-0.5, -0.5, -0.5) + r8.xyz;
                r8.xyz = r8.xyz + r8.xyz;
                r6.yzw = r6.xxx ? r6.yzw : r8.xyz;
                r2.w = r6.z * r6.y + r6.y;
                r5.w = m_sBranch2.m_fWhip * r6.w;
                r5.w = r5.w * v5.z + 1;
                r5.w = r5.w * r2.w;
                r3.w = r6.x ? r5.w : r2.w;
            }
            r6.xyz = r7.xyz * r3.www;
            r5.xyz = r6.xyz * m_sBranch2.m_fDistance + r5.xyz;
        }
        else
        {
            r2.w = cmp(0.5 < m_avWindConfigFlags[2].y);
            if (r2.w != 0)
            {
                r6.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[3].xy);
                r2.w = cmp(0.5 < m_avWindConfigFlags[2].w);
                r7.xyz = float3(0.0625, 1, 16) * v5.www;
                r7.xyz = frac(r7.xyz);
                r7.xyz = r7.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                r7.xyz = v5.zzz * r7.xyz;
                r3.w = v0.x + v0.y;
                r3.w = m_sBranch2.m_fTime + r3.w;
                if (r6.y != 0)
                {
                    r8.x = v5.w + r3.w;
                    r8.y = r3.w * m_sBranch2.m_fTwitchFreqScale + v5.w;
                    r5.w = m_sBranch2.m_fTwitchFreqScale * r8.x;
                    r8.z = 0.5 * r5.w;
                    r8.w = -v5.z + r8.x;
                    r9.xyzw = float4(0.5, 0.5, 0.5, 1.5) + r8.xyzw;
                    r9.xyzw = frac(r9.xyzw);
                    r9.xyzw = r9.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
                    r10.xyzw = abs(r9.xyzw) * abs(r9.xyzw);
                    r9.xyzw = -abs(r9.xyzw) * float4(2, 2, 2, 2) + float4(3, 3, 3, 3);
                    r9.xyzw = r10.xyzw * r9.xyzw + float4(-0.5, -0.5, -0.5, -0.5);
                    r9.xyzw = r9.xyzw + r9.xyzw;
                    r6.yzw = float3(0.5, 0.5, 0.5) + r8.xyz;
                    r6.yzw = frac(r6.yzw);
                    r6.yzw = r6.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
                    r8.xyz = abs(r6.yzw) * abs(r6.yzw);
                    r6.yzw = -abs(r6.yzw) * float3(2, 2, 2) + float3(3, 3, 3);
                    r8.xyz = r8.xyz * r6.yzw;
                    r8.w = 0;
                    r8.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r8.xyzw;
                    r8.xyzw = r8.xyzw + r8.xyzw;
                    r8.xyzw = r6.xxxx ? r9.wxyz : r8.wxyz;
                    r9.w = r8.z * r8.w;
                    r5.w = cmp(r9.w < 0);
                    r9.y = -r9.w;
                    r9.xz = float2(-1, 1);
                    r6.yz = r5.ww ? r9.xy : r9.zw;
                    r5.w = -r8.z * r8.w + r6.y;
                    r5.w = r6.z * r5.w + r9.w;
                    r6.y = r6.y + -r5.w;
                    r5.w = r6.z * r6.y + r5.w;
                    r5.w = m_sBranch2.m_fTwitch * r5.w;
                    r6.y = 1 + -m_fStrength;
                    r6.z = 1 + -m_sBranch2.m_fTwitch;
                    r6.z = r8.y * r6.z;
                    r5.w = r5.w * r6.y + r6.z;
                    r6.y = m_sBranch2.m_fWhip * r8.x;
                    r6.y = r6.y * v5.z + 1;
                    r6.y = r6.y * r5.w;
                    r5.w = r6.x ? r6.y : r5.w;
                }
                else
                {
                    r9.x = v5.w + r3.w;
                    r9.y = r3.w * 0.68900001 + v5.w;
                    r9.z = -v5.z + r9.x;
                    r6.yzw = float3(0.5, 0.5, 1.5) + r9.xyz;
                    r6.yzw = frac(r6.yzw);
                    r6.yzw = r6.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
                    r10.xyz = abs(r6.yzw) * abs(r6.yzw);
                    r6.yzw = -abs(r6.yzw) * float3(2, 2, 2) + float3(3, 3, 3);
                    r6.yzw = r10.xyz * r6.yzw + float3(-0.5, -0.5, -0.5);
                    r6.yzw = r6.yzw + r6.yzw;
                    r9.xy = float2(0.5, 0.5) + r9.xy;
                    r9.xy = frac(r9.xy);
                    r9.xy = r9.xy * float2(2, 2) + float2(-1, -1);
                    r9.zw = abs(r9.xy) * abs(r9.xy);
                    r9.xy = -abs(r9.xy) * float2(2, 2) + float2(3, 3);
                    r9.xy = r9.zw * r9.xy;
                    r9.z = 0;
                    r9.xyz = float3(-0.5, -0.5, -0.5) + r9.xyz;
                    r9.xyz = r9.xyz + r9.xyz;
                    r8.xyz = r6.xxx ? r6.wyz : r9.zxy;
                    r6.y = r8.z * r8.y + r8.y;
                    r6.z = m_sBranch2.m_fWhip * r8.x;
                    r6.z = r6.z * v5.z + 1;
                    r6.z = r6.y * r6.z;
                    r5.w = r6.x ? r6.z : r6.y;
                }
                r6.yzw = r7.xyz * r5.www;
                r6.yzw = r6.yzw * m_sBranch2.m_fDistance + r5.xyz;
                r7.x = r3.w * 0.100000001 + v5.w;
                r3.w = m_sBranch2.m_fTurbulence * m_fWallTime;
                r7.y = r3.w * 0.100000001 + v5.w;
                r7.xy = float2(0.5, 0.5) + r7.xy;
                r7.xy = frac(r7.xy);
                r7.xy = r7.xy * float2(2, 2) + float2(-1, -1);
                r7.zw = abs(r7.xy) * abs(r7.xy);
                r7.xy = -abs(r7.xy) * float2(2, 2) + float2(3, 3);
                r7.xy = r7.zw * r7.xy + float2(-0.5, -0.5);
                r7.xy = r7.xy + r7.xy;
                r7.xy = r7.xy * r7.xy;
                r3.w = r7.y * r7.x;
                r3.w = -r3.w * m_sBranch2.m_fTurbulence + 1;
                r2.w = r2.w ? r3.w : 1;
                r3.w = m_fStrength * r8.x;
                r3.w = r3.w * m_sBranch2.m_fWhip + r2.w;
                r2.w = r6.x ? r3.w : r2.w;
                r7.xyz = m_sBranch2.m_fDirectionAdherence * m_vDirection.xyz;
                r7.xyz = r7.xyz * r2.www;
                r5.xyz = r7.xyz * v5.zzz + r6.yzw;
            }
            else
            {
                r2.w = cmp(0.5 < m_avWindConfigFlags[2].z);
                if (r2.w != 0)
                {
                    r6.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[3].xy);
                    r2.w = cmp(0.5 < m_avWindConfigFlags[2].w);
                    r7.xyz = float3(0.0625, 1, 16) * v5.www;
                    r7.xyz = frac(r7.xyz);
                    r7.xyz = r7.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                    r7.xyz = v5.zzz * r7.xyz;
                    r3.w = v0.x + v0.y;
                    r3.w = m_sBranch2.m_fTime + r3.w;
                    if (r6.y != 0)
                    {
                        r8.x = v5.w + r3.w;
                        r8.y = r3.w * m_sBranch2.m_fTwitchFreqScale + v5.w;
                        r5.w = m_sBranch2.m_fTwitchFreqScale * r8.x;
                        r8.z = 0.5 * r5.w;
                        r8.w = -v5.z + r8.x;
                        r9.xyzw = float4(0.5, 0.5, 0.5, 1.5) + r8.xyzw;
                        r9.xyzw = frac(r9.xyzw);
                        r9.xyzw = r9.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
                        r10.xyzw = abs(r9.xyzw) * abs(r9.xyzw);
                        r9.xyzw = -abs(r9.xyzw) * float4(2, 2, 2, 2) + float4(3, 3, 3, 3);
                        r9.xyzw = r10.xyzw * r9.xyzw + float4(-0.5, -0.5, -0.5, -0.5);
                        r9.xyzw = r9.xyzw + r9.xyzw;
                        r6.yzw = float3(0.5, 0.5, 0.5) + r8.xyz;
                        r6.yzw = frac(r6.yzw);
                        r6.yzw = r6.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
                        r8.xyz = abs(r6.yzw) * abs(r6.yzw);
                        r6.yzw = -abs(r6.yzw) * float3(2, 2, 2) + float3(3, 3, 3);
                        r8.xyz = r8.xyz * r6.yzw;
                        r8.w = 0;
                        r8.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r8.xyzw;
                        r8.xyzw = r8.xyzw + r8.xyzw;
                        r8.xyzw = r6.xxxx ? r9.wxyz : r8.wxyz;
                        r9.w = r8.z * r8.w;
                        r5.w = cmp(r9.w < 0);
                        r9.y = -r9.w;
                        r9.xz = float2(-1, 1);
                        r6.yz = r5.ww ? r9.xy : r9.zw;
                        r5.w = -r8.z * r8.w + r6.y;
                        r5.w = r6.z * r5.w + r9.w;
                        r6.y = r6.y + -r5.w;
                        r5.w = r6.z * r6.y + r5.w;
                        r5.w = m_sBranch2.m_fTwitch * r5.w;
                        r6.y = 1 + -m_fStrength;
                        r6.z = 1 + -m_sBranch2.m_fTwitch;
                        r6.z = r8.y * r6.z;
                        r5.w = r5.w * r6.y + r6.z;
                        r6.y = m_sBranch2.m_fWhip * r8.x;
                        r6.y = r6.y * v5.z + 1;
                        r6.y = r6.y * r5.w;
                        r5.w = r6.x ? r6.y : r5.w;
                    }
                    else
                    {
                        r9.x = v5.w + r3.w;
                        r9.y = r3.w * 0.68900001 + v5.w;
                        r9.z = -v5.z + r9.x;
                        r6.yzw = float3(0.5, 0.5, 1.5) + r9.xyz;
                        r6.yzw = frac(r6.yzw);
                        r6.yzw = r6.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
                        r10.xyz = abs(r6.yzw) * abs(r6.yzw);
                        r6.yzw = -abs(r6.yzw) * float3(2, 2, 2) + float3(3, 3, 3);
                        r6.yzw = r10.xyz * r6.yzw + float3(-0.5, -0.5, -0.5);
                        r6.yzw = r6.yzw + r6.yzw;
                        r9.xy = float2(0.5, 0.5) + r9.xy;
                        r9.xy = frac(r9.xy);
                        r9.xy = r9.xy * float2(2, 2) + float2(-1, -1);
                        r9.zw = abs(r9.xy) * abs(r9.xy);
                        r9.xy = -abs(r9.xy) * float2(2, 2) + float2(3, 3);
                        r9.xy = r9.zw * r9.xy;
                        r9.z = 0;
                        r9.xyz = float3(-0.5, -0.5, -0.5) + r9.xyz;
                        r9.xyz = r9.xyz + r9.xyz;
                        r8.xyz = r6.xxx ? r6.wyz : r9.zxy;
                        r6.y = r8.z * r8.y + r8.y;
                        r6.z = m_sBranch2.m_fWhip * r8.x;
                        r6.z = r6.z * v5.z + 1;
                        r6.z = r6.y * r6.z;
                        r5.w = r6.x ? r6.z : r6.y;
                    }
                    r6.yzw = r7.xyz * r5.www;
                    r6.yzw = r6.yzw * m_sBranch2.m_fDistance + r5.xyz;
                    r7.x = r3.w * 0.100000001 + v5.w;
                    r3.w = m_sBranch2.m_fTurbulence * m_fWallTime;
                    r7.y = r3.w * 0.100000001 + v5.w;
                    r7.xy = float2(0.5, 0.5) + r7.xy;
                    r7.xy = frac(r7.xy);
                    r7.xy = r7.xy * float2(2, 2) + float2(-1, -1);
                    r7.zw = abs(r7.xy) * abs(r7.xy);
                    r7.xy = -abs(r7.xy) * float2(2, 2) + float2(3, 3);
                    r7.xy = r7.zw * r7.xy + float2(-0.5, -0.5);
                    r7.xy = r7.xy + r7.xy;
                    r7.xy = r7.xy * r7.xy;
                    r3.w = r7.y * r7.x;
                    r3.w = -r3.w * m_sBranch2.m_fTurbulence + 1;
                    r2.w = r2.w ? r3.w : 1;
                    r3.w = m_fStrength * r8.x;
                    r3.w = r3.w * m_sBranch2.m_fWhip + r2.w;
                    r2.w = r6.x ? r3.w : r2.w;
                    r7.xyz = m_vAnchor.xyz + -r6.yzw;
                    r7.xyz = m_sBranch2.m_fDirectionAdherence * r7.xyz;
                    r7.xyz = r7.xyz * r2.www;
                    r5.xyz = r7.xyz * v5.zzz + r6.yzw;
                }
            }
        }
        r5.xyz = r5.xyz + -r2.xyz;
    }
    else
    {
        r5.xyz = float3(0, 0, 0);
    }
    r3.xyz = v7.yyy * r3.xyz;
    r3.xyz = v2.xyz * v7.xxx + r3.xyz;
    r3.xyz = v1.xyz * v7.zzz + r3.xyz;
    r2.w = cmp(0 < v6.w);
    if (r2.w != 0)
    {
        r6.xyz = cmp(float3(0.5, 0.5, 0.5) < m_avWindConfigFlags[5].wxy);
        r2.w = dot(r3.xy, r3.xy);
        r2.w = rsqrt(r2.w);
        r7.xy = r3.xy * r2.ww;
        r2.w = dot(-r7.xy, m_vDirection.xy);
        r2.w = 1 + r2.w;
        r2.w = 0.5 * r2.w;
        r3.w = 1 + -m_sLeaf2.m_fLeewardScalar;
        r2.w = r2.w * r3.w + m_sLeaf2.m_fLeewardScalar;
        r2.w = v6.x * r2.w;
        r2.w = r6.x ? r2.w : v6.x;
        r3.w = cmp(0.5 < m_avWindConfigFlags[6].w);
        if (r3.w != 0)
        {
            r6.xw = v0.xy + r3.xy;
            r6.xw = -m_sRolling.m_vOffset.xy + r6.xw;
            r6.xw = m_sRolling.m_fNoiseSize * r6.xw;
            r3.w = 5 * m_sRolling.m_fNoisePeriod;
            r3.w = dot(r6.xw, r3.ww);
            r5.w = m_sRolling.m_fNoiseTurbulence;
            r7.x = 0;
            while (true)
            {
                r7.y = cmp(r5.w < 1);
                if (r7.y != 0)
                    break;
                r7.yz = r6.xw / r5.ww;
                r7.yz = frac(r7.yz);
                r8.xyzw = PerlinNoiseKernel.SampleLevel(samStandard_s, r7.yz, 0).xyzw;
                r7.y = dot(r8.xyzw, float4(0.25, 0.25, 0.25, 0.25));
                r7.x = r7.y * r5.w + r7.x;
                r5.w = 0.5 * r5.w;
            }
            r5.w = 0.5 * r7.x;
            r5.w = r5.w / m_sRolling.m_fNoiseTurbulence;
            r3.w = m_sRolling.m_fNoiseTwist * r5.w + r3.w;
            r3.w = 3.14159274 * r3.w;
            r3.w = sin(r3.w);
            r3.w = 1 + -abs(r3.w);
            r5.w = 1 + -m_sRolling.m_fLeafRippleMin;
            r7.x = r3.w * r5.w + m_sRolling.m_fLeafRippleMin;
            r5.w = 1 + -m_sRolling.m_fLeafTumbleMin;
            r7.y = r3.w * r5.w + m_sRolling.m_fLeafTumbleMin;
        }
        else
        {
            r7.xy = float2(1, 1);
        }
        r3.w = cmp(0.5 < m_avWindConfigFlags[4].w);
        r5.w = r7.x * r2.w;
        r6.x = m_sLeaf2.m_fRippleTime + r0.w;
        r6.x = 0.5 + r6.x;
        r6.x = frac(r6.x);
        r6.x = r6.x * 2 + -1;
        r6.w = abs(r6.x) * abs(r6.x);
        r6.x = -abs(r6.x) * 2 + 3;
        r6.x = r6.w * r6.x + -0.5;
        r6.x = dot(r6.xx, m_sLeaf2.m_fRippleDistance);
        r7.xzw = r6.xxx * r4.xyz;
        r7.xzw = r7.xzw * r5.www + r2.xyz;
        r8.xyz = float3(0.0625, 1, 16) * v6.zzz;
        r8.xyz = frac(r8.xyz);
        r8.xyz = r8.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
        r8.xyz = r8.xyz * r6.xxx;
        r8.xyz = r8.xyz * r5.www + r2.xyz;
        r6.xyw = r6.yyy ? r8.xyz : r2.xyz;
        r6.xyw = r3.www ? r7.xzw : r6.xyw;
        if (r6.z != 0)
        {
            r7.xzw = float3(0.0625, 1, 16) * v6.yyy;
            r7.xzw = frac(r7.xzw);
            r7.xzw = r7.xzw * float3(2, 2, 2) + float3(-1, -1, -1);
            r2.w = r7.y * r2.w;
            r3.w = cmp(0.5 < m_avWindConfigFlags[5].z);
            r8.xyz = r3.xyz + r0.www;
            r8.xyz = float3(30.2999992, 30.2999992, 30.2999992) * r8.xyz;
            r8.xyz = frac(r8.xyz);
            r5.w = r8.x + r8.y;
            r5.w = r5.w + r8.z;
            r8.y = m_sLeaf2.m_fTumbleTime + r5.w;
            r8.x = m_sLeaf2.m_fTumbleTime * 0.75 + -r5.w;
            r8.xy = float2(0.5, 0.5) + r8.xy;
            r8.xy = frac(r8.xy);
            r8.xy = r8.xy * float2(2, 2) + float2(-1, -1);
            r8.zw = abs(r8.xy) * abs(r8.xy);
            r8.xy = -abs(r8.xy) * float2(2, 2) + float2(3, 3);
            r8.xy = r8.zw * r8.xy + float2(-0.5, -0.5);
            r8.xy = r8.xy + r8.xy;
            r9.xyz = r6.xyw + -r3.xyz;
            r6.z = dot(r9.xyz, r9.xyz);
            r6.z = sqrt(r6.z);
            r7.y = r8.x * r8.x + r8.y;
            r8.z = m_sLeaf2.m_fTumbleTwist * r2.w;
            r7.y = r8.z * r7.y;
            sincos(r7.y, r10.x, r11.x);
            r7.y = 1 + -r11.x;
            r12.xyzw = r7.yyyy * r7.xxxz;
            r10.xyz = r10.xxx * r7.wxz;
            r13.xy = r12.zy * r7.wz + r10.zx;
            r14.xy = r12.xw * r7.xz + r11.xx;
            r13.z = r12.w * r7.w + -r10.y;
            r15.xy = r12.yz * r7.zw + -r10.xz;
            r15.z = r12.w * r7.w + r10.y;
            r8.z = r7.w * r7.w;
            r15.w = r8.z * r7.y + r11.x;
            r10.xyz = m_vDirection.yzx * r7.wxz;
            r10.xyz = r7.zwx * m_vDirection.zxy + -r10.xyz;
            r7.x = dot(m_vDirection.xyz, r7.xzw);
            r7.x = max(-1, r7.x);
            r7.x = min(1, r7.x);
            r10.w = r10.z + r7.x;
            r7.y = dot(r10.xyw, r10.xyw);
            r7.y = rsqrt(r7.y);
            r7.yzw = r10.wxy * r7.yyy;
            r8.z = 1 + -abs(r7.x);
            r8.z = sqrt(r8.z);
            r8.w = abs(r7.x) * -0.0187292993 + 0.0742610022;
            r8.w = r8.w * abs(r7.x) + -0.212114394;
            r8.w = r8.w * abs(r7.x) + 1.57072878;
            r9.w = r8.w * r8.z;
            r9.w = r9.w * -2 + 3.14159274;
            r7.x = cmp(r7.x < -r7.x);
            r7.x = r7.x ? r9.w : 0;
            r7.x = r8.w * r8.z + r7.x;
            r8.x = -r8.y * r8.y + r8.x;
            r5.w = m_sLeaf2.m_fTwitchTime + r5.w;
            r10.x = r0.w * r0.w + r5.w;
            r10.y = r5.w * 0.870000005 + r0.w;
            r8.yz = float2(0.5, 0.5) + r10.xy;
            r8.yz = frac(r8.yz);
            r8.yz = r8.yz * float2(2, 2) + float2(-1, -1);
            r10.xy = abs(r8.yz) * abs(r8.yz);
            r8.yz = -abs(r8.yz) * float2(2, 2) + float2(3, 3);
            r8.yz = r10.xy * r8.yz + float2(-0.5, -0.5);
            r8.yz = r8.yz + r8.yz;
            r5.w = r8.z * r8.z;
            r5.w = r5.w * r8.y + 1;
            r5.w = saturate(0.5 * r5.w);
            r5.w = log2(r5.w);
            r5.w = m_sLeaf2.m_fTwitchSharpness * r5.w;
            r5.w = exp2(r5.w);
            r5.w = m_sLeaf2.m_fTwitchThrow * r5.w;
            r3.w = r3.w ? r5.w : 0;
            r5.w = m_sLeaf2.m_fTumbleFlip * r8.x;
            r5.w = r7.x * m_sLeaf2.m_fTumbleDirectionAdherence + r5.w;
            r3.w = r5.w + r3.w;
            r2.w = r3.w * r2.w;
            sincos(r2.w, r7.x, r8.x);
            r2.w = 1 + -r8.x;
            r10.xyzw = r2.wwww * r7.zzzw;
            r8.yzw = r7.xxx * r7.yzw;
            r11.xy = r10.zy * r7.yw + r8.wy;
            r12.xy = r10.xw * r7.zw + r8.xx;
            r11.z = r10.w * r7.y + -r8.z;
            r16.xy = r10.yz * r7.wy + -r8.yw;
            r16.z = r10.w * r7.y + r8.z;
            r3.w = r7.y * r7.y;
            r11.w = r3.w * r2.w + r8.x;
            r14.z = r15.x;
            r14.w = r13.x;
            r12.z = r11.y;
            r12.w = r16.y;
            r7.x = dot(r14.xzw, r12.xzw);
            r16.w = r12.y;
            r7.y = dot(r14.xwz, r16.xzw);
            r7.z = dot(r14.xzw, r11.xzw);
            r13.w = r14.y;
            r8.x = dot(r13.ywz, r12.xzw);
            r8.y = dot(r13.yzw, r16.xzw);
            r8.z = dot(r13.ywz, r11.xzw);
            r10.x = dot(r15.yzw, r12.xzw);
            r10.y = dot(r15.ywz, r16.xzw);
            r10.z = dot(r15.yzw, r11.xzw);
            r11.x = dot(r7.xyz, r4.xyz);
            r11.y = dot(r8.xyz, r4.xyz);
            r11.z = dot(r10.xyz, r4.xyz);
            r7.x = dot(r7.xyz, r9.xyz);
            r7.y = dot(r8.xyz, r9.xyz);
            r7.z = dot(r10.xyz, r9.xyz);
            r2.w = dot(r7.xyz, r7.xyz);
            r2.w = rsqrt(r2.w);
            r7.xyz = r7.xyz * r2.www;
            r6.xyw = r7.xyz * r6.zzz + r3.xyz;
            r4.xyz = r11.xyz;
        }
        r6.xyz = r6.xyw + -r2.xyz;
    }
    else
    {
        r7.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[4].zx);
        r2.w = dot(r3.xy, r3.xy);
        r2.w = rsqrt(r2.w);
        r7.zw = r3.xy * r2.ww;
        r2.w = dot(-r7.zw, m_vDirection.xy);
        r2.w = 1 + r2.w;
        r2.w = 0.5 * r2.w;
        r3.w = 1 + -m_sLeaf1.m_fLeewardScalar;
        r2.w = r2.w * r3.w + m_sLeaf1.m_fLeewardScalar;
        r2.w = v6.x * r2.w;
        r2.w = r7.x ? r2.w : v6.x;
        r3.w = cmp(0.5 < m_avWindConfigFlags[6].w);
        if (r3.w != 0)
        {
            r7.xz = v0.xy + r3.xy;
            r7.xz = -m_sRolling.m_vOffset.xy + r7.xz;
            r7.xz = m_sRolling.m_fNoiseSize * r7.xz;
            r3.w = 5 * m_sRolling.m_fNoisePeriod;
            r3.w = dot(r7.xz, r3.ww);
            r5.w = m_sRolling.m_fNoiseTurbulence;
            r6.w = 0;
            while (true)
            {
                r7.w = cmp(r5.w < 1);
                if (r7.w != 0)
                    break;
                r8.xy = r7.xz / r5.ww;
                r8.xy = frac(r8.xy);
                r8.xyzw = PerlinNoiseKernel.SampleLevel(samStandard_s, r8.xy, 0).xyzw;
                r7.w = dot(r8.xyzw, float4(0.25, 0.25, 0.25, 0.25));
                r6.w = r7.w * r5.w + r6.w;
                r5.w = 0.5 * r5.w;
            }
            r5.w = 0.5 * r6.w;
            r5.w = r5.w / m_sRolling.m_fNoiseTurbulence;
            r3.w = m_sRolling.m_fNoiseTwist * r5.w + r3.w;
            r3.w = 3.14159274 * r3.w;
            r3.w = sin(r3.w);
            r3.w = 1 + -abs(r3.w);
            r5.w = 1 + -m_sRolling.m_fLeafRippleMin;
            r8.x = r3.w * r5.w + m_sRolling.m_fLeafRippleMin;
            r5.w = 1 + -m_sRolling.m_fLeafTumbleMin;
            r8.y = r3.w * r5.w + m_sRolling.m_fLeafTumbleMin;
        }
        else
        {
            r8.xy = float2(1, 1);
        }
        r3.w = r8.x * r2.w;
        r5.w = m_sLeaf1.m_fRippleTime + r0.w;
        r5.w = 0.5 + r5.w;
        r5.w = frac(r5.w);
        r5.w = r5.w * 2 + -1;
        r6.w = abs(r5.w) * abs(r5.w);
        r5.w = -abs(r5.w) * 2 + 3;
        r5.w = r6.w * r5.w + -0.5;
        r5.w = dot(r5.ww, m_sLeaf1.m_fRippleDistance);
        r7.xzw = r5.www * r4.xyz;
        r7.xzw = r7.xzw * r3.www + r2.xyz;
        r8.xz = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[3].zw);
        r9.xyz = float3(0.0625, 1, 16) * v6.zzz;
        r9.xyz = frac(r9.xyz);
        r9.xyz = r9.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
        r9.xyz = r9.xyz * r5.www;
        r9.xyz = r9.xyz * r3.www + r2.xyz;
        r9.xyz = r8.zzz ? r9.xyz : r2.xyz;
        r7.xzw = r8.xxx ? r7.xzw : r9.xyz;
        if (r7.y != 0)
        {
            r8.xzw = float3(0.0625, 1, 16) * v6.yyy;
            r8.xzw = frac(r8.xzw);
            r8.xzw = r8.xzw * float3(2, 2, 2) + float3(-1, -1, -1);
            r2.w = r8.y * r2.w;
            r3.w = cmp(0.5 < m_avWindConfigFlags[4].y);
            r9.xyz = r3.xyz + r0.www;
            r9.xyz = float3(30.2999992, 30.2999992, 30.2999992) * r9.xyz;
            r9.xyz = frac(r9.xyz);
            r5.w = r9.x + r9.y;
            r5.w = r5.w + r9.z;
            r9.y = m_sLeaf1.m_fTumbleTime + r5.w;
            r9.x = m_sLeaf1.m_fTumbleTime * 0.75 + -r5.w;
            r9.xy = float2(0.5, 0.5) + r9.xy;
            r9.xy = frac(r9.xy);
            r9.xy = r9.xy * float2(2, 2) + float2(-1, -1);
            r9.zw = abs(r9.xy) * abs(r9.xy);
            r9.xy = -abs(r9.xy) * float2(2, 2) + float2(3, 3);
            r9.xy = r9.zw * r9.xy + float2(-0.5, -0.5);
            r9.xy = r9.xy + r9.xy;
            r10.xyz = r7.xzw + -r3.xyz;
            r6.w = dot(r10.xyz, r10.xyz);
            r6.w = sqrt(r6.w);
            r7.y = r9.x * r9.x + r9.y;
            r8.y = m_sLeaf1.m_fTumbleTwist * r2.w;
            r7.y = r8.y * r7.y;
            sincos(r7.y, r11.x, r12.x);
            r7.y = 1 + -r12.x;
            r13.xyzw = r7.yyyy * r8.xxxz;
            r11.xyz = r11.xxx * r8.wxz;
            r14.xy = r13.zy * r8.wz + r11.zx;
            r15.xy = r13.xw * r8.xz + r12.xx;
            r14.z = r13.w * r8.w + -r11.y;
            r16.xy = r13.yz * r8.zw + -r11.xz;
            r16.z = r13.w * r8.w + r11.y;
            r8.y = r8.w * r8.w;
            r16.w = r8.y * r7.y + r12.x;
            r11.xyz = m_vDirection.yzx * r8.wxz;
            r11.xyz = r8.zwx * m_vDirection.zxy + -r11.xyz;
            r7.y = dot(m_vDirection.xyz, r8.xzw);
            r7.y = max(-1, r7.y);
            r7.y = min(1, r7.y);
            r11.w = r11.z + r7.y;
            r8.x = dot(r11.xyw, r11.xyw);
            r8.x = rsqrt(r8.x);
            r8.xyz = r11.wxy * r8.xxx;
            r8.w = 1 + -abs(r7.y);
            r8.w = sqrt(r8.w);
            r9.z = abs(r7.y) * -0.0187292993 + 0.0742610022;
            r9.z = r9.z * abs(r7.y) + -0.212114394;
            r9.z = r9.z * abs(r7.y) + 1.57072878;
            r9.w = r9.z * r8.w;
            r9.w = r9.w * -2 + 3.14159274;
            r7.y = cmp(r7.y < -r7.y);
            r7.y = r7.y ? r9.w : 0;
            r7.y = r9.z * r8.w + r7.y;
            r8.w = -r9.y * r9.y + r9.x;
            r5.w = m_sLeaf1.m_fTwitchTime + r5.w;
            r9.x = r0.w * r0.w + r5.w;
            r9.y = r5.w * 0.870000005 + r0.w;
            r9.xy = float2(0.5, 0.5) + r9.xy;
            r9.xy = frac(r9.xy);
            r9.xy = r9.xy * float2(2, 2) + float2(-1, -1);
            r9.zw = abs(r9.xy) * abs(r9.xy);
            r9.xy = -abs(r9.xy) * float2(2, 2) + float2(3, 3);
            r9.xy = r9.zw * r9.xy + float2(-0.5, -0.5);
            r9.xy = r9.xy + r9.xy;
            r0.w = r9.y * r9.y;
            r0.w = r0.w * r9.x + 1;
            r0.w = saturate(0.5 * r0.w);
            r0.w = log2(r0.w);
            r0.w = m_sLeaf1.m_fTwitchSharpness * r0.w;
            r0.w = exp2(r0.w);
            r0.w = m_sLeaf1.m_fTwitchThrow * r0.w;
            r0.w = r3.w ? r0.w : 0;
            r3.w = m_sLeaf1.m_fTumbleFlip * r8.w;
            r3.w = r7.y * m_sLeaf1.m_fTumbleDirectionAdherence + r3.w;
            r0.w = r3.w + r0.w;
            r0.w = r2.w * r0.w;
            sincos(r0.w, r9.x, r11.x);
            r0.w = 1 + -r11.x;
            r12.xyzw = r0.wwww * r8.yyyz;
            r9.xyz = r9.xxx * r8.xyz;
            r13.xy = r12.zy * r8.xz + r9.zx;
            r17.xy = r12.xw * r8.yz + r11.xx;
            r13.z = r12.w * r8.x + -r9.y;
            r18.xy = r12.yz * r8.zx + -r9.xz;
            r18.z = r12.w * r8.x + r9.y;
            r2.w = r8.x * r8.x;
            r13.w = r2.w * r0.w + r11.x;
            r15.z = r16.x;
            r15.w = r14.x;
            r17.z = r13.y;
            r17.w = r18.y;
            r8.x = dot(r15.xzw, r17.xzw);
            r18.w = r17.y;
            r8.y = dot(r15.xwz, r18.xzw);
            r8.z = dot(r15.xzw, r13.xzw);
            r14.w = r15.y;
            r9.x = dot(r14.ywz, r17.xzw);
            r9.y = dot(r14.yzw, r18.xzw);
            r9.z = dot(r14.ywz, r13.xzw);
            r11.x = dot(r16.yzw, r17.xzw);
            r11.y = dot(r16.ywz, r18.xzw);
            r11.z = dot(r16.yzw, r13.xzw);
            r12.x = dot(r8.xyz, r4.xyz);
            r12.y = dot(r9.xyz, r4.xyz);
            r12.z = dot(r11.xyz, r4.xyz);
            r8.x = dot(r8.xyz, r10.xyz);
            r8.y = dot(r9.xyz, r10.xyz);
            r8.z = dot(r11.xyz, r10.xyz);
            r0.w = dot(r8.xyz, r8.xyz);
            r0.w = rsqrt(r0.w);
            r8.xyz = r8.xyz * r0.www;
            r7.xzw = r8.xyz * r6.www + r3.xyz;
            r4.xyz = r12.xyz;
        }
        r6.xyz = r7.xzw + -r2.xyz;
    }
    r0.w = cmp(0.5 < m_avWindLodFlags[0].w);
    if (r0.w != 0)
    {
        r3.xyz = r1.xyz * r1.www + r2.xyz;
    }
    else
    {
        r0.w = cmp(0.5 < m_avWindLodFlags[1].x);
        if (r0.w != 0)
        {
            r7.xyz = r5.xyz + r1.xyz;
            r3.xyz = r7.xyz * r1.www + r2.xyz;
        }
        else
        {
            r0.w = cmp(0.5 < m_avWindLodFlags[1].y);
            if (r0.w != 0)
            {
                r7.xyz = r5.xyz + r1.xyz;
                r7.xyz = r7.xyz + r6.xyz;
                r3.xyz = r7.xyz * r1.www + r2.xyz;
            }
            else
            {
                r0.w = cmp(0.5 < m_avWindLodFlags[1].z);
                if (r0.w != 0)
                {
                    r7.xyz = r5.xyz * r1.www + r1.xyz;
                    r3.xyz = r7.xyz + r2.xyz;
                }
                else
                {
                    r0.w = cmp(0.5 < m_avWindLodFlags[1].w);
                    r7.xyz = r6.xyz + r5.xyz;
                    r7.xyz = r7.xyz * r1.www + r1.xyz;
                    r7.xyz = r7.xyz + r2.xyz;
                    r2.w = cmp(0.5 < m_avWindLodFlags[2].x);
                    r5.xyz = r5.xyz + r1.xyz;
                    r8.xyz = r6.xyz * r1.www + r5.xyz;
                    r8.xyz = r8.xyz + r2.xyz;
                    r1.xyz = r2.xyz + r1.xyz;
                    r9.xyz = r5.xyz + r2.xyz;
                    r10.xyz = cmp(float3(0.5, 0.5, 0.5) < m_avWindLodFlags[0].xyz);
                    r5.xyz = r5.xyz + r6.xyz;
                    r5.xyz = r5.xyz + r2.xyz;
                    r2.xyz = r10.zzz ? r5.xyz : r2.xyz;
                    r2.xyz = r10.yyy ? r9.xyz : r2.xyz;
                    r1.xyz = r10.xxx ? r1.xyz : r2.xyz;
                    r1.xyz = r2.www ? r8.xyz : r1.xyz;
                    r3.xyz = r0.www ? r7.xyz : r1.xyz;
                }
            }
        }
    }
    r1.xyz = r3.xyz * v0.www + v0.xyz;
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
    r4.w = v8.w * 2 + -1;
    o2.xyzw = r4.xyzw;
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
