#include "GameData.hlsli"
#include "WaterCommon.hlsli"

Texture2D<float2> under_water_mask_texture : register(t2);
Texture2D<float3> half_res_in_scattering_texture : register(t13);

Texture2D<float> half_res_depth_texture : register(t14);
Texture2D<float> full_res_depth_texture : register(t15);

RWTexture2D<float3> full_res_in_scattering_texture : register(u0);
RWTexture2D<float3> full_res_transmittance_texture : register(u1);

float2 GetUpperLeftCoord(float2 tex_coord)
{
    float2 half_res_texture_size = screenDimensions.xy * 0.5;
    return (floor(tex_coord * half_res_texture_size - 0.5f) + 0.5f) / half_res_texture_size;
}

float4 GetBillinearWeights(float2 tex_coord, float2 upper_left_tex_coord)
{
    float2 half_res_texture_size = screenDimensions.xy * 0.5;
    float2 frac_uv = frac((tex_coord - upper_left_tex_coord) * half_res_texture_size);
    float4 weights;
    weights.x = (1 - frac_uv.x) * (1 - frac_uv.y);
    weights.y = frac_uv.x * (1 - frac_uv.y);
    weights.z = (1 - frac_uv.x) * frac_uv.y;
    weights.w = frac_uv.x * frac_uv.y;
    return weights;
}

float4 GetDepthWeights(float reference_depth, float4 other_depths)
{
    float4 max_depths = max(reference_depth, other_depths);
    float4 min_depths = min(reference_depth, other_depths);
    return 1 - min(1, (max_depths / min_depths - 1.05) * 20);
}

int MaxIndex(float4 v)
{
    float current_max = -100000;
    int max_index = 0;
	[unroll]
    for (int i = 0; i < 4; i++)
    {
        if (v[i] > current_max)
        {
            current_max = v[i];
            max_index = i;
        }
    }
    return max_index;
}

float4 GetUpsampleWeights(float2 tex_coord, float full_res_depth)
{
    float2 upper_left_coord = GetUpperLeftCoord(tex_coord);
    float4 billinear_weigths = GetBillinearWeights(tex_coord, upper_left_coord);
	
    float4 sample_depths = DeviceToSceneDepth(half_res_depth_texture.GatherRed(_linear_sampler, tex_coord).wzxy);
    float4 depth_weights = GetDepthWeights(full_res_depth, sample_depths);

    float4 total_weights = billinear_weigths * depth_weights;
    if (total_weights.x + total_weights.y + total_weights.z + total_weights.w < 0.1)
    {
        int closest_depth_index = MaxIndex(depth_weights);
        switch (closest_depth_index)
        {
            case 0:
                total_weights = float4(1, 0, 0, 0);
                break;
            case 1:
                total_weights = float4(0, 1, 0, 0);
                break;
            case 2:
                total_weights = float4(0, 0, 1, 0);
                break;
            case 3:
            default:
                total_weights = float4(0, 0, 0, 1);
                break;
        }
    }
    return total_weights;
}

float3 UpsampleRaymarchResult(float2 tex_coord, float full_res_scene_depth)
{
	// bilateral upscale based on https://www.gdcvault.com/play/1022982/Mixed-Resolution-Rendering-in-Skylanders
    float2 upper_left_coord = GetUpperLeftCoord(tex_coord);
    float4 weights = GetUpsampleWeights(tex_coord, full_res_scene_depth);
	
    float2 row_sums = weights.xz + weights.yw;
    float2 row_offsets = weights.yw / max(row_sums, 0.0001);
    float2 row_weights = row_sums / max(row_sums.x + row_sums.y, 0.0001);
    float2 half_res_rcp = screenDimensions.zw * 2;

    float3 upper_row_result = half_res_in_scattering_texture.SampleLevel(_linear_sampler, upper_left_coord + float2(row_offsets.x, 0) * half_res_rcp, 0);
    float3 lower_row_result = half_res_in_scattering_texture.SampleLevel(_linear_sampler, upper_left_coord + float2(row_offsets.y, 1) * half_res_rcp, 0);
    float3 bilateral_upscaled = row_weights.x * upper_row_result + row_weights.y * lower_row_result;

    return bilateral_upscaled;
}

[numthreads(8, 8, 1)]
void CSMain( uint3 thread_id : SV_DispatchThreadID )
{
    float full_res_device_depth = full_res_depth_texture.Load(int3(thread_id.xy, 0));
    float3 world_position = ThreadIdDeviceDepthToWorldPosition(thread_id.xy, full_res_device_depth);

    float ray_length = distance(cameraPosition.xyz, world_position);

    float3 scattering, absorbtion;
    GetWaterScatteringAbsorbtion(scattering, absorbtion);
    float3 extinction = scattering + absorbtion;

    float2 tex_coord = ThreadIdToTexCoord(thread_id.xy, screenDimensions.zw);
    float2 underwater_mask = under_water_mask_texture.SampleLevel(_linear_sampler, tex_coord, 0).xy;

    full_res_transmittance_texture[thread_id.xy] = lerp(1, exp(-ray_length * extinction), Square(underwater_mask.x));

    float full_res_scene_depth = DeviceToSceneDepth(full_res_device_depth);
    full_res_in_scattering_texture[thread_id.xy] = UpsampleRaymarchResult(tex_coord, full_res_scene_depth);
}