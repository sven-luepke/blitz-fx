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

cbuffer PigmentConsts : register(b11)
{
float4 pigmentWorldAreaScaleBias : packoffset(c0);
row_major float4x4 m_transformMatrices[16] : packoffset(c1);
uint m_activeCollisionsNum : packoffset(c65);
float4 terrainNormalsAreaParams : packoffset(c66);
float4 terrainNormalsParams : packoffset(c67);
float4 alphaScalarMulParams : packoffset(c68);
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

SamplerState TerrainPigmentSmp_s : register(s3);
SamplerState TerrainNormalsSmp_s : register(s4);
Texture2D<float4> TerrainPigmentTex : register(t3);
Texture2DArray<float2> TerrainNormalsTex : register(t4);

#define cmp -

float3 ComputePreviousFramePosition(float4 v0, float4 v1, float4 v2, float4 v3, float4 v4, float4 v5, float4 v6, float4 v7, float4 v9,
                                    float world_distance_squared)
{
    float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9;

    r0.xyz = v9.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
    r0.w = floor(v1.w);
    r0.w = v1.w + -r0.w;
    r0.w = 1.33333337 * r0.w;
    r1.xyz = v2.yzx * v1.zxy;
    r1.xyz = v1.yzx * v2.zxy + -r1.xyz;
    r1.w = dot(r1.xyz, r1.xyz);
    r1.w = rsqrt(r1.w);
    r1.xyz = r1.xyz * r1.www;
    r2.xyz = v3.yyy * r1.xyz;
    r2.xyz = v2.xyz * v3.xxx + r2.xyz;
    r2.xyz = v1.xyz * v3.zzz + r2.xyz;
    r3.xyz = r1.xyz * r0.yyy;
    r3.xyz = v2.xyz * r0.xxx + r3.xyz;
    r3.xyz = v1.xyz * r0.zzz + r3.xyz;
    r1.w = cmp(0.5 < m_avWindLodFlags[2].w);
    if (r1.w != 0)
    {
        r4.xyz = cmp(float3(0.5, 0.5, 0.5) < m_avWindConfigFlags[1].zwy);
        r5.xyz = float3(0.0625, 1, 16) * v7.yyy;
        r5.xyz = frac(r5.xyz);
        r5.xyz = r5.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
        r5.xyz = v7.xxx * r5.xyz;
        r1.w = v0.x + v0.y;
        r1.w = previous_m_sBranch1.m_fTime + r1.w;
        if (r4.y != 0)
        {
            r6.x = v7.y + r1.w;
            r6.y = r1.w * previous_m_sBranch1.m_fTwitchFreqScale + v7.y;
            r2.w = previous_m_sBranch1.m_fTwitchFreqScale * r6.x;
            r6.z = 0.5 * r2.w;
            r6.w = -v7.x + r6.x;
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
            r6.xyzw = r4.xxxx ? r7.wxyz : r6.wxyz;
            r7.w = r6.z * r6.w;
            r2.w = cmp(r7.w < 0);
            r7.y = -r7.w;
            r7.xz = float2(-1, 1);
            r4.yw = r2.ww ? r7.xy : r7.zw;
            r2.w = -r6.z * r6.w + r4.y;
            r2.w = r4.w * r2.w + r7.w;
            r4.y = r4.y + -r2.w;
            r2.w = r4.w * r4.y + r2.w;
            r2.w = previous_m_sBranch1.m_fTwitch * r2.w;
            r4.y = 1 + -previous_m_fStrength;
            r4.w = 1 + -previous_m_sBranch1.m_fTwitch;
            r4.w = r6.y * r4.w;
            r2.w = r2.w * r4.y + r4.w;
            r4.y = previous_m_sBranch1.m_fWhip * r6.x;
            r4.y = r4.y * v7.x + 1;
            r4.y = r4.y * r2.w;
            r2.w = r4.x ? r4.y : r2.w;
        }
        else
        {
            r7.x = v7.y + r1.w;
            r7.y = r1.w * 0.68900001 + v7.y;
            r7.z = -v7.x + r7.x;
            r8.xyz = float3(0.5, 0.5, 1.5) + r7.xyz;
            r8.xyz = frac(r8.xyz);
            r8.xyz = r8.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
            r9.xyz = abs(r8.xyz) * abs(r8.xyz);
            r8.xyz = -abs(r8.xyz) * float3(2, 2, 2) + float3(3, 3, 3);
            r8.xyz = r9.xyz * r8.xyz + float3(-0.5, -0.5, -0.5);
            r8.xyz = r8.xyz + r8.xyz;
            r4.yw = float2(0.5, 0.5) + r7.xy;
            r4.yw = frac(r4.yw);
            r4.yw = r4.yw * float2(2, 2) + float2(-1, -1);
            r7.xy = abs(r4.yw) * abs(r4.yw);
            r4.yw = -abs(r4.yw) * float2(2, 2) + float2(3, 3);
            r7.xy = r7.xy * r4.yw;
            r7.z = 0;
            r7.xyz = float3(-0.5, -0.5, -0.5) + r7.xyz;
            r7.xyz = r7.xyz + r7.xyz;
            r6.xyz = r4.xxx ? r8.zxy : r7.zxy;
            r4.y = r6.z * r6.y + r6.y;
            r4.w = previous_m_sBranch1.m_fWhip * r6.x;
            r4.w = r4.w * v7.x + 1;
            r4.w = r4.y * r4.w;
            r2.w = r4.x ? r4.w : r4.y;
        }
        r5.xyz = r5.xyz * r2.www;
        r5.xyz = r5.xyz * previous_m_sBranch1.m_fDistance + r2.xyz;
        r7.x = r1.w * 0.100000001 + v7.y;
        r1.w = previous_m_sBranch1.m_fTurbulence * m_fWallTime;
        r7.y = r1.w * 0.100000001 + v7.y;
        r4.yw = float2(0.5, 0.5) + r7.xy;
        r4.yw = frac(r4.yw);
        r4.yw = r4.yw * float2(2, 2) + float2(-1, -1);
        r6.yz = abs(r4.yw) * abs(r4.yw);
        r4.yw = -abs(r4.yw) * float2(2, 2) + float2(3, 3);
        r4.yw = r6.yz * r4.yw + float2(-0.5, -0.5);
        r4.yw = r4.yw + r4.yw;
        r4.yw = r4.yw * r4.yw;
        r1.w = r4.w * r4.y;
        r1.w = -r1.w * previous_m_sBranch1.m_fTurbulence + 1;
        r1.w = r4.z ? r1.w : 1;
        r2.w = previous_m_fStrength * r6.x;
        r2.w = r2.w * previous_m_sBranch1.m_fWhip + r1.w;
        r1.w = r4.x ? r2.w : r1.w;
        r4.xyz = previous_m_sBranch1.m_fDirectionAdherence * previous_m_vDirection.xyz;
        r4.xyz = r4.xyz * r1.www;
        r4.xyz = r4.xyz * v7.xxx + r5.xyz;
        r4.xyz = r4.xyz + -r2.xyz;
    }
    else
    {
        r4.xyz = float3(0, 0, 0);
    }
    r1.w = cmp(v5.x == 1.000000);
    r2.w = cmp(v4.x < 0.5);
    r2.w = r2.w ? 0.750000 : 0;
    r4.w = previous_m_sFrondRipple.m_fTime * v4.y;
    r2.w = r4.w * previous_m_sFrondRipple.m_fTile + r2.w;
    r2.w = 0.5 + r2.w;
    r2.w = frac(r2.w);
    r2.w = r2.w * 2 + -1;
    r4.w = abs(r2.w) * abs(r2.w);
    r2.w = -abs(r2.w) * 2 + 3;
    r2.w = r4.w * r2.w + -0.5;
    r2.w = v6.z * r2.w;
    r2.w = dot(previous_m_sFrondRipple.m_fDistance, r2.ww);
    r5.xyz = r2.www * r3.xyz;
    r5.xyz = r1.www ? r5.xyz : 0;
    r4.xyz = r5.xyz + r4.xyz;
    r2.xyz = r4.xyz + r2.xyz;
    r1.w = cmp(0.5 < m_avEffectConfigFlags[2].z);
    r2.w = 1 + -v6.x;
    r2.w = r0.w * r2.w + v6.x;
    r4.xy = v5.yz * r2.ww;
    r4.xy = r1.ww ? r4.xy : v5.yz;
    r4.z = -r4.x;
    r4.w = 1;
    r5.x = dot(m_mCameraFacingMatrix._m02_m01_m03, r4.yzw);
    r4.xyz = float3(-1, 1, 1) * r4.xyw;
    r5.y = dot(m_mCameraFacingMatrix._m11_m12_m13, r4.xyz);
    r5.z = dot(m_mCameraFacingMatrix._m21_m22_m23, r4.xyz);
    r2.xyz = r5.xyz + r2.xyz;
    r2.xyz = v5.www * m_vCameraDirection.xyz + r2.xyz;
    r2.xyz = r2.xyz * v0.www + v0.xyz;
    r1.w = dot(r3.xy, r3.xy);
    r1.w = rsqrt(r1.w);
    r4.xy = r3.xy * r1.ww;
    r1.w = saturate(v3.z);
    r1.w = log2(r1.w);
    r1.w = 1.5 * r1.w;
    r1.w = exp2(r1.w);
    r2.w = 1 + v3.z;
    r5.xy = float2(0, 0);
    r6.zw = float2(0, 0);
    r4.z = 0;

    [branch]
    if (world_distance_squared < 256) // Square(16)
    {
        while (true)
        {
            r4.w = cmp((uint) r4.z >= m_activeCollisionsNum);
            if (r4.w != 0)
                break;
            r4.w = (uint) r4.z << 2;
            r7.xyz = -m_transformMatrices[r4.w / 4]._m30_m31_m32 + r2.xyz;
            r7.w = dot(r7.xyz, m_transformMatrices[r4.w / 4]._m00_m01_m02);
            r8.x = dot(m_transformMatrices[r4.w / 4]._m00_m01_m02, m_transformMatrices[r4.w / 4]._m00_m01_m02);
            r8.x = r7.w / r8.x;
            r7.w = dot(r7.xyz, m_transformMatrices[r4.w / 4]._m10_m11_m12);
            r8.w = dot(m_transformMatrices[r4.w / 4]._m10_m11_m12, m_transformMatrices[r4.w / 4]._m10_m11_m12);
            r8.y = r7.w / r8.w;
            r7.w = dot(r7.xyz, m_transformMatrices[r4.w / 4]._m20_m21_m22);
            r8.w = dot(m_transformMatrices[r4.w / 4]._m20_m21_m22, m_transformMatrices[r4.w / 4]._m20_m21_m22);
            r8.z = r7.w / r8.w;
            r7.w = dot(r8.xyz, r8.xyz);
            r7.w = rsqrt(r7.w);
            r8.xyz = r8.xyz * r7.www;
            r9.xyz = m_transformMatrices[r4.w / 4]._m10_m11_m12 * r8.yyy;
            r8.xyw = m_transformMatrices[r4.w / 4]._m00_m01_m02 * r8.xxx + r9.xyz;
            r8.xyz = m_transformMatrices[r4.w / 4]._m20_m21_m22 * r8.zzz + r8.xyw;
            r7.w = dot(r7.xyz, r8.xyz);
            r8.w = dot(r8.xyz, r8.xyz);
            r7.w = r7.w / r8.w;
            r8.w = cmp(r7.w < 1);
            r9.xyz = r8.xyz + -r7.xyz;
            r7.x = dot(r9.xyz, r9.xyz);
            r6.xy = r5.xy;
            r7.y = dot(r6.xyz, r6.xyz);
            r7.xy = sqrt(r7.xy);
            r7.x = cmp(r7.y < r7.x);
            r7.y = rsqrt(r7.w);
            r7.y = 1 / r7.y;
            r7.y = 1 + -r7.y;
            r7.y = r7.y * -r2.w;
            r4.w = cmp(0 >= m_transformMatrices[r4.w / 4]._m33);
            r4.w = r4.w ? 1.000000 : 0;
            r9.w = r7.y * r4.w;
            r7.xyzw = r7.xxxx ? r9.xyzw : r6.xyzw;
            r6.xyzw = r8.wwww ? r7.xyzw : r6.xyzw;
            r4.z = (int) r4.z + 1;
            r5.xy = r6.xy;
        }
    }

    r5.w = abs(r6.z);
    r5.z = -r5.w;
    r1.w = m_vLavaCustomBaseTreeParams.z * r1.w;
    r2.w = dot(r5.xyz, r5.xyz);
    r2.w = sqrt(r2.w);
    r1.w = r2.w * r1.w;
    r4.xy = float2(0.200000003, 0.200000003) * r4.xy;
    r4.z = 0;
    r4.xyz = r5.xyw * float3(0.800000012, 0.800000012, -0.800000012) + r4.xyz;
    r4.xy = r4.xy * r1.ww;
    r4.w = r1.w * r4.z + r6.w;
    r4.xyz = max(float3(-1.25, -1.25, -1.25), r4.xyw);
    r4.xyz = min(float3(1.25, 1.25, 1.25), r4.xyz);
    r2.xyz = r4.xyz + r2.xyz;

    r1.xyz = -m_vCameraPosition.xyz + r2.xyz;
    r1.w = 1;

    float3 position;

    position.x = dot(m_mModelViewProj3d._m00_m01_m02_m03, r1.xyzw);
    position.y = dot(m_mModelViewProj3d._m10_m11_m12_m13, r1.xyzw);
    //position.z = dot(m_mModelViewProj3d._m20_m21_m22_m23, r1.xyzw);
    //position.w = dot(m_mModelViewProj3d._m30_m31_m32_m33, r1.xyzw);
    position.z = dot(m_mModelViewProj3d._m30_m31_m32_m33, r1.xyzw);

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
    float4 v10 : TEXCOORD9,
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
    float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9;

    r0.xyz = v9.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
    r0.w = floor(v1.w);
    r0.w = v1.w + -r0.w;
    r0.w = 1.33333337 * r0.w;
    r1.xyz = v2.yzx * v1.zxy;
    r1.xyz = v1.yzx * v2.zxy + -r1.xyz;
    r1.w = dot(r1.xyz, r1.xyz);
    r1.w = rsqrt(r1.w);
    r1.xyz = r1.xyz * r1.www;
    r2.xyz = v3.yyy * r1.xyz;
    r2.xyz = v2.xyz * v3.xxx + r2.xyz;
    r2.xyz = v1.xyz * v3.zzz + r2.xyz;
    r3.xyz = r1.xyz * r0.yyy;
    r3.xyz = v2.xyz * r0.xxx + r3.xyz;
    r3.xyz = v1.xyz * r0.zzz + r3.xyz;
    r1.w = cmp(0.5 < m_avWindLodFlags[2].w);
    if (r1.w != 0)
    {
        r4.xyz = cmp(float3(0.5, 0.5, 0.5) < m_avWindConfigFlags[1].zwy);
        r5.xyz = float3(0.0625, 1, 16) * v7.yyy;
        r5.xyz = frac(r5.xyz);
        r5.xyz = r5.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
        r5.xyz = v7.xxx * r5.xyz;
        r1.w = v0.x + v0.y;
        r1.w = m_sBranch1.m_fTime + r1.w;
        if (r4.y != 0)
        {
            r6.x = v7.y + r1.w;
            r6.y = r1.w * m_sBranch1.m_fTwitchFreqScale + v7.y;
            r2.w = m_sBranch1.m_fTwitchFreqScale * r6.x;
            r6.z = 0.5 * r2.w;
            r6.w = -v7.x + r6.x;
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
            r6.xyzw = r4.xxxx ? r7.wxyz : r6.wxyz;
            r7.w = r6.z * r6.w;
            r2.w = cmp(r7.w < 0);
            r7.y = -r7.w;
            r7.xz = float2(-1, 1);
            r4.yw = r2.ww ? r7.xy : r7.zw;
            r2.w = -r6.z * r6.w + r4.y;
            r2.w = r4.w * r2.w + r7.w;
            r4.y = r4.y + -r2.w;
            r2.w = r4.w * r4.y + r2.w;
            r2.w = m_sBranch1.m_fTwitch * r2.w;
            r4.y = 1 + -m_fStrength;
            r4.w = 1 + -m_sBranch1.m_fTwitch;
            r4.w = r6.y * r4.w;
            r2.w = r2.w * r4.y + r4.w;
            r4.y = m_sBranch1.m_fWhip * r6.x;
            r4.y = r4.y * v7.x + 1;
            r4.y = r4.y * r2.w;
            r2.w = r4.x ? r4.y : r2.w;
        }
        else
        {
            r7.x = v7.y + r1.w;
            r7.y = r1.w * 0.68900001 + v7.y;
            r7.z = -v7.x + r7.x;
            r8.xyz = float3(0.5, 0.5, 1.5) + r7.xyz;
            r8.xyz = frac(r8.xyz);
            r8.xyz = r8.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
            r9.xyz = abs(r8.xyz) * abs(r8.xyz);
            r8.xyz = -abs(r8.xyz) * float3(2, 2, 2) + float3(3, 3, 3);
            r8.xyz = r9.xyz * r8.xyz + float3(-0.5, -0.5, -0.5);
            r8.xyz = r8.xyz + r8.xyz;
            r4.yw = float2(0.5, 0.5) + r7.xy;
            r4.yw = frac(r4.yw);
            r4.yw = r4.yw * float2(2, 2) + float2(-1, -1);
            r7.xy = abs(r4.yw) * abs(r4.yw);
            r4.yw = -abs(r4.yw) * float2(2, 2) + float2(3, 3);
            r7.xy = r7.xy * r4.yw;
            r7.z = 0;
            r7.xyz = float3(-0.5, -0.5, -0.5) + r7.xyz;
            r7.xyz = r7.xyz + r7.xyz;
            r6.xyz = r4.xxx ? r8.zxy : r7.zxy;
            r4.y = r6.z * r6.y + r6.y;
            r4.w = m_sBranch1.m_fWhip * r6.x;
            r4.w = r4.w * v7.x + 1;
            r4.w = r4.y * r4.w;
            r2.w = r4.x ? r4.w : r4.y;
        }
        r5.xyz = r5.xyz * r2.www;
        r5.xyz = r5.xyz * m_sBranch1.m_fDistance + r2.xyz;
        r7.x = r1.w * 0.100000001 + v7.y;
        r1.w = m_sBranch1.m_fTurbulence * m_fWallTime;
        r7.y = r1.w * 0.100000001 + v7.y;
        r4.yw = float2(0.5, 0.5) + r7.xy;
        r4.yw = frac(r4.yw);
        r4.yw = r4.yw * float2(2, 2) + float2(-1, -1);
        r6.yz = abs(r4.yw) * abs(r4.yw);
        r4.yw = -abs(r4.yw) * float2(2, 2) + float2(3, 3);
        r4.yw = r6.yz * r4.yw + float2(-0.5, -0.5);
        r4.yw = r4.yw + r4.yw;
        r4.yw = r4.yw * r4.yw;
        r1.w = r4.w * r4.y;
        r1.w = -r1.w * m_sBranch1.m_fTurbulence + 1;
        r1.w = r4.z ? r1.w : 1;
        r2.w = m_fStrength * r6.x;
        r2.w = r2.w * m_sBranch1.m_fWhip + r1.w;
        r1.w = r4.x ? r2.w : r1.w;
        r4.xyz = m_sBranch1.m_fDirectionAdherence * m_vDirection.xyz;
        r4.xyz = r4.xyz * r1.www;
        r4.xyz = r4.xyz * v7.xxx + r5.xyz;
        r4.xyz = r4.xyz + -r2.xyz;
    }
    else
    {
        r4.xyz = float3(0, 0, 0);
    }
    r1.w = cmp(v5.x == 1.000000);
    r2.w = cmp(v4.x < 0.5);
    r2.w = r2.w ? 0.750000 : 0;
    r4.w = m_sFrondRipple.m_fTime * v4.y;
    r2.w = r4.w * m_sFrondRipple.m_fTile + r2.w;
    r2.w = 0.5 + r2.w;
    r2.w = frac(r2.w);
    r2.w = r2.w * 2 + -1;
    r4.w = abs(r2.w) * abs(r2.w);
    r2.w = -abs(r2.w) * 2 + 3;
    r2.w = r4.w * r2.w + -0.5;
    r2.w = v6.z * r2.w;
    r2.w = dot(m_sFrondRipple.m_fDistance, r2.ww);
    r5.xyz = r2.www * r3.xyz;
    r5.xyz = r1.www ? r5.xyz : 0;
    r4.xyz = r5.xyz + r4.xyz;
    r2.xyz = r4.xyz + r2.xyz;
    r1.w = cmp(0.5 < m_avEffectConfigFlags[2].z);
    r2.w = 1 + -v6.x;
    r2.w = r0.w * r2.w + v6.x;
    r4.xy = v5.yz * r2.ww;
    r4.xy = r1.ww ? r4.xy : v5.yz;
    r4.z = -r4.x;
    r4.w = 1;
    r5.x = dot(m_mCameraFacingMatrix._m02_m01_m03, r4.yzw);
    r4.xyz = float3(-1, 1, 1) * r4.xyw;
    r5.y = dot(m_mCameraFacingMatrix._m11_m12_m13, r4.xyz);
    r5.z = dot(m_mCameraFacingMatrix._m21_m22_m23, r4.xyz);
    r2.xyz = r5.xyz + r2.xyz;
    r2.xyz = v5.www * m_vCameraDirection.xyz + r2.xyz;
    r2.xyz = r2.xyz * v0.www + v0.xyz;
    r1.w = dot(r3.xy, r3.xy);
    r1.w = rsqrt(r1.w);
    r4.xy = r3.xy * r1.ww;
    r1.w = saturate(v3.z);
    r1.w = log2(r1.w);
    r1.w = 1.5 * r1.w;
    r1.w = exp2(r1.w);
    r2.w = 1 + v3.z;
    r5.xy = float2(0, 0);
    r6.zw = float2(0, 0);
    r4.z = 0;

    float3 view_vector = r2.xyz - m_vCameraPosition.xyz;
    float world_distance_squared = dot(view_vector, view_vector);

    [branch]
    if (world_distance_squared < 256)
    {
        while (true)
        {
            r4.w = cmp((uint) r4.z >= m_activeCollisionsNum);
            if (r4.w != 0)
                break;
            r4.w = (uint) r4.z << 2;
            r7.xyz = -m_transformMatrices[r4.w / 4]._m30_m31_m32 + r2.xyz;
            r7.w = dot(r7.xyz, m_transformMatrices[r4.w / 4]._m00_m01_m02);
            r8.x = dot(m_transformMatrices[r4.w / 4]._m00_m01_m02, m_transformMatrices[r4.w / 4]._m00_m01_m02);
            r8.x = r7.w / r8.x;
            r7.w = dot(r7.xyz, m_transformMatrices[r4.w / 4]._m10_m11_m12);
            r8.w = dot(m_transformMatrices[r4.w / 4]._m10_m11_m12, m_transformMatrices[r4.w / 4]._m10_m11_m12);
            r8.y = r7.w / r8.w;
            r7.w = dot(r7.xyz, m_transformMatrices[r4.w / 4]._m20_m21_m22);
            r8.w = dot(m_transformMatrices[r4.w / 4]._m20_m21_m22, m_transformMatrices[r4.w / 4]._m20_m21_m22);
            r8.z = r7.w / r8.w;
            r7.w = dot(r8.xyz, r8.xyz);
            r7.w = rsqrt(r7.w);
            r8.xyz = r8.xyz * r7.www;
            r9.xyz = m_transformMatrices[r4.w / 4]._m10_m11_m12 * r8.yyy;
            r8.xyw = m_transformMatrices[r4.w / 4]._m00_m01_m02 * r8.xxx + r9.xyz;
            r8.xyz = m_transformMatrices[r4.w / 4]._m20_m21_m22 * r8.zzz + r8.xyw;
            r7.w = dot(r7.xyz, r8.xyz);
            r8.w = dot(r8.xyz, r8.xyz);
            r7.w = r7.w / r8.w;
            r8.w = cmp(r7.w < 1);
            r9.xyz = r8.xyz + -r7.xyz;
            r7.x = dot(r9.xyz, r9.xyz);
            r6.xy = r5.xy;
            r7.y = dot(r6.xyz, r6.xyz);
            r7.xy = sqrt(r7.xy);
            r7.x = cmp(r7.y < r7.x);
            r7.y = rsqrt(r7.w);
            r7.y = 1 / r7.y;
            r7.y = 1 + -r7.y;
            r7.y = r7.y * -r2.w;
            r4.w = cmp(0 >= m_transformMatrices[r4.w / 4]._m33);
            r4.w = r4.w ? 1.000000 : 0;
            r9.w = r7.y * r4.w;
            r7.xyzw = r7.xxxx ? r9.xyzw : r6.xyzw;
            r6.xyzw = r8.wwww ? r7.xyzw : r6.xyzw;
            r4.z = (int) r4.z + 1;
            r5.xy = r6.xy;
        }
    }
    
    r5.w = abs(r6.z);
    r5.z = -r5.w;
    r1.w = m_vLavaCustomBaseTreeParams.z * r1.w;
    r2.w = dot(r5.xyz, r5.xyz);
    r2.w = sqrt(r2.w);
    r1.w = r2.w * r1.w;
    r4.xy = float2(0.200000003, 0.200000003) * r4.xy;
    r4.z = 0;
    r4.xyz = r5.xyw * float3(0.800000012, 0.800000012, -0.800000012) + r4.xyz;
    r4.xy = r4.xy * r1.ww;
    r4.w = r1.w * r4.z + r6.w;
    r4.xyz = max(float3(-1.25, -1.25, -1.25), r4.xyw);
    r4.xyz = min(float3(1.25, 1.25, 1.25), r4.xyz);
    r2.xyz = r4.xyz + r2.xyz;
    r4.xyz = m_vLodRefPosition.xyz + -r2.xyz;
    r1.w = dot(r4.xyz, r4.xyz);
    r1.w = sqrt(r1.w);
    r2.w = -m_f3dGrassStartDist + r1.w;
    r2.w = r2.w / m_f3dGrassRange;
    r2.w = saturate(1 + -r2.w);
    r2.w = m_fAlphaScalar * r2.w;
    r1.w = saturate(r1.w * alphaScalarMulParams.y + alphaScalarMulParams.z);
    r1.w = alphaScalarMulParams.x * r1.w + 1;
    o1.z = r2.w * r1.w;
    r4.xyz = cmp(v2.xyz >= -v2.xyz);
    r5.xyz = frac(abs(v2.xyz));
    r4.xyz = r4.xyz ? r5.xyz : -r5.xyz;
    r4.xyz = m_fHueVariationByPos * r4.xyz;
    r0.xyz = float3(20, 20, 20) * r0.xyz;
    r0.xyz = sin(r0.xyz);
    r0.xyz = m_fHueVariationByVertex * r0.xyz;
    r0.xyz = m_vHueVariationColor.xyz * r0.xyz;
    r0.xyz = r4.xyz * m_vHueVariationColor.xyz + r0.xyz;
    r1.w = cmp(1.5 < m_avEffectConfigFlags[3].w);
    r4.xyz = saturate(r0.www * r0.xyz);
    o4.xyz = r1.www ? r4.xyz : r0.xyz;
    r0.xyz = v2.xxx * float3(0.5, 0.5, 0.5) + float3(0.5, 0.166669995, -0.166660011);
    r1.w = saturate(3 * r0.x);
    r0.x = 1 + -r0.x;
    r0.x = saturate(3 * r0.x);
    r2.w = r1.w * r0.x;
    r4.x = -r2.w;
    o5.x = -r1.w * r0.x + 1;
    r0.xy = -abs(r0.yz) * float2(3, 3) + float2(1, 1);
    r4.yz = max(float2(0, 0), r0.xy);
    r0.x = cmp(0 < m_vLavaCustomBaseTreeParams.w);
    if (r0.x != 0)
    {
        r0.xy = v0.xy * terrainNormalsAreaParams.xx + terrainNormalsAreaParams.yz;
        r5.xy = float2(-0.5, -0.5) + r0.xy;
        r5.xy = cmp(abs(r5.xy) < float2(0.5, 0.5));
        r1.w = r5.y ? r5.x : 0;
        if (r1.w != 0)
        {
            r0.z = terrainNormalsAreaParams.w;
            r0.xy = TerrainNormalsTex.SampleLevel(TerrainNormalsSmp_s, r0.xyz, 0).xy;
            r4.xw = float2(0.5, -0.5) + r4.xy;
            r3.xy = r4.xw * terrainNormalsParams.xx + r0.xy;
            r0.x = dot(r3.xy, r3.xy);
            r0.x = min(1, r0.x);
            r0.x = 1 + -r0.x;
            r3.z = sqrt(r0.x);
        }
        else
        {
            r3.xyz = float3(0, 0, 1);
        }
        r0.xyz = -r3.xyz * r3.xxx + float3(1, 0, 0);
        r1.w = dot(r0.xyz, r0.xyz);
        r1.w = rsqrt(r1.w);
        o3.xyz = r1.www * r0.xyz;
    }
    else
    {
        r0.xyz = v10.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
        r1.xyz = r1.xyz * r0.yyy;
        r1.xyz = v2.xyz * r0.xxx + r1.xyz;
        o3.xyz = v1.xyz * r0.zzz + r1.xyz;
    }

    r1.xyz = -m_vCameraPosition.xyz + r2.xyz;
    r1.w = 1;
    o0.x = dot(m_mModelViewProj3d._m00_m01_m02_m03, r1.xyzw);
    o0.y = dot(m_mModelViewProj3d._m10_m11_m12_m13, r1.xyzw);
    o0.z = dot(m_mModelViewProj3d._m20_m21_m22_m23, r1.xyzw);
    o0.w = dot(m_mModelViewProj3d._m30_m31_m32_m33, r1.xyzw);
    r0.xy = v0.xy * pigmentWorldAreaScaleBias.xy + pigmentWorldAreaScaleBias.zw;
    r1.xy = float2(-0.5, -0.5) + r0.xy;
    r1.xy = cmp(abs(r1.xy) < float2(0.5, 0.5));
    r0.z = r1.y ? r1.x : 0;
    if (r0.z != 0)
    {
        r0.xyz = TerrainPigmentTex.SampleLevel(TerrainPigmentSmp_s, r0.xy, 0).xyz;
        o7.xyz = r0.xyz;
        o7.w = 1;
    }
    else
    {
        o7.xyzw = float4(0, 0, 0, 0);
    }
    o1.xy = v4.xy;
    o1.w = r0.w;
    r3.w = v9.w * 2 + -1;
    o2.xyzw = r3.xyzw;
    o5.yz = r4.yz;
    o5.w = 1;
    o6.w = v3.z;
    o6.xyz = r2.xyz;

    current_frame_position = o0.xyw;

    [branch]
    if (world_distance_squared < 2304) // Square(48)
    {
        previous_frame_position = ComputePreviousFramePosition(v0, v1, v2, v3, v4, v5, v6, v7, v9, world_distance_squared);
    }
    else
    {
        previous_frame_position = current_frame_position;
    }
    
}
