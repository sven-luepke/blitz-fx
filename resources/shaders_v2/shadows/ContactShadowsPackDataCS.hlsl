#include "CustomData.hlsli"
#include "GameData.hlsli"
#include "ShadowCommon.hlsli"
#include "GBuffer.hlsli"

RWTexture2D<float2> depth_opacity : register(u0);

float PackNormalOpacity(float3 normal, float opacity)
{
    uint3 normal_int = normal * 255;
    uint opacity_int = opacity * 255;

    uint packed = opacity_int;
    packed |= normal_int.x << 8;
    packed |= normal_int.y << 16;
    packed |= normal_int.z << 24;

    return asfloat(packed);
}

[numthreads(8, 8, 1)]
void CSMain(uint3 thread_id : SV_DispatchThreadID)
{
    uint stencil_mask = _g_buffer_stencil.Load(int3(thread_id.xy, 0)).g;
    uint g_buffer_mask = DecodeGBufferObjectMask(_g_buffer_specular_mask.Load(int3(thread_id.xy, 0)).w);
    float scene_depth = DeviceToSceneDepth(_g_buffer_depth.Load(int3(thread_id.xy, 0)));

    float opacity = 1;
    if (g_buffer_mask == G_BUFFER_OBJECT_MASK_TRANSLUCENT)
    {
        opacity = 0;
    }
    else if (g_buffer_mask == G_BUFFER_OBJECT_MASK_HAIR)
    {
        opacity = 0;
    }
    else if (g_buffer_mask == G_BUFFER_OBJECT_MASK_GRASS)
    {
        opacity = 0.75;
    }
    else if (stencil_mask & STENCIL_BIT_TERRAIN)
    {
        opacity = Linearstep(160, 170, scene_depth);
    }
    else if (stencil_mask & STENCIL_BIT_CHARACTER_HAIR_SKIN)
    {
        opacity = 1;
    }
    else if (g_buffer_mask == G_BUFFER_OBJECT_MASK_TREE_SPRITE)
    {
        opacity = 1;
    }
    else
    {
        float translucency = _g_buffer_albedo_translucency.Load(int3(thread_id.xy, 0)).a;
        if (translucency > 0.25)
        {
            opacity = 1 - translucency;
        }
    }
    float3 normal = _g_buffer_normal_roughness.Load(int3(thread_id.xy, 0)).xyz;
    
    depth_opacity[thread_id.xy] = float2(scene_depth, PackNormalOpacity(normal, opacity));
}