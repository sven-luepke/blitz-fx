#include "Common.hlsli"

Texture2D<float4> t13 : register(t13);
Texture2DArray<uint4> t5 : register(t5);
Texture2DArray<float4> t4 : register(t4);
Texture2DArray<float4> t3 : register(t3);
Texture2DArray<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);

SamplerState s13_s : register(s13);
SamplerState s3_s : register(s3);
SamplerState s0_s : register(s0);

cbuffer cb5 : register(b5)
{
float4 cb5[1];
}

cbuffer cb6 : register(b6)
{
float4 cb6[62];
}


#define cmp -


void PSMain(
    float4 v0 : TEXCOORD0,
    nointerpolation int4 v1 : TEXCOORD1,
    float3 v2 : TEXCOORD2,
    uint v3 : SV_IsFrontFace0,
    out float4 o0 : SV_Target0,
    out float4 normal_roughness : SV_Target1,
    out float4 o2 : SV_Target2,
    out float2 motion_vector : SV_Target3)
{
    const float4 icb[] =
    {
        {0, 0.333000, 0, 0},
        {0.125000, 0.166000, 0, 0},
        {0.250000, 0.050000, 0, 0},
        {0.375000, 0.025000, 0, 0},
        {0.500000, 0.012500, 0, 0},
        {0.625000, 0.007500, 0, 0},
        {0.750000, 0.003750, 0, 0},
        {0.980000, 0, 0, 0}
    };
    float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27,
           r28;
    float4 fDest;

    r0.xz = (int2)v1.xy;
    r0.yw = v0.xy;
    r1.xy = t4.SampleLevel(s3_s, r0.ywx, 0).xy;
    r0.w = dot(r1.xy, r1.xy);
    r0.w = 1 + -r0.w;
    r1.z = sqrt(r0.w);
    r2.xyz = -r1.xyz * r1.xxx + float3(1, 0, 0);
    r0.w = dot(r2.xyz, r2.xyz);
    r0.w = rsqrt(r0.w);
    r2.xyz = r2.xyz * r0.www;
    r3.xyz = r2.yzx * r1.zxy;
    r3.xyz = r1.yzx * r2.zxy + -r3.xyz;
    t5.GetDimensions(0, fDest.x, fDest.y, fDest.z, fDest.w);
    r4.xy = fDest.xy;
    r4.xy = v0.xy * r4.xy + float2(-0.5, -0.5);
    r5.xy = (int2)r4.xy;
    r5.z = v1.x;
    r5.w = 0;
    r6.x = t5.Load(r5.xyzw).x;
    r7.xyzw = (int4)r5.xyxy + int4(1, 0, 0, 1);
    r8.xy = r7.xy;
    r8.zw = r5.zw;
    r6.y = t5.Load(r8.xyzw).x;
    r8.xy = r7.zw;
    r6.z = t5.Load(r8.xyzw).x;
    r8.xy = (int2)r5.xy + int2(1, 1);
    r6.w = t5.Load(r8.xyzw).x;
    r5.xyzw = (int4)r6.xyzw & int4(31, 31, 31, 31);
    r5.xyzw = (int4)r5.xyzw + int4(-1, -1, -1, -1);

    r7.xyzw = (uint4(r6.xyzw) >> 5) & 31;
    r7.xyzw = (int4)r7.xyzw + int4(-1, -1, -1, -1);
    r8.xyzw = (uint4(r6.xyzw) >> 10) & 7;
    r6.xyzw = (uint4(r6.xyzw) >> 13) & 7;

    r0.w = dot(r1.xyz, r1.xyz);
    r0.w = rsqrt(r0.w);
    r9.xyz = r1.zyx * r0.www;
    r9.xyz = float3(-0.575999975, -0.575999975, -0.575999975) + abs(r9.xyz);
    r9.xyz = max(float3(0, 0, 0), r9.xyz);
    r0.w = r9.z + r9.y;
    r0.w = r0.w + r9.x;
    r9.xyz = r9.xyz / r0.www;
    r10.xyzw = -v2.xzyz;
    r11.xy = ddx_coarse(v2.xy);
    r11.zw = ddy_coarse(v2.xy);
    r12.xyzw = ddx_coarse(r10.xyzw);
    r13.xyzw = ddy_coarse(r10.xyzw);
    r4.xy = frac(r4.xy);
    r4.zw = float2(1, 1) + -r4.yx;
    r0.w = r4.w * r4.z;
    r4.zw = r4.xy * r4.zw;
    r1.w = r4.x * r4.y;
    r14.xyzw = float4(0.333000004, 0.333000004, 0.333000004, 0.333000004) * r11.xyzw;
    r15.xyzw = (uint4)r5.xyzw;
    r16.xy = float2(0.333000004, 0.333000004) * v2.xy;
    r16.z = r15.x;
    r17.xyz = t0.SampleGrad(s0_s, r16.xyz, r14.xy, r14.zw).xyz;
    r16.xyzw = t1.SampleGrad(s0_s, r16.xyz, r14.xy, r14.zw).xyzw;
    r5.xyzw = (uint4)r5.xyzw << int4(1, 1, 1, 1);
    r18.x = cb6[r5.x + 0].x * r0.w;
    r18.yzw = cb6[r5.x + 1].xyz * r0.www;
    r19.xy = float2(0.333000004, 0.333000004) * v2.xy;
    r19.z = r15.y;
    r20.xyz = t0.SampleGrad(s0_s, r19.xyz, r14.xy, r14.zw).xyz;
    r20.xyz = r20.xyz * r4.zzz;
    r17.xyz = r0.www * r17.xyz + r20.xyz;
    r19.xyzw = t1.SampleGrad(s0_s, r19.xyz, r14.xy, r14.zw).xyzw;
    r19.xyzw = r19.xyzw * r4.zzzz;
    r16.xyzw = r0.wwww * r16.xyzw + r19.xyzw;
    r19.x = cb6[r5.y + 0].x * r4.z;
    r19.yzw = cb6[r5.y + 1].xyz * r4.zzz;
    r18.xyzw = r19.xyzw + r18.xyzw;
    r2.w = icb[r8.y + 0].x * r4.z;
    r2.w = r0.w * icb[r8.x + 0].x + r2.w;
    r15.xy = float2(0.333000004, 0.333000004) * v2.xy;
    r19.xyz = t0.SampleGrad(s0_s, r15.xyz, r14.xy, r14.zw).xyz;
    r17.xyz = r4.www * r19.xyz + r17.xyz;
    r19.xyzw = t1.SampleGrad(s0_s, r15.xyz, r14.xy, r14.zw).xyzw;
    r16.xyzw = r4.wwww * r19.xyzw + r16.xyzw;
    r19.x = cb6[r5.z + 0].x * r4.w;
    r19.yzw = cb6[r5.z + 1].xyz * r4.www;
    r18.xyzw = r19.xyzw + r18.xyzw;
    r2.w = r4.w * icb[r8.z + 0].x + r2.w;
    r15.xy = float2(0.333000004, 0.333000004) * v2.xy;
    r5.xyz = t0.SampleGrad(s0_s, r15.xyw, r14.xy, r14.zw).xyz;
    r5.xyz = r1.www * r5.xyz + r17.xyz;
    r14.xyzw = t1.SampleGrad(s0_s, r15.xyw, r14.xy, r14.zw).xyzw;
    r14.xyzw = r1.wwww * r14.xyzw + r16.xyzw;
    r15.x = cb6[r5.w + 0].x * r1.w;
    r15.yzw = cb6[r5.w + 1].xyz * r1.www;
    r15.xyzw = r18.xyzw + r15.xyzw;
    r2.w = r1.w * icb[r8.w + 0].x + r2.w;
    r8.xyz = float3(-0.5, -0.5, -0.5) + r14.xyz;
    r3.w = dot(r8.xyz, r8.xyz);
    r3.w = rsqrt(r3.w);
    r8.xyz = r8.xyz * r3.www;
    r14.xyz = icb[r6.x + 0].yyy * r11.xyx;
    r16.xyz = icb[r6.x + 0].yyy * r11.zwz;
    r17.xyz = icb[r6.x + 0].yyy * r12.xyx;
    r18.xyz = icb[r6.x + 0].yyy * r13.xyx;
    r19.xy = r12.zw;
    r19.zw = r13.zw;
    r20.xyzw = icb[r6.x + 0].yyyy * r19.xyzw;
    r21.xy = icb[r6.x + 0].yy * v2.xy;
    r22.xyzw = icb[r6.x + 0].yyyy * r10.zwxy;
    r23.xyzw = (uint4)r7.xyzw;
    r24.xyz = cmp(float3(0, 0, 0) < r9.xyz);
    if (r24.x != 0)
    {
        r21.z = r23.x;
        r25.xyz = t0.SampleGrad(s0_s, r21.xyz, r14.zy, r16.zy).xyz;
        r25.xyz = r25.xyz * r9.xxx;
    }
    else
    {
        r25.xyz = float3(0, 0, 0);
    }
    if (r24.y != 0)
    {
        r26.xy = r22.zw;
        r26.z = r23.x;
        r26.xyz = t0.SampleGrad(s0_s, r26.xyz, r17.xy, r18.xy).xyz;
        r25.xyz = r9.yyy * r26.xyz + r25.xyz;
    }
    if (r24.z != 0)
    {
        r26.xy = r22.xy;
        r26.z = r23.x;
        r26.xyz = t0.SampleGrad(s0_s, r26.xyz, r20.xy, r20.zw).xyz;
        r25.xyz = r9.zzz * r26.xyz + r25.xyz;
    }
    if (r24.x != 0)
    {
        r21.w = r23.x;
        r16.xyzw = t1.SampleGrad(s0_s, r21.xyw, r14.xy, r16.xy).xyzw;
    }
    else
    {
        r16.xyzw = float4(0, 0, 0, 0);
    }
    if (r24.y != 0)
    {
        r14.xy = r22.zw;
        r14.z = r23.x;
        r17.xyzw = t1.SampleGrad(s0_s, r14.xyz, r17.xy, r18.xy).xzwy;
    }
    else
    {
        r17.xyzw = float4(0, 0, 0, 0);
    }
    if (r24.z != 0)
    {
        r22.z = r23.x;
        r18.xyzw = t1.SampleGrad(s0_s, r22.xyz, r20.xy, r20.zw).xzwy;
    }
    else
    {
        r18.xyzw = float4(0, 0, 0, 0);
    }
    r3.w = cmp(r1.y < 0);
    r4.x = 1 + -r17.w;
    r17.w = r3.w ? r4.x : r17.w;
    r18.w = 1 + -r18.w;
    r17.xyzw = r17.xwyz * r9.yyyy;
    r16.xyzw = r9.xxxx * r16.xyzw + r17.xyzw;
    r16.xyzw = r9.zzzz * r18.xwyz + r16.xyzw;
    r7.xyzw = (uint4)r7.xyzw << int4(1, 1, 1, 1);
    r14.xyz = icb[r6.y + 0].yyy * r11.xyx;
    r17.xyz = icb[r6.y + 0].yyy * r11.zwz;
    r18.xyz = icb[r6.y + 0].yyy * r12.xyx;
    r20.xyz = icb[r6.y + 0].yyy * r13.xyx;
    r21.xyzw = icb[r6.y + 0].yyyy * r19.xyzw;
    r22.xy = icb[r6.y + 0].yy * v2.xy;
    r26.xyzw = icb[r6.y + 0].yyyy * r10.zwxy;
    if (r24.x != 0)
    {
        r22.z = r23.y;
        r27.xyz = t0.SampleGrad(s0_s, r22.xyz, r14.zy, r17.zy).xyz;
        r27.xyz = r27.xyz * r9.xxx;
    }
    else
    {
        r27.xyz = float3(0, 0, 0);
    }
    if (r24.y != 0)
    {
        r28.xy = r26.zw;
        r28.z = r23.y;
        r28.xyz = t0.SampleGrad(s0_s, r28.xyz, r18.xy, r20.xy).xyz;
        r27.xyz = r9.yyy * r28.xyz + r27.xyz;
    }
    if (r24.z != 0)
    {
        r28.xy = r26.xy;
        r28.z = r23.y;
        r28.xyz = t0.SampleGrad(s0_s, r28.xyz, r21.xy, r21.zw).xyz;
        r27.xyz = r9.zzz * r28.xyz + r27.xyz;
    }
    r27.xyz = r27.xyz * r4.zzz;
    r25.xyz = r0.www * r25.xyz + r27.xyz;
    if (r24.x != 0)
    {
        r22.w = r23.y;
        r17.xyzw = t1.SampleGrad(s0_s, r22.xyw, r14.xy, r17.xy).xyzw;
    }
    else
    {
        r17.xyzw = float4(0, 0, 0, 0);
    }
    if (r24.y != 0)
    {
        r14.xy = r26.zw;
        r14.z = r23.y;
        r18.xyzw = t1.SampleGrad(s0_s, r14.xyz, r18.xy, r20.xy).xzwy;
    }
    else
    {
        r18.xyzw = float4(0, 0, 0, 0);
    }
    if (r24.z != 0)
    {
        r26.z = r23.y;
        r20.xyzw = t1.SampleGrad(s0_s, r26.xyz, r21.xy, r21.zw).xzwy;
    }
    else
    {
        r20.xyzw = float4(0, 0, 0, 0);
    }
    r4.x = 1 + -r18.w;
    r18.w = r3.w ? r4.x : r18.w;
    r20.w = 1 + -r20.w;
    r18.xyzw = r18.xwyz * r9.yyyy;
    r17.xyzw = r9.xxxx * r17.xyzw + r18.xyzw;
    r17.xyzw = r9.zzzz * r20.xwyz + r17.xyzw;
    r17.xyzw = r17.xyzw * r4.zzzz;
    r16.xyzw = r0.wwww * r16.xyzw + r17.xyzw;
    r14.xyz = cb6[r7.y + 1].xyz * r4.zzz;
    r4.xy = cb6[r7.y + 0].yz * r4.zz;
    r14.xyz = r0.www * cb6[r7.x + 1].xyz + r14.xyz;
    r4.xy = r0.ww * cb6[r7.x + 0].yz + r4.xy;
    r17.xyz = icb[r6.z + 0].yyy * r11.xyx;
    r18.xyz = icb[r6.z + 0].yyy * r11.zwz;
    r20.xyz = icb[r6.z + 0].yyy * r12.xyx;
    r21.xyz = icb[r6.z + 0].yyy * r13.xyx;
    r22.xyzw = icb[r6.z + 0].yyyy * r19.xyzw;
    r26.xy = icb[r6.z + 0].yy * v2.xy;
    r27.xyzw = icb[r6.z + 0].yyyy * r10.xyzw;
    if (r24.x != 0)
    {
        r26.z = r23.z;
        r6.xyz = t0.SampleGrad(s0_s, r26.xyz, r17.zy, r18.zy).xyz;
        r6.xyz = r9.xxx * r6.xyz;
    }
    else
    {
        r6.xyz = float3(0, 0, 0);
    }
    if (r24.y != 0)
    {
        r23.xy = r27.xy;
        r28.xyz = t0.SampleGrad(s0_s, r23.xyz, r20.xy, r21.xy).xyz;
        r6.xyz = r9.yyy * r28.xyz + r6.xyz;
    }
    if (r24.z != 0)
    {
        r23.xy = r27.zw;
        r28.xyz = t0.SampleGrad(s0_s, r23.xyz, r22.xy, r22.zw).xyz;
        r6.xyz = r9.zzz * r28.xyz + r6.xyz;
    }
    r6.xyz = r4.www * r6.xyz + r25.xyz;
    if (r24.x != 0)
    {
        r26.w = r23.z;
        r17.xyzw = t1.SampleGrad(s0_s, r26.xyw, r17.xy, r18.xy).xyzw;
    }
    else
    {
        r17.xyzw = float4(0, 0, 0, 0);
    }
    if (r24.y != 0)
    {
        r23.xy = r27.xy;
        r18.xyzw = t1.SampleGrad(s0_s, r23.xyz, r20.xy, r21.xy).xzwy;
    }
    else
    {
        r18.xyzw = float4(0, 0, 0, 0);
    }
    if (r24.z != 0)
    {
        r23.xy = r27.zw;
        r20.xyzw = t1.SampleGrad(s0_s, r23.xyz, r22.xy, r22.zw).xzwy;
    }
    else
    {
        r20.xyzw = float4(0, 0, 0, 0);
    }
    r0.w = 1 + -r18.w;
    r18.w = r3.w ? r0.w : r18.w;
    r20.w = 1 + -r20.w;
    r18.xyzw = r18.xwyz * r9.yyyy;
    r17.xyzw = r9.xxxx * r17.xyzw + r18.xyzw;
    r17.xyzw = r9.zzzz * r20.xwyz + r17.xyzw;
    r16.xyzw = r4.wwww * r17.xyzw + r16.xyzw;
    r14.xyz = r4.www * cb6[r7.z + 1].xyz + r14.xyz;
    r4.xy = r4.ww * cb6[r7.z + 0].yz + r4.xy;
    r7.xyz = icb[r6.w + 0].yyy * r11.xyx;
    r11.xyz = icb[r6.w + 0].yyy * r11.zwz;
    r12.xyz = icb[r6.w + 0].yyy * r12.xyx;
    r13.xyz = icb[r6.w + 0].yyy * r13.xyx;
    r17.xyzw = icb[r6.w + 0].yyyy * r19.xyzw;
    r23.xy = icb[r6.w + 0].yy * v2.xy;
    r10.xyzw = icb[r6.w + 0].yyyy * r10.xyzw;
    if (r24.x != 0)
    {
        r23.z = r23.w;
        r18.xyz = t0.SampleGrad(s0_s, r23.xyz, r7.zy, r11.zy).xyz;
        r18.xyz = r18.xyz * r9.xxx;
    }
    else
    {
        r18.xyz = float3(0, 0, 0);
    }
    if (r24.y != 0)
    {
        r19.xy = r10.xy;
        r19.z = r23.w;
        r19.xyz = t0.SampleGrad(s0_s, r19.xyz, r12.xy, r13.xy).xyz;
        r18.xyz = r9.yyy * r19.xyz + r18.xyz;
    }
    if (r24.z != 0)
    {
        r19.xy = r10.zw;
        r19.z = r23.w;
        r19.xyz = t0.SampleGrad(s0_s, r19.xyz, r17.xy, r17.zw).xyz;
        r18.xyz = r9.zzz * r19.xyz + r18.xyz;
    }
    r6.xyz = r1.www * r18.xyz + r6.xyz;
    if (r24.x != 0)
    {
        r11.xyzw = t1.SampleGrad(s0_s, r23.xyw, r7.xy, r11.xy).xyzw;
    }
    else
    {
        r11.xyzw = float4(0, 0, 0, 0);
    }
    if (r24.y != 0)
    {
        r23.xy = r10.xy;
        r12.xyzw = t1.SampleGrad(s0_s, r23.xyw, r12.xy, r13.xy).xzwy;
    }
    else
    {
        r12.xyzw = float4(0, 0, 0, 0);
    }
    if (r24.z != 0)
    {
        r23.xy = r10.zw;
        r10.xyzw = t1.SampleGrad(s0_s, r23.xyw, r17.xy, r17.zw).xzwy;
    }
    else
    {
        r10.xyzw = float4(0, 0, 0, 0);
    }
    r0.w = 1 + -r12.w;
    r12.w = r3.w ? r0.w : r12.w;
    r10.w = 1 + -r10.w;
    r12.xyzw = r12.xwyz * r9.yyyy;
    r11.xyzw = r9.xxxx * r11.xyzw + r12.xyzw;
    r9.xyzw = r9.zzzz * r10.xwyz + r11.xyzw;
    r9.xyzw = r1.wwww * r9.xyzw + r16.xyzw;
    r7.xyz = r1.www * cb6[r7.w + 1].xyz + r14.xyz;
    r4.xy = r1.ww * cb6[r7.w + 0].yz + r4.xy;
    r9.xyz = float3(-0.5, -0.5, -0.5) + r9.xyz;
    r0.w = dot(r9.xyz, r9.xyz);
    r0.w = rsqrt(r0.w);
    r9.xyz = r9.xyz * r0.www;
    r10.xyz = r9.yyy * r3.xyz;
    r10.xyz = r9.xxx * r2.xyz + r10.xyz;
    r9.xyz = r9.zzz * r1.xyz + r10.xyz;
    r3.xyz = r8.yyy * r3.xyz;
    r2.xyz = r8.xxx * r2.xyz + r3.xyz;
    r1.xyw = r8.zzz * r1.xyz + r2.xyz;
    r2.xyz = float3(0, 0, 1) + -r9.xyz;
    r2.xyz = r2.xyz * r1.zzz;
    r2.xyz = r4.xxx * r2.xyz + r9.xyz;
    r0.w = dot(r2.xyz, r2.xyz);
    r0.w = rsqrt(r0.w);
    r0.w = saturate(r2.z * r0.w);
    r1.z = saturate(r2.w + r15.x);
    r2.x = 1 + -r0.w;
    r2.x = sqrt(r2.x);
    r2.y = r0.w * -0.0187292993 + 0.0742610022;
    r2.y = r2.y * r0.w + -0.212114394;
    r0.w = r2.y * r0.w + 1.57072878;
    r0.w = r0.w * r2.x;
    r2.x = r0.w * r0.w;
    r2.y = r2.x * r0.w;
    r2.x = r2.x * r2.y;
    r0.w = r2.y * 0.333333343 + r0.w;
    r0.w = r2.x * 0.13333334 + r0.w;
    r0.w = min(1, r0.w);
    r0.w = r0.w + -r2.w;
    r1.z = r1.z + -r2.w;
    r0.w = saturate(r0.w / r1.z);
    r1.z = 1 + -r4.y;
    r2.xy = -r9.xy / r9.zz;
    r1.xy = -r1.xy / r1.ww;
    r1.xy = r4.yy * r1.xy;
    r1.xy = -r1.zz * r2.xy + -r1.xy;
    r1.z = 1;
    r1.w = dot(r1.xyz, r1.xyz);
    r1.w = rsqrt(r1.w);
    r2.xyz = r1.xyz * r1.www;
    r3.xyz = r6.xyz + -r5.xyz;
    r3.xyz = r0.www * r3.xyz + r5.xyz;
    r1.xyz = -r1.xyz * r1.www + r9.xyz;
    r1.xyz = r0.www * r1.xyz + r2.xyz;
    r2.xyz = r7.xyz + -r15.yzw;
    r2.xyz = r0.www * r2.xyz + r15.yzw;
    r1.w = r9.w + -r14.w;
    r0.w = r0.w * r1.w + r14.w;
    r0.xy = v0.zw;
    r0.xyz = t3.Sample(s3_s, r0.xyz, int2(0, 0)).xyz;
    r4.xyz = cmp(r0.xyz < float3(0.5, 0.5, 0.5));
    r5.xyz = r0.xyz * r3.xyz;
    r5.xyz = r5.xyz + r5.xyz;
    r3.xyz = float3(1, 1, 1) + -r3.xyz;
    r3.xyz = r3.xyz + r3.xyz;
    r0.xyz = float3(1, 1, 1) + -r0.xyz;
    r0.xyz = -r3.xyz * r0.xyz + float3(1, 1, 1);
    o0.xyz = r4.xyz ? r5.xyz : r0.xyz;
    r0.x = 1 + -r0.w;
    r0.y = -0.5 + r2.y;
    r0.z = log2(r2.x);
    r0.yz = float2(3, 2.20000005) * r0.yz;
    r0.z = exp2(r0.z);
    r0.x = r0.x * r2.z + r0.y;
    r0.x = saturate(r0.z * r0.x);
    r0.x = log2(r0.x);
    r0.x = 0.454544991 * r0.x;
    o2.xyz = exp2(r0.xxx);
    r0.x = dot(r1.xyz, r1.xyz);
    r0.x = rsqrt(r0.x);
    r0.xyz = r1.xyz * r0.xxx;

    float3 normal = r0.xyz;

    r1.x = max(abs(r0.x), abs(r0.y));
    r1.x = max(r1.x, abs(r0.z));
    r1.yz = cmp(abs(r0.zy) < r1.xx);
    r1.zw = r1.zz ? abs(r0.zy) : abs(r0.zx);
    r1.yz = r1.yy ? r1.zw : abs(r0.yx);
    r1.w = cmp(r1.z < r1.y);
    r2.xy = r1.ww ? r1.yz : r1.zy;
    r2.z = r2.y / r2.x;
    r0.xyz = r0.xyz / r1.xxx;
    r1.x = t13.SampleLevel(s13_s, r2.xz, 0).x;
    r0.xyz = r1.xxx * r0.xyz;
    normal_roughness.xyz = r0.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
    o0.w = 0;

    float roughness = r0.w;
    normal_roughness.w = FilterNDF(normal, roughness);

    o2.w = 0;

    motion_vector = 1;
}
