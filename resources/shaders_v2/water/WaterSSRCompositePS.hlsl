#include "GBuffer.hlsli"
#include "CustomData.hlsli"

Texture2D<float4> previous_ssr_texture : register(t2);
Texture2D<float4> current_ssr_texture : register(t1);
Texture2D<float4> water_normal_texture : register(t0);

cbuffer cb3 : register(b3)
{
float4 cb3[9];
}


#define cmp -

SamplerState _point_sampler;
SamplerState _linear_sampler;

void PSMain(
    float4 sv_position : SV_Position0,
    out float4 o0 : SV_Target0)
{
    float4 r0, r1, r2, r3, r4, r5, r6;

    float2 tex_coord = ThreadIdToTexCoord(sv_position.xy, rcp(cb3[0].xy));
    float device_depth = _g_buffer_depth.SampleLevel(_point_sampler, tex_coord, 0);
    float2 history_tex_coord = NdcXYToTexCoord(ComputeHistoryNdc(tex_coord, device_depth).xy);
    float alpha;
    if (any(history_tex_coord <= 0 || history_tex_coord >= 1 - rcp(cb3[0].xy)))
    {
        alpha = 0;
    }
    else
    {
        alpha = Alpha(0.5);
    }
    history_tex_coord *= cb3[8].xy;

    r0.zw = float2(0, 0);
    r1.xy = (uint2)sv_position.xy;
    r2.xyzw = (int4)r1.xyxy + int4(-1, 0, -1, -1);
    r0.xy = r2.zw;
    r0.xyz = current_ssr_texture.Load(r0.xyz).xyz;
    r1.zw = float2(0, 0);
    r3.xyz = current_ssr_texture.Load(r1.xyw).xyz;

    r4.xyz = previous_ssr_texture.Load(r1.xyz).xyz;
    r4.xyz = previous_ssr_texture.Sample(_linear_sampler, history_tex_coord);

    r5.xyz = min(r3.xyz, r0.xyz);
    r0.xyz = max(r3.xyz, r0.xyz);
    r2.zw = float2(0, 0);
    r2.xyz = current_ssr_texture.Load(r2.xyz).xyz;
    r5.xyz = min(r5.xyz, r2.xyz);
    r0.xyz = max(r2.xyz, r0.xyz);
    r2.zw = float2(0, 0);
    r6.xyzw = (int4)r1.xyxy + int4(0, -1, -1, 1);
    r2.xy = r6.zw;
    r2.xyz = current_ssr_texture.Load(r2.xyz).xyz;
    r5.xyz = min(r5.xyz, r2.xyz);
    r0.xyz = max(r2.xyz, r0.xyz);
    r6.zw = float2(0, 0);
    r2.xyz = current_ssr_texture.Load(r6.xyz).xyz;
    r5.xyz = min(r5.xyz, r2.xyz);
    r0.xyz = max(r2.xyz, r0.xyz);
    r0.xyz = max(r0.xyz, r3.xyz);
    r2.xyz = min(r5.xyz, r3.xyz);
    r5.zw = float2(0, 0);
    r6.xyzw = (int4)r1.xyxy + int4(1, -1, 0, 1);
    r5.xy = r6.zw;
    r5.xyz = current_ssr_texture.Load(r5.xyz).xyz;
    r2.xyz = min(r5.xyz, r2.xyz);
    r0.xyz = max(r5.xyz, r0.xyz);
    r6.zw = float2(0, 0);
    r5.xyz = current_ssr_texture.Load(r6.xyz).xyz;
    r2.xyz = min(r5.xyz, r2.xyz);
    r0.xyz = max(r5.xyz, r0.xyz);
    r5.xyzw = (int4)r1.xyxy + int4(1, 1, 1, 0);
    r1.xy = (int2)r1.xy;
    r1.xy = cb3[8].zw * r1.xy;
    r1.xy = (uint2)r1.xy;
    r6.xy = r5.zw;
    r6.zw = float2(0, 0);
    r6.xyz = current_ssr_texture.Load(r6.xyz).xyz;
    r2.xyz = min(r6.xyz, r2.xyz);
    r0.xyz = max(r6.xyz, r0.xyz);
    r5.zw = float2(0, 0);
    r5.xyz = current_ssr_texture.Load(r5.xyz).xyz;
    r2.xyz = min(r5.xyz, r2.xyz);
    r0.xyz = max(r5.xyz, r0.xyz);

    // neighborhood clamping
    r2.xyz = max(r4.xyz, r2.xyz);
    r0.xyz = min(r2.xyz, r0.xyz);

    r1.zw = float2(0, 0);
    r0.w = water_normal_texture.Sample(_linear_sampler, tex_coord).w;
    r0.w = cmp(0 < r0.w);
    r0.w = r0.w ? 1.000000 : 0;

    r0.xyz = r0.xyz + -r4.xyz;
    r0.xyz = r0.www * r0.xyz + r4.xyz;

    o0.xyz = lerp(r3.xyz, r0.xyz, alpha);
    o0.w = 1;
}
