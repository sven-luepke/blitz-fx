#include "GameData.hlsli"

Texture2D<float4> t24 : register(t24);
Texture2D<float4> t15 : register(t15);
Texture2D<float4> t2 : register(t2);
TextureCube<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);

Texture2D<float3> scene_texture : register(t50);

SamplerState s15_s : register(s15);
SamplerState s8_s : register(s8);
SamplerState s0_s : register(s0);

cbuffer cb13 : register(b13)
{
float4 cb13[35];
}
cbuffer cb4 : register(b4)
{
float4 cb4[14];
}
cbuffer cb12 : register(b12)
{
float4 cb12[68];
}
cbuffer cb2 : register(b2)
{
float4 cb2[3];
}
cbuffer cb1 : register(b1)
{
float4 cb1[9];
}
cbuffer cb0 : register(b0)
{
float4 cb0[10];
}

SamplerState _linear_mirror_sampler;

float3 ConvertNormal(float3 normal)
{
    float3 r1 = normal;
    r1.xyz = float3(-0.5, -0.5, -0.5) + r1.xyz;
    r1.xyz = cb4[4].xyz * r1.xyz;
    r1.xyz = r1.xyz + r1.xyz;
    float tmp = dot(r1.xyz, r1.xyz);
    tmp = rsqrt(tmp);
    r1.xyz = r1.xyz * tmp;

    return r1.xyz;
}

#define cmp -

void PSMain(
    float4 v0 : TEXCOORD0,
    float4 v1 : TEXCOORD1,
    float4 v2 : TEXCOORD2,
    float4 v3 : TEXCOORD3,
    float3 world_position : TEXCOORD4,
    float4 sv_position : SV_Position0,
    out float4 o0 : SV_Target0,
    out float responsive_aa_mask : SV_Target1)
{
    float4 r0, r1, r2, r3, r4;

    r0.xyz = cb1[8].xyz + -world_position.xyz;
    r0.w = dot(r0.xyz, r0.xyz);
    r0.w = rsqrt(r0.w);
    r0.xyz = r0.xyz * r0.www;
    r1.xy = cb4[3].xy * cb0[0].xx;
    r1.xy = v1.yz * cb4[2].xy + r1.xy;
    r2.x = 1 / cb4[4].x;
    r2.y = 1 / cb4[5].x;
    r0.w = floor(v1.x);
    r3.x = r0.w * r2.x;
    r0.w = v1.x * r2.x;
    r0.w = floor(r0.w);
    r3.y = r0.w * r2.y;
    r1.zw = r1.xy * r2.xy + r3.xy;

    float2 normal_tex_coord = r1.xy * r2.xy;
    float2 dx = ddx(normal_tex_coord.xy);
    float2 dy = ddy(normal_tex_coord.xy);

    float2 normal_tex_coord_0 = r1.zw;

    r0.w = 1 + v1.x;
    r1.z = floor(r0.w);
    r4.x = r1.z * r2.x;
    r0.w = r0.w * r2.x;
    r0.w = floor(r0.w);
    r4.y = r0.w * r2.y;
    r1.xy = r1.xy * r2.xy + r4.xy;

    float2 normal_tex_coord_1 = r1.xy;
    r0.w = frac(v1.x);

    r3.xyzw = t0.Sample(s0_s, normal_tex_coord_0 + dx * 0.25 + dy * 0.25).xyzw;
    r1.xyzw = t0.Sample(s0_s, normal_tex_coord_1 + dx * 0.25 + dy * 0.25).xyzw;
    r1.xyzw = r1.xyzw + -r3.xyzw;
    r1.xyzw = r0.wwww * r1.xyzw + r3.xyzw;

    float mask = r1.w * 0.5;

    r1.xyz = ConvertNormal(r1.xyz);

    float3 normal_0 = r1.xyz;

    r3.xyzw = t0.Sample(s0_s, normal_tex_coord_0 - dx * 0.25 - dy * 0.25).xyzw;
    r1.xyzw = t0.Sample(s0_s, normal_tex_coord_1 - dx * 0.25 - dy * 0.25).xyzw;
    r1.xyzw = r1.xyzw + -r3.xyzw;
    r1.xyzw = r0.wwww * r1.xyzw + r3.xyzw;

    mask += r1.w * 0.5;

    r1.xyz = ConvertNormal(r1.xyz);

    float3 normal_1 = r1.xyz;


    r0.w = dot(r0.xyz, r1.xyz);
    r0.w = r0.w + r0.w;
    r0.xyz = -r0.www * r1.xyz + r0.xyz;
    r0.xyz = -r0.xyz;
    r0.xyz = t1.Sample(s0_s, r0.xyz).xyz;
    r0.xyz = log2(r0.xyz);
    r0.xyz = cb4[7].xxx * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r0.xyz = cb4[8].xxx * r0.xyz;
    r0.xyz = v3.xyz * r0.xyz;
    r0.w = cb4[1].x + -cb4[0].x;
    r0.w = cb0[9].w * r0.w + cb4[0].x;
    r0.xyz = r0.www * r0.xyz;
    r1.xy = cb0[1].zw * sv_position.xy;
    r0.w = t15.SampleLevel(s15_s, r1.xy, 0).x;
    r0.w = r0.w * cb12[22].x + cb12[22].y;
    r0.w = r0.w * cb12[21].x + cb12[21].y;
    r0.w = max(9.99999975e-005, r0.w);
    r0.w = 1 / r0.w;
    r0.w = -v1.w + r0.w;
    r0.w = saturate(cb4[9].x * r0.w);
    r1.z = cmp(cb12[67].w >= 0);
    if (r1.z != 0)
    {
        r1.xy = t24.Sample(s8_s, r1.xy).xy;
        r2.xyz = -cb12[0].xyz + world_position.xyz;
        r1.z = dot(r2.xyz, r2.xyz);
        r1.z = sqrt(r1.z);
        r3.x = cb12[1].z;
        r3.y = cb12[2].z;
        r3.z = cb12[3].z;
        r2.x = dot(r3.xyz, r2.xyz);
        r2.y = 1 / cb12[21].y;
        r2.y = r2.y * r1.z;
        r2.x = r2.y / r2.x;
        r2.x = -r2.x + r1.z;
        r2.x = saturate(cb13[33].w * r2.x);
        r2.x = cb13[33].z * r2.x;
        r2.x = max(0.00100000005, r2.x);
        r1.z = r1.z / cb13[34].z;
        r2.y = cmp(r1.x < r1.y);
        if (r2.y != 0)
        {
            r2.yz = cmp(r1.zy < r1.xz);
            r2.w = cb13[34].z * r1.x + -cb13[34].x;
            r2.w = saturate(-r2.w * cb13[34].y + 1);
            r3.x = r1.z + -r1.x;
            r3.x = cb13[34].z * r3.x;
            r3.x = saturate(r3.x / r2.x);
            r3.y = r3.x * r2.w;
            r2.y = (int)r2.y | (int)r2.z;
            r3.x = 1;
            r2.yz = r2.yy ? float2(0, 1) : r3.xy;
        }
        else
        {
            r2.w = cmp(r1.y < r1.x);
            r3.xy = cmp(r1.zx < r1.yz);
            r1.x = cb13[34].z * r1.x + -cb13[34].x;
            r4.y = saturate(-r1.x * cb13[34].y + 1);
            r1.x = r1.z + -r1.y;
            r1.x = cb13[34].z * r1.x;
            r1.x = saturate(r1.x / r2.x);
            r4.w = 1 + -r1.x;
            r4.xz = float2(1, 1);
            r1.xy = r3.yy ? r4.xy : r4.zw;
            r1.xy = r3.xx ? float2(1, 1) : r1.xy;
            r2.yz = r2.ww ? r1.xy : float2(0, 1);
        }
        r1.x = -r2.z * r2.y + 1;
    }
    else
    {
        r1.x = 0;
    }
    r1.x = r1.x * r1.w + -r1.w;
    r1.x = cb4[10].x * r1.x + r1.w;
    r1.y = t2.Sample(s0_s, v1.yz).x;
    r1.z = r1.x * cb0[7].y + -r1.x;
    r1.x = cb4[11].x * r1.z + r1.x;
    r0.w = v3.w * r0.w + -1;
    r1.y = r1.x * r1.y + -r1.x;
    r1.x = cb4[12].x * r1.y + r1.x;
    r0.w = r1.x + r0.w;
    r0.w = saturate(cb4[13].x * r0.w);

    r0.xyz = mask;

    r0.xyz = r0.xyz * r0.www;
    r0.xyz = cb2[2].xyz * r0.xyz;
    r0.w = saturate(1 + -v2.w);
    r0.w = cb2[2].w * r0.w;
    o0.xyz = r0.xyz * r0.www;

    mask = o0.r * 200;
    if (mask <= 0)
    {
        discard;
    }

    float y_to_x_screen_ratio = screenDimensions.y * screenDimensions.z;
    float2 tex_coord = SvPositionToTexCoord(sv_position);
    float2 offset_0 = normal_0.xy * 0.3;
    offset_0.x *= y_to_x_screen_ratio;
    float3 refracted_color = scene_texture.SampleLevel(_linear_mirror_sampler, tex_coord + offset_0, 0);

    float2 offset_1 = normal_1.xy * 0.3;
    offset_1.x *= y_to_x_screen_ratio;
    refracted_color += scene_texture.SampleLevel(_linear_mirror_sampler, tex_coord + offset_1, 0);
    refracted_color *= 0.5;

    float alpha = min(1, mask * 2);

    o0.xyz = refracted_color * alpha;
    o0.w = alpha;

    responsive_aa_mask = min(1, alpha * 2);
}
