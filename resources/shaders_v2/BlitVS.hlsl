#include "Common.hlsli"

void VSMain(uint vertex_id : SV_VertexID, out BlitVSOutput output)
{
    output.tex_coord = float2(vertex_id % 2, vertex_id >> 1) * 2;
    output.position = float4(output.tex_coord * 2 - 1, 1, 1);
    output.position.y *= -1;
}