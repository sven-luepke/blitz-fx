#ifndef FOG_COMMON_HLSLI
#define FOG_COMMON_HLSLI

#include "GameData.hlsli"

struct FogResult
{
    float4 paramsFog;
    float4 paramsAerial;
};

float4 SelectDensityParams(const bool isSky)
{
    if (isSky)
        return fogDensityParamsSky;
    else
        return fogDensityParamsScene;
}

FogResult CalculateFog(float3 fragPosWorldSpace, float ao, const bool isSky)
{
    float3 camPos = cameraPosition.xyz;
    float fogStartDist = near_plane;
    float3 GlobalLightDirection = fogSunDir;
    
    float4 density_params = SelectDensityParams(isSky);

    float density = density_params.x;
    float dist_clamp = fogBaseParams.z;
    float final_exp_fog = fogBaseParams.w;
    float final_exp_aerial = aerialParams.x;

    float3 frag_vec = fragPosWorldSpace.xyz - camPos.xyz;
    float frag_dist = length(frag_vec);
    
    float3 frag_dir = frag_vec / frag_dist;
    
    camPos += frag_dir * fogStartDist;
    frag_dist = max(0, frag_dist - fogStartDist);

    frag_dist = (isSky) ? dist_clamp : min(dist_clamp, frag_dist);
    frag_vec = frag_dir * frag_dist;

    const float inv_num_samples = 1.0 / 16;
    float3 frag_step = frag_vec * inv_num_samples;
    float density_sample_scale = frag_dist * density * inv_num_samples;
    float dot_fragDirSunDir = dot(GlobalLightDirection.xyz, frag_dir);

    float density_factor = 1.0;
    {
        float density_shift = fogBaseParams.x;

        float fc_t = dot_fragDirSunDir;
        fc_t = (fc_t + density_shift) / (1.0 + density_shift);
        fc_t = saturate(fc_t);
        density_factor = lerp(density_params.z, density_params.y, fc_t);
    }

    float3 curr_col_fog;
    float3 curr_col_aerial;
    {
        float _dot = dot_fragDirSunDir;

        float _dd = _dot;
        {
            const float _distOffset = -150;
            const float _distRange = 500;
            const float _mul = 1.0 / _distRange;
            const float _bias = _distOffset * _mul;

            _dd = abs(_dd);
            _dd *= _dd;
            _dd *= saturate(frag_dist * _mul + _bias);
        }

        curr_col_fog = lerp(fogColorMiddle.xyz, (_dot > 0.0f ? fogColorFront.xyz : fogColorBack.xyz), _dd);
        curr_col_aerial = lerp(aerialColorMiddle.xyz, (_dot > 0.0f ? aerialColorFront.xyz : aerialColorBack.xyz), _dd);
    }

    float fog_amount = 1;
    float fog_amount_scale = 0;
    [branch]
    if (frag_dist >= aerialParams.y)
    {
        float curr_pos_z_base = (camPos.z + fogBaseParams.y) * density_factor;
        float curr_pos_z_step = frag_step.z * density_factor;

        [unroll]
        for (int i = 16; i > 0; --i)
        {
            fog_amount *= 1 - saturate(density_sample_scale / (1 + max(0.0, curr_pos_z_base + (i) * curr_pos_z_step)));
        }

        fog_amount = 1 - fog_amount;
        fog_amount_scale = saturate((frag_dist - aerialParams.y) * aerialParams.z);
    }

    FogResult ret;

    ret.paramsFog = float4(curr_col_fog, fog_amount_scale * pow(abs(fog_amount), final_exp_fog));
    ret.paramsAerial = float4(curr_col_aerial, fog_amount_scale * pow(abs(fog_amount), final_exp_aerial));
        
    // Override
    float fog_influence = ret.paramsFog.w; // r0.w

    float override1ColorScale = fogCustomRangesEnv0.x;
    float override1ColorBias = fogCustomRangesEnv0.y;
    float3 override1Color = fogCustomValuesEnv0.rgb;
	
    float override1InfluenceScale = fogCustomRangesEnv0.z;
    float override1InfluenceBias = fogCustomRangesEnv0.w;
    float override1Influence = fogCustomValuesEnv0.w;
	
	
    float override1ColorAmount = saturate(fog_influence * override1ColorScale + override1ColorBias);
    float override1InfluenceAmount = saturate(fog_influence * override1InfluenceScale + override1InfluenceBias);
    
    float4 paramsFogOverride;
    paramsFogOverride.rgb = lerp(curr_col_fog, override1Color, override1ColorAmount); // ***r5.xyz  
    

    float param1 = lerp(1.0, override1Influence, override1InfluenceAmount); // r0.x
    paramsFogOverride.w = saturate(fog_influence * param1); // ** r5.w

	
    const float extraFogOverride = mostImportantEnvsBlendParams.x;
	
    [branch] 
    if (extraFogOverride > 0.0)
    {
        float override2ColorScale = fogCustomRangesEnv1.x;
        float override2ColorBias = fogCustomRangesEnv1.y;
        float3 override2Color = fogCustomValuesEnv1.rgb;
	
        float override2InfluenceScale = fogCustomRangesEnv1.z;
        float override2InfluenceBias = fogCustomRangesEnv1.w;
        float override2Influence = fogCustomValuesEnv1.w;
		
        float override2ColorAmount = saturate(fog_influence * override2ColorScale + override2ColorBias);
        float override2InfluenceAmount = saturate(fog_influence * override2InfluenceScale + override2InfluenceBias);
     
        float4 paramsFogOverride2;
        paramsFogOverride2.rgb = lerp(curr_col_fog, override2Color, override2ColorAmount); // r3.xyz 
               
        float ov_param1 = lerp(1.0, override2Influence, override2InfluenceAmount); // r0.z
        paramsFogOverride2.w = saturate(fog_influence * ov_param1); // r3.w

        paramsFogOverride = lerp(paramsFogOverride, paramsFogOverride2, extraFogOverride);

    }
    ret.paramsFog = paramsFogOverride;

    ret.paramsFog.w *= ao;
    ret.paramsAerial.w *= ao;

    return ret;
}


float3 ApplyFog(float3 color, FogResult fog)
{
    const float3 LuminanceFactors = float3(0.333f, 0.555f, 0.222f);

    float3 aerialColor = dot(LuminanceFactors, color) * fog.paramsAerial.xyz;
    color = lerp(color, aerialColor, fog.paramsAerial.w);
    color = lerp(color, fog.paramsFog.xyz, fog.paramsFog.w);
    return color.xyz;
}

#endif