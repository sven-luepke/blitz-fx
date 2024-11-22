#include "GameData.hlsli"
#include "Noise.hlsli"

TextureCube<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

Texture2D<float3> aurora_texture : register(t32);

cbuffer cb12 : register(b12)
{
    float4 cb12[206];
}

cbuffer cb1 : register(b1)
{
    float4 cb1[9];
}

cbuffer cb0 : register(b0)
{
    float4 cb0[10];
}

SamplerState _linear_sampler;

#define cmp -

void PSMain(
  float4 v0 : TEXCOORD0,
  float3 world_position : TEXCOORD1,
  float4 sv_position : SV_Position0,
  out float4 o0 : SV_Target0)
{
    float4 r0, r1, r2, r3, r4, r5;

    r0.xyz = -cb12[0].xyz + world_position.xyz;
    r0.w = dot(r0.xyz, r0.xyz);
    r1.x = sqrt(r0.w);
    r1.xyz = r0.xyz / r1.xxx;

    float3 view_direction = r1.xyz;

    r0.x = dot(cb12[38].xyz, r1.xyz);
    r0.y = abs(r0.x) * abs(r0.x);
    r1.x = saturate(cb12[42].z * 0.00200000009 + -0.300000012);
    r0.y = r1.x * r0.y;
    r1.x = cmp(0 < r0.x);
    r1.xyw = r1.xxx ? cb12[39].xyz : cb12[41].xyz;
    r1.xyw = -cb12[40].xyz + r1.xyw;
    r1.xyw = r0.yyy * r1.xyw + cb12[40].xyz;
    r0.y = cmp(cb12[42].z >= cb12[48].y);
    if (r0.y != 0)
    {
        r0.y = r1.z * cb12[22].z + cb12[0].z;
        r1.z = cb12[42].z * r1.z;
        r1.z = 0.0625 * r1.z;
        r2.x = cb12[44].x * cb12[42].z;
        r2.x = 0.0625 * r2.x;
        r0.x = cb12[42].x + r0.x;
        r2.y = 1 + cb12[42].x;
        r0.x = saturate(r0.x / r2.y);
        r2.y = cb12[44].y + -cb12[44].z;
        r0.x = r0.x * r2.y + cb12[44].z;
        r0.y = cb12[42].y + r0.y;
        r2.y = r0.y * r0.x;
        r1.z = r1.z * r0.x;
        r3.xyzw = r1.zzzz * float4(16, 15, 14, 13) + r2.yyyy;
        r3.xyzw = max(float4(0, 0, 0, 0), r3.xyzw);
        r3.xyzw = float4(1, 1, 1, 1) + r3.xyzw;
        r3.xyzw = saturate(r2.xxxx / r3.xyzw);
        r3.xyzw = float4(1, 1, 1, 1) + -r3.xyzw;
        r2.z = r3.x * r3.y;
        r2.z = r2.z * r3.z;
        r2.z = r2.z * r3.w;
        r3.xyzw = r1.zzzz * float4(12, 11, 10, 9) + r2.yyyy;
        r3.xyzw = max(float4(0, 0, 0, 0), r3.xyzw);
        r3.xyzw = float4(1, 1, 1, 1) + r3.xyzw;
        r3.xyzw = saturate(r2.xxxx / r3.xyzw);
        r3.xyzw = float4(1, 1, 1, 1) + -r3.xyzw;
        r2.z = r3.x * r2.z;
        r2.z = r2.z * r3.y;
        r2.z = r2.z * r3.z;
        r2.z = r2.z * r3.w;
        r3.xyzw = r1.zzzz * float4(8, 7, 6, 5) + r2.yyyy;
        r3.xyzw = max(float4(0, 0, 0, 0), r3.xyzw);
        r3.xyzw = float4(1, 1, 1, 1) + r3.xyzw;
        r3.xyzw = saturate(r2.xxxx / r3.xyzw);
        r3.xyzw = float4(1, 1, 1, 1) + -r3.xyzw;
        r2.z = r3.x * r2.z;
        r2.z = r2.z * r3.y;
        r2.z = r2.z * r3.z;
        r2.z = r2.z * r3.w;
        r3.xy = r1.zz * float2(4, 3) + r2.yy;
        r3.xy = max(float2(0, 0), r3.xy);
        r3.xy = float2(1, 1) + r3.xy;
        r3.xy = saturate(r2.xx / r3.xy);
        r3.xy = float2(1, 1) + -r3.xy;
        r2.z = r3.x * r2.z;
        r2.z = r2.z * r3.y;
        r2.y = r1.z * 2 + r2.y;
        r2.y = max(0, r2.y);
        r2.y = 1 + r2.y;
        r2.y = saturate(r2.x / r2.y);
        r2.y = 1 + -r2.y;
        r2.y = r2.z * r2.y;
        r0.x = r0.y * r0.x + r1.z;
        r0.x = max(0, r0.x);
        r0.x = 1 + r0.x;
        r0.x = saturate(r2.x / r0.x);
        r0.x = 1 + -r0.x;
        r0.x = -r2.y * r0.x + 1;
        r0.y = -cb12[48].y + cb12[42].z;
        r0.y = saturate(cb12[48].z * r0.y);
    }
    else
    {
        r0.xy = float2(1, 0);
    }
    r0.x = log2(r0.x);
    r0.x = cb12[42].w * r0.x;
    r0.x = exp2(r0.x);
    r0.x = r0.y * r0.x;
    r2.xy = saturate(r0.xx * cb12[189].xz + cb12[189].yw);
    r3.xyz = cb12[188].xyz + -r1.xyw;
    r3.xyz = r2.xxx * r3.xyz + r1.xyw;
    r0.y = -1 + cb12[188].w;
    r0.y = r2.y * r0.y + 1;
    r3.w = saturate(r0.x * r0.y);
    r0.y = cmp(0 < cb12[192].x);
    if (r0.y != 0)
    {
        r2.xy = saturate(r0.xx * cb12[191].xz + cb12[191].yw);
        r4.xyz = cb12[190].xyz + -r1.xyw;
        r1.xyz = r2.xxx * r4.xyz + r1.xyw;
        r0.y = -1 + cb12[190].w;
        r0.y = r2.y * r0.y + 1;
        r1.w = saturate(r0.x * r0.y);
        r1.xyzw = r1.xyzw + -r3.xyzw;
        r3.xyzw = cb12[192].xxxx * r1.xyzw + r3.xyzw;
    }
    r1.xyz = cb12[0].xyz + -world_position.xyz;
    r0.x = dot(r1.xyz, r1.xyz);
    r0.x = rsqrt(r0.x);
    r1.xyz = r1.xyz * r0.xxx;
    r0.xy = saturate(cb12[205].yx);
    r1.w = dot(-r1.xyz, -r1.xyz);
    r1.w = rsqrt(r1.w);
    r1.xyz = -r1.xyz * r1.www;
    r1.w = dot(cb12[204].yz, cb12[204].yz);
    r1.w = rsqrt(r1.w);
    r2.xy = cb12[204].yz * r1.ww;
    r1.w = dot(r1.xy, r1.xy);
    r1.w = rsqrt(r1.w);
    r2.zw = r1.xy * r1.ww;
    r1.w = dot(r2.xy, r2.zw);
    r2.x = saturate(dot(cb12[204].yzw, r1.xyz));
    r2.y = dot(cb12[203].yz, cb12[203].yz);
    r2.y = rsqrt(r2.y);
    r4.xy = cb12[203].yz * r2.yy;
    r2.y = dot(r4.xy, r2.zw);
    r1.x = saturate(dot(cb12[203].yzw, r1.xyz));
    r1.y = r1.w * 0.5 + 0.5;
    r4.xyz = -cb12[200].xyz + cb12[199].xyz;
    r4.xyz = r1.yyy * r4.xyz + cb12[200].xyz;
    r1.y = r2.y * 0.5 + 0.5;
    r2.yzw = -cb12[197].xyz + cb12[196].xyz;
    r2.yzw = r1.yyy * r2.yzw + cb12[197].xyz;
    r1.y = -r1.z * r1.z + 1;
    r1.yz = r1.yy * r0.xy;
    r4.xyz = -cb12[195].xyz + r4.xyz;
    r4.xyz = r1.yyy * r4.xyz + cb12[195].xyz;
    r2.yzw = -r4.xyz + r2.yzw;
    r1.yzw = r1.zzz * r2.yzw + r4.xyz;
    r0.w = rsqrt(r0.w);
    r0.z = r0.z * r0.w;
    r0.z = r0.z * 1000 + cb12[0].z;
    r0.z = 710 + r0.z;
    r0.z = cb12[202].z * r0.z;
    r0.z = r0.z * 0.00100000005 + 0.100000001;
    r0.z = max(9.99999975e-005, r0.z);
    r0.z = 1 / r0.z;
    r0.z = min(1, r0.z);
    r0.z = log2(r0.z);
    r0.z = 2.79999995 * r0.z;
    r0.z = exp2(r0.z);
    r0.z = 1 + -r0.z;
    r2.yzw = cb12[194].xyz + -r1.yzw;
    r1.yzw = r0.zzz * r2.yzw + r1.yzw;
    r0.z = log2(r2.x);
    r0.z = cb12[204].x * r0.z;
    r0.z = exp2(r0.z);
    r0.x = r0.z * r0.x;
    r0.z = log2(r1.x);
    r0.z = cb12[203].x * r0.z;
    r0.z = exp2(r0.z);
    r0.y = r0.z * r0.y;
    r2.xyz = cb12[201].xyz + -r1.yzw;
    r0.xzw = r0.xxx * r2.xyz + r1.yzw;
    r1.xyz = cb12[198].xyz + -r0.xzw;
    r0.xyz = r0.yyy * r1.xyz + r0.xzw;
    r0.xyz = cb12[202].xxx * r0.xyz;
    r1.xyz = cb1[8].xyz + -world_position.xyz;
    r0.w = dot(r1.xyz, r1.xyz);
    r0.w = rsqrt(r0.w);
    r1.xyz = r1.xyz * r0.www;
    r2.xyz = float3(0, 0, 1) * cb12[204].zwy;
    r2.xyz = cb12[204].yzw * float3(0, 1, 0) + -r2.xyz;
    r4.xyz = cb12[204].zwy * r2.xyz;
    r4.xyz = r2.zxy * cb12[204].wyz + -r4.xyz;
    r4.x = dot(r1.xyz, r4.xyz);
    r4.y = dot(r1.xy, r2.yz);
    r4.z = dot(r1.xyz, cb12[204].yzw);
    r0.w = dot(r4.xyz, r4.xyz);
    r0.w = rsqrt(r0.w);
    r2.xyz = r4.xyz * r0.www;
    r4.xyz = t0.Sample(s0_s, r2.xyz).xyz;
    r0.w = 100 * v0.x;
    r1.w = floor(r0.w);
    r2.w = v0.y * 50 + cb0[0].x;
    r4.w = floor(r2.w);
    r4.w = reversebits((uint) r4.w);
    r5.x = (int) r1.w + (int) r4.w;
    r5.y = (uint) r5.x >> 13;
    r5.x = (int) r5.x ^ (int) r5.y;
    r5.y = (int) r5.x * (int) r5.x;
    r5.y = mad((int) r5.y, 0x0000ec4d, 0x0131071f);
    r5.x = mad((int) r5.x, (int) r5.y, 0x5208dd0d);
    r5.x = (int) r5.x & 0x7fffffff;
    r5.x = (int) r5.x;
    r5.y = v0.x * 100 + -1;
    r5.y = floor(r5.y);
    r4.w = (int) r4.w + (int) r5.y;
    r5.z = (uint) r4.w >> 13;
    r4.w = (int) r4.w ^ (int) r5.z;
    r5.z = (int) r4.w * (int) r4.w;
    r5.z = mad((int) r5.z, 0x0000ec4d, 0x0131071f);
    r4.w = mad((int) r4.w, (int) r5.z, 0x5208dd0d);
    r4.w = (int) r4.w & 0x7fffffff;
    r4.w = (int) r4.w;
    r5.z = -1 + r2.w;
    r5.z = floor(r5.z);
    r5.z = reversebits((uint) r5.z);
    r1.w = (int) r1.w + (int) r5.z;
    r5.w = (uint) r1.w >> 13;
    r1.w = (int) r1.w ^ (int) r5.w;
    r5.w = (int) r1.w * (int) r1.w;
    r5.w = mad((int) r5.w, 0x0000ec4d, 0x0131071f);
    r1.w = mad((int) r1.w, (int) r5.w, 0x5208dd0d);
    r1.w = (int) r1.w & 0x7fffffff;
    r1.w = (int) r1.w;
    r1.w = 0 * r1.w;
    r5.y = (int) r5.z + (int) r5.y;
    r5.z = (uint) r5.y >> 13;
    r5.y = (int) r5.y ^ (int) r5.z;
    r5.z = (int) r5.y * (int) r5.y;
    r5.z = mad((int) r5.z, 0x0000ec4d, 0x0131071f);
    r5.y = mad((int) r5.y, (int) r5.z, 0x5208dd0d);
    r5.y = (int) r5.y & 0x7fffffff;
    r5.y = (int) r5.y;
    r0.w = frac(r0.w);
    r0.w = 1 + -r0.w;
    r5.z = r0.w * r0.w;
    r0.w = r5.z * r0.w;
    r5.xz = float2(0, 3) * r5.xz;
    r0.w = r0.w * -2 + r5.z;
    r2.w = frac(r2.w);
    r2.w = 1 + -r2.w;
    r5.z = r2.w * r2.w;
    r2.w = r5.z * r2.w;
    r5.z = 3 * r5.z;
    r2.w = r2.w * -2 + r5.z;
    r4.w = r4.w * 0 + -r5.x;
    r4.w = r0.w * r4.w + r5.x;
    r5.x = r5.y * 0 + -r1.w;
    r0.w = r0.w * r5.x + r1.w;
    r0.w = r0.w + -r4.w;
    r0.w = r2.w * r0.w + r4.w;
    r2.xyz = r0.www * float3(0.000500000024, 0.000500000024, 0.000500000024) + r2.xyz;
    r2.xyz = t0.Sample(s0_s, r2.xyz).xyz;
    r4.xyz = log2(r4.xyz);
    r4.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r4.xyz;
    r4.xyz = exp2(r4.xyz);
    r2.xyz = log2(r2.xyz);
    r2.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r2.xyz;
    r2.xyz = exp2(r2.xyz);
    r2.xyz = r4.xyz * r2.xyz;
    r0.w = dot(-cb12[204].yzw, -cb12[204].yzw);
    r0.w = rsqrt(r0.w);
    r4.xyz = -cb12[204].yzw * r0.www;
    r0.w = saturate(dot(r4.xyz, r1.xyz));
    r0.w = r0.w * r0.w;
    r1.x = r0.w * r0.w;
    r1.x = r1.x * r1.x;
    r1.x = r1.x * r1.x;
    r0.w = r1.x * r0.w;
    r1.x = r1.x * r1.x;
    r0.w = -r0.w * r1.x + 1;

   

    r1.xyz = r2.xyz * r0.www;
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(2.5, 2.5, 2.5) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = min(float3(1, 1, 1), r1.xyz);
    r0.w = 1 + -cb0[9].w;

    float star_scale = r0.w;

    r1.xyz = r1.xyz * r0.www;
    r1.xyz = float3(10, 10, 10) * r1.xyz;
    r0.xyz = r0.xyz * cb12[202].yyy + r1.xyz;

    // Noisy blur: https://www.shadertoy.com/view/XsVBDR
	// this is smoothed out by the temporal filter in the next pass
	float4 blue_noise = GetAnimatedBlueNoise(sv_position.xy);
    float sinus, cosinus;
    sincos(blue_noise.r * PI_2, sinus, cosinus);
	// box-muller transform to get gaussian distributed sample points in the circle
    float2 uv_offset = float2(sinus, cosinus) * sqrt(-0.5 * log(blue_noise.g));

    float2 tex_coord = SvPositionToTexCoord(sv_position);
    tex_coord += uv_offset * screenDimensions.zw * 2;
    r0.rgb += aurora_texture.SampleLevel(_linear_sampler, tex_coord, 0) * pow(star_scale, 20);

    r1.xyz = r3.xyz + -r0.xyz;
    o0.xyz = r3.www * r1.xyz + r0.xyz;

    o0.w = 1;
    return;
}