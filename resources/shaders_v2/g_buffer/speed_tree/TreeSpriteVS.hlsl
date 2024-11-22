
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


#define cmp -


void VSMain(
  float4 v0 : TEXCOORD1,
  float4 v1 : TEXCOORD2,
  float4 v2 : TEXCOORD3,
  float4 v3 : POSITION0,
  float2 v4 : TEXCOORD0,
  out float4 o0 : SV_POSITION0,
  out float4 o1 : TEXCOORD0,
  out float4 o2 : TEXCOORD1,
  out float4 o3 : TEXCOORD2,
  out float4 o4 : TEXCOORD3,
  out float3 o5 : TEXCOORD4)
{
    float4 r0, r1, r2, r3, r4, r5;

    float3 world_position = v0.xyz;

    float3 view_direction = normalize(world_position.xyz - m_vCameraPosition.xyz);

    r0.xyz = m_vLodRefPosition.xyz + -v0.xyz;
    r0.x = dot(r0.xyz, r0.xyz);
    r0.x = sqrt(r0.x);
    r0.y = cmp(r0.x < m_fBillboardStartDist);
    r0.y = r0.y ? 0 : v0.w;
    r0.x = -m_fBillboardStartDist + r0.x;
    //r0.z = dot(m_vCameraDirection.xyz, v1.xyz);
    r0.z = dot(view_direction.xyz, v1.xyz);
    r1.xy = cmp(float2(0.5, 0.5) < m_avEffectConfigFlags[3].xw);
    r0.z = -m_fBillboardHorzFade + abs(r0.z);
    r0.xz = saturate(r0.xz / m_fBillboardRange);
    r0.z = 1.5 * r0.z;
    r0.z = r1.x ? r0.z : 1;
    r0.w = cmp(v3.w < 0.5);
    r0.w = r0.w ? r1.x : 0;
    if (r0.w != 0)
    {
        r2.xyz = v2.yzx * v1.zxy;
        r2.xyz = v1.yzx * v2.zxy + -r2.xyz;
        r0.w = dot(r2.xyz, r2.xyz);
        r0.w = rsqrt(r0.w);
        r2.xyz = r2.xyz * r0.www;
        r0.w = min(1, r0.z);
        r0.w = r0.x * r0.w;
        r3.xyz = v2.xyz;
        o1.xy = v4.xy;
    }
    else
    {
        r4.xyz = v2.yzx * v1.zxy;
        r4.xyz = v1.yzx * v2.zxy + -r4.xyz;
        r1.z = dot(r4.xyz, r4.xyz);
        r1.z = rsqrt(r1.z);
        r4.xyz = r4.xyz * r1.zzz;
        r5.xyz = -m_vCameraPosition.xyz + v0.xyz;
        r1.z = dot(r5.xyz, r5.xyz);
        r1.z = rsqrt(r1.z);
        r5.xyz = r5.xyz * r1.zzz;
        r1.z = dot(-r5.xyz, v1.xyz);
        r5.xyz = -r1.zzz * v1.xyz + -r5.xyz;
        r1.z = dot(r5.xyz, r5.xyz);
        r1.z = rsqrt(r1.z);
        r5.xyz = r5.xyz * r1.zzz;
        r1.z = dot(v2.xyz, r5.xyz);
        r1.w = 1 + -abs(r1.z);
        r1.w = sqrt(r1.w);
        r2.w = abs(r1.z) * -0.0187292993 + 0.0742610022;
        r2.w = r2.w * abs(r1.z) + -0.212114394;
        r2.w = r2.w * abs(r1.z) + 1.57072878;
        r3.w = r2.w * r1.w;
        r3.w = r3.w * -2 + 3.14159274;
        r1.z = cmp(r1.z < -r1.z);
        r1.z = r1.z ? r3.w : 0;
        r1.z = r2.w * r1.w + r1.z;
        r1.w = dot(r4.xyz, r5.xyz);
        r1.w = cmp(r1.w < 0);
        r2.w = 6.28318548 + -r1.z;
        r1.z = r1.w ? r2.w : r1.z;
        r1.w = 3.14159274 / m_fNumBillboards;
        r1.z = r1.z + r1.w;
        r1.z = 0.159154937 * r1.z;
        r1.w = cmp(r1.z >= -r1.z);
        r1.z = frac(abs(r1.z));
        r1.z = r1.w ? r1.z : -r1.z;
        r1.z = 6.28318548 * r1.z;
        r1.z = r1.z / m_fRadiansPerImage;
        r1.z = (int) r1.z;
        r1.w = cmp(m_avBillboardTexCoords[r1.z].x < 0);
        r4.x = m_avBillboardTexCoords[r1.z].z * v4.y + -m_avBillboardTexCoords[r1.z].x;
        r4.yzw = m_avBillboardTexCoords[r1.z].wzw * v4.xxy + m_avBillboardTexCoords[r1.z].yxy;
        o1.xy = r1.ww ? r4.xy : r4.zw;
        //r1.z = dot(m_vCameraDirection.xy, m_vCameraDirection.xy);
        r1.z = dot(view_direction.xy, view_direction.xy);
        r1.z = rsqrt(r1.z);
        //r4.xy = m_vCameraDirection.xy;
        r4.xy = view_direction.xy;
        r4.z = 0;
        r2.xyz = r4.xyz * r1.zzz;
        r4.xyz = v1.zxy * r2.yzx;
        r4.xyz = v1.yzx * r2.zxy + -r4.xyz;
        r1.z = dot(-r4.xyz, -r4.xyz);
        r1.z = rsqrt(r1.z);
        r3.xyz = -r4.xyz * r1.zzz;
        r0.z = 1.5 + -r0.z;
        r0.z = min(1, r0.z);
        r0.z = r1.x ? r0.z : 1;
        r0.w = r0.x * r0.z;
    }
    r1.xzw = v3.yyy * r2.xyz;
    r1.xzw = r3.xyz * v3.xxx + r1.xzw;
    r1.xzw = v1.xyz * v3.zzz + r1.xzw;
    r0.x = 1 / m_sGlobal.m_fHeight;
    r0.x = -r0.x * 0.25 + r1.w;
    r0.x = max(0, r0.x);
    r0.x = m_sGlobal.m_fHeight * r0.x;
    r0.z = cmp(r0.x != 0.000000);
    r2.x = log2(abs(r0.x));
    r2.x = m_sGlobal.m_fHeightExponent * r2.x;
    r2.x = exp2(r2.x);
    r0.x = r0.z ? r2.x : r0.x;
    r2.x = m_sGlobal.m_fTime + v0.x;
    r2.y = m_sGlobal.m_fTime * 0.800000012 + v0.y;
    r2.xy = float2(0.5, 0.5) + r2.xy;
    r2.xy = frac(r2.xy);
    r2.xy = r2.xy * float2(2, 2) + float2(-1, -1);
    r2.zw = abs(r2.xy) * abs(r2.xy);
    r2.xy = -abs(r2.xy) * float2(2, 2) + float2(3, 3);
    r2.xy = r2.zw * r2.xy + float2(-0.5, -0.5);
    r2.xy = r2.xy + r2.xy;
    r0.z = r2.y * r2.y + r2.x;
    r2.x = m_sGlobal.m_fAdherence / m_sGlobal.m_fHeight;
    r0.z = m_sGlobal.m_fDistance * r0.z + r2.x;
    r0.x = r0.z * r0.x;
    r0.xz = m_vDirection.xy * r0.xx;
    r2.xz = m_mCameraFacingMatrix._m01_m02;
    r2.yw = m_mCameraFacingMatrix._m11_m12;
    r2.x = dot(r0.xz, r2.xy);
    r3.x = m_mCameraFacingMatrix._m01 * r2.x;
    r3.y = m_mCameraFacingMatrix._m11 * r2.x;
    r3.z = m_mCameraFacingMatrix._m21 * r2.x;
    r0.x = dot(r0.xz, r2.zw);
    r2.x = m_mCameraFacingMatrix._m02 * r0.x;
    r2.y = m_mCameraFacingMatrix._m12 * r0.x;
    r2.z = m_mCameraFacingMatrix._m22 * r0.x;
    r2.xyz = r3.xyz + r2.xyz;
    r1.xzw = r2.xyz + r1.xzw;
    r0.xyz = r1.xzw * r0.yyy + v0.xyz;
    o1.z = m_fAlphaScalar * r0.w;
    r1.xzw = cmp(v2.xyz >= -v2.xyz);
    r2.xyz = frac(abs(v2.xyz));
    r1.xzw = r1.xzw ? r2.xyz : -r2.xyz;
    r1.xzw = m_fHueVariationByPos * r1.xzw;
    r1.xzw = m_vHueVariationColor.xyz * r1.xzw;
    o3.xyz = r1.yyy ? r1.xzw : 0;
    r0.xyz = -m_vCameraPosition.xyz + r0.xyz;
    r0.w = 1;
    o0.x = dot(m_mModelViewProj3d._m00_m01_m02_m03, r0.xyzw);
    o0.y = dot(m_mModelViewProj3d._m10_m11_m12_m13, r0.xyzw);
    o0.z = dot(m_mModelViewProj3d._m20_m21_m22_m23, r0.xyzw);
    o0.w = dot(m_mModelViewProj3d._m30_m31_m32_m33, r0.xyzw);
    r0.xyz = v2.xxx * float3(0.5, 0.5, 0.5) + float3(0.5, 0.166669995, -0.166660011);
    r0.w = saturate(3 * r0.x);
    r0.x = 1 + -r0.x;
    r0.x = saturate(3 * r0.x);
    o4.x = -r0.w * r0.x + 1;
    r0.xy = -abs(r0.yz) * float2(3, 3) + float2(1, 1);
    o4.yz = max(float2(0, 0), r0.xy);
    o4.w = 1;
    o2.xyz = v1.xyz;
    o5.xyz = v0.xyz;
    return;
}