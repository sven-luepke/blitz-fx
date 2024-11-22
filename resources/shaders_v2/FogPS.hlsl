#include "GameData.hlsli"
#include "Common.hlsli"
#include "FogCommon.hlsli"
#include "WaterCommon.hlsli"

cbuffer cbuffer3 : register(b3)
{
    float4 cb3_v0 : packoffset(c0.x);
    float4 cb3_v1 : packoffset(c1.x);
};

Texture2D<float2> underwater_post_process_mask : register(t64);

Texture2D texDepth : register(t0);
Texture2D texColor : register(t1);
Texture2D texAO : register(t2);

SamplerState samplerPointClamp : register(s0);
SamplerState samplerPointWrap : register(s1);
SamplerState samplerLinearClamp : register(s2);
SamplerState samplerLinearWrap : register(s3);
SamplerState samplerAnisoClamp : register(s4);
SamplerState samplerAnisoWrap : register(s5);

struct VS_OUTPUT
{
    float4 PositionH : SV_Position;
    float2 Texcoords : Texcoord0;
};


float AdjustAmbientOcclusion(in float inputAO, in float worldToCameraDistance)
{
    // *** Inputs *** //
    const float aoDistanceStart = cb3_v0.x;
    const float aoDistanceEnd = cb3_v0.y;
    const float aoStrengthStart = cb3_v0.z;
    const float aoStrengthEnd = cb3_v0.w;
     
    // * Adjust AO
    float aoDistanceIntensity = Linearstep(aoDistanceStart, aoDistanceEnd, worldToCameraDistance);
    float aoStrength = lerp(aoStrengthStart, aoStrengthEnd, aoDistanceIntensity);
    float adjustedAO = lerp(1.0, inputAO, aoStrength);
    
    return adjustedAO;
}

float4 PSMain(in VS_OUTPUT Input) : SV_Target0
{
    // Get coordinates for load
    uint3 ssPosition = uint3((uint2) Input.PositionH.xy, 0);
    
    // Load depth from texture
    float hardwareDepth = texDepth.Load(ssPosition).x;
    
    // Calculate inverted depth
    float depthScale = cameraDepthRange.x;
    float depthBias = cameraDepthRange.y;
    float invDepth = hardwareDepth * depthScale + depthBias;
    
    // Output color
    float3 outColor = 0;
    
    [branch]
    if (invDepth < 1.0)
    {
        float3 worldPos = PixelToWorldPosition(ssPosition.xy, hardwareDepth);
        
        // Get HDR color
        float3 colorHDR = texColor.Load(ssPosition).rgb;
        
        // Get AO and adjust it
        float ao = texAO.Load(ssPosition).x;
        ao = max(cb3_v1.x, ao);
        ao = AdjustAmbientOcclusion(ao, length(worldPos - cameraPosition.xyz));

        FogResult fog = CalculateFog(worldPos, ao, false);
        // Mix fog with scene color
        outColor = ApplyFog(colorHDR, fog);

        // remove fog below the water surface
        float water_depth = _water_depth.Load(ssPosition);
        float mask = underwater_post_process_mask.SampleLevel(_linear_sampler, Input.Texcoords, 0);
        outColor = lerp(outColor, colorHDR, saturate(water_depth * 100 * mask));
    }
    
    return float4(outColor, 1.0);
}