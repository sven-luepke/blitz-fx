#define LOOP_SHADOW_SAMPLES
#include "WaterCommon.hlsli"
#include "Noise.hlsli"
#include "ShadowCommon.hlsli"

Texture2D<float4> t24 : register(t24);
Texture2D<float4> t23 : register(t23);
Texture2D<float4> t22 : register(t22);
ByteAddressBuffer t21 : register(t21);
ByteAddressBuffer t20 : register(t20);
Texture2DArray<float> t19 : register(t19);
Texture2DArray<float> t14 : register(t14);
TextureCubeArray<float4> t10 : register(t10);
Texture2DArray<float4> t9 : register(t9);
Texture2DArray<float> t8 : register(t8);
Buffer<float4> t5 : register(t5);
Buffer<float4> t4 : register(t4);
Buffer<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);

SamplerState s14_s : register(s14);
SamplerState s11_s : register(s11);
SamplerState s10_s : register(s10);
SamplerComparisonState s9_s : register(s9);
SamplerState s0_s : register(s0);

cbuffer cb10 : register(b10)
{
    float4 cb10[296];
}

cbuffer cb2 : register(b2)
{
    float4 cb2[17];
}

cbuffer cb13 : register(b13)
{
    float4 cb13[3323];
}
cbuffer cb12 : register(b12)
{
    float4 cb12[269];
}

SamplerComparisonState _linear_comparison_less_sampler;

#define cmp -

[earlydepthstencil]
void PSMain(
  float4 sv_position : SV_Position0,
  nointerpolation float v1_x : COMP_TEX_COORD,
  nointerpolation uint v1_y : PRIMITIVE_ID,
  nointerpolation float v1_z : COORDS,
  float v2 : HAIR_TEX,
  uint sv_sample_index : SV_SampleIndex,
  out float4 o0 : SV_Target0)
{
    const float4 icb[] =
    {
        { 1.000000, 0, 0, 0 },
        { 0, 1.000000, 0, 0 },
        { 0, 0, 1.000000, 0 },
        { 0, 0, 0, 1.000000 }
    };
    float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22;

    r0.xyzw = cb10[13].xyzw * sv_position.yyyy;
    r0.xyzw = sv_position.xxxx * cb10[12].xyzw + r0.xyzw;
    r0.xyzw = sv_position.zzzz * cb10[14].xyzw + r0.xyzw;
    r0.xyzw = cb10[15].xyzw + r0.xyzw;
    r0.xyz = r0.xyz / r0.www;

    float3 world_position = r0.xyz;
    float water_depth = SampleWaterDepthVolume(world_position);

   // r1.xy = floor(v1_x.xz);
    r1.xy = floor(float2(v1_x, v1_z));
    //r2.xy = v1_x.xz + -r1.xy;
    r2.xy = float2(v1_x, v1_z) + -r1.xy;

    r3.xyz = cb10[16].xyz + -r0.xyz;
    r0.w = dot(r3.xyz, r3.xyz);
    r0.w = rsqrt(r0.w);
    r4.xyz = r3.xyz * r0.www;
    r1.z = r2.x * 4194304 + r1.x;
    r1.z = floor(r1.z);
    r1.w = asint(cb10[28].z);
    r3.w = v2.x * r1.w;
    r3.w = floor(r3.w);
    r4.w = (int) r3.w;
    r5.x = (int) r4.w + 1;
    r5.y = -1 + asint(cb10[28].z);
    r5.x = min((int) r5.x, (int) r5.y);
    r1.w = v2.x * r1.w + -r3.w;
    r5.yzw = t3.Load(v1_y).xyz;
    r5.yzw = floor(r5.yzw);
    r5.yzw = (int3) r5.yzw;
    r6.xyz = mad((int3) r5.yzw, asint(cb10[28].zzz), (int3) r4.www);
    r5.xyz = mad((int3) r5.yzw, asint(cb10[28].zzz), (int3) r5.xxx);
    r2.zw = float2(0.00048828125, 0.00048828125) * r1.xy;
    r7.xyz = t4.Load(r6.x).xyz;
    r8.xyz = t4.Load(r6.y).xyz;
    r9.xyz = t4.Load(r6.z).xyz;
    r8.xyz = r8.xyz * r2.www;
    r7.xyz = r2.yyy * r7.xyz + r8.xyz;
    r1.x = 1 + -r2.y;
    r1.x = -r1.y * 0.00048828125 + r1.x;
    r7.xyz = r1.xxx * r9.xyz + r7.xyz;
    r8.xyz = t5.Load(r6.x).xyz;
    r6.xyw = t5.Load(r6.y).xyz;
    r9.xyz = t5.Load(r6.z).xyz;
    r6.xyz = r6.xyw * r2.www;
    r6.xyz = r2.yyy * r8.xyz + r6.xyz;
    r6.xyz = r1.xxx * r9.xyz + r6.xyz;
    r8.xyz = t4.Load(r5.x).xyz;
    r9.xyz = t4.Load(r5.y).xyz;
    r10.xyz = t4.Load(r5.z).xyz;
    r9.xyz = r9.xyz * r2.www;
    r8.xyz = r2.yyy * r8.xyz + r9.xyz;
    r8.xyz = r1.xxx * r10.xyz + r8.xyz;
    r9.xyz = t5.Load(r5.x).xyz;
    r5.xyw = t5.Load(r5.y).xyz;
    r10.xyz = t5.Load(r5.z).xyz;
    r5.xyz = r5.xyw * r2.www;
    r5.xyz = r2.yyy * r9.xyz + r5.xyz;
    r5.xyz = r1.xxx * r10.xyz + r5.xyz;
    r8.xyz = r8.xyz + -r7.xyz;
    r7.xyz = r1.www * r8.xyz + r7.xyz;
    r1.x = dot(r7.xyz, r7.xyz);
    r1.x = rsqrt(r1.x);
    r7.xyz = r7.xyz * r1.xxx;
    r5.xyz = r5.xyz + -r6.xyz;
    r1.xyw = r1.www * r5.xyz + r6.xyz;
    r2.y = dot(r1.xyw, r1.xyw);
    r2.y = rsqrt(r2.y);
    r5.xyz = r2.yyy * r1.xyw;

    if (asint(cb10[26].x) != 0)
    {
        r6.xyz = t0.SampleLevel(s0_s, r2.xz, 0).xyz;
    }
    else
    {
        r6.xyz = cb10[30].xyz;
    }
    if (asint(cb10[26].y) != 0)
    {
        r8.xyz = t1.SampleLevel(s0_s, r2.xz, 0).xyz;
    }
    else
    {
        r8.xyz = cb10[31].xyz;
    }

    r1.x = cmp(cb10[38].x < 0.5);
    r1.y = dot(v2.xx, cb10[38].xx);
    r2.w = -cb10[38].x + 1;
    r2.w = r2.w + r2.w;
    r9.xy = float2(-1, 0) + v2.xx;
    r2.w = r2.w * r9.x + 1;
    r1.x = r1.x ? r1.y : r2.w;
    r1.y = cb10[38].y + 0.00100000005;
    r1.y = 1 / r1.y;
    r1.x = -0.5 + r1.x;
    r1.x = saturate(r1.y * r1.x + 0.5);
    r8.xyz = r8.xyz + -r6.xyz;
    r6.xyz = r1.xxx * r8.xyz + r6.xyz;
    if (asint(cb10[26].z) != 0)
    {
        r1.x = v2.x;
        r1.y = 0;
        r8.xyz = t2.SampleLevel(s0_s, r1.xy, 0).xyz;
        switch (asint(cb10[28].x))
        {
            case 0:
                r6.xyz = cb10[38].www * r8.xyz;
                break;
            case 1:
                r9.xzw = r6.xyz * r8.xyz + -r6.xyz;
                r6.xyz = cb10[38].www * r9.xzw + r6.xyz;
                break;
            case 2:
                r6.xyz = cb10[38].www * r8.xyz + r6.xyz;
                break;
            case 3:
                r8.xyz = float3(-0.5, -0.5, -0.5) + r8.xyz;
                r6.xyz = cb10[38].www * r8.xyz + r6.xyz;
                break;
            default:
                break;
        }
    }
    r6.xyz = cb10[33].www * r6.xyz;
    r1.x = cmp(0.000000 != cb10[34].z);
    if (r1.x != 0)
    {
        r1.xy = cb10[34].xy * r2.xz;
        r1.xy = floor(r1.xy);
        r2.xz = cb10[34].xy * r2.xz + -r1.xy;
        r2.xz = float2(-0.5, -0.5) + r2.xz;
        r8.xy = cmp(r2.xz < float2(0, 0));
        r10.xyzw = float4(-1, 1, -1, 1) + r1.xxyy;
        r8.xy = r8.xy ? r10.xz : r10.yw;
        r8.xy = max(float2(0, 0), r8.xy);
        r1.xy = (uint2) r1.xy;

        //if (8 == 0)
        //    r8.z = 0;
        //else if (8 + 2 < 32)
        //{
        //    r8.z = (uint) r1.x << (32 - (8 + 2));
        //    r8.z = (uint) r8.z >> (32 - 8);
        //}
        //else
        //    r8.z = (uint) r1.x >> 2;
        //if (8 == 0)
        //    r8.w = 0;
        //else if (8 + 2 < 32)
        //{
        //    r8.w = (uint) r1.y << (32 - (8 + 2));
        //    r8.w = (uint) r8.w >> (32 - 8);
        //}
        //else
        //    r8.w = (uint) r1.y >> 2;

        uint2 source_0 = asuint(r1.xy);
        r8.zw = (source_0.xy >> int2(2, 2)) & 255;

        r1.xy = (int2) r1.xy & int2(3, 3);
        r1.x = dot(cb10[r8.z + 40].xyzw, icb[r1.x + 0].xyzw);
        r8.xy = (uint2) r8.xy;

        //if (8 == 0)
        //    r9.x = 0;
        //else if (8 + 2 < 32)
        //{
        //    r9.x = (uint) r8.x << (32 - (8 + 2));
        //    r9.x = (uint) r9.x >> (32 - 8);
        //}
        //else
        //    r9.x = (uint) r8.x >> 2;
        //if (8 == 0)
        //    r9.z = 0;
        //else if (8 + 2 < 32)
        //{
        //    r9.z = (uint) r8.y << (32 - (8 + 2));
        //    r9.z = (uint) r9.z >> (32 - 8);
        //}
        //else
        //    r9.z = (uint) r8.y >> 2;
        source_0 = asuint(r8.xy);
        r9.xz = (source_0.xy >> int2(2, 2)) & 255;

        r8.xy = (int2) r8.xy & int2(3, 3);
        r2.w = dot(cb10[r9.x + 40].xyzw, icb[r8.x + 0].xyzw);
        r2.w = r2.w + -r1.x;
        r1.x = abs(r2.x) * r2.w + r1.x;
        r1.y = dot(cb10[r8.w + 40].xyzw, icb[r1.y + 0].xyzw);
        r2.x = dot(cb10[r9.z + 40].xyzw, icb[r8.y + 0].xyzw);
        r2.x = r2.x + -r1.y;
        r1.y = abs(r2.z) * r2.x + r1.y;
        r1.x = r1.x * r1.y;
        r1.x = rsqrt(r1.x);
        r1.x = 1 / r1.x;
        r1.y = cb10[34].w + 1;
        r1.x = r1.x * r1.y + -1;
        r1.x = cb10[34].z * r1.x + 1;
    }
    else
    {
        r1.x = 1;
    }
    r1.y = saturate(cb10[34].z);
    r1.x = -1 + r1.x;
    r1.y = r1.y * r1.x + 1;
    r2.xzw = r6.xyz * r1.yyy;
    r2.xzw = log2(r2.xzw);
    r2.xzw = float3(2.20000005, 2.20000005, 2.20000005) * r2.xzw;
    r2.xzw = exp2(r2.xzw);
    r1.y = saturate(cb10[35].w);
    r1.x = r1.y * r1.x + 1;
    r6.xyz = cb10[32].xyz * r1.xxx;
    r6.xyz = log2(r6.xyz);
    r6.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r6.xyz;
    r6.xyz = exp2(r6.xyz);
    r8.xyzw = (uint4) sv_position.xyxy;    

    r1.x = asint(cb10[27].y) ? r1.x : 1;
    r1.y = cb10[39].y * v2.x;
    r1.y = floor(r1.y);
    r3.w = cb10[39].y * v2.x + -r1.y;
    r3.w = -0.5 + r3.w;
    r4.w = cmp(r3.w < 0);
    r9.xz = float2(-1, 1) + r1.yy;
    r4.w = r4.w ? r9.x : r9.z;
    r4.w = max(0, r4.w);
    r1.y = r1.z + r1.y;
    r4.w = r4.w + r1.z;
    r1.yz = (uint2) r1.yz;

    //if (8 == 0)
    //    r5.w = 0;
    //else if (8 + 2 < 32)
    //{
    //    r5.w = (uint) r1.y << (32 - (8 + 2));
    //    r5.w = (uint) r5.w >> (32 - 8);
    //}
    //else
    //    r5.w = (uint) r1.y >> 2;

    uint source_02 = asuint(r1.y);
    r5.w = (source_02 >> 2) & 255;
    
    r1.y = (int) r1.y & 3;
    r1.y = dot(cb10[r5.w + 40].xyzw, icb[r1.y + 0].xyzw);
    r4.w = (uint) r4.w;

    //if (8 == 0)
    //    r5.w = 0;
    //else if (8 + 2 < 32)
    //{
    //    r5.w = (uint) r4.w << (32 - (8 + 2));
    //    r5.w = (uint) r5.w >> (32 - 8);
    //}
    //else
    //    r5.w = (uint) r4.w >> 2;

    source_02 = asuint(r4.w);
    r5.w = (source_02 >> 2) & 255;

    r4.w = (int) r4.w & 3;
    r4.w = dot(cb10[r5.w + 40].xyzw, icb[r4.w + 0].xyzw);
    r4.w = r4.w + -r1.y;
    r1.y = abs(r3.w) * r4.w + r1.y;
    r1.y = log2(r1.y);
    r1.y = cb10[39].z * r1.y;
    r1.y = exp2(r1.y);
    r9.xz = (int2) r8.zw ^ int2(2, 2);
    r10.xy = max((int2) -r8.zw, (int2) r8.xy);
    r10.xy = (uint2) r10.xy >> int2(1, 1);
    r10.zw = -(int2) r10.xy;
    r9.xz = (int2) r9.xz & int2(0, 0);
    r10.xy = r9.xz ? r10.zw : r10.xy;
    r10.zw = float2(0, 0);
    r9.xz = t24.Load(r10.xyz).xy;
    r10.xyz = -cb12[0].xyz + r0.xyz;
    r3.w = dot(r10.xyz, r10.xyz);
    r3.w = sqrt(r3.w);
    r11.x = cb12[1].z;
    r11.y = cb12[2].z;
    r11.z = cb12[3].z;
    r4.w = dot(r11.xyz, r10.xyz);
    r5.w = 1 / cb12[21].y;
    r5.w = r5.w * r3.w;
    r4.w = r5.w / r4.w;
    r4.w = -r4.w + r3.w;
    r4.w = saturate(cb13[33].w * r4.w);
    r4.w = cb13[33].z * r4.w;
    r4.w = max(0.00100000005, r4.w);
    r5.w = r3.w / cb13[34].z;
    r6.w = cmp(r9.x < r9.z);
    if (r6.w != 0)
    {
        r6.w = cmp(r5.w < r9.x);
        r7.w = cmp(r9.z < r5.w);
        r9.w = cb13[34].z * r9.x + -cb13[34].x;
        r9.w = saturate(-r9.w * cb13[34].y + 1);
        r10.w = r5.w + -r9.x;
        r10.w = cb13[34].z * r10.w;
        r10.w = saturate(r10.w / r4.w);
        r11.y = r10.w * r9.w;
        r6.w = (int) r6.w | (int) r7.w;
        r11.x = 1;
        r11.xy = r6.ww ? float2(0, 1) : r11.xy;
    }
    else
    {
        r6.w = cmp(r9.z < r9.x);
        r7.w = cmp(r5.w < r9.z);
        r9.w = cmp(r9.x < r5.w);
        r9.x = cb13[34].z * r9.x + -cb13[34].x;
        r12.y = saturate(-r9.x * cb13[34].y + 1);
        r5.w = r5.w + -r9.z;
        r5.w = cb13[34].z * r5.w;
        r4.w = saturate(r5.w / r4.w);
        r12.w = 1 + -r4.w;
        r12.xz = float2(1, 1);
        r9.xz = r9.ww ? r12.xy : r12.zw;
        r9.xz = r7.ww ? float2(1, 1) : r9.xz;
        r11.xy = r6.ww ? r9.xz : float2(0, 1);
    }
    r4.w = -r11.y * r11.x + 1;
    r9.xz = (int2) r8.zw & int2(1, 1);
    r11.xy = r9.zz ? float2(1, 3) : float2(2, 0);
    r5.w = r9.x ? r11.x : r11.y;

    //if (1 == 0)
    //    r11.x = 0;
    //else if (1 + 1 < 32)
    //{
    //    r11.x = (uint) r8.z << (32 - (1 + 1));
    //    r11.x = (uint) r11.x >> (32 - 1);
    //}
    //else
    //    r11.x = (uint) r8.z >> 1;
    //if (1 == 0)
    //    r11.y = 0;
    //else if (1 + 1 < 32)
    //{
    //    r11.y = (uint) r8.w << (32 - (1 + 1));
    //    r11.y = (uint) r11.y >> (32 - 1);
    //}
    //else
    //    r11.y = (uint) r8.w >> 1;
    //if (1 == 0)
    //    r11.z = 0;
    //else if (1 + 2 < 32)
    //{
    //    r11.z = (uint) r8.z << (32 - (1 + 2));
    //    r11.z = (uint) r11.z >> (32 - 1);
    //}
    //else
    //    r11.z = (uint) r8.z >> 2;
    //if (1 == 0)
    //    r11.w = 0;
    //else if (1 + 2 < 32)
    //{
    //    r11.w = (uint) r8.w << (32 - (1 + 2));
    //    r11.w = (uint) r11.w >> (32 - 1);
    //}
    //else
    //    r11.w = (uint) r8.w >> 2;

    uint2 source_00 = asuint(r8.zw);
    r11.xyzw = (uint4(source_00.xy, source_00.xy) >> int4(1, 1, 2, 2)) & 1;

    r12.xyzw = r11.yyww ? float4(1, 3, 1, 3) : float4(2, 0, 2, 0);
    r11.xy = r11.xz ? r12.xz : r12.yw;
    r5.w = (uint) r5.w << 4;
    r5.w = mad((int) r11.x, 4, (int) r5.w);
    r5.w = (int) r5.w + (int) r11.y;
    r5.w = (int) r5.w;
    r5.w = 0.5 + r5.w;
    r6.w = 0.015625 * r5.w;
    r8.xyzw = (uint4) r8.xyzw >> int4(5, 5, 4, 4);
    r11.xy = (int2) cb12[24].zx;
    r8.xy = mad((int2) r8.yw, (int2) r11.xy, (int2) r8.xz);
    r11.xyz = cb12[2].xyz * r0.yyy;
    r11.xyz = cb12[1].xyz * r0.xxx + r11.xyz;
    r11.xyz = cb12[3].xyz * r0.zzz + r11.xyz;
    r11.xyz = cb12[4].xyz + r11.xyz;
    r5.w = -r5.w * 0.015625 + 1;
    r11.w = 1;
    r12.xzw = float3(0, 0, 0);
    r13.xyzw = float4(0, 0, 0, 0);
    r7.w = 0;
    while (true)
    {
        r8.z = cmp((uint) r7.w >= 192);
        if (r8.z != 0)
            break;
        r8.z = mad((int) r8.x, 192, (int) r7.w);
        r8.z = (uint) r8.z << 2;
        // No code for instruction (needs manual fix):
        //ld_raw_indexable(raw_buffer) (mixed, mixed, mixed, mixed) r8.z, r8.z, t21.xxxx
        r8.z = t21.Load(r8.z);

        r8.w = cmp((uint) r8.z >= 192);
        if (r8.w != 0)
        {
            break;
        }
        r8.z = (int) r8.z * 5;
        r14.x = dot(r11.xyzw, cb13[r8.z + 2363].xyzw);
        r14.y = dot(r11.xyzw, cb13[r8.z + 2364].xyzw);
        r14.z = dot(r11.xyzw, cb13[r8.z + 2365].xyzw);
        r15.xyz = cmp(abs(r14.xyz) < float3(1, 1, 1));
        r8.w = r15.y ? r15.x : 0;
        r8.w = r15.z ? r8.w : 0;
        if (r8.w != 0)
        {
            r8.w = asuint(cb13[r8.z + 2366].w) >> 16;
            r8.w = (uint) r8.w;
            r8.w = 0.000015 * r8.w;
            r9.w = 0x0000ffff & asint(cb13[r8.z + 2366].w);
            r9.w = (uint) r9.w;
            r9.w = 0.000015 * r9.w;
            r10.w = dot(r14.xyz, r14.xyz);
            r10.w = sqrt(r10.w);
            r10.w = 1 + -r10.w;
            r10.w = max(0, r10.w);
            r14.xy = cb13[r8.z + 2367].wx * r10.ww;
            r14.x = saturate(r14.x);
            r10.w = cmp(-1.000000 == cb13[r8.z + 2367].w);
            r14.z = cmp(r8.w >= r5.w);
            r12.y = r14.z ? 1.000000 : 0;
            r8.w = cmp(r8.w >= r6.w);
            r8.w = r8.w ? 1.000000 : 0;
            r15.x = r9.w * r8.w;
            r15.y = min(0.998037279, r14.y);
            r15.zw = cb13[r8.z + 2367].yz * r14.xx;
            r14.xyzw = r10.wwww ? r12.xyzw : r15.xyzw;
            r13.xyzw = max(r13.xyzw, r14.xyzw);
        }
        r7.w = (int) r7.w + 1;
    }

    r5.w = r13.y * r13.y;
    r6.w = cmp(0 < r13.x);
    r7.w = r6.w ? 0 : 1;
    r4.w = r4.w * r4.w;
    r4.w = min(r7.w, r4.w);
    r4.w = max(r4.w, r5.w);
    r4.w = 1 + -r4.w;
    r5.w = 1 + -r13.x;
    r7.w = 1 + -cb13[33].y;
    r5.w = r6.w ? r5.w : r7.w;
    r8.xz = float2(1, 1) + -r13.zw;
    r5.w = min(r8.x, r5.w);
    r5.w = r5.w + -r8.z;
    r5.w = saturate(r4.w * r5.w + r8.z);
    r4.w = saturate(1 + -r4.w);

    float exterior_lighting_scale = r4.w;

    r6.w = dot(r10.xy, r10.xy);
    r6.w = sqrt(r6.w);
    r7.w = saturate(r0.z * cb12[218].z + cb12[218].w);
    r8.xzw = -cb13[52].xyz + cb13[51].xyz;
    r8.xzw = r7.www * r8.xzw + cb13[52].xyz;
    r6.w = saturate(r6.w * cb12[218].x + cb12[218].y);
    r8.xzw = -cb13[1].xyz + r8.xzw;
    r8.xzw = r6.www * r8.xzw + cb13[1].xyz;

    float3 directional_light_scale = GetUnderwaterDirectionalLightScale(water_depth, world_position);
    r8.xzw *= directional_light_scale;

    r7.w = dot(cb13[0].xyz, cb13[0].xyz);
    r7.w = rsqrt(r7.w);
    r11.xyz = cb13[0].xyz * r7.www;
    r7.w = dot(r7.xyz, r11.xyz);
    r7.w = max(-1, r7.w);
    r7.w = min(1, r7.w);
    r9.w = dot(r5.xyz, r11.xyz);
    r10.w = max(0, r9.w);

    DirectionalShadowArgs args;
    args.world_position = world_position.xyz;
    args.cascade_shadow_map = t8;
    args.cascade_shadow_sampler = s9_s;
    args.noise_01 = frac(GetStaticBlueNoise(sv_position.xy) + sv_sample_index * 0.25);
    args.is_vegetation_shadow = false;
    args.cloud_shadow_map = t14;
    args.cloud_shadow_sampler = s14_s;
    args.terrain_shadow_height_map = t19;
    args.terrain_shadow_sampler = s10_s;
    float shadow_factor = ComputeDirectionalShadow(args, hairworks_shadow_sample_count);
    r1.x = shadow_factor;
    r8.xzw = r8.xzw * r1.xxx;

    r7.w = -r7.w * r7.w + 1;
    r7.w = sqrt(r7.w);
    r11.w = r10.w + -r7.w;
    r7.w = saturate(cb10[33].x * r11.w + r7.w);
    r7.w = cb10[33].y * r7.w;
    r12.xyz = r7.www * r8.xzw;
    r7.w = cmp(0 < cb10[39].x);
    r11.w = dot(r8.xzw, float3(0.300000012, 0.5, 0.200000003));
    r12.w = cb10[39].x * r1.y;

    // edit: remove weird bleeding
    r12.w *= r10.w;

    r13.xyz = r12.www * r11.www + r12.xyz;
    r12.xyz = r7.www ? r13.xyz : r12.xyz;
    r12.xyz = max(float3(0, 0, 0), r12.xyz);


    //if (8 == 0)
    //    r11.w = 0;
    //else if (8 + 2 < 32)
    //{
    //    r11.w = (uint) r1.z << (32 - (8 + 2));
    //    r11.w = (uint) r11.w >> (32 - 8);
    //}
    //else
    //    r11.w = (uint) r1.z >> 2;

    uint source_01 = asuint(r1.z);
    r11.w = (source_01 >> 2) & 255;


    r1.z = (int) r1.z & 3;
    r1.z = dot(cb10[r11.w + 40].xyzw, icb[r1.z + 0].xyzw);
    r1.yz = float2(-1, -0.5) + r1.yz;
    r11.xyz = r3.xyz * r0.www + r11.xyz;
    r11.w = dot(r11.xyz, r11.xyz);
    r11.w = rsqrt(r11.w);
    r11.xyz = r11.xyz * r11.www;
    r11.x = dot(r7.xyz, r11.xyz);
    r11.x = max(-1, r11.x);
    r11.x = min(1, r11.x);
    r11.y = cb10[35].z * r1.z + r11.x;
    r11.y = max(-1, r11.y);
    r11.y = min(1, r11.y);
    r11.y = -r11.y * r11.y + 1;
    r11.y = sqrt(r11.y);
    r11.y = log2(r11.y);
    r11.y = cb10[35].y * r11.y;
    r11.y = exp2(r11.y);
    r11.x = cb10[36].z + r11.x;
    r11.x = max(-1, r11.x);
    r11.x = min(1, r11.x);
    r11.x = -r11.x * r11.x + 1;
    r11.x = sqrt(r11.x);
    r11.x = log2(r11.x);
    r11.x = cb10[36].y * r11.x;
    r11.x = exp2(r11.x);
    r11.x = cb10[36].x * r11.x;
    r11.x = cb10[35].x * r11.y + r11.x;
    r8.xzw = r8.xzw * r6.xyz;
    r8.xzw = r11.xxx * r8.xzw;
    r1.y = cb10[39].x * r1.y + 1;
    r11.xyz = r8.xzw * r1.yyy;
    r8.xzw = r7.www ? r11.xyz : r8.xzw;
    r1.y = min(1, r10.w);
    r10.w = -1 + r1.y;
    r10.w = cb10[33].x * r10.w + 1;
    r8.xzw = r10.www * r8.xzw;
    r8.xzw = max(float3(0, 0, 0), r8.xzw);
    r8.y = (uint) r8.y << 8;
    r10.w = cmp(r4.w == 1.000000);
    r11.x = -cb10[39].x + 1;
    r11.y = r10.w ? 1.000000 : 0;
    r10.w = r10.w ? 0 : 1;
    r13.xyz = r12.xyz;
    r14.xyz = r8.xzw;
    r11.z = 0;
    while (true)
    {
        r11.w = cmp((int) r11.z >= 256);
        if (r11.w != 0)
            break;
        r11.w = (int) r8.y + (int) r11.z;
        r11.w = (uint) r11.w << 2;
        // No code for instruction (needs manual fix):
        // ld_raw_indexable(raw_buffer)(mixed, mixed, mixed, mixed) r11.w, r11.w, t20.xxxx
        r11.w = t20.Load(r11.w);

        r12.w = cmp((uint) r11.w >= 256);
        if (r12.w != 0)
        {
            break;
        }
        r11.w = (int) r11.w * 9;
        r15.xyz = cb13[r11.w + 58].xyz + -r0.xyz;
        r12.w = dot(r15.xyz, r15.xyz);
        r13.w = sqrt(r12.w);
        r14.w = r13.w / cb13[r11.w + 58].w;
        r16.x = r14.w * r14.w;
        r16.x = -r16.x * r16.x + 1;
        r16.x = max(0, r16.x);
        r16.x = r16.x * r16.x;
        r16.yzw = int3(1, 2048, 4096) & asint(cb13[r11.w + 61].www);
        r17.x = cmp(0 < cb13[r11.w + 63].z);
        r17.y = cmp(0 < cb13[r11.w + 64].x);
        r17.z = r12.w * cb13[r11.w + 63].x + 1;
        r16.x = r16.x / r17.z;
        if (r16.y != 0)
        {
            r17.z = rsqrt(r12.w);
            r18.xyz = r17.zzz * r15.xyz;
            r17.z = dot(-r18.xyz, cb13[r11.w + 60].xyz);
            r17.z = saturate(r17.z * cb13[r11.w + 62].y + cb13[r11.w + 62].z);
            r17.z = log2(r17.z);
            r17.z = cb13[r11.w + 62].w * r17.z;
            r17.z = exp2(r17.z);
            r16.x = r17.z * r16.x;
        }
        r17.z = cmp(0 < r16.x);
        r17.x = r17.z ? r17.x : 0;
        if (r17.x != 0)
        {
            if (r16.y != 0)
            {
                r18.xyz = -cb13[r11.w + 58].xyz + r0.xyz;
                r19.xyz = cb13[r11.w + 65].zwy * cb13[r11.w + 60].zxy;
                r19.xyz = cb13[r11.w + 60].yzx * cb13[r11.w + 65].wyz + -r19.xyz;
                r19.x = dot(r19.xyz, r18.xyz);
                r19.y = dot(cb13[r11.w + 65].yzw, r18.xyz);
                r19.z = dot(cb13[r11.w + 60].xyz, r18.xyz);
                r19.w = cb13[r11.w + 65].x;
            }
            else
            {
                r18.xyz = -cb13[r11.w + 58].xzy + r0.xzy;
                r20.xyz = r15.xyz / r13.www;
                r13.w = max(abs(r20.y), abs(r20.z));
                r13.w = cmp(r13.w < abs(r20.x));
                if (r13.w != 0)
                {
                    r13.w = cmp(0 < r20.x);
                    r21.xyz = float3(1, 1, -1) * r18.zyx;
                    r21.w = cb13[r11.w + 65].x;
                    r22.xyz = float3(-1, 1, 1) * r18.zyx;
                    r22.w = cb13[r11.w + 65].y;
                    r19.xyzw = r13.wwww ? r21.xyzw : r22.xyzw;
                }
                else
                {
                    r13.w = max(abs(r20.x), abs(r20.z));
                    r13.w = cmp(r13.w < abs(r20.y));
                    if (r13.w != 0)
                    {
                        r13.w = cmp(0 < r20.y);
                        r21.xyz = float3(-1, 1, -1) * r18.xyz;
                        r21.w = cb13[r11.w + 65].z;
                        r18.w = cb13[r11.w + 65].w;
                        r19.xyzw = r13.wwww ? r21.xyzw : r18.xyzw;
                    }
                    else
                    {
                        r13.w = cmp(0 < r20.z);
                        r19.x = r18.x;
                        r19.y = r13.w ? r18.z : -r18.z;
                        r19.z = r13.w ? -r18.y : r18.y;
                        r19.w = r13.w ? cb13[r11.w + 66].x : cb13[r11.w + 66].y;
                    }
                }
            }
            r17.xw = cb13[r11.w + 63].yy * r19.xy;
            r17.xw = r17.xw / r19.zz;
            r17.xw = r17.xw * float2(0.5, -0.5) + float2(0.5, 0.5);


            //if (10 == 0)
            //    r18.x = 0;
            //else if (10 + 20 < 32)
            //{
            //    r18.x = (uint) r19.w << (32 - (10 + 20));
            //    r18.x = (uint) r18.x >> (32 - 10);
            //}
            //else
            //    r18.x = (uint) r19.w >> 20;
            //if (10 == 0)
            //    r18.y = 0;
            //else if (10 + 10 < 32)
            //{
            //    r18.y = (uint) r19.w << (32 - (10 + 10));
            //    r18.y = (uint) r18.y >> (32 - 10);
            //}
            //else
            //    r18.y = (uint) r19.w >> 10;
            //
            //r18.xy = (uint2) r18.xy;
            //r13.w = (int) r19.w & 1023;
            //r13.w = (uint) r13.w;
            //r16.y = (uint) r19.w >> 30;
            //r19.z = (uint) r16.y;
            //r16.y = cmp(0 < r13.w);

            uint source = asuint(r19.w);
            r18.xy = (source.xx >> int2(20, 10)) & 1023;
            r13.w = source & 1023;
            r19.z = source >> 30;

            if (r13.w)
            {
                r17.xw = r17.xw * r13.ww + r18.xy;
                r19.xy = float2(0.0009765625, 0.0009765625) * r17.xw;
                r13.w = t9.SampleLevel(s10_s, r19.xyz, 0).x;
                r13.w = -r14.w * 0.99000001 + r13.w;
                r13.w = 144.269501 * r13.w;
                r13.w = exp2(r13.w);
                r13.w = min(1, r13.w);
            }
            else
            {
                r13.w = 1;
            }
        }
        else
        {
            r13.w = 1;
        }
        r16.y = r17.z ? r17.y : 0;
        if (r16.y != 0)
        {
            r15.w = cb13[r11.w + 64].y;
            r15.w = t10.SampleLevel(s10_s, r15.xyzw, 0).x;
            r14.w = -r14.w * 0.99000001 + r15.w;
            r14.w = 144.269501 * r14.w;
            r14.w = exp2(r14.w);
            r14.w = min(1, r14.w);
            r13.w = r14.w * r13.w;
        }
        r13.w = -1 + r13.w;
        r13.w = cb13[r11.w + 60].w * r13.w + 1;
        r13.w = r16.x * r13.w;
        r14.w = r16.z ? 1 : r11.y;
        r15.w = r16.w ? 1 : r10.w;
        r14.w = r15.w * r14.w;
        r13.w = r14.w * r13.w;
        r14.w = cmp(0 < r13.w);
        if (r14.w != 0)
        {
            r12.w = rsqrt(r12.w);
            r15.xyz = r15.xyz * r12.www;
            r16.xyz = cb13[r11.w + 61].xyz * r13.www;
            r11.w = dot(r7.xyz, r15.xyz);
            r11.w = max(-1, r11.w);
            r11.w = min(1, r11.w);
            r12.w = dot(r5.xyz, r15.xyz);
            r12.w = max(0, r12.w);
            r11.w = -r11.w * r11.w + 1;
            r11.w = sqrt(r11.w);
            r13.w = r12.w + -r11.w;
            r11.w = saturate(cb10[33].x * r13.w + r11.w);
            r11.w = cb10[33].y * r11.w;
            r17.xyz = r11.www * r16.xyz;
            r17.xyz = max(float3(0, 0, 0), r17.xyz);
            r13.xyz = r17.xyz + r13.xyz;
            r15.xyz = r3.xyz * r0.www + r15.xyz;
            r11.w = dot(r15.xyz, r15.xyz);
            r11.w = rsqrt(r11.w);
            r15.xyz = r15.xyz * r11.www;
            r11.w = dot(r7.xyz, r15.xyz);
            r11.w = max(-1, r11.w);
            r11.w = min(1, r11.w);
            r13.w = cb10[35].z * r1.z + r11.w;
            r13.w = max(-1, r13.w);
            r13.w = min(1, r13.w);
            r13.w = -r13.w * r13.w + 1;
            r13.w = sqrt(r13.w);
            r13.w = log2(r13.w);
            r13.w = cb10[35].y * r13.w;
            r13.w = exp2(r13.w);
            r11.w = cb10[36].z + r11.w;
            r11.w = max(-1, r11.w);
            r11.w = min(1, r11.w);
            r11.w = -r11.w * r11.w + 1;
            r11.w = sqrt(r11.w);
            r11.w = log2(r11.w);
            r11.w = cb10[36].y * r11.w;
            r11.w = exp2(r11.w);
            r11.w = cb10[36].x * r11.w;
            r11.w = cb10[35].x * r13.w + r11.w;
            r15.xyz = r16.xyz * r6.xyz;
            r15.xyz = r15.xyz * r11.www;
            r16.xyz = r15.xyz * r11.xxx;
            r15.xyz = r7.www ? r16.xyz : r15.xyz;
            r11.w = min(1, r12.w);
            r11.w = -1 + r11.w;
            r11.w = cb10[33].x * r11.w + 1;
            r15.xyz = r15.xyz * r11.www;
            r15.xyz = max(float3(0, 0, 0), r15.xyz);
            r14.xyz = r15.xyz + r14.xyz;
        }
        r11.z = (int) r11.z + 1;
    }
    r0.w = 0.25 + r9.w;
    r0.w = saturate(0.800000012 * r0.w);
    r1.y = r1.y + r0.w;
    r0.w = 1 + r0.w;
    r0.w = r1.y / r0.w;
    r0.w = min(r0.w, r1.x);
    r1.x = dot(-r4.xyz, r5.xyz);
    r1.x = r1.x + r1.x;
    r1.xyz = r5.xyz * -r1.xxx + -r4.xyz;
    r3.x = dot(r1.xyz, r1.xyz);
    r3.x = rsqrt(r3.x);
    r7.xyz = r3.xxx * r1.xyz;
    r8.xyz = ddx_coarse(r7.xyz);
    r11.xyz = ddy_coarse(r7.xyz);
    r8.xyz = r9.xxx ? -r8.xyz : r8.xyz;
    r9.xzw = r9.zzz ? -r11.xyz : r11.xyz;
    r8.xyz = r1.xyz * r3.xxx + r8.xyz;
    r3.y = dot(r8.xyz, r8.xyz);
    r3.y = rsqrt(r3.y);
    r8.xyz = r8.xyz * r3.yyy;
    r3.y = dot(r7.xyz, r8.xyz);
    r3.z = 1 + -abs(r3.y);
    r3.z = sqrt(r3.z);
    r7.w = abs(r3.y) * -0.0187292993 + 0.0742610022;
    r7.w = r7.w * abs(r3.y) + -0.212114394;
    r7.w = r7.w * abs(r3.y) + 1.57072878;
    r8.x = r7.w * r3.z;
    r8.x = r8.x * -2 + 3.14159274;
    r3.y = cmp(r3.y < -r3.y);
    r3.y = r3.y ? r8.x : 0;
    r3.y = r7.w * r3.z + r3.y;
    r3.y = 81.4873276 * r3.y;
    r3.y = log2(r3.y);
    r8.xyz = r1.xyz * r3.xxx + r9.xzw;
    r3.x = dot(r8.xyz, r8.xyz);
    r3.x = rsqrt(r3.x);
    r8.xyz = r8.xyz * r3.xxx;
    r3.x = dot(r7.xyz, r8.xyz);
    r3.z = 1 + -abs(r3.x);
    r3.z = sqrt(r3.z);
    r7.x = abs(r3.x) * -0.0187292993 + 0.0742610022;
    r7.x = r7.x * abs(r3.x) + -0.212114394;
    r7.x = r7.x * abs(r3.x) + 1.57072878;
    r7.y = r7.x * r3.z;
    r7.y = r7.y * -2 + 3.14159274;
    r3.x = cmp(r3.x < -r3.x);
    r3.x = r3.x ? r7.y : 0;
    r3.x = r7.x * r3.z + r3.x;
    r3.x = 81.4873276 * r3.x;
    r3.x = log2(r3.x);
    r3.xy = max(float2(0, 0), r3.xy);
    r3.x = max(r3.y, r3.x);
    r3.x = 0.625 * r3.x;
    r3.x = max(10.5, r3.x);
    r3.y = cmp(r5.z < 0);
    r3.z = r3.y ? 1 : 0; // fixed
    r7.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r5.xyxy;
    r8.x = -r1.w * r2.y + 1;
    r8.x = max(0.00100000005, r8.x);
    r7.xy = r7.xy / r8.xx;
    r1.w = r1.w * r2.y + 1;
    r1.w = max(0.00100000005, r1.w);
    r7.zw = r7.zw / r1.ww;
    r7.xyzw = float4(0.5, 0.5, 0.5, 0.5) + r7.xyzw;
    r7.xy = r3.yy ? r7.xy : r7.zw;
    r7.xy = r7.xy * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
    r8.x = (int) r3.z;
    r8.y = 0;
    r3.yz = r8.xy + r7.xy;
    r7.xy = float2(0.5, 0.142857149) * r3.yz;
    r8.xyz = cb12[114].xyz * r0.yyy;
    r8.xyz = cb12[113].xyz * r0.xxx + r8.xyz;
    r8.xyz = cb12[115].xyz * r0.zzz + r8.xyz;
    r8.xyz = cb12[116].xyz + r8.xyz;
    r8.xyz = float3(1, 1, 1) + -abs(r8.xyz);
    r3.yz = asint(cb12[117].yy) & int2(1, 2);
    r1.w = r3.y ? 1 : r4.w;
    r2.y = 1 + -r4.w;
    r3.y = r3.z ? 1 : r2.y;
    r1.w = r3.y * r1.w;
    r9.xzw = cmp(float3(0, 0, 0) < r8.xyz);
    r3.y = r9.z ? r9.x : 0;
    r3.y = r9.w ? r3.y : 0;
    r3.z = cmp(0 < r1.w);
    r3.y = r3.z ? r3.y : 0;
    if (r3.y != 0)
    {
        r8.xyz = saturate(cb12[112].xyz * r8.xyz);
        r1.w = cb12[111].x * r1.w;
        r1.w = 0.999989986 * r1.w;
        r3.y = r8.x * r8.y;
        r3.y = r3.y * r8.z;
        r3.z = r3.y * r1.w;
        r1.w = r1.w * r3.y + 9.99999975e-006;
        r3.y = cb12[117].x * r3.z;
        r3.z = asint(cb12[122].x);
        r7.z = r3.z * 0.142857149 + r7.y;
        r8.xyz = t22.SampleLevel(s11_s, r7.xz, 0).xyz;
        r8.xyz = r8.xyz * r3.yyy;
        r9.xzw = cb12[119].xyz * r1.yyy;
        r9.xzw = cb12[118].xyz * r1.xxx + r9.xzw;
        r9.xzw = cb12[120].xyz * r1.zzz + r9.xzw;
        r11.xyz = cb12[119].xyz * r0.yyy;
        r11.xyz = cb12[118].xyz * r0.xxx + r11.xyz;
        r11.xyz = cb12[120].xyz * r0.zzz + r11.xyz;
        r11.xyz = cb12[121].xyz + r11.xyz;
        r9.xzw = float3(1, 1, 1) / r9.xzw;
        r12.xyz = -r11.xyz * r9.xzw + r9.xzw;
        r9.xzw = -r11.xyz * r9.xzw + -r9.xzw;
        r9.xzw = max(r12.xyz, r9.xzw);
        r3.z = min(r9.z, r9.w);
        r3.z = min(r9.x, r3.z);
        r9.xzw = r1.xyz * r3.zzz + r0.xyz;
        r9.xzw = -cb12[111].yzw + r9.xzw;
        r3.z = dot(r9.xzw, r9.xzw);
        r3.z = rsqrt(r3.z);
        r11.xyz = r9.xzw * r3.zzz;
        r7.z = cmp(r11.z < 0);
        r8.w = r7.z ? 1 : 0; // fixed
        r11.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r11.xyxy;
        r9.x = -r9.w * r3.z + 1;
        r9.x = max(0.00100000005, r9.x);
        r9.xz = r11.xy / r9.xx;
        r9.xz = float2(0.5, 0.5) + r9.xz;
        r3.z = r9.w * r3.z + 1;
        r3.z = max(0.00100000005, r3.z);
        r11.xy = r11.zw / r3.zz;
        r11.xy = float2(0.5, 0.5) + r11.xy;
        r9.xz = r7.zz ? r9.xz : r11.xy;
        r9.xz = r9.xz * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
        r11.y = asint(cb12[122].x);
        r11.z = (int) r8.w;
        r11.xw = float2(0, 0);
        r9.xz = r11.zw + r9.xz;
        r9.xz = r11.xy + r9.xz;
        r9.xz = float2(0.5, 0.142857149) * r9.xz;
        r9.xzw = t23.SampleLevel(s11_s, r9.xz, r3.x).xyz;
        r9.xzw = r9.xzw * r3.yyy;
    }
    else
    {
        r8.xyz = float3(0, 0, 0);
        r9.xzw = float3(0, 0, 0);
        r1.w = 9.99999975e-006;
    }
    r3.y = cmp(r1.w < 0.999000013);
    if (r3.y != 0)
    {
        r11.xyz = cb12[126].xyz * r0.yyy;
        r11.xyz = cb12[125].xyz * r0.xxx + r11.xyz;
        r11.xyz = cb12[127].xyz * r0.zzz + r11.xyz;
        r11.xyz = cb12[128].xyz + r11.xyz;
        r11.xyz = float3(1, 1, 1) + -abs(r11.xyz);
        r12.xy = asint(cb12[129].yy) & int2(1, 2);
        r3.z = r12.x ? 1 : r4.w;
        r7.z = r12.y ? 1 : r2.y;
        r3.z = r7.z * r3.z;
        r12.xyz = cmp(float3(0, 0, 0) < r11.xyz);
        r7.z = r12.y ? r12.x : 0;
        r7.z = r12.z ? r7.z : 0;
        r8.w = cmp(0 < r3.z);
        r7.z = r8.w ? r7.z : 0;
        if (r7.z != 0)
        {
            r11.xyz = saturate(cb12[124].xyz * r11.xyz);
            r7.z = 1 + -r1.w;
            r3.z = r7.z * r3.z;
            r3.z = cb12[123].x * r3.z;
            r7.z = r11.x * r11.y;
            r7.z = r7.z * r11.z;
            r8.w = r7.z * r3.z;
            r1.w = r3.z * r7.z + r1.w;
            r3.z = cb12[129].x * r8.w;
            r7.z = asint(cb12[134].x);
            r7.w = r7.z * 0.142857149 + r7.y;
            r11.xyz = t22.SampleLevel(s11_s, r7.xw, 0).xyz;
            r8.xyz = r3.zzz * r11.xyz + r8.xyz;
            r11.xyz = cb12[131].xyz * r1.yyy;
            r11.xyz = cb12[130].xyz * r1.xxx + r11.xyz;
            r11.xyz = cb12[132].xyz * r1.zzz + r11.xyz;
            r12.xyz = cb12[131].xyz * r0.yyy;
            r12.xyz = cb12[130].xyz * r0.xxx + r12.xyz;
            r12.xyz = cb12[132].xyz * r0.zzz + r12.xyz;
            r12.xyz = cb12[133].xyz + r12.xyz;
            r11.xyz = float3(1, 1, 1) / r11.xyz;
            r15.xyz = -r12.xyz * r11.xyz + r11.xyz;
            r11.xyz = -r12.xyz * r11.xyz + -r11.xyz;
            r11.xyz = max(r15.xyz, r11.xyz);
            r7.z = min(r11.y, r11.z);
            r7.z = min(r11.x, r7.z);
            r11.xyz = r1.xyz * r7.zzz + r0.xyz;
            r11.xyz = -cb12[123].yzw + r11.xyz;
            r7.z = dot(r11.xyz, r11.xyz);
            r7.z = rsqrt(r7.z);
            r11.xyw = r11.xyz * r7.zzz;
            r7.w = cmp(r11.w < 0);
            r8.w = r7.w ? 1 : 0;
            r12.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r11.xyxy;
            r10.w = -r11.z * r7.z + 1;
            r10.w = max(0.00100000005, r10.w);
            r11.xy = r12.xy / r10.ww;
            r7.z = r11.z * r7.z + 1;
            r7.z = max(0.00100000005, r7.z);
            r11.zw = r12.zw / r7.zz;
            r11.xyzw = float4(0.5, 0.5, 0.5, 0.5) + r11.xyzw;
            r7.zw = r7.ww ? r11.xy : r11.zw;
            r7.zw = r7.zw * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
            r11.y = asint(cb12[134].x);
            r11.z = (int) r8.w;
            r11.xw = float2(0, 0);
            r7.zw = r11.zw + r7.zw;
            r7.zw = r11.xy + r7.zw;
            r7.zw = float2(0.5, 0.142857149) * r7.zw;
            r11.xyz = t23.SampleLevel(s11_s, r7.zw, r3.x).xyz;
            r9.xzw = r3.zzz * r11.xyz + r9.xzw;
        }
    }
    r3.z = cmp(r1.w < 0.999000013);
    r3.y = r3.z ? r3.y : 0;
    if (r3.y != 0)
    {
        r11.xyz = cb12[138].xyz * r0.yyy;
        r11.xyz = cb12[137].xyz * r0.xxx + r11.xyz;
        r11.xyz = cb12[139].xyz * r0.zzz + r11.xyz;
        r11.xyz = cb12[140].xyz + r11.xyz;
        r11.xyz = float3(1, 1, 1) + -abs(r11.xyz);
        r7.zw = asint(cb12[141].yy) & int2(1, 2);
        r3.z = r7.z ? 1 : r4.w;
        r7.z = r7.w ? 1 : r2.y;
        r3.z = r7.z * r3.z;
        r12.xyz = cmp(float3(0, 0, 0) < r11.xyz);
        r7.z = r12.y ? r12.x : 0;
        r7.z = r12.z ? r7.z : 0;
        r7.w = cmp(0 < r3.z);
        r7.z = r7.w ? r7.z : 0;
        if (r7.z != 0)
        {
            r11.xyz = saturate(cb12[136].xyz * r11.xyz);
            r7.z = 1 + -r1.w;
            r3.z = r7.z * r3.z;
            r3.z = cb12[135].x * r3.z;
            r7.z = r11.x * r11.y;
            r7.z = r7.z * r11.z;
            r7.w = r7.z * r3.z;
            r1.w = r3.z * r7.z + r1.w;
            r3.z = cb12[141].x * r7.w;
            r7.z = asint(cb12[146].x);
            r11.y = r7.z * 0.142857149 + r7.y;
            r11.x = r7.x;
            r11.xyz = t22.SampleLevel(s11_s, r11.xy, 0).xyz;
            r8.xyz = r3.zzz * r11.xyz + r8.xyz;
            r11.xyz = cb12[143].xyz * r1.yyy;
            r11.xyz = cb12[142].xyz * r1.xxx + r11.xyz;
            r11.xyz = cb12[144].xyz * r1.zzz + r11.xyz;
            r12.xyz = cb12[143].xyz * r0.yyy;
            r12.xyz = cb12[142].xyz * r0.xxx + r12.xyz;
            r12.xyz = cb12[144].xyz * r0.zzz + r12.xyz;
            r12.xyz = cb12[145].xyz + r12.xyz;
            r11.xyz = float3(1, 1, 1) / r11.xyz;
            r15.xyz = -r12.xyz * r11.xyz + r11.xyz;
            r11.xyz = -r12.xyz * r11.xyz + -r11.xyz;
            r11.xyz = max(r15.xyz, r11.xyz);
            r7.z = min(r11.y, r11.z);
            r7.z = min(r11.x, r7.z);
            r11.xyz = r1.xyz * r7.zzz + r0.xyz;
            r11.xyz = -cb12[135].yzw + r11.xyz;
            r7.z = dot(r11.xyz, r11.xyz);
            r7.z = rsqrt(r7.z);
            r11.xyw = r11.xyz * r7.zzz;
            r7.w = cmp(r11.w < 0);
            r8.w = r7.w ? 1 : 0;
            r12.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r11.xyxy;
            r10.w = -r11.z * r7.z + 1;
            r10.w = max(0.00100000005, r10.w);
            r11.xy = r12.xy / r10.ww;
            r7.z = r11.z * r7.z + 1;
            r7.z = max(0.00100000005, r7.z);
            r11.zw = r12.zw / r7.zz;
            r11.xyzw = float4(0.5, 0.5, 0.5, 0.5) + r11.xyzw;
            r7.zw = r7.ww ? r11.xy : r11.zw;
            r7.zw = r7.zw * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
            r11.y = asint(cb12[146].x);
            r11.z = (int) r8.w;
            r11.xw = float2(0, 0);
            r7.zw = r11.zw + r7.zw;
            r7.zw = r11.xy + r7.zw;
            r7.zw = float2(0.5, 0.142857149) * r7.zw;
            r11.xyz = t23.SampleLevel(s11_s, r7.zw, r3.x).xyz;
            r9.xzw = r3.zzz * r11.xyz + r9.xzw;
        }
    }
    r3.z = cmp(r1.w < 0.999000013);
    r3.y = r3.z ? r3.y : 0;
    if (r3.y != 0)
    {
        r11.xyz = cb12[150].xyz * r0.yyy;
        r11.xyz = cb12[149].xyz * r0.xxx + r11.xyz;
        r11.xyz = cb12[151].xyz * r0.zzz + r11.xyz;
        r11.xyz = cb12[152].xyz + r11.xyz;
        r11.xyz = float3(1, 1, 1) + -abs(r11.xyz);
        r7.zw = asint(cb12[153].yy) & int2(1, 2);
        r3.z = r7.z ? 1 : r4.w;
        r7.z = r7.w ? 1 : r2.y;
        r3.z = r7.z * r3.z;
        r12.xyz = cmp(float3(0, 0, 0) < r11.xyz);
        r7.z = r12.y ? r12.x : 0;
        r7.z = r12.z ? r7.z : 0;
        r7.w = cmp(0 < r3.z);
        r7.z = r7.w ? r7.z : 0;
        if (r7.z != 0)
        {
            r11.xyz = saturate(cb12[148].xyz * r11.xyz);
            r7.z = 1 + -r1.w;
            r3.z = r7.z * r3.z;
            r3.z = cb12[147].x * r3.z;
            r7.z = r11.x * r11.y;
            r7.z = r7.z * r11.z;
            r7.w = r7.z * r3.z;
            r1.w = r3.z * r7.z + r1.w;
            r3.z = cb12[153].x * r7.w;
            r7.z = asint(cb12[158].x);
            r11.y = r7.z * 0.142857149 + r7.y;
            r11.x = r7.x;
            r11.xyz = t22.SampleLevel(s11_s, r11.xy, 0).xyz;
            r8.xyz = r3.zzz * r11.xyz + r8.xyz;
            r11.xyz = cb12[155].xyz * r1.yyy;
            r11.xyz = cb12[154].xyz * r1.xxx + r11.xyz;
            r11.xyz = cb12[156].xyz * r1.zzz + r11.xyz;
            r12.xyz = cb12[155].xyz * r0.yyy;
            r12.xyz = cb12[154].xyz * r0.xxx + r12.xyz;
            r12.xyz = cb12[156].xyz * r0.zzz + r12.xyz;
            r12.xyz = cb12[157].xyz + r12.xyz;
            r11.xyz = float3(1, 1, 1) / r11.xyz;
            r15.xyz = -r12.xyz * r11.xyz + r11.xyz;
            r11.xyz = -r12.xyz * r11.xyz + -r11.xyz;
            r11.xyz = max(r15.xyz, r11.xyz);
            r7.z = min(r11.y, r11.z);
            r7.z = min(r11.x, r7.z);
            r11.xyz = r1.xyz * r7.zzz + r0.xyz;
            r11.xyz = -cb12[147].yzw + r11.xyz;
            r7.z = dot(r11.xyz, r11.xyz);
            r7.z = rsqrt(r7.z);
            r11.xyw = r11.xyz * r7.zzz;
            r7.w = cmp(r11.w < 0);
            r8.w = r7.w ? 1 : 0;
            r12.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r11.xyxy;
            r10.w = -r11.z * r7.z + 1;
            r10.w = max(0.00100000005, r10.w);
            r11.xy = r12.xy / r10.ww;
            r7.z = r11.z * r7.z + 1;
            r7.z = max(0.00100000005, r7.z);
            r11.zw = r12.zw / r7.zz;
            r11.xyzw = float4(0.5, 0.5, 0.5, 0.5) + r11.xyzw;
            r7.zw = r7.ww ? r11.xy : r11.zw;
            r7.zw = r7.zw * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
            r11.y = asint(cb12[158].x);
            r11.z = (int) r8.w;
            r11.xw = float2(0, 0);
            r7.zw = r11.zw + r7.zw;
            r7.zw = r11.xy + r7.zw;
            r7.zw = float2(0.5, 0.142857149) * r7.zw;
            r11.xyz = t23.SampleLevel(s11_s, r7.zw, r3.x).xyz;
            r9.xzw = r3.zzz * r11.xyz + r9.xzw;
        }
    }
    r3.z = cmp(r1.w < 0.999000013);
    r3.y = r3.z ? r3.y : 0;
    if (r3.y != 0)
    {
        r11.xyz = cb12[162].xyz * r0.yyy;
        r11.xyz = cb12[161].xyz * r0.xxx + r11.xyz;
        r11.xyz = cb12[163].xyz * r0.zzz + r11.xyz;
        r11.xyz = cb12[164].xyz + r11.xyz;
        r11.xyz = float3(1, 1, 1) + -abs(r11.xyz);
        r7.zw = asint(cb12[165].yy) & int2(1, 2);
        r3.z = r7.z ? 1 : r4.w;
        r7.z = r7.w ? 1 : r2.y;
        r3.z = r7.z * r3.z;
        r12.xyz = cmp(float3(0, 0, 0) < r11.xyz);
        r7.z = r12.y ? r12.x : 0;
        r7.z = r12.z ? r7.z : 0;
        r7.w = cmp(0 < r3.z);
        r7.z = r7.w ? r7.z : 0;
        if (r7.z != 0)
        {
            r11.xyz = saturate(cb12[160].xyz * r11.xyz);
            r7.z = 1 + -r1.w;
            r3.z = r7.z * r3.z;
            r3.z = cb12[159].x * r3.z;
            r7.z = r11.x * r11.y;
            r7.z = r7.z * r11.z;
            r7.w = r7.z * r3.z;
            r1.w = r3.z * r7.z + r1.w;
            r3.z = cb12[165].x * r7.w;
            r7.z = asint(cb12[170].x);
            r11.y = r7.z * 0.142857149 + r7.y;
            r11.x = r7.x;
            r11.xyz = t22.SampleLevel(s11_s, r11.xy, 0).xyz;
            r8.xyz = r3.zzz * r11.xyz + r8.xyz;
            r11.xyz = cb12[167].xyz * r1.yyy;
            r11.xyz = cb12[166].xyz * r1.xxx + r11.xyz;
            r11.xyz = cb12[168].xyz * r1.zzz + r11.xyz;
            r12.xyz = cb12[167].xyz * r0.yyy;
            r12.xyz = cb12[166].xyz * r0.xxx + r12.xyz;
            r12.xyz = cb12[168].xyz * r0.zzz + r12.xyz;
            r12.xyz = cb12[169].xyz + r12.xyz;
            r11.xyz = float3(1, 1, 1) / r11.xyz;
            r15.xyz = -r12.xyz * r11.xyz + r11.xyz;
            r11.xyz = -r12.xyz * r11.xyz + -r11.xyz;
            r11.xyz = max(r15.xyz, r11.xyz);
            r7.z = min(r11.y, r11.z);
            r7.z = min(r11.x, r7.z);
            r11.xyz = r1.xyz * r7.zzz + r0.xyz;
            r11.xyz = -cb12[159].yzw + r11.xyz;
            r7.z = dot(r11.xyz, r11.xyz);
            r7.z = rsqrt(r7.z);
            r11.xyw = r11.xyz * r7.zzz;
            r7.w = cmp(r11.w < 0);
            r8.w = r7.w ? 1 : 0;
            r12.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r11.xyxy;
            r10.w = -r11.z * r7.z + 1;
            r10.w = max(0.00100000005, r10.w);
            r11.xy = r12.xy / r10.ww;
            r7.z = r11.z * r7.z + 1;
            r7.z = max(0.00100000005, r7.z);
            r11.zw = r12.zw / r7.zz;
            r11.xyzw = float4(0.5, 0.5, 0.5, 0.5) + r11.xyzw;
            r7.zw = r7.ww ? r11.xy : r11.zw;
            r7.zw = r7.zw * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
            r11.y = asint(cb12[170].x);
            r11.z = (int) r8.w;
            r11.xw = float2(0, 0);
            r7.zw = r11.zw + r7.zw;
            r7.zw = r11.xy + r7.zw;
            r7.zw = float2(0.5, 0.142857149) * r7.zw;
            r11.xyz = t23.SampleLevel(s11_s, r7.zw, r3.x).xyz;
            r9.xzw = r3.zzz * r11.xyz + r9.xzw;
        }
    }
    r3.z = cmp(r1.w < 0.999000013);
    r3.y = r3.z ? r3.y : 0;
    if (r3.y != 0)
    {
        r11.xyz = cb12[174].xyz * r0.yyy;
        r11.xyz = cb12[173].xyz * r0.xxx + r11.xyz;
        r11.xyz = cb12[175].xyz * r0.zzz + r11.xyz;
        r11.xyz = cb12[176].xyz + r11.xyz;
        r11.xyz = float3(1, 1, 1) + -abs(r11.xyz);
        r3.yz = asint(cb12[177].yy) & int2(1, 2);
        r3.y = r3.y ? 1 : r4.w;
        r2.y = r3.z ? 1 : r2.y;
        r2.y = r3.y * r2.y;
        r12.xyz = cmp(float3(0, 0, 0) < r11.xyz);
        r3.y = r12.y ? r12.x : 0;
        r3.y = r12.z ? r3.y : 0;
        r3.z = cmp(0 < r2.y);
        r3.y = r3.z ? r3.y : 0;
        if (r3.y != 0)
        {
            r11.xyz = saturate(cb12[172].xyz * r11.xyz);
            r3.y = 1 + -r1.w;
            r2.y = r3.y * r2.y;
            r2.y = cb12[171].x * r2.y;
            r3.y = r11.x * r11.y;
            r3.y = r3.y * r11.z;
            r3.z = r3.y * r2.y;
            r1.w = r2.y * r3.y + r1.w;
            r2.y = cb12[177].x * r3.z;
            r3.y = asint(cb12[182].x);
            r11.y = r3.y * 0.142857149 + r7.y;
            r11.x = r7.x;
            r11.xyz = t22.SampleLevel(s11_s, r11.xy, 0).xyz;
            r8.xyz = r2.yyy * r11.xyz + r8.xyz;
            r11.xyz = cb12[179].xyz * r1.yyy;
            r11.xyz = cb12[178].xyz * r1.xxx + r11.xyz;
            r11.xyz = cb12[180].xyz * r1.zzz + r11.xyz;
            r12.xyz = cb12[179].xyz * r0.yyy;
            r12.xyz = cb12[178].xyz * r0.xxx + r12.xyz;
            r12.xyz = cb12[180].xyz * r0.zzz + r12.xyz;
            r12.xyz = cb12[181].xyz + r12.xyz;
            r11.xyz = float3(1, 1, 1) / r11.xyz;
            r15.xyz = -r12.xyz * r11.xyz + r11.xyz;
            r11.xyz = -r12.xyz * r11.xyz + -r11.xyz;
            r11.xyz = max(r15.xyz, r11.xyz);
            r3.y = min(r11.y, r11.z);
            r3.y = min(r11.x, r3.y);
            r0.xyz = r1.xyz * r3.yyy + r0.xyz;
            r0.xyz = -cb12[171].yzw + r0.xyz;
            r3.y = dot(r0.xyz, r0.xyz);
            r3.y = rsqrt(r3.y);
            r11.xyz = r3.yyy * r0.xyz;
            r0.x = cmp(r11.z < 0);
            r0.y = r0.x ? 1 : 0;
            r11.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r11.xyxy;
            r3.z = -r0.z * r3.y + 1;
            r3.z = max(0.00100000005, r3.z);
            r7.zw = r11.xy / r3.zz;
            r7.zw = float2(0.5, 0.5) + r7.zw;
            r0.z = r0.z * r3.y + 1;
            r0.z = max(0.00100000005, r0.z);
            r3.yz = r11.zw / r0.zz;
            r3.yz = float2(0.5, 0.5) + r3.yz;
            r0.xz = r0.xx ? r7.zw : r3.yz;
            r0.xz = r0.xz * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
            r11.y = asint(cb12[182].x);
            r11.z = (int) r0.y;
            r11.xw = float2(0, 0);
            r0.xy = r11.zw + r0.xz;
            r0.xy = r11.xy + r0.xy;
            r0.xy = float2(0.5, 0.142857149) * r0.xy;
            r0.xyz = t23.SampleLevel(s11_s, r0.xy, r3.x).xyz;
            r9.xzw = r2.yyy * r0.xyz + r9.xzw;
        }
    }
    r0.x = cmp(r1.w < 0.999000013);
    if (r0.x != 0)
    {
        r0.x = 1 + -r1.w;
        r0.y = cb12[99].x * r0.x;
        r1.w = r0.x * cb12[99].x + r1.w;
        r0.x = cb12[105].x * r0.y;
        r0.y = asint(cb12[110].x);
        r7.y = r0.y * 0.142857149 + r7.y;
        r7.xyz = t22.SampleLevel(s11_s, r7.xy, 0).xyz;
        r8.xyz = r0.xxx * r7.xyz + r8.xyz;
        r0.y = cmp(r1.z < 0);
        r0.z = r0.y ? 1 : 0;
        r7.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r1.xyxy;
        r1.x = 1 + -r1.z;
        r1.x = max(0.00100000005, r1.x);
        r1.xy = r7.xy / r1.xx;
        r1.xy = float2(0.5, 0.5) + r1.xy;
        r1.z = 1 + r1.z;
        r1.z = max(0.00100000005, r1.z);
        r3.yz = r7.zw / r1.zz;
        r3.yz = float2(0.5, 0.5) + r3.yz;
        r1.xy = r0.yy ? r1.xy : r3.yz;
        r1.xy = r1.xy * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
        r7.y = asint(cb12[110].x);
        r7.z = (int) r0.z;
        r7.xw = float2(0, 0);
        r0.yz = r7.zw + r1.xy;
        r0.yz = r7.xy + r0.yz;
        r0.yz = float2(0.5, 0.142857149) * r0.yz;
        r1.xyz = t23.SampleLevel(s11_s, r0.yz, r3.x).xyz;
        r9.xzw = r0.xxx * r1.xyz + r9.xzw;
    }
    r0.x = 1 / r1.w;
    r1.xyz = r8.xyz * r0.xxx; // diffuse ambient
    r0.xyz = r9.xzw * r0.xxx; // specular ambient

    UnderwaterModifyAmbientLighting(water_depth, exterior_lighting_scale, r1.xyz, r0.xyz);

    r1.w = abs(cb2[16].x) + -cb2[16].y;
    r1.w = r0.w * r1.w + cb2[16].y;
    r2.y = cb2[16].z + -cb2[16].w;
    r2.y = r0.w * r2.y + cb2[16].w;
    r1.xyz = r1.xyz * r1.www;
    r0.xyz = r2.yyy * r0.xyz;
    r1.xyz = cb10[37].xxx * r1.xyz;
    r1.w = -1 + cb12[184].z;
    r1.w = r6.w * r1.w + 1;
    r2.y = cb12[183].x + -cb12[183].y;
    r2.y = r0.w * r2.y + cb12[183].y;
    r2.y = r2.y * r1.w;
    r3.x = cb12[184].x + -cb12[184].y;
    r0.w = r0.w * r3.x + cb12[184].y;
    r0.w = r1.w * r0.w;
    r3.xyz = cb12[183].zzz * r13.xyz;
    r7.xyz = cb12[183].www * r14.xyz;
    r1.xyz = r2.yyy * r1.xyz;
    r1.w = dot(r5.xyz, r4.xyz);
    r1.w = max(abs(r1.w), abs(r1.w));
    r1.w = 1 + -r1.w;
    r1.w = max(0, r1.w);
    r2.y = r1.w * r1.w;
    r2.y = r2.y * r2.y;
    r1.w = r2.y * r1.w;
    r2.y = min(cb10[37].y, cb13[56].y);
    r4.xyz = -cb10[37].yyy * r6.xyz + float3(1, 1, 1);
    r4.xyz = max(float3(0, 0, 0), r4.xyz);
    r4.xyz = r4.xyz * r2.yyy;
    r4.xyz = r4.xyz * r1.www;
    r1.w = 1 + cb13[56].w;
    r4.xyz = r4.xyz / r1.www;
    r4.xyz = cb10[37].yyy * r6.xyz + r4.xyz;
    r5.xyz = float3(1, 1, 1) + -r4.xyz;
    r1.xyz = r5.xyz * r1.xyz;
    r0.xyz = r0.www * r0.xyz;
    r0.xyz = r0.xyz * r4.xyz;
    r0.w = cb12[69].x + cb12[69].y;
    r3.xyz = r3.xyz * r0.www;
    r4.xyz = r7.xyz * r0.www;
    r1.xyz = r1.xyz * r5.www + r3.xyz;
    r1.xyz = r2.xzw * r1.xyz + r4.xyz;
    r0.xyz = r0.xyz * r5.www + r1.xyz;
    r1.xyz = r10.xyz / r3.www;
    r0.w = -cb12[22].z + r3.w;
    r0.w = max(0, r0.w);
    r0.w = min(cb12[42].z, r0.w);
    r1.x = dot(cb12[38].xyz, r1.xyz);
    r1.y = abs(r1.x) * abs(r1.x);
    r1.w = saturate(r0.w * 0.00200000009 + -0.300000012);
    r1.y = r1.y * r1.w;
    r1.w = cmp(0 < r1.x);
    r2.xyz = r1.www ? cb12[39].xyz : cb12[41].xyz;
    r2.xyz = -cb12[40].xyz + r2.xyz;
    r2.xyz = r1.yyy * r2.xyz + cb12[40].xyz;
    r3.xyz = r1.www ? cb12[45].xyz : cb12[47].xyz;
    r3.xyz = -cb12[46].xyz + r3.xyz;
    r3.xyz = r1.yyy * r3.xyz + cb12[46].xyz;
    r1.y = cmp(r0.w >= cb12[48].y);
    if (r1.y != 0)
    {
        r1.y = r1.z * cb12[22].z + cb12[0].z;
        r1.z = r1.z * r0.w;
        r1.w = cb12[43].x * r0.w;
        r1.zw = float2(0.0625, 0.0625) * r1.zw;
        r1.x = cb12[42].x + r1.x;
        r2.w = 1 + cb12[42].x;
        r1.x = saturate(r1.x / r2.w);
        r2.w = cb12[43].y + -cb12[43].z;
        r1.x = r1.x * r2.w + cb12[43].z;
        r1.y = cb12[42].y + r1.y;
        r2.w = r1.y * r1.x;
        r1.z = r1.z * r1.x;
        r4.xyzw = r1.zzzz * float4(16, 15, 14, 13) + r2.wwww;
        r4.xyzw = max(float4(0, 0, 0, 0), r4.xyzw);
        r4.xyzw = float4(1, 1, 1, 1) + r4.xyzw;
        r4.xyzw = saturate(r1.wwww / r4.xyzw);
        r4.xyzw = float4(1, 1, 1, 1) + -r4.xyzw;
        r3.w = r4.x * r4.y;
        r3.w = r3.w * r4.z;
        r3.w = r3.w * r4.w;
        r4.xyzw = r1.zzzz * float4(12, 11, 10, 9) + r2.wwww;
        r4.xyzw = max(float4(0, 0, 0, 0), r4.xyzw);
        r4.xyzw = float4(1, 1, 1, 1) + r4.xyzw;
        r4.xyzw = saturate(r1.wwww / r4.xyzw);
        r4.xyzw = float4(1, 1, 1, 1) + -r4.xyzw;
        r3.w = r4.x * r3.w;
        r3.w = r3.w * r4.y;
        r3.w = r3.w * r4.z;
        r3.w = r3.w * r4.w;
        r4.xyzw = r1.zzzz * float4(8, 7, 6, 5) + r2.wwww;
        r4.xyzw = max(float4(0, 0, 0, 0), r4.xyzw);
        r4.xyzw = float4(1, 1, 1, 1) + r4.xyzw;
        r4.xyzw = saturate(r1.wwww / r4.xyzw);
        r4.xyzw = float4(1, 1, 1, 1) + -r4.xyzw;
        r3.w = r4.x * r3.w;
        r3.w = r3.w * r4.y;
        r3.w = r3.w * r4.z;
        r3.w = r3.w * r4.w;
        r4.xy = r1.zz * float2(4, 3) + r2.ww;
        r4.xy = max(float2(0, 0), r4.xy);
        r4.xy = float2(1, 1) + r4.xy;
        r4.xy = saturate(r1.ww / r4.xy);
        r4.xy = float2(1, 1) + -r4.xy;
        r3.w = r4.x * r3.w;
        r3.w = r3.w * r4.y;
        r2.w = r1.z * 2 + r2.w;
        r2.w = max(0, r2.w);
        r2.w = 1 + r2.w;
        r2.w = saturate(r1.w / r2.w);
        r2.w = 1 + -r2.w;
        r2.w = r3.w * r2.w;
        r1.x = r1.y * r1.x + r1.z;
        r1.x = max(0, r1.x);
        r1.x = 1 + r1.x;
        r1.x = saturate(r1.w / r1.x);
        r1.x = 1 + -r1.x;
        r1.x = -r2.w * r1.x + 1;
        r0.w = -cb12[48].y + r0.w;
        r0.w = saturate(cb12[48].z * r0.w);
    }
    else
    {
        r1.x = 1;
        r0.w = 0;
    }
    r1.x = log2(r1.x);
    r1.y = cb12[42].w * r1.x;
    r1.y = exp2(r1.y);
    r1.y = r1.y * r0.w;
    r1.x = cb12[48].x * r1.x;
    r1.x = exp2(r1.x);
    r0.w = r1.x * r0.w;
    r1.xz = saturate(r1.yy * cb12[189].xz + cb12[189].yw);
    r4.xyz = cb12[188].xyz + -r2.xyz;
    r4.xyz = r1.xxx * r4.xyz + r2.xyz;
    r1.x = -1 + cb12[188].w;
    r1.x = r1.z * r1.x + 1;
    r4.w = saturate(r1.y * r1.x);
    r1.x = cmp(0 < cb12[192].x);
    if (r1.x != 0)
    {
        r1.xz = saturate(r1.yy * cb12[191].xz + cb12[191].yw);
        r5.xyz = cb12[190].xyz + -r2.xyz;
        r2.xyz = r1.xxx * r5.xyz + r2.xyz;
        r1.x = -1 + cb12[190].w;
        r1.x = r1.z * r1.x + 1;
        r2.w = saturate(r1.y * r1.x);
        r1.xyzw = r2.xyzw + -r4.xyzw;
        r4.xyzw = cb12[192].xxxx * r1.xyzw + r4.xyzw;
    }
    r1.x = dot(float3(0.333000004, 0.555000007, 0.222000003), r0.xyz);
    r1.xyz = r1.xxx * r3.xyz + -r0.xyz;
    r0.xyz = r0.www * r1.xyz + r0.xyz;
    r1.xyz = r4.xyz + -r0.xyz;
    r0.xyz = r4.www * r1.xyz + r0.xyz;
    o0.xyz = max(float3(0, 0, 0), r0.xyz);
    r0.x = cb10[39].w + 9.99999994e-009;
    r0.x = saturate(r9.y / r0.x);
    r0.y = -cb10[29].z + 1;
    o0.w = r0.x * r0.y;

    return;
}