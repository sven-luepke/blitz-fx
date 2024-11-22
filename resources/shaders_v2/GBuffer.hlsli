#ifndef G_BUFFER_HLSLI
#define G_BUFFER_HLSLI

Texture2D<float> _g_buffer_depth;
Texture2D<float4> _g_buffer_albedo_translucency;
Texture2D<float4> _g_buffer_normal_roughness;
Texture2D<uint2> _g_buffer_stencil; // the stencil mask is in the second channel
Texture2D<float4> _g_buffer_specular_mask;
Texture2D<float4> _ao_shadow_interior_mask;
Texture2D<float2> _g_buffer_velocity;

#define STENCIL_BIT_VEGETATION 0x01
#define STENCIL_BIT_CHARACTER 0x02
#define STENCIL_BIT_TERRAIN 0x40
#define STENCIL_BIT_CHARACTER_HAIR_SKIN 0x80

uint DecodeGBufferObjectMask(float g_buffer_mask_sample)
{
    return g_buffer_mask_sample * 255.0f + 0.5f;
}

float3 DecompressGBufferNormal(float3 g_buffer_normal)
{
    float3 normal = g_buffer_normal - 0.5;
    return normalize(normal);
}

#define G_BUFFER_OBJECT_MASK_GRASS 1
#define G_BUFFER_OBJECT_MASK_HIGH_RES_TREE 6
#define G_BUFFER_OBJECT_MASK_TREE_SPRITE 8
#define G_BUFFER_OBJECT_MASK_HAIR 128
#define G_BUFFER_OBJECT_MASK_TRANSLUCENT 255


#endif