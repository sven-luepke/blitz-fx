#include "Common.hlsli"
#include "GBuffer.hlsli"
#include "CustomData.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float3> _previous_frame_raw_hdr_buffer;

cbuffer cb3 : register(b3)
{
float4 cb3[2];
}

SamplerState _linear_sampler;
SamplerState _point_sampler;

void PSMain(
    float4 v0 : SV_Position0,
    out float4 o0 : SV_Target0)
{
    float3 r0, r1;

    r0.xy = floor(v0.xy);

    float2 resolution_rcp = rcp(cb3[0].xy);
    float2 tex_coord = ThreadIdToTexCoord(r0.xy, resolution_rcp);
    float device_depth = _g_buffer_depth.SampleLevel(_point_sampler, tex_coord, 0);
    tex_coord = NdcXYToTexCoord(ComputeHistoryNdcUnjittered(tex_coord, device_depth).xy);

    float s = 0.5;
    r0.xyz = _previous_frame_raw_hdr_buffer.SampleLevel(_linear_sampler, mad(resolution_rcp, s * float2(-1.0, -1.0), tex_coord), 0);
    r0.xyz += _previous_frame_raw_hdr_buffer.SampleLevel(_linear_sampler, mad(resolution_rcp, s * float2(-1.0, 1.0), tex_coord), 0);
    r0.xyz += _previous_frame_raw_hdr_buffer.SampleLevel(_linear_sampler, mad(resolution_rcp, s * float2(1.0, -1.0), tex_coord), 0);
    r0.xyz += _previous_frame_raw_hdr_buffer.SampleLevel(_linear_sampler, mad(resolution_rcp, s * float2(1.0, 1.0), tex_coord), 0);
    r0.xyz *= 0.25;

    //r1.x = dot(float3(0.333330005, 0.333330005, 0.333330005), r0.xyz);
    //r1.y = min(32, r1.x);
    //r1.x = max(0.00001, r1.x);
    //r1.x = r1.y / r1.x;
    o0.xyz = r0.xyz;
    o0.w = 0;
    return;
}
