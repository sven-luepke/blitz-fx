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


#define cmp -

float3 ComputePreviousFramePosition(float4 v0, float4 v1, float4 v2, float4 v3, float4 v4, float4 v5, float4 v6, float4 v7, float4 v8)
{
    float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10;

    r0.xyz = v7.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
    r1.xyz = v8.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
    r0.w = floor(v1.w);
    r1.w = v1.w + -r0.w;
    r1.w = 1.33333337 * r1.w;
    r0.w = cmp(0.5 < m_avEffectConfigFlags[2].z);
    r2.x = v3.w;
    r2.yz = v4.zw;
    r3.xyz = v3.xyz + -r2.xyz;
    r2.xyz = r1.www * r3.xyz + r2.xyz;
    r2.xyz = r0.www ? r2.xyz : v3.xyz;
    r3.xyz = v2.yzx * v1.zxy;
    r3.xyz = v1.yzx * v2.zxy + -r3.xyz;
    r0.w = dot(r3.xyz, r3.xyz);
    r0.w = rsqrt(r0.w);
    r3.xyz = r3.xyz * r0.www;
    r4.xyz = r3.xyz * r2.yyy;
    r2.xyw = v2.xyz * r2.xxx + r4.xyz;
    r2.xyz = v1.xyz * r2.zzz + r2.xyw;
    r4.xyz = r3.xyz * r0.yyy;
    r4.xyz = v2.xyz * r0.xxx + r4.xyz;
    r4.xyz = v1.xyz * r0.zzz + r4.xyz;
    r3.xyz = r3.xyz * r1.yyy;
    r3.xyz = v2.xyz * r1.xxx + r3.xyz;
    r0.w = cmp(0.5 < m_avWindConfigFlags[0].x);
    r1.x = dot(r2.xyz, r2.xyz);
    r1.x = sqrt(r1.x);
    r1.y = 1 / previous_m_sGlobal.m_fHeight;
    r1.y = -r1.y * 0.25 + r2.z;
    r1.y = max(0, r1.y);
    r1.y = previous_m_sGlobal.m_fHeight * r1.y;
    r1.z = cmp(r1.y != 0.000000);
    r2.w = log2(abs(r1.y));
    r2.w = previous_m_sGlobal.m_fHeightExponent * r2.w;
    r2.w = exp2(r2.w);
    r1.y = r1.z ? r2.w : r1.y;
    r3.x = previous_m_sGlobal.m_fTime + v0.x;
    r3.y = previous_m_sGlobal.m_fTime * 0.800000012 + v0.y;
    r3.xy = float2(0.5, 0.5) + r3.xy;
    r3.xy = frac(r3.xy);
    r3.xy = r3.xy * float2(2, 2) + float2(-1, -1);
    r3.zw = abs(r3.xy) * abs(r3.xy);
    r3.xy = -abs(r3.xy) * float2(2, 2) + float2(3, 3);
    r3.xy = r3.zw * r3.xy + float2(-0.5, -0.5);
    r3.xy = r3.xy + r3.xy;
    r1.z = r3.y * r3.y + r3.x;
    r2.w = previous_m_sGlobal.m_fAdherence / previous_m_sGlobal.m_fHeight;
    r1.z = previous_m_sGlobal.m_fDistance * r1.z + r2.w;
    r1.y = r1.z * r1.y;
    r3.xy = previous_m_vDirection.xy * r1.yy + r2.xy;
    r3.z = r2.z;
    r1.y = dot(r3.xyz, r3.xyz);
    r1.y = rsqrt(r1.y);
    r3.xyz = r3.xyz * r1.yyy;
    r1.xyz = r3.xyz * r1.xxx + -r2.xyz;
    r1.xyz = r0.www ? r1.xyz : 0;
    r0.w = cmp(0.5 < m_avWindLodFlags[2].w);
    if (r0.w != 0)
    {
        r0.w = cmp(0.5 < m_avWindConfigFlags[0].z);
        if (r0.w != 0)
        {
            r3.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[1].zw);
            r5.xyz = float3(0.0625, 1, 16) * v6.yyy;
            r5.xyz = frac(r5.xyz);
            r5.xyz = r5.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
            r5.xyz = v6.xxx * r5.xyz;
            r0.w = v0.x + v0.y;
            r0.w = previous_m_sBranch1.m_fTime + r0.w;
            if (r3.y != 0)
            {
                r6.x = v6.y + r0.w;
                r6.y = r0.w * previous_m_sBranch1.m_fTwitchFreqScale + v6.y;
                r2.w = previous_m_sBranch1.m_fTwitchFreqScale * r6.x;
                r6.z = 0.5 * r2.w;
                r6.w = -v6.x + r6.x;
                r7.xyzw = float4(0.5, 0.5, 0.5, 1.5) + r6.xyzw;
                r7.xyzw = frac(r7.xyzw);
                r7.xyzw = r7.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
                r8.xyzw = abs(r7.xyzw) * abs(r7.xyzw);
                r7.xyzw = -abs(r7.xyzw) * float4(2, 2, 2, 2) + float4(3, 3, 3, 3);
                r7.xyzw = r8.xyzw * r7.xyzw + float4(-0.5, -0.5, -0.5, -0.5);
                r7.xyzw = r7.xyzw + r7.xyzw;
                r3.yzw = float3(0.5, 0.5, 0.5) + r6.xyz;
                r3.yzw = frac(r3.yzw);
                r3.yzw = r3.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
                r6.xyz = abs(r3.yzw) * abs(r3.yzw);
                r3.yzw = -abs(r3.yzw) * float3(2, 2, 2) + float3(3, 3, 3);
                r6.xyz = r6.xyz * r3.yzw;
                r6.w = 0;
                r6.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r6.xyzw;
                r6.xyzw = r6.xyzw + r6.xyzw;
                r6.xyzw = r3.xxxx ? r7.xyzw : r6.xyzw;
                r7.w = r6.y * r6.z;
                r2.w = cmp(r7.w < 0);
                r7.y = -r7.w;
                r7.xz = float2(-1, 1);
                r3.yz = r2.ww ? r7.xy : r7.zw;
                r2.w = -r6.y * r6.z + r3.y;
                r2.w = r3.z * r2.w + r7.w;
                r3.y = r3.y + -r2.w;
                r2.w = r3.z * r3.y + r2.w;
                r2.w = previous_m_sBranch1.m_fTwitch * r2.w;
                r3.y = 1 + -previous_m_fStrength;
                r3.z = 1 + -previous_m_sBranch1.m_fTwitch;
                r3.z = r6.x * r3.z;
                r2.w = r2.w * r3.y + r3.z;
                r3.y = previous_m_sBranch1.m_fWhip * r6.w;
                r3.y = r3.y * v6.x + 1;
                r3.y = r3.y * r2.w;
                r2.w = r3.x ? r3.y : r2.w;
            }
            else
            {
                r6.x = v6.y + r0.w;
                r6.y = r0.w * 0.68900001 + v6.y;
                r6.z = -v6.x + r6.x;
                r3.yzw = float3(0.5, 0.5, 1.5) + r6.xyz;
                r3.yzw = frac(r3.yzw);
                r3.yzw = r3.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
                r7.xyz = abs(r3.yzw) * abs(r3.yzw);
                r3.yzw = -abs(r3.yzw) * float3(2, 2, 2) + float3(3, 3, 3);
                r3.yzw = r7.xyz * r3.yzw + float3(-0.5, -0.5, -0.5);
                r3.yzw = r3.yzw + r3.yzw;
                r6.xy = float2(0.5, 0.5) + r6.xy;
                r6.xy = frac(r6.xy);
                r6.xy = r6.xy * float2(2, 2) + float2(-1, -1);
                r6.zw = abs(r6.xy) * abs(r6.xy);
                r6.xy = -abs(r6.xy) * float2(2, 2) + float2(3, 3);
                r6.xy = r6.zw * r6.xy;
                r6.z = 0;
                r6.xyz = float3(-0.5, -0.5, -0.5) + r6.xyz;
                r6.xyz = r6.xyz + r6.xyz;
                r3.yzw = r3.xxx ? r3.yzw : r6.xyz;
                r0.w = r3.z * r3.y + r3.y;
                r3.y = previous_m_sBranch1.m_fWhip * r3.w;
                r3.y = r3.y * v6.x + 1;
                r3.y = r3.y * r0.w;
                r2.w = r3.x ? r3.y : r0.w;
            }
            r3.xyz = r5.xyz * r2.www;
            r3.xyz = r3.xyz * previous_m_sBranch1.m_fDistance + r2.xyz;
        }
        else
        {
            r0.w = cmp(0.5 < m_avWindConfigFlags[0].w);
            if (r0.w != 0)
            {
                r5.xyz = cmp(float3(0.5, 0.5, 0.5) < m_avWindConfigFlags[1].zwy);
                r6.xyz = float3(0.0625, 1, 16) * v6.yyy;
                r6.xyz = frac(r6.xyz);
                r6.xyz = r6.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                r6.xyz = v6.xxx * r6.xyz;
                r0.w = v0.x + v0.y;
                r0.w = previous_m_sBranch1.m_fTime + r0.w;
                if (r5.y != 0)
                {
                    r7.x = v6.y + r0.w;
                    r7.y = r0.w * previous_m_sBranch1.m_fTwitchFreqScale + v6.y;
                    r2.w = previous_m_sBranch1.m_fTwitchFreqScale * r7.x;
                    r7.z = 0.5 * r2.w;
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
                    r2.w = cmp(r8.w < 0);
                    r8.y = -r8.w;
                    r8.xz = float2(-1, 1);
                    r5.yw = r2.ww ? r8.xy : r8.zw;
                    r2.w = -r7.z * r7.w + r5.y;
                    r2.w = r5.w * r2.w + r8.w;
                    r3.w = r5.y + -r2.w;
                    r2.w = r5.w * r3.w + r2.w;
                    r2.w = previous_m_sBranch1.m_fTwitch * r2.w;
                    r3.w = 1 + -previous_m_fStrength;
                    r4.w = 1 + -previous_m_sBranch1.m_fTwitch;
                    r4.w = r7.y * r4.w;
                    r2.w = r2.w * r3.w + r4.w;
                    r3.w = previous_m_sBranch1.m_fWhip * r7.x;
                    r3.w = r3.w * v6.x + 1;
                    r3.w = r3.w * r2.w;
                    r2.w = r5.x ? r3.w : r2.w;
                }
                else
                {
                    r8.x = v6.y + r0.w;
                    r8.y = r0.w * 0.68900001 + v6.y;
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
                    r3.w = r7.z * r7.y + r7.y;
                    r4.w = previous_m_sBranch1.m_fWhip * r7.x;
                    r4.w = r4.w * v6.x + 1;
                    r4.w = r4.w * r3.w;
                    r2.w = r5.x ? r4.w : r3.w;
                }
                r6.xyz = r6.xyz * r2.www;
                r6.xyz = r6.xyz * previous_m_sBranch1.m_fDistance + r2.xyz;
                r8.x = r0.w * 0.100000001 + v6.y;
                r0.w = previous_m_sBranch1.m_fTurbulence * m_fWallTime;
                r8.y = r0.w * 0.100000001 + v6.y;
                r5.yw = float2(0.5, 0.5) + r8.xy;
                r5.yw = frac(r5.yw);
                r5.yw = r5.yw * float2(2, 2) + float2(-1, -1);
                r7.yz = abs(r5.yw) * abs(r5.yw);
                r5.yw = -abs(r5.yw) * float2(2, 2) + float2(3, 3);
                r5.yw = r7.yz * r5.yw + float2(-0.5, -0.5);
                r5.yw = r5.yw + r5.yw;
                r5.yw = r5.yw * r5.yw;
                r0.w = r5.w * r5.y;
                r0.w = -r0.w * previous_m_sBranch1.m_fTurbulence + 1;
                r0.w = r5.z ? r0.w : 1;
                r2.w = previous_m_fStrength * r7.x;
                r2.w = r2.w * previous_m_sBranch1.m_fWhip + r0.w;
                r0.w = r5.x ? r2.w : r0.w;
                r5.xyz = previous_m_sBranch1.m_fDirectionAdherence * previous_m_vDirection.xyz;
                r5.xyz = r5.xyz * r0.www;
                r3.xyz = r5.xyz * v6.xxx + r6.xyz;
            }
            else
            {
                r0.w = cmp(0.5 < m_avWindConfigFlags[1].x);
                if (r0.w != 0)
                {
                    r5.xyz = cmp(float3(0.5, 0.5, 0.5) < m_avWindConfigFlags[1].zwy);
                    r6.xyz = float3(0.0625, 1, 16) * v6.yyy;
                    r6.xyz = frac(r6.xyz);
                    r6.xyz = r6.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                    r6.xyz = v6.xxx * r6.xyz;
                    r0.w = v0.x + v0.y;
                    r0.w = previous_m_sBranch1.m_fTime + r0.w;
                    if (r5.y != 0)
                    {
                        r7.x = v6.y + r0.w;
                        r7.y = r0.w * previous_m_sBranch1.m_fTwitchFreqScale + v6.y;
                        r2.w = previous_m_sBranch1.m_fTwitchFreqScale * r7.x;
                        r7.z = 0.5 * r2.w;
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
                        r2.w = cmp(r8.w < 0);
                        r8.y = -r8.w;
                        r8.xz = float2(-1, 1);
                        r5.yw = r2.ww ? r8.xy : r8.zw;
                        r2.w = -r7.z * r7.w + r5.y;
                        r2.w = r5.w * r2.w + r8.w;
                        r3.w = r5.y + -r2.w;
                        r2.w = r5.w * r3.w + r2.w;
                        r2.w = previous_m_sBranch1.m_fTwitch * r2.w;
                        r3.w = 1 + -previous_m_fStrength;
                        r4.w = 1 + -previous_m_sBranch1.m_fTwitch;
                        r4.w = r7.y * r4.w;
                        r2.w = r2.w * r3.w + r4.w;
                        r3.w = previous_m_sBranch1.m_fWhip * r7.x;
                        r3.w = r3.w * v6.x + 1;
                        r3.w = r3.w * r2.w;
                        r2.w = r5.x ? r3.w : r2.w;
                    }
                    else
                    {
                        r8.x = v6.y + r0.w;
                        r8.y = r0.w * 0.68900001 + v6.y;
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
                        r3.w = r7.z * r7.y + r7.y;
                        r4.w = m_sBranch1.m_fWhip * r7.x;
                        r4.w = r4.w * v6.x + 1;
                        r4.w = r4.w * r3.w;
                        r2.w = r5.x ? r4.w : r3.w;
                    }
                    r6.xyz = r6.xyz * r2.www;
                    r6.xyz = r6.xyz * previous_m_sBranch1.m_fDistance + r2.xyz;
                    r8.x = r0.w * 0.100000001 + v6.y;
                    r0.w = previous_m_sBranch1.m_fTurbulence * m_fWallTime;
                    r8.y = r0.w * 0.100000001 + v6.y;
                    r5.yw = float2(0.5, 0.5) + r8.xy;
                    r5.yw = frac(r5.yw);
                    r5.yw = r5.yw * float2(2, 2) + float2(-1, -1);
                    r7.yz = abs(r5.yw) * abs(r5.yw);
                    r5.yw = -abs(r5.yw) * float2(2, 2) + float2(3, 3);
                    r5.yw = r7.yz * r5.yw + float2(-0.5, -0.5);
                    r5.yw = r5.yw + r5.yw;
                    r5.yw = r5.yw * r5.yw;
                    r0.w = r5.w * r5.y;
                    r0.w = -r0.w * previous_m_sBranch1.m_fTurbulence + 1;
                    r0.w = r5.z ? r0.w : 1;
                    r2.w = previous_m_fStrength * r7.x;
                    r2.w = r2.w * previous_m_sBranch1.m_fWhip + r0.w;
                    r0.w = r5.x ? r2.w : r0.w;
                    r5.xyz = previous_m_vAnchor.xyz + -r6.xyz;
                    r5.xyz = previous_m_sBranch1.m_fDirectionAdherence * r5.xyz;
                    r5.xyz = r5.xyz * r0.www;
                    r3.xyz = r5.xyz * v6.xxx + r6.xyz;
                }
                else
                {
                    r3.xyz = r2.xyz;
                }
            }
        }
        r0.w = cmp(0.5 < m_avWindConfigFlags[2].x);
        if (r0.w != 0)
        {
            r5.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[3].xy);
            r6.xyz = float3(0.0625, 1, 16) * v6.www;
            r6.xyz = frac(r6.xyz);
            r6.xyz = r6.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
            r6.xyz = v6.zzz * r6.xyz;
            r0.w = v0.x + v0.y;
            r0.w = previous_m_sBranch2.m_fTime + r0.w;
            if (r5.y != 0)
            {
                r7.x = v6.w + r0.w;
                r7.y = r0.w * previous_m_sBranch2.m_fTwitchFreqScale + v6.w;
                r2.w = previous_m_sBranch2.m_fTwitchFreqScale * r7.x;
                r7.z = 0.5 * r2.w;
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
                r2.w = cmp(r8.w < 0);
                r8.y = -r8.w;
                r8.xz = float2(-1, 1);
                r5.yz = r2.ww ? r8.xy : r8.zw;
                r2.w = -r7.y * r7.z + r5.y;
                r2.w = r5.z * r2.w + r8.w;
                r3.w = r5.y + -r2.w;
                r2.w = r5.z * r3.w + r2.w;
                r2.w = previous_m_sBranch2.m_fTwitch * r2.w;
                r3.w = 1 + -previous_m_fStrength;
                r4.w = 1 + -previous_m_sBranch2.m_fTwitch;
                r4.w = r7.x * r4.w;
                r2.w = r2.w * r3.w + r4.w;
                r3.w = previous_m_sBranch2.m_fWhip * r7.w;
                r3.w = r3.w * v6.z + 1;
                r3.w = r3.w * r2.w;
                r2.w = r5.x ? r3.w : r2.w;
            }
            else
            {
                r7.x = v6.w + r0.w;
                r7.y = r0.w * 0.68900001 + v6.w;
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
                r0.w = r5.z * r5.y + r5.y;
                r3.w = previous_m_sBranch2.m_fWhip * r5.w;
                r3.w = r3.w * v6.z + 1;
                r3.w = r3.w * r0.w;
                r2.w = r5.x ? r3.w : r0.w;
            }
            r5.xyz = r6.xyz * r2.www;
            r3.xyz = r5.xyz * previous_m_sBranch2.m_fDistance + r3.xyz;
        }
        else
        {
            r0.w = cmp(0.5 < m_avWindConfigFlags[2].y);
            if (r0.w != 0)
            {
                r5.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[3].xy);
                r0.w = cmp(0.5 < m_avWindConfigFlags[2].w);
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
                    r7.xyzw = r5.xxxx ? r8.wxyz : r7.wxyz;
                    r8.w = r7.z * r7.w;
                    r3.w = cmp(r8.w < 0);
                    r8.y = -r8.w;
                    r8.xz = float2(-1, 1);
                    r5.yz = r3.ww ? r8.xy : r8.zw;
                    r3.w = -r7.z * r7.w + r5.y;
                    r3.w = r5.z * r3.w + r8.w;
                    r4.w = r5.y + -r3.w;
                    r3.w = r5.z * r4.w + r3.w;
                    r3.w = previous_m_sBranch2.m_fTwitch * r3.w;
                    r4.w = 1 + -previous_m_fStrength;
                    r5.y = 1 + -previous_m_sBranch2.m_fTwitch;
                    r5.y = r7.y * r5.y;
                    r3.w = r3.w * r4.w + r5.y;
                    r4.w = previous_m_sBranch2.m_fWhip * r7.x;
                    r4.w = r4.w * v6.z + 1;
                    r4.w = r4.w * r3.w;
                    r3.w = r5.x ? r4.w : r3.w;
                }
                else
                {
                    r8.x = v6.w + r2.w;
                    r8.y = r2.w * 0.68900001 + v6.w;
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
                    r4.w = r7.z * r7.y + r7.y;
                    r5.y = previous_m_sBranch2.m_fWhip * r7.x;
                    r5.y = r5.y * v6.z + 1;
                    r5.y = r5.y * r4.w;
                    r3.w = r5.x ? r5.y : r4.w;
                }
                r5.yzw = r6.xyz * r3.www;
                r5.yzw = r5.yzw * previous_m_sBranch2.m_fDistance + r3.xyz;
                r6.x = r2.w * 0.100000001 + v6.w;
                r2.w = previous_m_sBranch2.m_fTurbulence * m_fWallTime;
                r6.y = r2.w * 0.100000001 + v6.w;
                r6.xy = float2(0.5, 0.5) + r6.xy;
                r6.xy = frac(r6.xy);
                r6.xy = r6.xy * float2(2, 2) + float2(-1, -1);
                r6.zw = abs(r6.xy) * abs(r6.xy);
                r6.xy = -abs(r6.xy) * float2(2, 2) + float2(3, 3);
                r6.xy = r6.zw * r6.xy + float2(-0.5, -0.5);
                r6.xy = r6.xy + r6.xy;
                r6.xy = r6.xy * r6.xy;
                r2.w = r6.y * r6.x;
                r2.w = -r2.w * previous_m_sBranch2.m_fTurbulence + 1;
                r0.w = r0.w ? r2.w : 1;
                r2.w = previous_m_fStrength * r7.x;
                r2.w = r2.w * previous_m_sBranch2.m_fWhip + r0.w;
                r0.w = r5.x ? r2.w : r0.w;
                r6.xyz = previous_m_sBranch2.m_fDirectionAdherence * previous_m_vDirection.xyz;
                r6.xyz = r6.xyz * r0.www;
                r3.xyz = r6.xyz * v6.zzz + r5.yzw;
            }
            else
            {
                r0.w = cmp(0.5 < m_avWindConfigFlags[2].z);
                if (r0.w != 0)
                {
                    r5.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[3].xy);
                    r0.w = cmp(0.5 < m_avWindConfigFlags[2].w);
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
                        r7.xyzw = r5.xxxx ? r8.wxyz : r7.wxyz;
                        r8.w = r7.z * r7.w;
                        r3.w = cmp(r8.w < 0);
                        r8.y = -r8.w;
                        r8.xz = float2(-1, 1);
                        r5.yz = r3.ww ? r8.xy : r8.zw;
                        r3.w = -r7.z * r7.w + r5.y;
                        r3.w = r5.z * r3.w + r8.w;
                        r4.w = r5.y + -r3.w;
                        r3.w = r5.z * r4.w + r3.w;
                        r3.w = previous_m_sBranch2.m_fTwitch * r3.w;
                        r4.w = 1 + -previous_m_fStrength;
                        r5.y = 1 + -previous_m_sBranch2.m_fTwitch;
                        r5.y = r7.y * r5.y;
                        r3.w = r3.w * r4.w + r5.y;
                        r4.w = previous_m_sBranch2.m_fWhip * r7.x;
                        r4.w = r4.w * v6.z + 1;
                        r4.w = r4.w * r3.w;
                        r3.w = r5.x ? r4.w : r3.w;
                    }
                    else
                    {
                        r8.x = v6.w + r2.w;
                        r8.y = r2.w * 0.68900001 + v6.w;
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
                        r4.w = r7.z * r7.y + r7.y;
                        r5.y = previous_m_sBranch2.m_fWhip * r7.x;
                        r5.y = r5.y * v6.z + 1;
                        r5.y = r5.y * r4.w;
                        r3.w = r5.x ? r5.y : r4.w;
                    }
                    r5.yzw = r6.xyz * r3.www;
                    r5.yzw = r5.yzw * previous_m_sBranch2.m_fDistance + r3.xyz;
                    r6.x = r2.w * 0.100000001 + v6.w;
                    r2.w = previous_m_sBranch2.m_fTurbulence * m_fWallTime;
                    r6.y = r2.w * 0.100000001 + v6.w;
                    r6.xy = float2(0.5, 0.5) + r6.xy;
                    r6.xy = frac(r6.xy);
                    r6.xy = r6.xy * float2(2, 2) + float2(-1, -1);
                    r6.zw = abs(r6.xy) * abs(r6.xy);
                    r6.xy = -abs(r6.xy) * float2(2, 2) + float2(3, 3);
                    r6.xy = r6.zw * r6.xy + float2(-0.5, -0.5);
                    r6.xy = r6.xy + r6.xy;
                    r6.xy = r6.xy * r6.xy;
                    r2.w = r6.y * r6.x;
                    r2.w = -r2.w * previous_m_sBranch2.m_fTurbulence + 1;
                    r0.w = r0.w ? r2.w : 1;
                    r2.w = previous_m_fStrength * r7.x;
                    r2.w = r2.w * previous_m_sBranch2.m_fWhip + r0.w;
                    r0.w = r5.x ? r2.w : r0.w;
                    r6.xyz = previous_m_vAnchor.xyz + -r5.yzw;
                    r6.xyz = previous_m_sBranch2.m_fDirectionAdherence * r6.xyz;
                    r6.xyz = r6.xyz * r0.www;
                    r3.xyz = r6.xyz * v6.zzz + r5.yzw;
                }
            }
        }
        r3.xyz = r3.xyz + -r2.xyz;
    }
    else
    {
        r3.xyz = float3(0, 0, 0);
    }
    r0.w = cmp(0.5 < m_avWindLodFlags[0].w);
    if (r0.w != 0)
    {
        r5.xyz = r1.xyz * r1.www + r2.xyz;
    }
    else
    {
        r0.w = cmp(0.5 < m_avWindLodFlags[1].x);
        if (r0.w != 0)
        {
            r6.xyz = r3.xyz + r1.xyz;
            r5.xyz = r6.xyz * r1.www + r2.xyz;
        }
        else
        {
            r0.w = cmp(v4.x < 0.5);
            r0.w = r0.w ? 0.750000 : 0;
            r2.w = previous_m_sFrondRipple.m_fTime * v4.y;
            r0.w = r2.w * previous_m_sFrondRipple.m_fTile + r0.w;
            r0.w = 0.5 + r0.w;
            r0.w = frac(r0.w);
            r0.w = r0.w * 2 + -1;
            r2.w = abs(r0.w) * abs(r0.w);
            r0.w = -abs(r0.w) * 2 + 3;
            r0.w = r2.w * r0.w + -0.5;
            r0.w = v5.z * r0.w;
            r0.w = dot(previous_m_sFrondRipple.m_fDistance, r0.ww);
            r6.xyz = r0.www * r4.xyz;
            r7.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[6].xy);
            r0.w = previous_m_sFrondRipple.m_fTime * v5.w;
            r0.w = r0.w * previous_m_sFrondRipple.m_fTile + 0.5;
            r0.w = frac(r0.w);
            r0.w = r0.w * 2 + -1;
            r2.w = abs(r0.w) * abs(r0.w);
            r0.w = -abs(r0.w) * 2 + 3;
            r0.w = r2.w * r0.w + -0.5;
            r0.w = v5.z * r0.w;
            r8.xyz = float3(0.0625, 1, 16) * v5.yyy;
            r8.xyz = frac(r8.xyz);
            r8.xyz = r8.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
            r0.w = dot(previous_m_sFrondRipple.m_fDistance, r0.ww);
            r8.xyz = r0.www * r8.xyz;
            r7.yzw = r7.yyy ? r8.xyz : 0;
            r6.xyz = r7.xxx ? r6.xyz : r7.yzw;
            r0.w = cmp(0.5 < m_avWindLodFlags[1].y);
            if (r0.w != 0)
            {
                r7.xyz = r3.xyz + r1.xyz;
                r7.xyz = r7.xyz + r6.xyz;
                r5.xyz = r7.xyz * r1.www + r2.xyz;
            }
            else
            {
                r0.w = cmp(0.5 < m_avWindLodFlags[1].z);
                if (r0.w != 0)
                {
                    r7.xyz = r3.xyz * r1.www + r1.xyz;
                    r5.xyz = r7.xyz + r2.xyz;
                }
                else
                {
                    r0.w = cmp(0.5 < m_avWindLodFlags[1].w);
                    r7.xyz = r6.xyz + r3.xyz;
                    r7.xyz = r7.xyz * r1.www + r1.xyz;
                    r7.xyz = r7.xyz + r2.xyz;
                    r2.w = cmp(0.5 < m_avWindLodFlags[2].x);
                    r3.xyz = r3.xyz + r1.xyz;
                    r8.xyz = r6.xyz * r1.www + r3.xyz;
                    r8.xyz = r8.xyz + r2.xyz;
                    r1.xyz = r2.xyz + r1.xyz;
                    r9.xyz = r3.xyz + r2.xyz;
                    r10.xyz = cmp(float3(0.5, 0.5, 0.5) < m_avWindLodFlags[0].xyz);
                    r3.xyz = r3.xyz + r6.xyz;
                    r3.xyz = r3.xyz + r2.xyz;
                    r2.xyz = r10.zzz ? r3.xyz : r2.xyz;
                    r2.xyz = r10.yyy ? r9.xyz : r2.xyz;
                    r1.xyz = r10.xxx ? r1.xyz : r2.xyz;
                    r1.xyz = r2.www ? r8.xyz : r1.xyz;
                    r5.xyz = r0.www ? r7.xyz : r1.xyz;
                }
            }
        }
    }
    r1.xyz = r5.xyz * v0.www + v0.xyz;
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

    r0.xyz = v7.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
    r1.xyz = v8.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
    r0.w = floor(v1.w);
    r1.w = v1.w + -r0.w;
    r1.w = 1.33333337 * r1.w;
    o7.x = 0.00392156886 * r0.w;
    r0.w = cmp(0.5 < m_avEffectConfigFlags[2].z);
    r2.x = v3.w;
    r2.yz = v4.zw;
    r3.xyz = v3.xyz + -r2.xyz;
    r2.xyz = r1.www * r3.xyz + r2.xyz;
    r2.xyz = r0.www ? r2.xyz : v3.xyz;
    r3.xyz = v2.yzx * v1.zxy;
    r3.xyz = v1.yzx * v2.zxy + -r3.xyz;
    r0.w = dot(r3.xyz, r3.xyz);
    r0.w = rsqrt(r0.w);
    r3.xyz = r3.xyz * r0.www;
    r4.xyz = r3.xyz * r2.yyy;
    r2.xyw = v2.xyz * r2.xxx + r4.xyz;
    r2.xyz = v1.xyz * r2.zzz + r2.xyw;
    r4.xyz = r3.xyz * r0.yyy;
    r4.xyz = v2.xyz * r0.xxx + r4.xyz;
    r4.xyz = v1.xyz * r0.zzz + r4.xyz;
    r3.xyz = r3.xyz * r1.yyy;
    r3.xyz = v2.xyz * r1.xxx + r3.xyz;
    o3.xyz = v1.xyz * r1.zzz + r3.xyz;
    r0.w = cmp(0.5 < m_avWindConfigFlags[0].x);
    r1.x = dot(r2.xyz, r2.xyz);
    r1.x = sqrt(r1.x);
    r1.y = 1 / m_sGlobal.m_fHeight;
    r1.y = -r1.y * 0.25 + r2.z;
    r1.y = max(0, r1.y);
    r1.y = m_sGlobal.m_fHeight * r1.y;
    r1.z = cmp(r1.y != 0.000000);
    r2.w = log2(abs(r1.y));
    r2.w = m_sGlobal.m_fHeightExponent * r2.w;
    r2.w = exp2(r2.w);
    r1.y = r1.z ? r2.w : r1.y;
    r3.x = m_sGlobal.m_fTime + v0.x;
    r3.y = m_sGlobal.m_fTime * 0.800000012 + v0.y;
    r3.xy = float2(0.5, 0.5) + r3.xy;
    r3.xy = frac(r3.xy);
    r3.xy = r3.xy * float2(2, 2) + float2(-1, -1);
    r3.zw = abs(r3.xy) * abs(r3.xy);
    r3.xy = -abs(r3.xy) * float2(2, 2) + float2(3, 3);
    r3.xy = r3.zw * r3.xy + float2(-0.5, -0.5);
    r3.xy = r3.xy + r3.xy;
    r1.z = r3.y * r3.y + r3.x;
    r2.w = m_sGlobal.m_fAdherence / m_sGlobal.m_fHeight;
    r1.z = m_sGlobal.m_fDistance * r1.z + r2.w;
    r1.y = r1.z * r1.y;
    r3.xy = m_vDirection.xy * r1.yy + r2.xy;
    r3.z = r2.z;
    r1.y = dot(r3.xyz, r3.xyz);
    r1.y = rsqrt(r1.y);
    r3.xyz = r3.xyz * r1.yyy;
    r1.xyz = r3.xyz * r1.xxx + -r2.xyz;
    r1.xyz = r0.www ? r1.xyz : 0;
    r0.w = cmp(0.5 < m_avWindLodFlags[2].w);
    if (r0.w != 0)
    {
        r0.w = cmp(0.5 < m_avWindConfigFlags[0].z);
        if (r0.w != 0)
        {
            r3.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[1].zw);
            r5.xyz = float3(0.0625, 1, 16) * v6.yyy;
            r5.xyz = frac(r5.xyz);
            r5.xyz = r5.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
            r5.xyz = v6.xxx * r5.xyz;
            r0.w = v0.x + v0.y;
            r0.w = m_sBranch1.m_fTime + r0.w;
            if (r3.y != 0)
            {
                r6.x = v6.y + r0.w;
                r6.y = r0.w * m_sBranch1.m_fTwitchFreqScale + v6.y;
                r2.w = m_sBranch1.m_fTwitchFreqScale * r6.x;
                r6.z = 0.5 * r2.w;
                r6.w = -v6.x + r6.x;
                r7.xyzw = float4(0.5, 0.5, 0.5, 1.5) + r6.xyzw;
                r7.xyzw = frac(r7.xyzw);
                r7.xyzw = r7.xyzw * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
                r8.xyzw = abs(r7.xyzw) * abs(r7.xyzw);
                r7.xyzw = -abs(r7.xyzw) * float4(2, 2, 2, 2) + float4(3, 3, 3, 3);
                r7.xyzw = r8.xyzw * r7.xyzw + float4(-0.5, -0.5, -0.5, -0.5);
                r7.xyzw = r7.xyzw + r7.xyzw;
                r3.yzw = float3(0.5, 0.5, 0.5) + r6.xyz;
                r3.yzw = frac(r3.yzw);
                r3.yzw = r3.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
                r6.xyz = abs(r3.yzw) * abs(r3.yzw);
                r3.yzw = -abs(r3.yzw) * float3(2, 2, 2) + float3(3, 3, 3);
                r6.xyz = r6.xyz * r3.yzw;
                r6.w = 0;
                r6.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r6.xyzw;
                r6.xyzw = r6.xyzw + r6.xyzw;
                r6.xyzw = r3.xxxx ? r7.xyzw : r6.xyzw;
                r7.w = r6.y * r6.z;
                r2.w = cmp(r7.w < 0);
                r7.y = -r7.w;
                r7.xz = float2(-1, 1);
                r3.yz = r2.ww ? r7.xy : r7.zw;
                r2.w = -r6.y * r6.z + r3.y;
                r2.w = r3.z * r2.w + r7.w;
                r3.y = r3.y + -r2.w;
                r2.w = r3.z * r3.y + r2.w;
                r2.w = m_sBranch1.m_fTwitch * r2.w;
                r3.y = 1 + -m_fStrength;
                r3.z = 1 + -m_sBranch1.m_fTwitch;
                r3.z = r6.x * r3.z;
                r2.w = r2.w * r3.y + r3.z;
                r3.y = m_sBranch1.m_fWhip * r6.w;
                r3.y = r3.y * v6.x + 1;
                r3.y = r3.y * r2.w;
                r2.w = r3.x ? r3.y : r2.w;
            }
            else
            {
                r6.x = v6.y + r0.w;
                r6.y = r0.w * 0.68900001 + v6.y;
                r6.z = -v6.x + r6.x;
                r3.yzw = float3(0.5, 0.5, 1.5) + r6.xyz;
                r3.yzw = frac(r3.yzw);
                r3.yzw = r3.yzw * float3(2, 2, 2) + float3(-1, -1, -1);
                r7.xyz = abs(r3.yzw) * abs(r3.yzw);
                r3.yzw = -abs(r3.yzw) * float3(2, 2, 2) + float3(3, 3, 3);
                r3.yzw = r7.xyz * r3.yzw + float3(-0.5, -0.5, -0.5);
                r3.yzw = r3.yzw + r3.yzw;
                r6.xy = float2(0.5, 0.5) + r6.xy;
                r6.xy = frac(r6.xy);
                r6.xy = r6.xy * float2(2, 2) + float2(-1, -1);
                r6.zw = abs(r6.xy) * abs(r6.xy);
                r6.xy = -abs(r6.xy) * float2(2, 2) + float2(3, 3);
                r6.xy = r6.zw * r6.xy;
                r6.z = 0;
                r6.xyz = float3(-0.5, -0.5, -0.5) + r6.xyz;
                r6.xyz = r6.xyz + r6.xyz;
                r3.yzw = r3.xxx ? r3.yzw : r6.xyz;
                r0.w = r3.z * r3.y + r3.y;
                r3.y = m_sBranch1.m_fWhip * r3.w;
                r3.y = r3.y * v6.x + 1;
                r3.y = r3.y * r0.w;
                r2.w = r3.x ? r3.y : r0.w;
            }
            r3.xyz = r5.xyz * r2.www;
            r3.xyz = r3.xyz * m_sBranch1.m_fDistance + r2.xyz;
        }
        else
        {
            r0.w = cmp(0.5 < m_avWindConfigFlags[0].w);
            if (r0.w != 0)
            {
                r5.xyz = cmp(float3(0.5, 0.5, 0.5) < m_avWindConfigFlags[1].zwy);
                r6.xyz = float3(0.0625, 1, 16) * v6.yyy;
                r6.xyz = frac(r6.xyz);
                r6.xyz = r6.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                r6.xyz = v6.xxx * r6.xyz;
                r0.w = v0.x + v0.y;
                r0.w = m_sBranch1.m_fTime + r0.w;
                if (r5.y != 0)
                {
                    r7.x = v6.y + r0.w;
                    r7.y = r0.w * m_sBranch1.m_fTwitchFreqScale + v6.y;
                    r2.w = m_sBranch1.m_fTwitchFreqScale * r7.x;
                    r7.z = 0.5 * r2.w;
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
                    r2.w = cmp(r8.w < 0);
                    r8.y = -r8.w;
                    r8.xz = float2(-1, 1);
                    r5.yw = r2.ww ? r8.xy : r8.zw;
                    r2.w = -r7.z * r7.w + r5.y;
                    r2.w = r5.w * r2.w + r8.w;
                    r3.w = r5.y + -r2.w;
                    r2.w = r5.w * r3.w + r2.w;
                    r2.w = m_sBranch1.m_fTwitch * r2.w;
                    r3.w = 1 + -m_fStrength;
                    r4.w = 1 + -m_sBranch1.m_fTwitch;
                    r4.w = r7.y * r4.w;
                    r2.w = r2.w * r3.w + r4.w;
                    r3.w = m_sBranch1.m_fWhip * r7.x;
                    r3.w = r3.w * v6.x + 1;
                    r3.w = r3.w * r2.w;
                    r2.w = r5.x ? r3.w : r2.w;
                }
                else
                {
                    r8.x = v6.y + r0.w;
                    r8.y = r0.w * 0.68900001 + v6.y;
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
                    r3.w = r7.z * r7.y + r7.y;
                    r4.w = m_sBranch1.m_fWhip * r7.x;
                    r4.w = r4.w * v6.x + 1;
                    r4.w = r4.w * r3.w;
                    r2.w = r5.x ? r4.w : r3.w;
                }
                r6.xyz = r6.xyz * r2.www;
                r6.xyz = r6.xyz * m_sBranch1.m_fDistance + r2.xyz;
                r8.x = r0.w * 0.100000001 + v6.y;
                r0.w = m_sBranch1.m_fTurbulence * m_fWallTime;
                r8.y = r0.w * 0.100000001 + v6.y;
                r5.yw = float2(0.5, 0.5) + r8.xy;
                r5.yw = frac(r5.yw);
                r5.yw = r5.yw * float2(2, 2) + float2(-1, -1);
                r7.yz = abs(r5.yw) * abs(r5.yw);
                r5.yw = -abs(r5.yw) * float2(2, 2) + float2(3, 3);
                r5.yw = r7.yz * r5.yw + float2(-0.5, -0.5);
                r5.yw = r5.yw + r5.yw;
                r5.yw = r5.yw * r5.yw;
                r0.w = r5.w * r5.y;
                r0.w = -r0.w * m_sBranch1.m_fTurbulence + 1;
                r0.w = r5.z ? r0.w : 1;
                r2.w = m_fStrength * r7.x;
                r2.w = r2.w * m_sBranch1.m_fWhip + r0.w;
                r0.w = r5.x ? r2.w : r0.w;
                r5.xyz = m_sBranch1.m_fDirectionAdherence * m_vDirection.xyz;
                r5.xyz = r5.xyz * r0.www;
                r3.xyz = r5.xyz * v6.xxx + r6.xyz;
            }
            else
            {
                r0.w = cmp(0.5 < m_avWindConfigFlags[1].x);
                if (r0.w != 0)
                {
                    r5.xyz = cmp(float3(0.5, 0.5, 0.5) < m_avWindConfigFlags[1].zwy);
                    r6.xyz = float3(0.0625, 1, 16) * v6.yyy;
                    r6.xyz = frac(r6.xyz);
                    r6.xyz = r6.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
                    r6.xyz = v6.xxx * r6.xyz;
                    r0.w = v0.x + v0.y;
                    r0.w = m_sBranch1.m_fTime + r0.w;
                    if (r5.y != 0)
                    {
                        r7.x = v6.y + r0.w;
                        r7.y = r0.w * m_sBranch1.m_fTwitchFreqScale + v6.y;
                        r2.w = m_sBranch1.m_fTwitchFreqScale * r7.x;
                        r7.z = 0.5 * r2.w;
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
                        r2.w = cmp(r8.w < 0);
                        r8.y = -r8.w;
                        r8.xz = float2(-1, 1);
                        r5.yw = r2.ww ? r8.xy : r8.zw;
                        r2.w = -r7.z * r7.w + r5.y;
                        r2.w = r5.w * r2.w + r8.w;
                        r3.w = r5.y + -r2.w;
                        r2.w = r5.w * r3.w + r2.w;
                        r2.w = m_sBranch1.m_fTwitch * r2.w;
                        r3.w = 1 + -m_fStrength;
                        r4.w = 1 + -m_sBranch1.m_fTwitch;
                        r4.w = r7.y * r4.w;
                        r2.w = r2.w * r3.w + r4.w;
                        r3.w = m_sBranch1.m_fWhip * r7.x;
                        r3.w = r3.w * v6.x + 1;
                        r3.w = r3.w * r2.w;
                        r2.w = r5.x ? r3.w : r2.w;
                    }
                    else
                    {
                        r8.x = v6.y + r0.w;
                        r8.y = r0.w * 0.68900001 + v6.y;
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
                        r3.w = r7.z * r7.y + r7.y;
                        r4.w = m_sBranch1.m_fWhip * r7.x;
                        r4.w = r4.w * v6.x + 1;
                        r4.w = r4.w * r3.w;
                        r2.w = r5.x ? r4.w : r3.w;
                    }
                    r6.xyz = r6.xyz * r2.www;
                    r6.xyz = r6.xyz * m_sBranch1.m_fDistance + r2.xyz;
                    r8.x = r0.w * 0.100000001 + v6.y;
                    r0.w = m_sBranch1.m_fTurbulence * m_fWallTime;
                    r8.y = r0.w * 0.100000001 + v6.y;
                    r5.yw = float2(0.5, 0.5) + r8.xy;
                    r5.yw = frac(r5.yw);
                    r5.yw = r5.yw * float2(2, 2) + float2(-1, -1);
                    r7.yz = abs(r5.yw) * abs(r5.yw);
                    r5.yw = -abs(r5.yw) * float2(2, 2) + float2(3, 3);
                    r5.yw = r7.yz * r5.yw + float2(-0.5, -0.5);
                    r5.yw = r5.yw + r5.yw;
                    r5.yw = r5.yw * r5.yw;
                    r0.w = r5.w * r5.y;
                    r0.w = -r0.w * m_sBranch1.m_fTurbulence + 1;
                    r0.w = r5.z ? r0.w : 1;
                    r2.w = m_fStrength * r7.x;
                    r2.w = r2.w * m_sBranch1.m_fWhip + r0.w;
                    r0.w = r5.x ? r2.w : r0.w;
                    r5.xyz = m_vAnchor.xyz + -r6.xyz;
                    r5.xyz = m_sBranch1.m_fDirectionAdherence * r5.xyz;
                    r5.xyz = r5.xyz * r0.www;
                    r3.xyz = r5.xyz * v6.xxx + r6.xyz;
                }
                else
                {
                    r3.xyz = r2.xyz;
                }
            }
        }
        r0.w = cmp(0.5 < m_avWindConfigFlags[2].x);
        if (r0.w != 0)
        {
            r5.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[3].xy);
            r6.xyz = float3(0.0625, 1, 16) * v6.www;
            r6.xyz = frac(r6.xyz);
            r6.xyz = r6.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
            r6.xyz = v6.zzz * r6.xyz;
            r0.w = v0.x + v0.y;
            r0.w = m_sBranch2.m_fTime + r0.w;
            if (r5.y != 0)
            {
                r7.x = v6.w + r0.w;
                r7.y = r0.w * m_sBranch2.m_fTwitchFreqScale + v6.w;
                r2.w = m_sBranch2.m_fTwitchFreqScale * r7.x;
                r7.z = 0.5 * r2.w;
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
                r2.w = cmp(r8.w < 0);
                r8.y = -r8.w;
                r8.xz = float2(-1, 1);
                r5.yz = r2.ww ? r8.xy : r8.zw;
                r2.w = -r7.y * r7.z + r5.y;
                r2.w = r5.z * r2.w + r8.w;
                r3.w = r5.y + -r2.w;
                r2.w = r5.z * r3.w + r2.w;
                r2.w = m_sBranch2.m_fTwitch * r2.w;
                r3.w = 1 + -m_fStrength;
                r4.w = 1 + -m_sBranch2.m_fTwitch;
                r4.w = r7.x * r4.w;
                r2.w = r2.w * r3.w + r4.w;
                r3.w = m_sBranch2.m_fWhip * r7.w;
                r3.w = r3.w * v6.z + 1;
                r3.w = r3.w * r2.w;
                r2.w = r5.x ? r3.w : r2.w;
            }
            else
            {
                r7.x = v6.w + r0.w;
                r7.y = r0.w * 0.68900001 + v6.w;
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
                r0.w = r5.z * r5.y + r5.y;
                r3.w = m_sBranch2.m_fWhip * r5.w;
                r3.w = r3.w * v6.z + 1;
                r3.w = r3.w * r0.w;
                r2.w = r5.x ? r3.w : r0.w;
            }
            r5.xyz = r6.xyz * r2.www;
            r3.xyz = r5.xyz * m_sBranch2.m_fDistance + r3.xyz;
        }
        else
        {
            r0.w = cmp(0.5 < m_avWindConfigFlags[2].y);
            if (r0.w != 0)
            {
                r5.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[3].xy);
                r0.w = cmp(0.5 < m_avWindConfigFlags[2].w);
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
                    r7.xyzw = r5.xxxx ? r8.wxyz : r7.wxyz;
                    r8.w = r7.z * r7.w;
                    r3.w = cmp(r8.w < 0);
                    r8.y = -r8.w;
                    r8.xz = float2(-1, 1);
                    r5.yz = r3.ww ? r8.xy : r8.zw;
                    r3.w = -r7.z * r7.w + r5.y;
                    r3.w = r5.z * r3.w + r8.w;
                    r4.w = r5.y + -r3.w;
                    r3.w = r5.z * r4.w + r3.w;
                    r3.w = m_sBranch2.m_fTwitch * r3.w;
                    r4.w = 1 + -m_fStrength;
                    r5.y = 1 + -m_sBranch2.m_fTwitch;
                    r5.y = r7.y * r5.y;
                    r3.w = r3.w * r4.w + r5.y;
                    r4.w = m_sBranch2.m_fWhip * r7.x;
                    r4.w = r4.w * v6.z + 1;
                    r4.w = r4.w * r3.w;
                    r3.w = r5.x ? r4.w : r3.w;
                }
                else
                {
                    r8.x = v6.w + r2.w;
                    r8.y = r2.w * 0.68900001 + v6.w;
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
                    r4.w = r7.z * r7.y + r7.y;
                    r5.y = m_sBranch2.m_fWhip * r7.x;
                    r5.y = r5.y * v6.z + 1;
                    r5.y = r5.y * r4.w;
                    r3.w = r5.x ? r5.y : r4.w;
                }
                r5.yzw = r6.xyz * r3.www;
                r5.yzw = r5.yzw * m_sBranch2.m_fDistance + r3.xyz;
                r6.x = r2.w * 0.100000001 + v6.w;
                r2.w = m_sBranch2.m_fTurbulence * m_fWallTime;
                r6.y = r2.w * 0.100000001 + v6.w;
                r6.xy = float2(0.5, 0.5) + r6.xy;
                r6.xy = frac(r6.xy);
                r6.xy = r6.xy * float2(2, 2) + float2(-1, -1);
                r6.zw = abs(r6.xy) * abs(r6.xy);
                r6.xy = -abs(r6.xy) * float2(2, 2) + float2(3, 3);
                r6.xy = r6.zw * r6.xy + float2(-0.5, -0.5);
                r6.xy = r6.xy + r6.xy;
                r6.xy = r6.xy * r6.xy;
                r2.w = r6.y * r6.x;
                r2.w = -r2.w * m_sBranch2.m_fTurbulence + 1;
                r0.w = r0.w ? r2.w : 1;
                r2.w = m_fStrength * r7.x;
                r2.w = r2.w * m_sBranch2.m_fWhip + r0.w;
                r0.w = r5.x ? r2.w : r0.w;
                r6.xyz = m_sBranch2.m_fDirectionAdherence * m_vDirection.xyz;
                r6.xyz = r6.xyz * r0.www;
                r3.xyz = r6.xyz * v6.zzz + r5.yzw;
            }
            else
            {
                r0.w = cmp(0.5 < m_avWindConfigFlags[2].z);
                if (r0.w != 0)
                {
                    r5.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[3].xy);
                    r0.w = cmp(0.5 < m_avWindConfigFlags[2].w);
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
                        r7.xyzw = r5.xxxx ? r8.wxyz : r7.wxyz;
                        r8.w = r7.z * r7.w;
                        r3.w = cmp(r8.w < 0);
                        r8.y = -r8.w;
                        r8.xz = float2(-1, 1);
                        r5.yz = r3.ww ? r8.xy : r8.zw;
                        r3.w = -r7.z * r7.w + r5.y;
                        r3.w = r5.z * r3.w + r8.w;
                        r4.w = r5.y + -r3.w;
                        r3.w = r5.z * r4.w + r3.w;
                        r3.w = m_sBranch2.m_fTwitch * r3.w;
                        r4.w = 1 + -m_fStrength;
                        r5.y = 1 + -m_sBranch2.m_fTwitch;
                        r5.y = r7.y * r5.y;
                        r3.w = r3.w * r4.w + r5.y;
                        r4.w = m_sBranch2.m_fWhip * r7.x;
                        r4.w = r4.w * v6.z + 1;
                        r4.w = r4.w * r3.w;
                        r3.w = r5.x ? r4.w : r3.w;
                    }
                    else
                    {
                        r8.x = v6.w + r2.w;
                        r8.y = r2.w * 0.68900001 + v6.w;
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
                        r4.w = r7.z * r7.y + r7.y;
                        r5.y = m_sBranch2.m_fWhip * r7.x;
                        r5.y = r5.y * v6.z + 1;
                        r5.y = r5.y * r4.w;
                        r3.w = r5.x ? r5.y : r4.w;
                    }
                    r5.yzw = r6.xyz * r3.www;
                    r5.yzw = r5.yzw * m_sBranch2.m_fDistance + r3.xyz;
                    r6.x = r2.w * 0.100000001 + v6.w;
                    r2.w = m_sBranch2.m_fTurbulence * m_fWallTime;
                    r6.y = r2.w * 0.100000001 + v6.w;
                    r6.xy = float2(0.5, 0.5) + r6.xy;
                    r6.xy = frac(r6.xy);
                    r6.xy = r6.xy * float2(2, 2) + float2(-1, -1);
                    r6.zw = abs(r6.xy) * abs(r6.xy);
                    r6.xy = -abs(r6.xy) * float2(2, 2) + float2(3, 3);
                    r6.xy = r6.zw * r6.xy + float2(-0.5, -0.5);
                    r6.xy = r6.xy + r6.xy;
                    r6.xy = r6.xy * r6.xy;
                    r2.w = r6.y * r6.x;
                    r2.w = -r2.w * m_sBranch2.m_fTurbulence + 1;
                    r0.w = r0.w ? r2.w : 1;
                    r2.w = m_fStrength * r7.x;
                    r2.w = r2.w * m_sBranch2.m_fWhip + r0.w;
                    r0.w = r5.x ? r2.w : r0.w;
                    r6.xyz = m_vAnchor.xyz + -r5.yzw;
                    r6.xyz = m_sBranch2.m_fDirectionAdherence * r6.xyz;
                    r6.xyz = r6.xyz * r0.www;
                    r3.xyz = r6.xyz * v6.zzz + r5.yzw;
                }
            }
        }
        r3.xyz = r3.xyz + -r2.xyz;
    }
    else
    {
        r3.xyz = float3(0, 0, 0);
    }
    r0.w = cmp(0.5 < m_avWindLodFlags[0].w);
    if (r0.w != 0)
    {
        r5.xyz = r1.xyz * r1.www + r2.xyz;
    }
    else
    {
        r0.w = cmp(0.5 < m_avWindLodFlags[1].x);
        if (r0.w != 0)
        {
            r6.xyz = r3.xyz + r1.xyz;
            r5.xyz = r6.xyz * r1.www + r2.xyz;
        }
        else
        {
            r0.w = cmp(v4.x < 0.5);
            r0.w = r0.w ? 0.750000 : 0;
            r2.w = m_sFrondRipple.m_fTime * v4.y;
            r0.w = r2.w * m_sFrondRipple.m_fTile + r0.w;
            r0.w = 0.5 + r0.w;
            r0.w = frac(r0.w);
            r0.w = r0.w * 2 + -1;
            r2.w = abs(r0.w) * abs(r0.w);
            r0.w = -abs(r0.w) * 2 + 3;
            r0.w = r2.w * r0.w + -0.5;
            r0.w = v5.z * r0.w;
            r0.w = dot(m_sFrondRipple.m_fDistance, r0.ww);
            r6.xyz = r0.www * r4.xyz;
            r7.xy = cmp(float2(0.5, 0.5) < m_avWindConfigFlags[6].xy);
            r0.w = m_sFrondRipple.m_fTime * v5.w;
            r0.w = r0.w * m_sFrondRipple.m_fTile + 0.5;
            r0.w = frac(r0.w);
            r0.w = r0.w * 2 + -1;
            r2.w = abs(r0.w) * abs(r0.w);
            r0.w = -abs(r0.w) * 2 + 3;
            r0.w = r2.w * r0.w + -0.5;
            r0.w = v5.z * r0.w;
            r8.xyz = float3(0.0625, 1, 16) * v5.yyy;
            r8.xyz = frac(r8.xyz);
            r8.xyz = r8.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
            r0.w = dot(m_sFrondRipple.m_fDistance, r0.ww);
            r8.xyz = r0.www * r8.xyz;
            r7.yzw = r7.yyy ? r8.xyz : 0;
            r6.xyz = r7.xxx ? r6.xyz : r7.yzw;
            r0.w = cmp(0.5 < m_avWindLodFlags[1].y);
            if (r0.w != 0)
            {
                r7.xyz = r3.xyz + r1.xyz;
                r7.xyz = r7.xyz + r6.xyz;
                r5.xyz = r7.xyz * r1.www + r2.xyz;
            }
            else
            {
                r0.w = cmp(0.5 < m_avWindLodFlags[1].z);
                if (r0.w != 0)
                {
                    r7.xyz = r3.xyz * r1.www + r1.xyz;
                    r5.xyz = r7.xyz + r2.xyz;
                }
                else
                {
                    r0.w = cmp(0.5 < m_avWindLodFlags[1].w);
                    r7.xyz = r6.xyz + r3.xyz;
                    r7.xyz = r7.xyz * r1.www + r1.xyz;
                    r7.xyz = r7.xyz + r2.xyz;
                    r2.w = cmp(0.5 < m_avWindLodFlags[2].x);
                    r3.xyz = r3.xyz + r1.xyz;
                    r8.xyz = r6.xyz * r1.www + r3.xyz;
                    r8.xyz = r8.xyz + r2.xyz;
                    r1.xyz = r2.xyz + r1.xyz;
                    r9.xyz = r3.xyz + r2.xyz;
                    r10.xyz = cmp(float3(0.5, 0.5, 0.5) < m_avWindLodFlags[0].xyz);
                    r3.xyz = r3.xyz + r6.xyz;
                    r3.xyz = r3.xyz + r2.xyz;
                    r2.xyz = r10.zzz ? r3.xyz : r2.xyz;
                    r2.xyz = r10.yyy ? r9.xyz : r2.xyz;
                    r1.xyz = r10.xxx ? r1.xyz : r2.xyz;
                    r1.xyz = r2.www ? r8.xyz : r1.xyz;
                    r5.xyz = r0.www ? r7.xyz : r1.xyz;
                }
            }
        }
    }
    r1.xyz = r5.xyz * v0.www + v0.xyz;
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
    o2.w = v7.w * 2 + -1;
    o2.xyz = r4.xyz;
    o5.w = 1;
    o6.w = v3.z;
    o6.xyz = r1.xyz;
    o7.yzw = float3(0, 0, 0);

    current_frame_position = o0.xyw;

    [branch]
    if (distance_squared < 16384) // Square(128)
    {
        previous_frame_position = ComputePreviousFramePosition(v0, v1, v2, v3, v4, v5, v6, v7, v8);
    }
    else
    {
        previous_frame_position = current_frame_position;
    }
    
}
