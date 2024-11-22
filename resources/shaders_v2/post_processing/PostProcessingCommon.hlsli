#include "Noise.hlsli"
#include "Common.hlsli"
#include "GameData.hlsli"
#include "CustomData.hlsli"
#include "GBuffer.hlsli"

cbuffer cb3 : register(b3)
{
    float4 cb3[18];
}
float3 ApplyParametricColorBalance(float3 color)
{
    if (!enable_parametric_color_balance)
    {
        return color; // disable parametric balance
    }
   
    float4 r0;
    float4 r1;
    float4 r2;
    float4 r3;

    r0.xyz = color;

    r0.xyz = r0.xyz * cb3[14].xxx + cb3[14].yyy;
    r0.xyz = max(float3(0, 0, 0), r0.xyz);
    r0.xyz = log2(r0.xyz);
    r0.xyz = cb3[14].zzz * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r0.w = dot(float3(0.298999995, 0.587000012, 0.114), r0.xyz);
    r0.xyz = min(float3(1, 1, 1), r0.xyz);
    r0.xyz = log2(r0.xyz);
    r0.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r1.xy = -cb3[10].xz + r0.ww;
    r1.xy = saturate(cb3[10].yw * r1.xy);
    r2.xyzw = -cb3[12].xyzw + cb3[11].xyzw;
    r2.xyzw = r1.xxxx * r2.xyzw + cb3[12].xyzw;
    r3.xyzw = cb3[13].xyzw + -r2.xyzw;
    r1.xyzw = r1.yyyy * r3.xyzw + r2.xyzw;
    r0.w = dot(float3(0.212599993, 0.715200007, 0.0722000003), r0.xyz);
    r0.xyz = r0.xyz + -r0.www;
    r0.xyz = r0.xyz * r1.www + r0.www;
    r0.xyz = saturate(r0.xyz * r1.xyz);
    r0.xyz = log2(r0.xyz);
    r0.xyz = float3(0.454545468, 0.454545468, 0.454545468) * r0.xyz;
    r0.xyz = exp2(r0.xyz);

    return r0;
}

void ApplyPostProcessDithering(in uint2 pixel_coord, inout float3 color)
{
	// add dithering before quantizing to 8 bits
    float3 dither = GetStaticBlueNoise(pixel_coord);
    color += (dither * 2 - 0.5) / 255.0;
}

float GetCinematicBorder(uint2 pixel_coord)
{
    if (cinematic_border == 1)
    {
        return 1;
    }
    float half_res_height = screenDimensions.y * 0.5;
    float half_res_height_rcp = screenDimensions.w * 2;
    return abs(pixel_coord.y - half_res_height) * half_res_height_rcp < cinematic_border;
}

void ApplyDebugView(float2 sv_position, inout float3 color)
{
    [branch]
    if (debug_view_mode == DEBUG_VIEW_MODE_OFF)
    {
        return;
    }
    int3 load_coord = int3(sv_position.xy, 0);
    [branch]
    switch (debug_view_mode)
    {
        case DEBUG_VIEW_MODE_DEPTH:
            color = 1.0 / max(_g_buffer_depth.Load(load_coord).x, 0.001) / 1000.0;
            return;
        case DEBUG_VIEW_MODE_ALBEDO:
            color = _g_buffer_albedo_translucency.Load(load_coord).rgb;
            return;
        case DEBUG_VIEW_MODE_NORMAL:
            color = _g_buffer_normal_roughness.Load(load_coord).rgb;
            return;
        case DEBUG_VIEW_MODE_ROUGHNESS:
            color = _g_buffer_normal_roughness.Load(load_coord).a;
            return;
        case DEBUG_VIEW_MODE_SPECULAR:
            color = _g_buffer_specular_mask.Load(load_coord).rgb;
            return;
        case DEBUG_VIEW_MODE_AO:
            color = _ao_shadow_interior_mask.Load(load_coord).r;
            return;
        case DEBUG_VIEW_MODE_SHADOW:
            color = _ao_shadow_interior_mask.Load(load_coord).g;
            return;
    }
}