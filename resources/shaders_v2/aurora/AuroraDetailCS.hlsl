#include "Noise.hlsli"
#include "GameData.hlsli"
#include "Common.hlsli"


RWTexture2D<float2> output : register(u0);

[numthreads(8, 8, 1)]
void CSMain(uint3 thread_id : SV_DispatchThreadID)
{
    float2 tex_coord = ThreadIdToTexCoord(thread_id.xy, 1.0f / 256.0f);

    float2 result;
    result.x = TileablePerlinFbm(float3(tex_coord.xy, game_time * 0.06), 2, 2.0, 0.5, 8);
    result.y = TileablePerlinFbm(float3(tex_coord.xy, game_time * 0.06 + 0.2), 2, 2.0, 0.5, 8);
    output[thread_id.xy] = result * 0.004;
}