#include "Noise.hlsli"
#include "GameData.hlsli"
#include "Common.hlsli"

float GetBands(float2 position)
{
    return Rescale(0.5, 1, Square((sin(position.x) * 0.5 + 0.5)));
}

RWTexture2D<float> output : register(u0);

[numthreads(8, 8, 1)]
void CSMain( uint3 thread_id : SV_DispatchThreadID )
{
    float2 tex_coord = ThreadIdToTexCoord(thread_id.xy, 1.0f / 1024.0f);

    float shape = GetBands(tex_coord * 64 + 12 * GradientNoise(float3(tex_coord * 6.4, game_time * 0.01)));

    output[thread_id.xy] = shape;
}