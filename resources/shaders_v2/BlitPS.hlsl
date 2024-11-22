#include "Common.hlsli"

Texture2D<float4> source : register(t1);

void PSMain(BlitVSOutput input, out float4 output : SV_Target0)
{
    output = source.Load(uint3(input.position.xy, 0));
}