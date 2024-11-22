Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);

cbuffer cb12 : register(b12)
{
float4 cb12[214];
}

cbuffer cb3 : register(b3)
{
float4 cb3[3];
}

void PSMain(
    float4 sv_position : SV_Position0,
    out float4 o0 : SV_Target0,
    out float sv_depth : SV_Depth)
{
    o0.rgb = t0.Load(int3(sv_position.xy, 0)).xyz;
    o0.a = 0.0f;
    // overwrite sv_depth to disable depth culling
    sv_depth = 1.0f;
}
