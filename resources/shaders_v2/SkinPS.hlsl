#include "WaterCommon.hlsli"

Texture2D<float4> t23 : register(t23);
Texture2D<float4> t22 : register(t22);
ByteAddressBuffer t20 : register(t20);
Texture2D<float4> t17 : register(t17);
TextureCubeArray<float4> t10 : register(t10);
Texture2DArray<float4> t9 : register(t9);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);

SamplerState s11_s : register(s11);

SamplerState s10_s : register(s10);

SamplerState s0_s : register(s0);

cbuffer cb13 : register(b13)
{
    float4 cb13[2362];
}

cbuffer cb4 : register(b4)
{
    float4 cb4[34];
}

cbuffer cb12 : register(b12)
{
    float4 cb12[219];
}

cbuffer cb3 : register(b3)
{
    float4 cb3[25];
}

cbuffer cb2 : register(b2)
{
    float4 cb2[17];
}

cbuffer cb1 : register(b1)
{
    float4 cb1[9];
}




// 3Dmigoto declarations
#define cmp -



void PSMain(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float4 v3 : TEXCOORD3,
  float4 world_position : TEXCOORD4,
  float3 v5 : TEXCOORD5,
  float4 sv_position : SV_Position0,
  out float4 o0 : SV_Target0)
{
// Needs manual fix for instruction:
// unknown dcl_: dcl_resource_raw t20
    float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27, r28, r29;

    float water_depth = _water_depth.Load(int3(sv_position.xy, 0));

    r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
    r0.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r0.xyzw;
    r1.xyz = t1.Sample(s0_s, v1.xy).xyz;
    r1.xyz = float3(-0.5, -0.5, -0.5) + r1.xyz;
    r2.xy = cb4[0].xy * v1.xy;
    r2.xyzw = t2.Sample(s0_s, r2.xy).xyzw;
    r2.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r2.xyzw;
    r2.xyz = r2.xyz + r2.xyz;
    r3.xyz = cb1[8].xyz + -world_position.xyz;
    r1.w = dot(r3.xyz, r3.xyz);
    r3.w = sqrt(r1.w);
    r3.w = saturate(cb4[2].x + -r3.w);
    r4.xyz = t3.Sample(s0_s, v1.xy).xyz;
    r4.w = cb4[1].x * r4.x;
    r2.xy = r4.ww * r2.xy;
    r4.w = dot(r2.xyz, r2.xyz);
    r4.w = rsqrt(r4.w);
    r1.xyz = r1.xyz * float3(2, 2, 2) + float3(0, 0, 1);
    r2.xyz = r2.xyz * r4.www + float3(-0, -0, -0.5);
    r2.xyz = r3.www * r2.xyz + float3(0, 0, 0.5);
    r4.w = dot(r2.xyz, r2.xyz);
    r4.w = rsqrt(r4.w);
    r2.xyz = r4.www * r2.xyz;
    r2.xyz = float3(-1, -1, 1) * r2.xyz;
    r4.w = dot(r1.xyz, r2.xyz);
    r2.xyz = r2.xyz * r1.zzz;
    r1.xyz = r1.xyz * r4.www + -r2.xyz;
    r2.x = dot(r1.xyz, r1.xyz);
    r2.x = rsqrt(r2.x);
    r5.xyzw = cmp(cb3[0].xyzw < v1.xxxx);
    r6.xyzw = cmp(cb3[1].xyzw < v1.xxxx);
    r7.xyzw = cmp(cb3[2].xyzw < v1.xxxx);
    r8.xyzw = cmp(cb3[3].xyzw < v1.xxxx);
    r9.xyzw = cmp(cb3[4].xyzw < v1.yyyy);
    r10.xyzw = cmp(cb3[5].xyzw < v1.yyyy);
    r11.xyzw = cmp(cb3[6].xyzw < v1.yyyy);
    r12.xyzw = cmp(cb3[7].xyzw < v1.yyyy);
    r13.xyzw = cmp(v1.xxxx < cb3[8].xyzw);
    r14.xyzw = cmp(v1.xxxx < cb3[9].xyzw);
    r15.xyzw = cmp(v1.xxxx < cb3[10].xyzw);
    r16.xyzw = cmp(v1.xxxx < cb3[11].xyzw);
    r17.xyzw = cmp(v1.yyyy < cb3[12].xyzw);
    r18.xyzw = cmp(v1.yyyy < cb3[13].xyzw);
    r19.xyzw = cmp(v1.yyyy < cb3[14].xyzw);
    r20.xyzw = cmp(v1.yyyy < cb3[15].xyzw);
    r5.xyzw = r5.xyzw ? r9.xyzw : 0;
    r6.xyzw = r6.xyzw ? r10.xyzw : 0;
    r7.xyzw = r7.xyzw ? r11.xyzw : 0;
    r8.xyzw = r8.xyzw ? r12.xyzw : 0;
    r5.xyzw = r13.xyzw ? r5.xyzw : 0;
    r6.xyzw = r14.xyzw ? r6.xyzw : 0;
    r7.xyzw = r15.xyzw ? r7.xyzw : 0;
    r8.xyzw = r16.xyzw ? r8.xyzw : 0;
    r5.xyzw = r17.xyzw ? r5.xyzw : 0;
    r6.xyzw = r18.xyzw ? r6.xyzw : 0;
    r7.xyzw = r19.xyzw ? r7.xyzw : 0;
    r8.xyzw = r20.xyzw ? r8.xyzw : 0;
    r5.xyzw = r5.xyzw ? float4(1, 1, 1, 1) : 0;
    r6.xyzw = r6.xyzw ? float4(1, 1, 1, 1) : 0;
    r7.xyzw = r7.xyzw ? float4(1, 1, 1, 1) : 0;
    r8.xyzw = r8.xyzw ? float4(1, 1, 1, 1) : 0;
    r5.xyzw = cb3[16].xyzw * r5.xyzw;
    r6.xyzw = cb3[17].xyzw * r6.xyzw;
    r7.xyzw = cb3[18].xyzw * r7.xyzw;
    r8.xyzw = cb3[19].xyzw * r8.xyzw;
    r5.x = dot(r5.xyzw, r5.xyzw);
    r5.y = dot(r6.xyzw, r6.xyzw);
    r5.z = dot(r7.xyzw, r7.xyzw);
    r5.w = dot(r8.xyzw, r8.xyzw);
    r2.y = dot(r5.xyzw, float4(1, 1, 1, 1));
    r2.y = min(1, r2.y);
    r1.xyz = r1.xyz * r2.xxx + float3(0, 0, 1);
    r0.xyzw = r0.xyzw * float4(2, 2, 2, 2) + float4(-0, -0, -0.5, 1);
    r0.xyz = r2.yyy * r0.xyz + float3(0, 0, 0.5);
    r2.x = dot(r0.xyz, r0.xyz);
    r2.x = rsqrt(r2.x);
    r0.xyz = r2.xxx * r0.xyz;
    r0.xyz = float3(-1, -1, 1) * r0.xyz;
    r2.x = dot(r1.xyz, r0.xyz);
    r0.xyz = r0.xyz * r1.zzz;
    r0.xyz = r1.xyz * r2.xxx + -r0.xyz;
    r1.x = dot(r0.xyz, r0.xyz);
    r1.x = rsqrt(r1.x);
    r0.xyz = r1.xxx * r0.xyz;
    r0.w = -r0.w * 0.5 + 1;
    r0.w = -r2.y * r0.w + 1;
    r1.x = cb4[3].x * cb4[1].x;
    r1.y = 0.5 * r2.w;
    r1.z = -0.550000012 + r4.x;
    r1.z = saturate(2.22222233 * r1.z);
    r1.z = -r1.y * r1.z;
    r1.z = r1.z * r3.w;
    r1.x = r1.z * r1.x + 1;
    r1.x = max(0, r1.x);
    r2.xyz = t4.Sample(s0_s, v1.xy).xyz;
    r2.xyz = log2(r2.xyz);
    r2.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r2.xyz;
    r2.xyz = exp2(r2.xyz);
    r2.xyz = r2.xyz * r1.xxx;
    r2.xyz = log2(r2.xyz);
    r2.xyz = float3(0.454544991, 0.454544991, 0.454544991) * r2.xyz;
    r2.xyz = exp2(r2.xyz);
    r1.x = r2.x + r2.y;
    r1.x = r1.x + r2.z;
    r1.z = 0.333299994 * r1.x;
    r2.w = cb4[5].x + -1;
    r2.w = 0.5 * r2.w;
    r4.w = saturate(r2.w);
    r1.x = r1.x * -0.666599989 + 1;
    r1.x = r4.w * r1.x + r1.z;
    r5.xyz = cb4[4].xyz * r2.xyz;
    r5.xyz = saturate(float3(1.5, 1.5, 1.5) * r5.xyz);
    r1.x = saturate(r1.x * abs(r2.w));
    r5.xyz = r5.xyz + -r2.xyz;
    r2.xyz = r1.xxx * r5.xyz + r2.xyz;
    r5.xyz = r0.www * float3(0.192156971, 0.517647028, 0.517647028) + float3(0.807843029, 0.482353002, 0.482353002);
    r2.xyz = saturate(r5.xyz * r2.xyz);
    r5.x = v0.w;
    r5.yz = v1.zw;
    r5.xyz = r5.xyz * r0.yyy;
    r0.xyw = v5.xyz * r0.xxx + r5.xyz;
    r0.xyz = v3.xyz * r0.zzz + r0.xyw;
    r0.w = 0.649999976 * v0.z;
    r1.x = r4.x * r3.w;
    r1.x = cb4[1].x * r1.x;
    r1.x = saturate(r1.x * r1.y + r4.y);
    r1.y = saturate(cb4[6].x + r1.x);
    r4.xyw = log2(cb4[7].xyz);
    r4.xyw = float3(2.20000005, 2.20000005, 2.20000005) * r4.xyw;
    r4.xyw = exp2(r4.xyw);
    r1.z = r4.z * cb4[8].x + cb4[9].x;
    r4.xyw = saturate(r4.xyw * r1.zzz);
    r4.xyw = log2(r4.xyw);
    r4.xyw = float3(0.454544991, 0.454544991, 0.454544991) * r4.xyw;
    r4.xyw = exp2(r4.xyw);
    r1.z = max(r4.y, r4.w);
    r1.z = max(r4.x, r1.z);
    r1.z = cmp(0.200000003 < r1.z);
    r5.xyz = r1.zzz ? r4.xyw : float3(0.119999997, 0.119999997, 0.119999997);
    r5.xyz = r5.xyz + -r4.xyw;
    r4.xyw = saturate(r0.www * r5.xyz + r4.xyw);
    r1.z = cmp(r1.y < 0.330000013);
    r2.w = 0.949999988 * r1.y;
    r1.z = r1.z ? r2.w : 0.330000013;
    r1.z = r1.z + -r1.y;
    r0.w = saturate(r0.w * r1.z + r1.y);
    r1.y = rsqrt(r1.w);
    r1.yzw = r3.xyz * r1.yyy;
    r1.y = dot(r0.xyz, r1.yzw);
    r1.y = saturate(1 + -r1.y);
    r1.y = log2(r1.y);
    r1.y = cb4[10].x * r1.y;
    r1.y = 0.899999976 * r1.y;
    r1.y = exp2(r1.y);
    r1.y = saturate(cb4[11].x * r1.y);
    r1.z = saturate(cb4[13].x * v2.z);
    r1.x = saturate(cb4[14].x + r1.x);
    r1.w = log2(r4.z);
    r1.w = cb4[16].x * r1.w;
    r1.w = exp2(r1.w);
    r3.xyz = log2(cb4[15].xyz);
    r3.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r3.xyz;
    r3.xyz = exp2(r3.xyz);
    r1.w = r1.w * cb4[17].x + cb4[18].x;
    r3.xyz = saturate(r3.xyz * r1.www);
    r1.w = cb4[20].x * 0.800000012 + cb4[21].x;
    r5.xy = cb4[25].xx * float2(0, 1);
    r5.xy = cb4[24].xx * float2(1, 0) + r5.xy;
    r6.xyz = cb4[30].xyz * cb4[30].xyz;
    r2.xyz = log2(r2.xyz);
    r2.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r2.xyz;
    r2.xyz = exp2(r2.xyz);
    r4.xyz = log2(r4.xyw);
    r4.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r4.xyz;
    r4.xyz = exp2(r4.xyz);
    r7.xy = (uint2) sv_position.xy;
    r2.w = dot(r0.xyz, r0.xyz);
    r2.w = rsqrt(r2.w);
    r8.xyz = r2.www * r0.xyz;
    r3.w = dot(v3.xyz, v3.xyz);
    r3.w = rsqrt(r3.w);
    r9.xyz = v3.xyz * r3.www;
    r5.zw = (uint2) r7.xy >> int2(4, 4);
    r3.w = (int) cb12[24].x;
    r3.w = mad((int) r5.w, (int) r3.w, (int) r5.z);
    r3.w = (uint) r3.w << 8;
    r10.xyz = cb12[0].xyz + -world_position.xyz;
    r4.w = dot(r10.xyz, r10.xyz);
    r4.w = rsqrt(r4.w);
    r11.xyz = r10.xyz * r4.www;
    r7.zw = float2(0, 0);
    r12.xyzw = t17.Load(r7.xyz).xyzw;

    float exterior_lighting_scale = r12.z;

    r5.z = cmp(0 < cb4[26].x);
    r5.w = cmp(cb3[24].y != 0.000000);
    r6.w = cmp(r12.z == 1.000000);
    r7.z = r5.z ? cb4[29].x : cb4[28].x;
    r13.x = cb3[21].z * r7.z + cb3[21].y;
    r13.y = cb3[22].z * r7.z + cb3[22].y;
    r13.z = cb3[23].z * r7.z + cb3[23].y;
    r14.xyz = world_position.xyz + -r13.xyz;
    r7.z = dot(r14.xyz, r14.xyz);
    r7.z = rsqrt(r7.z);
    r14.xyz = r14.xyz * r7.zzz;
    r15.x = r5.z ? r14.x : cb3[21].x;
    r15.y = r5.z ? r14.y : cb3[22].x;
    r15.z = r5.z ? r14.z : cb3[23].x;
    r7.z = cb4[27].x * v2.y + -0.200000003;
    r5.z = r5.z ? -r7.z : -0.58431375;
    r7.z = cmp(cb2[16].x < 0);
    r7.z = r7.z ? 1 : cb12[71].x;
    r7.w = 1 + r1.w;
    r8.w = cb4[23].x + -cb4[22].x;
    r14.xyz = r0.xyz * r2.www + -r9.xyz;
    r9.w = 1 / r7.w;
    r10.w = r9.w * r1.w;
    r16.xyz = -cb4[12].xyz * cb4[12].xyz + float3(1, 1, 1);
    r17.xyz = -cb4[30].xyz * cb4[30].xyz + float3(1, 1, 1);
    r11.w = 1 + -r0.w;
    r18.xyz = float3(1, 1, 1) + -r4.xyz;
    r18.xyz = cb13[56].xxx * r18.xyz;
    r19.xy = float2(1, 1) + cb13[56].zw;
    r11.w = -cb13[56].z * r11.w + r19.x;
    r13.w = dot(r8.xyz, -r11.xyz);
    r13.w = 1 + r13.w;
    r13.w = 0.190500006 * r13.w;
    r14.w = dot(r8.xyz, r11.xyz);
    r15.w = r0.w * r0.w;
    r16.w = r15.w * r15.w;
    r15.w = r15.w * r15.w + -1;
    r0.w = 1 + r0.w;
    r0.w = r0.w * r0.w;
    r17.w = 0.125 * r0.w;
    r0.w = -r0.w * 0.125 + 1;
    r18.w = abs(r14.w) * r0.w + r17.w;
    r18.w = abs(r14.w) / r18.w;
    r14.w = 4 * abs(r14.w);
    r19.x = r6.w ? 1.000000 : 0;
    r6.w = r6.w ? 0 : 1;
    r20.xyz = float3(0, 0, 0);
    r21.xyz = float3(0, 0, 0);
    r19.z = 0;
    while (true)
    {
        r19.w = cmp((int) r19.z >= 256);
        if (r19.w != 0)
            break;
        r19.w = (int) r3.w + (int) r19.z;
        r19.w = (uint) r19.w << 2;
  // No code for instruction (needs manual fix):
       // ld_raw_indexable(raw_buffer) (mixed, mixed, mixed, mixed) r19.w, r19.w, t20.xxxx
        r19.w = t20.Load(r19.w);

        r20.w = cmp((uint) r19.w >= 256);
        if (r20.w != 0)
        {
            break;
        }
        r19.w = (int) r19.w * 9;
        r22.xyz = cb13[r19.w + 58].xyz + -world_position.xyz;
        r20.w = dot(r22.xyz, r22.xyz);
        r21.w = sqrt(r20.w);
        r23.x = r21.w / cb13[r19.w + 58].w;
        r23.y = r23.x * r23.x;
        r23.y = -r23.y * r23.y + 1;
        r23.y = max(0, r23.y);
        r23.y = r23.y * r23.y;
        r24.xyz = int3(1, 2048, 4096) & asint(cb13[r19.w + 61].www);
        r23.z = cmp(0 < cb13[r19.w + 63].z);
        r23.w = cmp(0 < cb13[r19.w + 64].x);
        r24.w = r20.w * cb13[r19.w + 63].x + 1;
        r23.y = r23.y / r24.w;
        if (r24.x != 0)
        {
            r24.w = rsqrt(r20.w);
            r25.xyz = r24.www * r22.xyz;
            r24.w = dot(-r25.xyz, cb13[r19.w + 60].xyz);
            r24.w = saturate(r24.w * cb13[r19.w + 62].y + cb13[r19.w + 62].z);
            r24.w = log2(r24.w);
            r24.w = cb13[r19.w + 62].w * r24.w;
            r24.w = exp2(r24.w);
            r23.y = r24.w * r23.y;
        }
        r24.w = cmp(0 < r23.y);
        r23.z = r23.z ? r24.w : 0;
        if (r23.z != 0)
        {
            if (r24.x != 0)
            {
                r25.xyz = -cb13[r19.w + 58].xyz + world_position.xyz;
                r26.xyz = cb13[r19.w + 65].zwy * cb13[r19.w + 60].zxy;
                r26.xyz = cb13[r19.w + 60].yzx * cb13[r19.w + 65].wyz + -r26.xyz;
                r26.x = dot(r26.xyz, r25.xyz);
                r26.y = dot(cb13[r19.w + 65].yzw, r25.xyz);
                r26.z = dot(cb13[r19.w + 60].xyz, r25.xyz);
                r26.w = cb13[r19.w + 65].x;
            }
            else
            {
                r25.xyz = -cb13[r19.w + 58].xzy + world_position.xzy;
                r27.xyz = r22.xyz / r21.www;
                r21.w = max(abs(r27.y), abs(r27.z));
                r21.w = cmp(r21.w < abs(r27.x));
                if (r21.w != 0)
                {
                    r21.w = cmp(0 < r27.x);
                    r28.xyz = float3(1, 1, -1) * r25.zyx;
                    r28.w = cb13[r19.w + 65].x;
                    r29.xyz = float3(-1, 1, 1) * r25.zyx;
                    r29.w = cb13[r19.w + 65].y;
                    r26.xyzw = r21.wwww ? r28.xyzw : r29.xyzw;
                }
                else
                {
                    r21.w = max(abs(r27.x), abs(r27.z));
                    r21.w = cmp(r21.w < abs(r27.y));
                    if (r21.w != 0)
                    {
                        r21.w = cmp(0 < r27.y);
                        r28.xyz = float3(-1, 1, -1) * r25.xyz;
                        r28.w = cb13[r19.w + 65].z;
                        r25.w = cb13[r19.w + 65].w;
                        r26.xyzw = r21.wwww ? r28.xyzw : r25.xyzw;
                    }
                    else
                    {
                        r21.w = cmp(0 < r27.z);
                        r26.x = r25.x;
                        r26.y = r21.w ? r25.z : -r25.z;
                        r26.z = r21.w ? -r25.y : r25.y;
                        r26.w = r21.w ? cb13[r19.w + 66].x : cb13[r19.w + 66].y;
                    }
                }
            }
            r25.xy = cb13[r19.w + 63].yy * r26.xy;
            r25.xy = r25.xy / r26.zz;
            r25.xy = r25.xy * float2(0.5, -0.5) + float2(0.5, 0.5);

            //if (10 == 0)
            //    r25.z = 0;
            //else if (10 + 20 < 32)
            //{
            //    r25.z = (uint) r26.w << (32 - (10 + 20));
            //    r25.z = (uint) r25.z >> (32 - 10);
            //}
            //else
            //    r25.z = (uint) r26.w >> 20;
            //if (10 == 0)
            //    r25.w = 0;
            //else if (10 + 10 < 32)
            //{
            //    r25.w = (uint) r26.w << (32 - (10 + 10));
            //    r25.w = (uint) r25.w >> (32 - 10);
            //}
            //else
            //    r25.w = (uint) r26.w >> 10;

            //r25.zw = (uint2) r25.zw;
            //r21.w = (int) r26.w & 1023;
            //r21.w = (uint) r21.w;
            //r23.z = (uint) r26.w >> 30;
            //r26.z = (uint) r23.z;

            uint source = asuint(r26.w);
            r25.zw = (source.xx >> int2(20, 10)) & 1023;
            r21.w = source & 1023;
            r23.z = source >> 30;
            r26.z = (uint) r23.z;

            r23.z = cmp(0 < r21.w);
            if (r23.z != 0)
            {
                r25.xy = r25.xy * r21.ww + r25.zw;
                r26.xy = float2(0.0009765625, 0.0009765625) * r25.xy;
                r21.w = t9.SampleLevel(s10_s, r26.xyz, 0).x;
                r21.w = -r23.x * 0.99000001 + r21.w;
                r21.w = 144.269501 * r21.w;
                r21.w = exp2(r21.w);
                r21.w = min(1, r21.w);
            }
            else
            {
                r21.w = 1;
            }
        }
        else
        {
            r21.w = 1;
        }
        r23.z = r23.w ? r24.w : 0;
        if (r23.z != 0)
        {
            r22.w = cb13[r19.w + 64].y;
            r22.w = t10.SampleLevel(s10_s, r22.xyzw, 0).x;
            r22.w = -r23.x * 0.99000001 + r22.w;
            r22.w = 144.269501 * r22.w;
            r22.w = exp2(r22.w);
            r22.w = min(1, r22.w);
            r21.w = r22.w * r21.w;
        }
        r21.w = -1 + r21.w;
        r21.w = cb13[r19.w + 60].w * r21.w + 1;
        r21.w = r23.y * r21.w;
        if (r5.w != 0)
        {
            r23.xyz = cb13[r19.w + 58].xyz + -r13.xyz;
            r22.w = dot(r23.xyz, r23.xyz);
            r22.w = rsqrt(r22.w);
            r23.xyz = r23.xyz * r22.www;
            r22.w = dot(r15.xyz, r23.xyz);
            r22.w = r22.w * 0.5 + r5.z;
            r22.w = 0.5 + r22.w;
            r22.w = saturate(5 * r22.w);
        }
        else
        {
            r22.w = 1;
        }
        r21.w = r22.w * r21.w;
        r23.x = r24.y ? 1 : r19.x;
        r23.y = r24.z ? 1 : r6.w;
        r23.x = r23.x * r23.y;
        r21.w = r23.x * r21.w;
        r23.x = cmp(0 < r21.w);
        if (r23.x != 0)
        {
            r22.w = r22.w * r1.y;
            r23.x = 0x80000000 & asint(cb13[r19.w + 61].w);
            r23.x = r23.x ? r7.z : 1;
            r21.w = r23.x * r21.w;
            r20.w = rsqrt(r20.w);
            r22.xyz = r22.xyz * r20.www;
            r20.w = dot(r9.xyz, r22.xyz);
            r20.w = r20.w + r1.w;
            r20.w = saturate(r20.w / r7.w);
            r20.w = log2(r20.w);
            r20.w = cb4[19].x * r20.w;
            r20.w = exp2(r20.w);
            r20.w = saturate(r20.w * r8.w + cb4[22].x);
            r23.xyz = r20.www * r14.xyz + r9.xyz;
            r20.w = dot(r23.xyz, r23.xyz);
            r20.w = rsqrt(r20.w);
            r24.xyz = r23.xyz * r20.www;
            r23.w = dot(r24.xyz, r22.xyz);
            r23.w = r23.w * r9.w + r10.w;
            r23.xyz = r23.xyz * r20.www + -r9.xyz;
            r24.xyz = r16.xxx * r23.xyz + r9.xyz;
            r20.w = dot(r24.xyz, r24.xyz);
            r20.w = rsqrt(r20.w);
            r24.xyz = r24.xyz * r20.www;
            r25.xyz = r16.yyy * r23.xyz + r9.xyz;
            r20.w = dot(r25.xyz, r25.xyz);
            r20.w = rsqrt(r20.w);
            r25.xyz = r25.xyz * r20.www;
            r23.xyz = r16.zzz * r23.xyz + r9.xyz;
            r20.w = dot(r23.xyz, r23.xyz);
            r20.w = rsqrt(r20.w);
            r23.xyz = r23.xyz * r20.www;
            r20.w = dot(r24.xyz, r22.xyz);
            r20.w = r20.w * r9.w + r10.w;
            r20.w = saturate(max(r20.w, r23.w));
            r24.x = dot(r25.xyz, r22.xyz);
            r24.x = r24.x * r9.w + r10.w;
            r24.x = saturate(max(r24.x, r23.w));
            r23.x = dot(r23.xyz, r22.xyz);
            r23.x = r23.x * r9.w + r10.w;
            r23.x = saturate(max(r23.x, r23.w));
            r25.x = log2(r20.w);
            r25.y = log2(r24.x);
            r25.z = log2(r23.x);
            r23.xyz = cb4[32].xxx * r25.xyz;
            r23.xyz = exp2(r23.xyz);
            r20.w = saturate(cb4[31].x * r23.w);
            r24.xyz = r20.www * r17.xyz + r6.xyz;
            r23.xyz = saturate(r24.xyz * r23.xyz);
            r24.xyz = r10.xyz * r4.www + r22.xyz;
            r20.w = dot(r24.xyz, r24.xyz);
            r20.w = rsqrt(r20.w);
            r24.xyz = r24.xyz * r20.www;
            r20.w = dot(r24.xyz, r11.xyz);
            r20.w = 1 + -abs(r20.w);
            r20.w = max(0, r20.w);
            r23.w = r20.w * r20.w;
            r23.w = r23.w * r23.w;
            r20.w = r23.w * r20.w;
            r25.xyz = r20.www * r18.xyz;
            r25.xyz = r25.xyz / r11.www;
            r25.xyz = r25.xyz + r4.xyz;
            r26.xyz = float3(1, 1, 1) + -r25.xyz;
            r23.xyz = r26.xyz * r23.xyz;
            r23.xyz = cb4[33].xxx * r23.xyz;
            r20.w = cmp(0 < r22.w);
            if (r20.w != 0)
            {
                r20.w = dot(r22.xyz, r8.xyz);
                r20.w = 1 + r20.w;
                r20.w = 0.5 * r20.w;
                r23.w = dot(r22.xyz, -r11.xyz);
                r23.w = 1 + r23.w;
                r23.w = 0.5 * r23.w;
                r23.w = r23.w * r23.w;
                r23.w = r23.w * r23.w + -r20.w;
                r20.w = r23.w * 0.200000003 + r20.w;
                r20.w = r20.w * r13.w;
                r26.xyz = r20.www * r22.www;
            }
            else
            {
                r26.xyz = float3(0, 0, 0);
            }
            r23.xyz = r23.xyz * float3(0.318309873, 0.318309873, 0.318309873) + r26.xyz;
            r23.xyz = cb13[r19.w + 61].xyz * r23.xyz;
            r20.xyz = r21.www * r23.xyz + r20.xyz;
            r20.w = dot(r22.xyz, r8.xyz);
            r22.x = cmp(0 < r20.w);
            if (r22.x != 0)
            {
                r22.x = saturate(dot(r8.xyz, r24.xyz));
                r20.w = saturate(r20.w);
                r22.x = r22.x * r22.x;
                r22.x = r22.x * r15.w + 1;
                r22.x = r22.x * r22.x;
                r22.x = 3.14152002 * r22.x;
                r22.x = r16.w / r22.x;
                r22.y = r20.w * r0.w + r17.w;
                r22.y = r20.w / r22.y;
                r22.y = r22.y * r18.w;
                r22.x = r22.x * r22.y;
                r22.xyz = r22.xxx * r25.xyz;
                r22.w = r20.w * r14.w;
                r22.xyz = r22.xyz / r22.www;
                r22.xyz = r22.xyz * r20.www;
            }
            else
            {
                r22.xyz = float3(0, 0, 0);
            }
            r22.xyz = cb13[r19.w + 61].xyz * r22.xyz;
            r21.xyz = r21.www * r22.xyz + r21.xyz;
        }
        r19.z = (int) r19.z + 1;
    }
    r3.w = cmp(0 < r12.y);
    if (r3.w != 0)
    {
        r3.w = dot(r9.xyz, cb13[0].xyz);
        r1.w = r3.w + r1.w;
        r1.w = saturate(r1.w / r7.w);
        r1.w = log2(r1.w);
        r1.w = cb4[19].x * r1.w;
        r1.w = exp2(r1.w);
        r1.w = saturate(r1.w * r8.w + cb4[22].x);
        r13.xyz = r1.www * r14.xyz + r9.xyz;
        r1.w = dot(r13.xyz, r13.xyz);
        r1.w = rsqrt(r1.w);
        r14.xyz = r13.xyz * r1.www;
        r3.w = dot(r14.xyz, cb13[0].xyz);
        r3.w = r3.w * r9.w + r10.w;
        r13.xyz = r13.xyz * r1.www + -r9.xyz;
        r14.xyz = r16.xxx * r13.xyz + r9.xyz;
        r1.w = dot(r14.xyz, r14.xyz);
        r1.w = rsqrt(r1.w);
        r14.xyz = r14.xyz * r1.www;
        r15.xyz = r16.yyy * r13.xyz + r9.xyz;
        r1.w = dot(r15.xyz, r15.xyz);
        r1.w = rsqrt(r1.w);
        r15.xyz = r15.xyz * r1.www;
        r13.xyz = r16.zzz * r13.xyz + r9.xyz;
        r1.w = dot(r13.xyz, r13.xyz);
        r1.w = rsqrt(r1.w);
        r13.xyz = r13.xyz * r1.www;
        r1.w = dot(r14.xyz, cb13[0].xyz);
        r1.w = r1.w * r9.w + r10.w;
        r1.w = saturate(max(r1.w, r3.w));
        r5.z = dot(r15.xyz, cb13[0].xyz);
        r5.z = r5.z * r9.w + r10.w;
        r5.w = dot(r13.xyz, cb13[0].xyz);
        r5.w = r5.w * r9.w + r10.w;
        r5.zw = saturate(max(r5.zw, r3.ww));
        r13.x = log2(r1.w);
        r13.y = log2(r5.z);
        r13.z = log2(r5.w);
        r13.xyz = cb4[32].xxx * r13.xyz;
        r13.xyz = exp2(r13.xyz);
        r1.w = saturate(cb4[31].x * r3.w);
        r6.xyz = r1.www * r17.xyz + r6.xyz;
        r6.xyz = saturate(r13.xyz * r6.xyz);
        r10.xyz = r10.xyz * r4.www + cb13[0].xyz;
        r1.w = dot(r10.xyz, r10.xyz);
        r1.w = rsqrt(r1.w);
        r10.xyz = r10.xyz * r1.www;
        r1.w = dot(r10.xyz, r11.xyz);
        r1.w = 1 + -abs(r1.w);
        r1.w = max(0, r1.w);
        r3.w = r1.w * r1.w;
        r3.w = r3.w * r3.w;
        r1.w = r3.w * r1.w;
        r13.xyz = r18.xyz * r1.www;
        r13.xyz = r13.xyz / r11.www;
        r4.xyz = r13.xyz + r4.xyz;
        r13.xyz = float3(1, 1, 1) + -r4.xyz;
        r13.xyz = r13.xyz * r6.xyz;
        r13.xyz = cb4[33].xxx * r13.xyz;
        r5.zw = -cb12[0].xy + world_position.xy;
        r1.w = dot(r5.zw, r5.zw);
        r1.w = sqrt(r1.w);
        r3.w = saturate(world_position.z * cb12[218].z + cb12[218].w);
        r14.xyz = -cb13[52].xyz + cb13[51].xyz;
        r14.xyz = r3.www * r14.xyz + cb13[52].xyz;
        r1.w = saturate(r1.w * cb12[218].x + cb12[218].y);
        r14.xyz = -cb13[1].xyz + r14.xyz;
        r14.xyz = r1.www * r14.xyz + cb13[1].xyz;

        r14.xyz *= GetUnderwaterDirectionalLightScale(water_depth, world_position.xyz);

        r1.w = cmp(0 < r1.y);
        if (r1.w != 0)
        {
            r1.w = dot(cb13[0].xyz, r8.xyz);
            r1.w = 1 + r1.w;
            r1.w = 0.5 * r1.w;
            r3.w = dot(cb13[0].xyz, -r11.xyz);
            r3.w = 1 + r3.w;
            r3.w = 0.5 * r3.w;
            r3.w = r3.w * r3.w;
            r3.w = r3.w * r3.w + -r1.w;
            r1.w = r3.w * 0.200000003 + r1.w;
            r1.w = r13.w * r1.w;
            r15.xyz = r1.www * r1.yyy;
        }
        else
        {
            r15.xyz = float3(0, 0, 0);
        }
        r13.xyz = r13.xyz * float3(0.318309873, 0.318309873, 0.318309873) + r15.xyz;
        r13.xyz = r13.xyz * r12.yyy;
        r13.xyz = r13.xyz * r14.xyz;
        r1.w = dot(cb13[0].xyz, r8.xyz);
        r3.w = cmp(0 < r1.w);
        if (r3.w != 0)
        {
            r3.w = saturate(dot(r8.xyz, r10.xyz));
            r1.w = saturate(r1.w);
            r3.w = r3.w * r3.w;
            r3.w = r3.w * r15.w + 1;
            r3.w = r3.w * r3.w;
            r3.w = 3.14152002 * r3.w;
            r3.w = r16.w / r3.w;
            r0.w = r1.w * r0.w + r17.w;
            r0.w = r1.w / r0.w;
            r0.w = r0.w * r18.w;
            r0.w = r3.w * r0.w;
            r4.xyz = r0.www * r4.xyz;
            r0.w = r14.w * r1.w;
            r4.xyz = r4.xyz / r0.www;
            r4.xyz = r4.xyz * r1.www;
        }
        else
        {
            r4.xyz = float3(0, 0, 0);
        }
        r4.xyz = r12.yyy * r4.xyz;
        r4.xyz = r4.xyz * r14.xyz;
    }
    else
    {
        r6.xyz = float3(0, 0, 0);
        r13.xyz = float3(0, 0, 0);
        r4.xyz = float3(0, 0, 0);
    }
    r6.xyz = min(r6.xyz, r12.yyy);
    r8.xyz = r20.xyz + r13.xyz;
    r4.xyz = r21.xyz + r4.xyz;
    r0.xyz = r0.xyz * r2.www + -v3.xyz;
    r0.xyz = r5.yyy * r0.xyz + v3.xyz;
    r0.w = dot(r0.xyz, r0.xyz);
    r0.w = rsqrt(r0.w);
    r5.yzw = r0.xyz * r0.www;
    r0.x = dot(-r11.xyz, r5.yzw);
    r0.x = r0.x + r0.x;
    r10.xyz = r5.yzw * -r0.xxx + -r11.xyz;
    r0.x = dot(r10.xyz, r10.xyz);
    r0.x = rsqrt(r0.x);
    r13.xyz = r10.xyz * r0.xxx;
    r14.xyz = ddx_coarse(r13.xyz);
    r15.xyz = ddy_coarse(r13.xyz);
    r7.xy = (int2) r7.xy & int2(1, 1);
    r7.xzw = r7.xxx ? -r14.xyz : r14.xyz;
    r14.xyz = r7.yyy ? -r15.xyz : r15.xyz;
    r7.xyz = r10.xyz * r0.xxx + r7.xzw;
    r0.y = dot(r7.xyz, r7.xyz);
    r0.y = rsqrt(r0.y);
    r7.xyz = r7.xyz * r0.yyy;
    r0.y = dot(r13.xyz, r7.xyz);
    r1.w = 1 + -abs(r0.y);
    r1.w = sqrt(r1.w);
    r2.w = abs(r0.y) * -0.0187292993 + 0.0742610022;
    r2.w = r2.w * abs(r0.y) + -0.212114394;
    r2.w = r2.w * abs(r0.y) + 1.57072878;
    r3.w = r2.w * r1.w;
    r3.w = r3.w * -2 + 3.14159274;
    r0.y = cmp(r0.y < -r0.y);
    r0.y = r0.y ? r3.w : 0;
    r0.y = r2.w * r1.w + r0.y;
    r0.y = 81.4873276 * r0.y;
    r0.y = log2(r0.y);
    r7.xyz = r10.xyz * r0.xxx + r14.xyz;
    r0.x = dot(r7.xyz, r7.xyz);
    r0.x = rsqrt(r0.x);
    r7.xyz = r7.xyz * r0.xxx;
    r0.x = dot(r13.xyz, r7.xyz);
    r1.w = 1 + -abs(r0.x);
    r1.w = sqrt(r1.w);
    r2.w = abs(r0.x) * -0.0187292993 + 0.0742610022;
    r2.w = r2.w * abs(r0.x) + -0.212114394;
    r2.w = r2.w * abs(r0.x) + 1.57072878;
    r3.w = r2.w * r1.w;
    r3.w = r3.w * -2 + 3.14159274;
    r0.x = cmp(r0.x < -r0.x);
    r0.x = r0.x ? r3.w : 0;
    r0.x = r2.w * r1.w + r0.x;
    r0.x = 81.4873276 * r0.x;
    r0.x = log2(r0.x);
    r0.xy = max(float2(0, 0), r0.xy);
    r0.x = max(r0.y, r0.x);
    r0.y = r1.x * r1.x;
    r0.xy = float2(0.625, 10.5) * r0.xy;
    r0.x = max(r0.y, r0.x);
    r0.y = cmp(r5.w < 0);

    // The shader decompiler created this (r1.w = r0.y ? 0 : 0) instead of the following correct line
    r1.w = r0.y ? 1 : 0;

    r7.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r5.yzyz;
    r2.w = -r0.z * r0.w + 1;
    r2.w = max(0.00100000005, r2.w);
    r7.xy = r7.xy / r2.ww;
    r7.xy = float2(0.5, 0.5) + r7.xy;
    r0.z = r0.z * r0.w + 1;
    r0.z = max(0.00100000005, r0.z);
    r0.zw = r7.zw / r0.zz;
    r0.zw = float2(0.5, 0.5) + r0.zw;
    r0.yz = r0.yy ? r7.xy : r0.zw;
    r0.yz = r0.yz * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
    r7.x = (int) r1.w;
    r7.y = 0;
    r0.yz = r7.xy + r0.yz;

    r7.xy = float2(0.5, 0.142857149) * r0.yz;
    r0.yzw = cb12[114].xyz * world_position.yyy;
    r0.yzw = cb12[113].xyz * world_position.xxx + r0.yzw;
    r0.yzw = cb12[115].xyz * world_position.zzz + r0.yzw;
    r0.yzw = cb12[116].xyz + r0.yzw;
    r0.yzw = float3(1, 1, 1) + -abs(r0.yzw);
    r1.w = cmp(r12.z != -1.000000);
    if (r1.w != 0)
    {
        r13.xy = asint(cb12[117].yy) & int2(1, 2);
        r2.w = r13.x ? 1 : r12.z;
        r3.w = 1 + -r12.z;
        r3.w = r13.y ? 1 : r3.w;
        r2.w = r3.w * r2.w;
    }
    else
    {
        r2.w = 1;
    }
    r13.xyz = cmp(float3(0, 0, 0) < r0.yzw);
    r3.w = r13.y ? r13.x : 0;
    r3.w = r13.z ? r3.w : 0;
    r4.w = cmp(0 < r2.w);
    r3.w = r4.w ? r3.w : 0;
    if (r3.w != 0)
    {
        r0.yzw = saturate(cb12[112].xyz * r0.yzw);
        r2.w = cb12[111].x * r2.w;
        r2.w = 1 * r2.w;
        r0.y = r0.y * r0.z;
        r0.y = r0.y * r0.w;
        r0.z = r2.w * r0.y;
        r0.y = r2.w * r0.y + 0;
        r0.z = cb12[117].x * r0.z;
        r0.w = asint(cb12[122].x);
        r7.z = r0.w * 0.142857149 + r7.y;
        r13.xyz = t22.SampleLevel(s11_s, r7.xz, 1).xyz;
        r13.xyz = r13.xyz * r0.zzz;
        r14.xyz = cb12[119].xyz * r10.yyy;
        r14.xyz = cb12[118].xyz * r10.xxx + r14.xyz;
        r14.xyz = cb12[120].xyz * r10.zzz + r14.xyz;
        r15.xyz = cb12[119].xyz * world_position.yyy;
        r15.xyz = cb12[118].xyz * world_position.xxx + r15.xyz;
        r15.xyz = cb12[120].xyz * world_position.zzz + r15.xyz;
        r15.xyz = cb12[121].xyz + r15.xyz;
        r14.xyz = float3(1, 1, 1) / r14.xyz;
        r16.xyz = -r15.xyz * r14.xyz + r14.xyz;
        r14.xyz = -r15.xyz * r14.xyz + -r14.xyz;
        r14.xyz = max(r16.xyz, r14.xyz);
        r0.w = min(r14.y, r14.z);
        r0.w = min(r14.x, r0.w);
        r14.xyz = r10.xyz * r0.www + world_position.xyz;
        r14.xyz = -cb12[111].yzw + r14.xyz;
        r0.w = dot(r14.xyz, r14.xyz);
        r0.w = rsqrt(r0.w);
        r14.xyw = r14.xyz * r0.www;
        r2.w = cmp(r14.w < 0);
        r3.w = r2.w ? 1 : 0; // fixed
        r15.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r14.xyxy;
        r4.w = -r14.z * r0.w + 1;
        r4.w = max(0.00100000005, r4.w);
        r14.xy = r15.xy / r4.ww;
        r0.w = r14.z * r0.w + 1;
        r0.w = max(0.00100000005, r0.w);
        r14.zw = r15.zw / r0.ww;
        r14.xyzw = float4(0.5, 0.5, 0.5, 0.5) + r14.xyzw;
        r14.xy = r2.ww ? r14.xy : r14.zw;
        r14.xy = r14.xy * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
        r15.y = asint(cb12[122].x);
        r15.z = (int) r3.w;
        r15.xw = float2(0, 0);
        r14.xy = r15.zw + r14.xy;
        r14.xy = r15.xy + r14.xy;
        r14.xy = float2(0.5, 0.142857149) * r14.xy;
        r14.xyz = t23.SampleLevel(s11_s, r14.xy, r0.x).xyz;
        r14.xyz = r14.xyz * r0.zzz;
    }
    else
    {
        r13.xyz = float3(0, 0, 0);
        r14.xyz = float3(0, 0, 0);
        r0.y = 0;
    }
    r0.z = cmp(r0.y < 0.999000013);
    if (r0.z != 0)
    {
        r15.xyz = cb12[126].xyz * world_position.yyy;
        r15.xyz = cb12[125].xyz * world_position.xxx + r15.xyz;
        r15.xyz = cb12[127].xyz * world_position.zzz + r15.xyz;
        r15.xyz = cb12[128].xyz + r15.xyz;
        r15.xyz = float3(1, 1, 1) + -abs(r15.xyz);
        if (r1.w != 0)
        {
            r16.xy = asint(cb12[129].yy) & int2(1, 2);
            r0.w = r16.x ? 1 : r12.z;
            r2.w = 1 + -r12.z;
            r2.w = r16.y ? 1 : r2.w;
            r0.w = r2.w * r0.w;
        }
        else
        {
            r0.w = 1;
        }
        r16.xyz = cmp(float3(0, 0, 0) < r15.xyz);
        r2.w = r16.y ? r16.x : 0;
        r2.w = r16.z ? r2.w : 0;
        r3.w = cmp(0 < r0.w);
        r2.w = r3.w ? r2.w : 0;
        if (r2.w != 0)
        {
            r15.xyz = saturate(cb12[124].xyz * r15.xyz);
            r2.w = 1 + -r0.y;
            r0.w = r2.w * r0.w;
            r0.w = cb12[123].x * r0.w;
            r2.w = r15.x * r15.y;
            r2.w = r2.w * r15.z;
            r3.w = r2.w * r0.w;
            r0.y = r0.w * r2.w + r0.y;
            r0.w = cb12[129].x * r3.w;
            r2.w = asint(cb12[134].x);
            r7.w = r2.w * 0.142857149 + r7.y;
            r15.xyz = t22.SampleLevel(s11_s, r7.xw, 1).xyz;
            r13.xyz = r0.www * r15.xyz + r13.xyz;
            r15.xyz = cb12[131].xyz * r10.yyy;
            r15.xyz = cb12[130].xyz * r10.xxx + r15.xyz;
            r15.xyz = cb12[132].xyz * r10.zzz + r15.xyz;
            r16.xyz = cb12[131].xyz * world_position.yyy;
            r16.xyz = cb12[130].xyz * world_position.xxx + r16.xyz;
            r16.xyz = cb12[132].xyz * world_position.zzz + r16.xyz;
            r16.xyz = cb12[133].xyz + r16.xyz;
            r15.xyz = float3(1, 1, 1) / r15.xyz;
            r17.xyz = -r16.xyz * r15.xyz + r15.xyz;
            r15.xyz = -r16.xyz * r15.xyz + -r15.xyz;
            r15.xyz = max(r17.xyz, r15.xyz);
            r2.w = min(r15.y, r15.z);
            r2.w = min(r15.x, r2.w);
            r15.xyz = r10.xyz * r2.www + world_position.xyz;
            r15.xyz = -cb12[123].yzw + r15.xyz;
            r2.w = dot(r15.xyz, r15.xyz);
            r2.w = rsqrt(r2.w);
            r15.xyw = r15.xyz * r2.www;
            r3.w = cmp(r15.w < 0);
            r4.w = r3.w ? 1 : 0; // fixed
            r16.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r15.xyxy;
            r6.w = -r15.z * r2.w + 1;
            r6.w = max(0.00100000005, r6.w);
            r7.zw = r16.xy / r6.ww;
            r7.zw = float2(0.5, 0.5) + r7.zw;
            r2.w = r15.z * r2.w + 1;
            r2.w = max(0.00100000005, r2.w);
            r15.xy = r16.zw / r2.ww;
            r15.xy = float2(0.5, 0.5) + r15.xy;
            r7.zw = r3.ww ? r7.zw : r15.xy;
            r7.zw = r7.zw * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
            r15.y = asint(cb12[134].x);
            r15.z = (int) r4.w;
            r15.xw = float2(0, 0);
            r7.zw = r15.zw + r7.zw;
            r7.zw = r15.xy + r7.zw;
            r7.zw = float2(0.5, 0.142857149) * r7.zw;
            r15.xyz = t23.SampleLevel(s11_s, r7.zw, r0.x).xyz;
            r14.xyz = r0.www * r15.xyz + r14.xyz;
        }
    }
    r0.w = cmp(r0.y < 0.999000013);
    r0.z = r0.w ? r0.z : 0;
    if (r0.z != 0)
    {
        r15.xyz = cb12[138].xyz * world_position.yyy;
        r15.xyz = cb12[137].xyz * world_position.xxx + r15.xyz;
        r15.xyz = cb12[139].xyz * world_position.zzz + r15.xyz;
        r15.xyz = cb12[140].xyz + r15.xyz;
        r15.xyz = float3(1, 1, 1) + -abs(r15.xyz);
        if (r1.w != 0)
        {
            r7.zw = asint(cb12[141].yy) & int2(1, 2);
            r0.w = r7.z ? 1 : r12.z;
            r2.w = 1 + -r12.z;
            r2.w = r7.w ? 1 : r2.w;
            r0.w = r2.w * r0.w;
        }
        else
        {
            r0.w = 1;
        }
        r16.xyz = cmp(float3(0, 0, 0) < r15.xyz);
        r2.w = r16.y ? r16.x : 0;
        r2.w = r16.z ? r2.w : 0;
        r3.w = cmp(0 < r0.w);
        r2.w = r3.w ? r2.w : 0;
        if (r2.w != 0)
        {
            r15.xyz = saturate(cb12[136].xyz * r15.xyz);
            r2.w = 1 + -r0.y;
            r0.w = r2.w * r0.w;
            r0.w = cb12[135].x * r0.w;
            r2.w = r15.x * r15.y;
            r2.w = r2.w * r15.z;
            r3.w = r2.w * r0.w;
            r0.y = r0.w * r2.w + r0.y;
            r0.w = cb12[141].x * r3.w;
            r2.w = asint(cb12[146].x);
            r15.y = r2.w * 0.142857149 + r7.y;
            r15.x = r7.x;
            r15.xyz = t22.SampleLevel(s11_s, r15.xy, 1).xyz;
            r13.xyz = r0.www * r15.xyz + r13.xyz;
            r15.xyz = cb12[143].xyz * r10.yyy;
            r15.xyz = cb12[142].xyz * r10.xxx + r15.xyz;
            r15.xyz = cb12[144].xyz * r10.zzz + r15.xyz;
            r16.xyz = cb12[143].xyz * world_position.yyy;
            r16.xyz = cb12[142].xyz * world_position.xxx + r16.xyz;
            r16.xyz = cb12[144].xyz * world_position.zzz + r16.xyz;
            r16.xyz = cb12[145].xyz + r16.xyz;
            r15.xyz = float3(1, 1, 1) / r15.xyz;
            r17.xyz = -r16.xyz * r15.xyz + r15.xyz;
            r15.xyz = -r16.xyz * r15.xyz + -r15.xyz;
            r15.xyz = max(r17.xyz, r15.xyz);
            r2.w = min(r15.y, r15.z);
            r2.w = min(r15.x, r2.w);
            r15.xyz = r10.xyz * r2.www + world_position.xyz;
            r15.xyz = -cb12[135].yzw + r15.xyz;
            r2.w = dot(r15.xyz, r15.xyz);
            r2.w = rsqrt(r2.w);
            r15.xyw = r15.xyz * r2.www;
            r3.w = cmp(r15.w < 0);
            r4.w = r3.w ? 1 : 0; // fixed
            r16.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r15.xyxy;
            r6.w = -r15.z * r2.w + 1;
            r6.w = max(0.00100000005, r6.w);
            r7.zw = r16.xy / r6.ww;
            r7.zw = float2(0.5, 0.5) + r7.zw;
            r2.w = r15.z * r2.w + 1;
            r2.w = max(0.00100000005, r2.w);
            r15.xy = r16.zw / r2.ww;
            r15.xy = float2(0.5, 0.5) + r15.xy;
            r7.zw = r3.ww ? r7.zw : r15.xy;
            r7.zw = r7.zw * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
            r15.y = asint(cb12[146].x);
            r15.z = (int) r4.w;
            r15.xw = float2(0, 0);
            r7.zw = r15.zw + r7.zw;
            r7.zw = r15.xy + r7.zw;
            r7.zw = float2(0.5, 0.142857149) * r7.zw;
            r15.xyz = t23.SampleLevel(s11_s, r7.zw, r0.x).xyz;
            r14.xyz = r0.www * r15.xyz + r14.xyz;
        }
    }
    r0.w = cmp(r0.y < 0.999000013);
    r0.z = r0.w ? r0.z : 0;
    if (r0.z != 0)
    {
        r15.xyz = cb12[150].xyz * world_position.yyy;
        r15.xyz = cb12[149].xyz * world_position.xxx + r15.xyz;
        r15.xyz = cb12[151].xyz * world_position.zzz + r15.xyz;
        r15.xyz = cb12[152].xyz + r15.xyz;
        r15.xyz = float3(1, 1, 1) + -abs(r15.xyz);
        if (r1.w != 0)
        {
            r7.zw = asint(cb12[153].yy) & int2(1, 2);
            r0.w = r7.z ? 1 : r12.z;
            r2.w = 1 + -r12.z;
            r2.w = r7.w ? 1 : r2.w;
            r0.w = r2.w * r0.w;
        }
        else
        {
            r0.w = 1;
        }
        r16.xyz = cmp(float3(0, 0, 0) < r15.xyz);
        r2.w = r16.y ? r16.x : 0;
        r2.w = r16.z ? r2.w : 0;
        r3.w = cmp(0 < r0.w);
        r2.w = r3.w ? r2.w : 0;
        if (r2.w != 0)
        {
            r15.xyz = saturate(cb12[148].xyz * r15.xyz);
            r2.w = 1 + -r0.y;
            r0.w = r2.w * r0.w;
            r0.w = cb12[147].x * r0.w;
            r2.w = r15.x * r15.y;
            r2.w = r2.w * r15.z;
            r3.w = r2.w * r0.w;
            r0.y = r0.w * r2.w + r0.y;
            r0.w = cb12[153].x * r3.w;
            r2.w = asint(cb12[158].x);
            r15.y = r2.w * 0.142857149 + r7.y;
            r15.x = r7.x;
            r15.xyz = t22.SampleLevel(s11_s, r15.xy, 1).xyz;
            r13.xyz = r0.www * r15.xyz + r13.xyz;
            r15.xyz = cb12[155].xyz * r10.yyy;
            r15.xyz = cb12[154].xyz * r10.xxx + r15.xyz;
            r15.xyz = cb12[156].xyz * r10.zzz + r15.xyz;
            r16.xyz = cb12[155].xyz * world_position.yyy;
            r16.xyz = cb12[154].xyz * world_position.xxx + r16.xyz;
            r16.xyz = cb12[156].xyz * world_position.zzz + r16.xyz;
            r16.xyz = cb12[157].xyz + r16.xyz;
            r15.xyz = float3(1, 1, 1) / r15.xyz;
            r17.xyz = -r16.xyz * r15.xyz + r15.xyz;
            r15.xyz = -r16.xyz * r15.xyz + -r15.xyz;
            r15.xyz = max(r17.xyz, r15.xyz);
            r2.w = min(r15.y, r15.z);
            r2.w = min(r15.x, r2.w);
            r15.xyz = r10.xyz * r2.www + world_position.xyz;
            r15.xyz = -cb12[147].yzw + r15.xyz;
            r2.w = dot(r15.xyz, r15.xyz);
            r2.w = rsqrt(r2.w);
            r15.xyw = r15.xyz * r2.www;
            r3.w = cmp(r15.w < 0);
            r4.w = r3.w ? 1 : 0; // fixed
            r16.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r15.xyxy;
            r6.w = -r15.z * r2.w + 1;
            r6.w = max(0.00100000005, r6.w);
            r7.zw = r16.xy / r6.ww;
            r7.zw = float2(0.5, 0.5) + r7.zw;
            r2.w = r15.z * r2.w + 1;
            r2.w = max(0.00100000005, r2.w);
            r15.xy = r16.zw / r2.ww;
            r15.xy = float2(0.5, 0.5) + r15.xy;
            r7.zw = r3.ww ? r7.zw : r15.xy;
            r7.zw = r7.zw * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
            r15.y = asint(cb12[158].x);
            r15.z = (int) r4.w;
            r15.xw = float2(0, 0);
            r7.zw = r15.zw + r7.zw;
            r7.zw = r15.xy + r7.zw;
            r7.zw = float2(0.5, 0.142857149) * r7.zw;
            r15.xyz = t23.SampleLevel(s11_s, r7.zw, r0.x).xyz;
            r14.xyz = r0.www * r15.xyz + r14.xyz;
        }
    }
    r0.w = cmp(r0.y < 0.999000013);
    r0.z = r0.w ? r0.z : 0;
    if (r0.z != 0)
    {
        r15.xyz = cb12[162].xyz * world_position.yyy;
        r15.xyz = cb12[161].xyz * world_position.xxx + r15.xyz;
        r15.xyz = cb12[163].xyz * world_position.zzz + r15.xyz;
        r15.xyz = cb12[164].xyz + r15.xyz;
        r15.xyz = float3(1, 1, 1) + -abs(r15.xyz);
        if (r1.w != 0)
        {
            r7.zw = asint(cb12[165].yy) & int2(1, 2);
            r0.w = r7.z ? 1 : r12.z;
            r2.w = 1 + -r12.z;
            r2.w = r7.w ? 1 : r2.w;
            r0.w = r2.w * r0.w;
        }
        else
        {
            r0.w = 1;
        }
        r16.xyz = cmp(float3(0, 0, 0) < r15.xyz);
        r2.w = r16.y ? r16.x : 0;
        r2.w = r16.z ? r2.w : 0;
        r3.w = cmp(0 < r0.w);
        r2.w = r3.w ? r2.w : 0;
        if (r2.w != 0)
        {
            r15.xyz = saturate(cb12[160].xyz * r15.xyz);
            r2.w = 1 + -r0.y;
            r0.w = r2.w * r0.w;
            r0.w = cb12[159].x * r0.w;
            r2.w = r15.x * r15.y;
            r2.w = r2.w * r15.z;
            r3.w = r2.w * r0.w;
            r0.y = r0.w * r2.w + r0.y;
            r0.w = cb12[165].x * r3.w;
            r2.w = asint(cb12[170].x);
            r15.y = r2.w * 0.142857149 + r7.y;
            r15.x = r7.x;
            r15.xyz = t22.SampleLevel(s11_s, r15.xy, 1).xyz;
            r13.xyz = r0.www * r15.xyz + r13.xyz;
            r15.xyz = cb12[167].xyz * r10.yyy;
            r15.xyz = cb12[166].xyz * r10.xxx + r15.xyz;
            r15.xyz = cb12[168].xyz * r10.zzz + r15.xyz;
            r16.xyz = cb12[167].xyz * world_position.yyy;
            r16.xyz = cb12[166].xyz * world_position.xxx + r16.xyz;
            r16.xyz = cb12[168].xyz * world_position.zzz + r16.xyz;
            r16.xyz = cb12[169].xyz + r16.xyz;
            r15.xyz = float3(1, 1, 1) / r15.xyz;
            r17.xyz = -r16.xyz * r15.xyz + r15.xyz;
            r15.xyz = -r16.xyz * r15.xyz + -r15.xyz;
            r15.xyz = max(r17.xyz, r15.xyz);
            r2.w = min(r15.y, r15.z);
            r2.w = min(r15.x, r2.w);
            r15.xyz = r10.xyz * r2.www + world_position.xyz;
            r15.xyz = -cb12[159].yzw + r15.xyz;
            r2.w = dot(r15.xyz, r15.xyz);
            r2.w = rsqrt(r2.w);
            r15.xyw = r15.xyz * r2.www;
            r3.w = cmp(r15.w < 0);
            r4.w = r3.w ? 1 : 0; // fixed
            r16.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r15.xyxy;
            r6.w = -r15.z * r2.w + 1;
            r6.w = max(0.00100000005, r6.w);
            r7.zw = r16.xy / r6.ww;
            r7.zw = float2(0.5, 0.5) + r7.zw;
            r2.w = r15.z * r2.w + 1;
            r2.w = max(0.00100000005, r2.w);
            r15.xy = r16.zw / r2.ww;
            r15.xy = float2(0.5, 0.5) + r15.xy;
            r7.zw = r3.ww ? r7.zw : r15.xy;
            r7.zw = r7.zw * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
            r15.y = asint(cb12[170].x);
            r15.z = (int) r4.w;
            r15.xw = float2(0, 0);
            r7.zw = r15.zw + r7.zw;
            r7.zw = r15.xy + r7.zw;
            r7.zw = float2(0.5, 0.142857149) * r7.zw;
            r15.xyz = t23.SampleLevel(s11_s, r7.zw, r0.x).xyz;
            r14.xyz = r0.www * r15.xyz + r14.xyz;
        }
    }
    r0.w = cmp(r0.y < 0.999000013);
    r0.z = r0.w ? r0.z : 0;
    if (r0.z != 0)
    {
        r15.xyz = cb12[174].xyz * world_position.yyy;
        r15.xyz = cb12[173].xyz * world_position.xxx + r15.xyz;
        r15.xyz = cb12[175].xyz * world_position.zzz + r15.xyz;
        r15.xyz = cb12[176].xyz + r15.xyz;
        r15.xyz = float3(1, 1, 1) + -abs(r15.xyz);
        if (r1.w != 0)
        {
            r0.zw = asint(cb12[177].yy) & int2(1, 2);
            r0.z = r0.z ? 1 : r12.z;
            r1.w = 1 + -r12.z;
            r0.w = r0.w ? 1 : r1.w;
            r0.z = r0.z * r0.w;
        }
        else
        {
            r0.z = 1;
        }
        r16.xyz = cmp(float3(0, 0, 0) < r15.xyz);
        r0.w = r16.y ? r16.x : 0;
        r0.w = r16.z ? r0.w : 0;
        r1.w = cmp(0 < r0.z);
        r0.w = r1.w ? r0.w : 0;
        if (r0.w != 0)
        {
            r15.xyz = saturate(cb12[172].xyz * r15.xyz);
            r0.w = 1 + -r0.y;
            r0.z = r0.w * r0.z;
            r0.z = cb12[171].x * r0.z;
            r0.w = r15.x * r15.y;
            r0.w = r0.w * r15.z;
            r1.w = r0.z * r0.w;
            r0.y = r0.z * r0.w + r0.y;
            r0.z = cb12[177].x * r1.w;
            r0.w = asint(cb12[182].x);
            r15.y = r0.w * 0.142857149 + r7.y;
            r15.x = r7.x;
            r15.xyz = t22.SampleLevel(s11_s, r15.xy, 1).xyz;
            r13.xyz = r0.zzz * r15.xyz + r13.xyz;
            r15.xyz = cb12[179].xyz * r10.yyy;
            r15.xyz = cb12[178].xyz * r10.xxx + r15.xyz;
            r15.xyz = cb12[180].xyz * r10.zzz + r15.xyz;
            r16.xyz = cb12[179].xyz * world_position.yyy;
            r16.xyz = cb12[178].xyz * world_position.xxx + r16.xyz;
            r16.xyz = cb12[180].xyz * world_position.zzz + r16.xyz;
            r16.xyz = cb12[181].xyz + r16.xyz;
            r15.xyz = float3(1, 1, 1) / r15.xyz;
            r17.xyz = -r16.xyz * r15.xyz + r15.xyz;
            r15.xyz = -r16.xyz * r15.xyz + -r15.xyz;
            r15.xyz = max(r17.xyz, r15.xyz);
            r0.w = min(r15.y, r15.z);
            r0.w = min(r15.x, r0.w);
            r15.xyz = r10.xyz * r0.www + world_position.xyz;
            r15.xyz = -cb12[171].yzw + r15.xyz;
            r0.w = dot(r15.xyz, r15.xyz);
            r0.w = rsqrt(r0.w);
            r15.xyw = r15.xyz * r0.www;
            r1.w = cmp(r15.w < 0);
            r2.w = r1.w ? 1 : 0; // fixed
            r16.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r15.xyxy;
            r3.w = -r15.z * r0.w + 1;
            r3.w = max(0.00100000005, r3.w);
            r7.zw = r16.xy / r3.ww;
            r7.zw = float2(0.5, 0.5) + r7.zw;
            r0.w = r15.z * r0.w + 1;
            r0.w = max(0.00100000005, r0.w);
            r12.yz = r16.zw / r0.ww;
            r12.yz = float2(0.5, 0.5) + r12.yz;
            r7.zw = r1.ww ? r7.zw : r12.yz;
            r7.zw = r7.zw * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
            r15.y = asint(cb12[182].x);
            r15.z = (int) r2.w;
            r15.xw = float2(0, 0);
            r7.zw = r15.zw + r7.zw;
            r7.zw = r15.xy + r7.zw;
            r7.zw = float2(0.5, 0.142857149) * r7.zw;
            r15.xyz = t23.SampleLevel(s11_s, r7.zw, r0.x).xyz;
            r14.xyz = r0.zzz * r15.xyz + r14.xyz;
        }
    }
    r0.z = cmp(r0.y < 0.999000013);
    if (r0.z != 0)
    {
        r0.z = 1 + -r0.y;
        r0.w = cb12[99].x * r0.z;
        r0.y = r0.z * cb12[99].x + r0.y;
        r0.z = cb12[105].x * r0.w;
        r0.w = asint(cb12[110].x);
        r7.y = r0.w * 0.142857149 + r7.y;
        r7.xyz = t22.SampleLevel(s11_s, r7.xy, 1).xyz;
        r13.xyz = r0.zzz * r7.xyz + r13.xyz;
        r0.w = cmp(r10.z < 0);
        r1.w = r0.w ? 1 : 0;
        r7.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r10.xyxy;
        r2.w = 1 + -r10.z;
        r2.w = max(0.00100000005, r2.w);
        r7.xy = r7.xy / r2.ww;
        r2.w = 1 + r10.z;
        r2.w = max(0.00100000005, r2.w);
        r7.zw = r7.zw / r2.ww;
        r7.xyzw = float4(0.5, 0.5, 0.5, 0.5) + r7.xyzw;
        r7.xy = r0.ww ? r7.xy : r7.zw;
        r7.xy = r7.xy * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
        r10.y = asint(cb12[110].x);
        r10.z = (int) r1.w;
        r10.xw = float2(0, 0);
        r7.xy = r10.zw + r7.xy;
        r7.xy = r10.xy + r7.xy;
        r7.xy = float2(0.5, 0.142857149) * r7.xy;
        r7.xyz = t23.SampleLevel(s11_s, r7.xy, r0.x).xyz;
        r14.xyz = r0.zzz * r7.xyz + r14.xyz;
    }
    r0.x = 1 / r0.y;
    r0.yzw = r13.xyz * r0.xxx; // ambient
    r7.xyz = r14.xyz * r0.xxx; // reflection

    UnderwaterModifyAmbientLighting(water_depth, exterior_lighting_scale, r0.yzw, r7.xyz);

    r0.x = abs(cb2[16].x) + -cb2[16].y;
    r10.xyz = r6.xyz * r0.xxx + cb2[16].yyy;
    r0.x = cb2[16].z + -cb2[16].w;
    r13.xyz = r6.xyz * r0.xxx + cb2[16].www;
    r14.xyz = r10.xyz * r0.yzw;
    r7.xyz = r13.xyz * r7.xyz;
    r12.yz = -cb12[0].xy + world_position.xy;
    r0.x = dot(r12.yz, r12.yz);
    r0.x = sqrt(r0.x);
    r0.x = saturate(r0.x * cb12[218].x + cb12[218].y);
    r1.w = -1 + cb12[184].z;
    r0.x = r0.x * r1.w + 1;
    r1.w = cb12[183].x + -cb12[183].y;
    r13.xyz = r6.xyz * r1.www + cb12[183].yyy;
    r13.xyz = r13.xyz * r0.xxx;
    r1.w = cb12[184].x + -cb12[184].y;
    r6.xyz = r6.xyz * r1.www + cb12[184].yyy;
    r6.xyz = r6.xyz * r0.xxx;
    r8.xyz = cb12[183].zzz * r8.xyz;
    r4.xyz = cb12[183].www * r4.xyz;
    r0.x = dot(r14.xyz, float3(0.300000012, 0.5, 0.200000003));
    r0.xyz = -r0.yzw * r10.xyz + r0.xxx;
    r0.xyz = r0.xyz * float3(0.5, 0.5, 0.5) + r14.xyz;
    r0.xyz = r13.xyz * r0.xyz;
    r0.w = dot(r5.yzw, r11.xyz);
    r1.w = dot(r9.xyz, r11.xyz);
    r0.w = max(abs(r1.w), abs(r0.w));
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r1.w = r0.w * r0.w;
    r1.w = r1.w * r1.w;
    r0.w = r1.w * r0.w;
    r1.x = 1 + -r1.x;
    r1.z = min(cb13[56].y, r1.z);
    r5.yzw = float3(1, 1, 1) + -r3.xyz;
    r5.yzw = r5.yzw * r1.zzz;
    r5.yzw = r5.yzw * r0.www;
    r0.w = -cb13[56].w * r1.x + r19.y;
    r1.xzw = r5.yzw / r0.www;
    r1.xzw = r3.xyz + r1.xzw;
    r3.xyz = float3(1, 1, 1) + -r1.xzw;
    r0.xyz = r3.xyz * r0.xyz;
    r3.xyz = r6.xyz * r7.xyz;
    r1.xzw = r3.xyz * r1.xzw;

    r3.xyz = saturate(r12.xxx * cb12[186].xyz + cb12[187].xyz);
    r5.x = saturate(r5.x); // comment to disable AO attenuation on skin
    r3.xyz = -1 + r3.xyz;
    r3.xyz = r5.xxx * r3.xyz; // comment to disable AO attenuation on skin
    r0.w = -1 + cb12[69].z;
    r0.w = r1.y * r0.w + 1;
    r3.xyz = r0.www * r3.xyz + 1;
    r5.xyz = r12.www * r3.xyz;

    r3.xyz = cb12[69].xxx * r3.xyz + cb12[69].yyy;
    r6.xyz = r8.xyz * r3.xyz;
    r3.xyz = r4.xyz * r3.xyz;
    r0.xyz = r0.xyz * r5.xyz + r6.xyz;
    r0.xyz = r2.xyz * r0.xyz + r3.xyz;
    o0.xyz = r1.xzw * r5.xyz + r0.xyz;
    o0.w = 1;
    return;
}