#include "WaterCommon.hlsli"
Texture2D<float4> t23 : register(t23);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);

SamplerState s11_s : register(s11);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

cbuffer cb12 : register(b12)
{
    float4 cb12[210];
}

cbuffer cb3 : register(b3)
{
    float4 cb3[13];
}


#define cmp -


void PSMain(
  float4 sv_position : SV_Position0,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1)
{
    float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16;

    r0.xy = (uint2) sv_position.xy;
    r1.xy = (uint2) r0.xy;
    r1.zw = float2(0.5, 0.5) + r1.xy;
    r2.xy = (int2) r0.xy;
    r2.xy = cb3[8].zw * r2.xy;
    r2.xy = (uint2) r2.xy;
    r2.zw = float2(0, 0);
    r2.xy = t0.Load(r2.xyz).zw;
    r2.y = cmp(0 < r2.y);
    if (r2.y != 0)
    {
        r2.yz = cb3[5].zw * r1.zw;
        r2.x = cmp(0.5 < r2.x);
        r0.z = 0;
        r0.z = t2.Load(r0.xyz).x;
        r1.xy = cb3[8].zw * r1.xy;
        r3.xy = (uint2) r1.xy;
        r3.zw = float2(0, 0);
        r1.x = t4.Load(r3.xyz).x;
        r1.y = cmp(cb12[22].y == 1.000000);
        r2.w = max(r1.x, r0.z);
        r0.z = min(r1.x, r0.z);
        r0.z = r1.y ? r2.w : r0.z;
        r1.xy = r1.zw / cb3[0].xy;
        r1.xy = r1.xy * float2(2, 2) + float2(-1, -1);
        r3.xyzw = cb12[207].xyzw * -r1.yyyy;
        r3.xyzw = cb12[206].xyzw * r1.xxxx + r3.xyzw;
        r3.xyzw = cb12[208].xyzw * r0.zzzz + r3.xyzw;
        r3.xyzw = cb12[209].xyzw + r3.xyzw;
        r3.xyz = r3.xyz / r3.www;
        r0.z = cmp(cb12[0].z >= r3.z);
        r0.z = r0.z ? 1 : -1;
        r4.xy = float2(0, 0);
        r4.z = (int) r0.z;
        r5.xyz = cb12[2].xyz * r3.yyy;
        r5.xyz = cb12[1].xyz * r3.xxx + r5.xyz;
        r5.xyz = cb12[3].xyz * r3.zzz + r5.xyz;
        r5.xyz = cb12[4].xyz + r5.xyz;
        r6.xyz = -cb12[0].xyz + r3.xyz;
        r0.z = dot(r6.xyz, r6.xyz);
        r0.z = rsqrt(r0.z);
        r6.xyz = r6.xyz * r0.zzz;
        r0.z = dot(r6.zz, r4.zz);
        r4.xyz = r4.xyz * -r0.zzz + r6.xyz;
        r6.xyz = cb12[2].xyz * r4.yyy;
        r6.xyz = cb12[1].xyz * r4.xxx + r6.xyz;
        r6.xyz = cb12[3].xyz * r4.zzz + r6.xyz;
        r6.xyw = r6.xyz * float3(100, 100, 100) + r5.xyz;
        r7.xyz = cb12[14].xyw * r5.yyy;
        r5.xyw = cb12[13].xyw * r5.xxx + r7.xyz;
        r5.xyw = cb12[15].xyw * r5.zzz + r5.xyw;
        r5.xyw = cb12[16].xyw + r5.xyw;
        r1.xy = r5.xy / r5.ww;
        r7.xyzw = float4(0.5, -0.5, 0.5, 0.5) * cb3[0].xyxy;
        r7.xyzw = r7.xyzw / cb3[0].zwzw;
        r8.xy = r1.xy * r7.xy + r7.zw;
        r5.xyw = cb12[14].xyw * r6.yyy;
        r5.xyw = cb12[13].xyw * r6.xxx + r5.xyw;
        r5.xyw = cb12[15].xyw * r6.www + r5.xyw;
        r5.xyw = cb12[16].xyw + r5.xyw;
        r5.xy = r5.xy / r5.ww;
        r9.yz = r5.xy * r7.xy + r7.zw;
        r0.z = cb12[21].x * r5.z;
        r0.z = 1 / r0.z;
        r1.y = cb12[21].y / cb12[21].x;
        r8.z = -r1.y + r0.z;
        r0.z = cb12[21].x * r6.w;
        r0.z = 1 / r0.z;
        r9.w = r0.z + -r1.y;
        r5.yzw = r9.yzw + -r8.xyz;
        r0.z = 1 + -abs(r1.x);
        r6.xyw = float3(2, 0.5, 0.5) / cb3[0].xzw;
        r0.z = -r6.x + r0.z;
        r1.x = 4 * r0.z;
        r1.x = saturate(r1.x);
        r5.x = r5.y * r1.x;
        r1.x = cmp(abs(r5.x) >= abs(r5.z));
        r9.xy = cb3[0].zw * abs(r5.xz);
        r1.x = r1.x ? r9.x : r9.y;
        r1.x = 1 / r1.x;
        r9.xyz = r5.xzw * r1.xxx;
        r1.y = cmp(0 < r6.z);
        r2.w = max(cb3[0].x, cb3[0].y);
        r2.w = trunc(r2.w);
        r10.xyz = cmp(float3(0, 0, 0) < r9.xyz);
        r6.xz = cb3[0].xy / cb3[0].zw;
        r11.xy = r6.xz + -r8.xy;
        r10.xy = r10.xy ? r11.xy : r8.xy;
        r10.xy = r10.xy / abs(r9.xy);
        r2.w = min(r10.x, r2.w);
        r2.w = trunc(r2.w);
        r2.w = min(r2.w, r10.y);
        r2.w = trunc(r2.w);
        r4.w = 1 + -r8.z;
        r4.w = r10.z ? r4.w : 0;
        r4.w = r4.w / abs(r9.z);
        r4.w = 3 + r4.w;
        r2.w = min(r4.w, r2.w);
        r2.w = (int) r2.w;
        r1.y = r1.y ? r2.w : 0;
        r2.w = abs(r9.z) + abs(r9.z);
        r10.xy = float2(-1.5, -1.5) + cb3[0].xy;
        r10.zw = r10.xy / cb3[0].zw;
        r11.xy = r8.xy;
        r4.w = r8.z;
        r5.y = 0;
        r6.x = 1;
        while (true)
        {
            r8.w = cmp((int) r6.x >= (int) r1.y);
            if (r8.w != 0)
                break;
            r8.w = (int) r6.x;
            r12.xyz = r8.www * r9.xyz + r8.xyz;
            r13.xyz = r5.xzw * r1.xxx + r12.xyz;
            r14.xyz = r5.xzw * r1.xxx + r13.xyz;
            r15.xyw = r5.xzw * r1.xxx + r14.xyz;
            r11.zw = min(r12.xy, r10.zw);
            r8.w = t2.SampleLevel(s0_s, r11.zw, 0).x;
            r16.x = r8.w * cb12[22].x + cb12[22].y;
            r11.zw = min(r13.xy, r10.zw);
            r8.w = t2.SampleLevel(s0_s, r11.zw, 0).x;
            r16.y = r8.w * cb12[22].x + cb12[22].y;
            r11.zw = min(r14.xy, r10.zw);
            r8.w = t2.SampleLevel(s0_s, r11.zw, 0).x;
            r16.z = r8.w * cb12[22].x + cb12[22].y;
            r11.zw = min(r15.xy, r10.zw);
            r8.w = t2.SampleLevel(s0_s, r11.zw, 0).x;
            r16.w = r8.w * cb12[22].x + cb12[22].y;
            r15.x = r12.z;
            r15.y = r13.z;
            r15.z = r14.z;
            r12.xyzw = r15.xyzw + -r16.xyzw;
            r12.xyzw = -abs(r9.zzzz) * float4(2, 2, 2, 2) + r12.xyzw;
            r12.xyzw = cmp(abs(r12.xyzw) < r2.wwww);
            r11.zw = (int2) r12.zw | (int2) r12.xy;
            r8.w = (int) r11.w | (int) r11.z;
            if (r8.w != 0)
            {
                r8.w = r12.z ? 2 : 3;
                r8.w = r12.y ? 1 : r8.w;
                r8.w = r12.x ? 0 : r8.w;
                r8.w = (int) r6.x + (int) r8.w;
                r8.w = (int) r8.w;
                r12.xyz = r8.www * r9.xyz + r8.xyz;
                r5.y = -1;
                r11.xy = r12.xy;
                r4.w = r12.z;
                break;
            }
            r6.x = (int) r6.x + 4;
            r5.y = 0;
        }
        if (r5.y != 0)
        {
            r1.x = r11.y / r6.z;
            r1.x = -0.5 + r1.x;
            r1.x = -abs(r1.x) * 2 + 1;
            r1.x = max(0, r1.x);
            r1.x = r1.x + r1.x;
            r1.x = min(1, r1.x);
            r1.x = 1 + -r1.x;
            r1.x = -r1.x * r1.x + 1;
            r5.xy = r11.xy / cb3[3].yy;
            r5.zw = float2(0.5, 0.5) / cb3[0].xy;
            r6.xz = cb3[3].yy * cb3[0].zw;
            r6.xz = r10.xy / r6.xz;
            r5.xy = max(r5.xy, r5.zw);
            r5.xy = min(r5.xy, r6.xz);
            r5.xyz = t1.SampleLevel(s0_s, r5.xy, 0).xyz;
            r1.y = 1;

            // don't fade out SSR based on the distance to screen border
            r1.x = 1;
        }
        else
        {
            r11.xy = float2(0, 0);
            r4.w = 0;
            r5.xyz = float3(0, 0, 0);
            r1.xy = float2(0, 0);
        }
        if (r2.x != 0)
        {
            [branch]
            if (r4.z < 0)
            {
                // sample underwater fog paraboloid
                float2 tex_coord = GetParaboloidTexCoord(r4.xyz);
                r8.xyz = _underwater_reflection_fallback_paraboloid.SampleLevel(s1_s, tex_coord, 0).xyz;
            }
            else
            {
                r2.xw = float2(-0.5, 0.5) * r4.xy;
                r5.w = 1 + abs(r4.z);
                r2.xw = r2.xw / r5.ww;
                r2.xw = float2(0.5, 0.5) + r2.xw;
                r2.xw = cb3[4].xy * r2.xw;
                r6.xz = float2(-0.5, -0.5) + cb3[4].xy;
                r2.xw = max(float2(0.5, 0.5), r2.xw);
                r2.xw = min(r2.xw, r6.xz);
                r2.xw = r2.xw / cb3[4].zw;
                r8.xyz = t5.SampleLevel(s1_s, r2.xw, 0).xyz;
            }           
        }
        else
        {
            r9.xyz = cb12[114].xyz * r3.yyy;
            r9.xyz = cb12[113].xyz * r3.xxx + r9.xyz;
            r9.xyz = cb12[115].xyz * r3.zzz + r9.xyz;
            r9.xyz = cb12[116].xyz + r9.xyz;
            r9.xyz = float3(1, 1, 1) + -abs(r9.xyz);
            r12.xyz = cmp(float3(0, 0, 0) < r9.xyz);
            r2.x = r12.y ? r12.x : 0;
            r2.x = r12.z ? r2.x : 0;
            if (r2.x != 0)
            {
                r9.xyz = saturate(cb12[112].xyz * r9.xyz);
                r2.x = 0.999989986 * cb12[111].x;
                r2.w = r9.x * r9.y;
                r2.w = r2.w * r9.z;
                r5.w = r2.x * r2.w;
                r2.x = r2.x * r2.w + 9.99999975e-006;
                r2.w = cb12[117].x * r5.w;
                r9.xyz = cb12[119].xyz * r4.yyy;
                r9.xyz = cb12[118].xyz * r4.xxx + r9.xyz;
                r9.xyz = cb12[120].xyz * r4.zzz + r9.xyz;
                r12.xyz = cb12[119].xyz * r3.yyy;
                r12.xyz = cb12[118].xyz * r3.xxx + r12.xyz;
                r12.xyz = cb12[120].xyz * r3.zzz + r12.xyz;
                r12.xyz = cb12[121].xyz + r12.xyz;
                r9.xyz = float3(1, 1, 1) / r9.xyz;
                r13.xyz = -r12.xyz * r9.xyz + r9.xyz;
                r9.xyz = -r12.xyz * r9.xyz + -r9.xyz;
                r9.xyz = max(r13.xyz, r9.xyz);
                r5.w = min(r9.y, r9.z);
                r5.w = min(r9.x, r5.w);
                r9.xyz = r4.xyz * r5.www + r3.xyz;
                r9.xyz = -cb12[111].yzw + r9.xyz;
                r5.w = dot(r9.xyz, r9.xyz);
                r5.w = rsqrt(r5.w);
                r9.xyw = r9.xyz * r5.www;
                r6.x = cmp(r9.w < 0);
                r6.z = r6.x ? 0.000000 : 0;
                r12.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r9.xyxy;
                r8.w = -r9.z * r5.w + 1;
                r8.w = max(0.00100000005, r8.w);
                r9.xy = r12.xy / r8.ww;
                r5.w = r9.z * r5.w + 1;
                r5.w = max(0.00100000005, r5.w);
                r9.zw = r12.zw / r5.ww;
                r9.xyzw = float4(0.5, 0.5, 0.5, 0.5) + r9.xyzw;
                r9.xy = r6.xx ? r9.xy : r9.zw;
                r9.xy = r9.xy * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
                r12.y = asint(cb12[122].x);
                r12.z = (int) r6.z;
                r12.xw = float2(0, 0);
                r6.xz = r12.zw + r9.xy;
                r6.xz = r12.xy + r6.xz;
                r6.xz = float2(0.5, 0.142857149) * r6.xz;
                r9.xyz = t23.SampleLevel(s11_s, r6.xz, 0).xyz;
                r9.xyz = r9.xyz * r2.www;
            }
            else
            {
                r9.xyz = float3(0, 0, 0);
                r2.x = 9.99999975e-006;
            }
            r2.w = cmp(r2.x < 0.999000013);
            if (r2.w != 0)
            {
                r12.xyz = cb12[126].xyz * r3.yyy;
                r12.xyz = cb12[125].xyz * r3.xxx + r12.xyz;
                r12.xyz = cb12[127].xyz * r3.zzz + r12.xyz;
                r12.xyz = cb12[128].xyz + r12.xyz;
                r12.xyz = float3(1, 1, 1) + -abs(r12.xyz);
                r13.xyz = cmp(float3(0, 0, 0) < r12.xyz);
                r5.w = r13.y ? r13.x : 0;
                r5.w = r13.z ? r5.w : 0;
                if (r5.w != 0)
                {
                    r12.xyz = saturate(cb12[124].xyz * r12.xyz);
                    r5.w = 1 + -r2.x;
                    r5.w = cb12[123].x * r5.w;
                    r6.x = r12.x * r12.y;
                    r6.x = r6.x * r12.z;
                    r6.z = r6.x * r5.w;
                    r2.x = r5.w * r6.x + r2.x;
                    r5.w = cb12[129].x * r6.z;
                    r12.xyz = cb12[131].xyz * r4.yyy;
                    r12.xyz = cb12[130].xyz * r4.xxx + r12.xyz;
                    r12.xyz = cb12[132].xyz * r4.zzz + r12.xyz;
                    r13.xyz = cb12[131].xyz * r3.yyy;
                    r13.xyz = cb12[130].xyz * r3.xxx + r13.xyz;
                    r13.xyz = cb12[132].xyz * r3.zzz + r13.xyz;
                    r13.xyz = cb12[133].xyz + r13.xyz;
                    r12.xyz = float3(1, 1, 1) / r12.xyz;
                    r14.xyz = -r13.xyz * r12.xyz + r12.xyz;
                    r12.xyz = -r13.xyz * r12.xyz + -r12.xyz;
                    r12.xyz = max(r14.xyz, r12.xyz);
                    r6.x = min(r12.y, r12.z);
                    r6.x = min(r12.x, r6.x);
                    r12.xyz = r4.xyz * r6.xxx + r3.xyz;
                    r12.xyz = -cb12[123].yzw + r12.xyz;
                    r6.x = dot(r12.xyz, r12.xyz);
                    r6.x = rsqrt(r6.x);
                    r12.xyw = r12.xyz * r6.xxx;
                    r6.z = cmp(r12.w < 0);
                    r8.w = r6.z ? 0.000000 : 0;
                    r13.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r12.xyxy;
                    r9.w = -r12.z * r6.x + 1;
                    r9.w = max(0.00100000005, r9.w);
                    r10.xy = r13.xy / r9.ww;
                    r10.xy = float2(0.5, 0.5) + r10.xy;
                    r6.x = r12.z * r6.x + 1;
                    r6.x = max(0.00100000005, r6.x);
                    r11.zw = r13.zw / r6.xx;
                    r11.zw = float2(0.5, 0.5) + r11.zw;
                    r6.xz = r6.zz ? r10.xy : r11.zw;
                    r6.xz = r6.xz * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
                    r12.y = asint(cb12[134].x);
                    r12.z = (int) r8.w;
                    r12.xw = float2(0, 0);
                    r6.xz = r12.zw + r6.xz;
                    r6.xz = r12.xy + r6.xz;
                    r6.xz = float2(0.5, 0.142857149) * r6.xz;
                    r12.xyz = t23.SampleLevel(s11_s, r6.xz, 0).xyz;
                    r9.xyz = r5.www * r12.xyz + r9.xyz;
                }
            }
            r5.w = cmp(r2.x < 0.999000013);
            r2.w = r2.w ? r5.w : 0;
            if (r2.w != 0)
            {
                r12.xyz = cb12[138].xyz * r3.yyy;
                r12.xyz = cb12[137].xyz * r3.xxx + r12.xyz;
                r12.xyz = cb12[139].xyz * r3.zzz + r12.xyz;
                r12.xyz = cb12[140].xyz + r12.xyz;
                r12.xyz = float3(1, 1, 1) + -abs(r12.xyz);
                r13.xyz = cmp(float3(0, 0, 0) < r12.xyz);
                r5.w = r13.y ? r13.x : 0;
                r5.w = r13.z ? r5.w : 0;
                if (r5.w != 0)
                {
                    r12.xyz = saturate(cb12[136].xyz * r12.xyz);
                    r5.w = 1 + -r2.x;
                    r5.w = cb12[135].x * r5.w;
                    r6.x = r12.x * r12.y;
                    r6.x = r6.x * r12.z;
                    r6.z = r6.x * r5.w;
                    r2.x = r5.w * r6.x + r2.x;
                    r5.w = cb12[141].x * r6.z;
                    r12.xyz = cb12[143].xyz * r4.yyy;
                    r12.xyz = cb12[142].xyz * r4.xxx + r12.xyz;
                    r12.xyz = cb12[144].xyz * r4.zzz + r12.xyz;
                    r13.xyz = cb12[143].xyz * r3.yyy;
                    r13.xyz = cb12[142].xyz * r3.xxx + r13.xyz;
                    r13.xyz = cb12[144].xyz * r3.zzz + r13.xyz;
                    r13.xyz = cb12[145].xyz + r13.xyz;
                    r12.xyz = float3(1, 1, 1) / r12.xyz;
                    r14.xyz = -r13.xyz * r12.xyz + r12.xyz;
                    r12.xyz = -r13.xyz * r12.xyz + -r12.xyz;
                    r12.xyz = max(r14.xyz, r12.xyz);
                    r6.x = min(r12.y, r12.z);
                    r6.x = min(r12.x, r6.x);
                    r12.xyz = r4.xyz * r6.xxx + r3.xyz;
                    r12.xyz = -cb12[135].yzw + r12.xyz;
                    r6.x = dot(r12.xyz, r12.xyz);
                    r6.x = rsqrt(r6.x);
                    r12.xyw = r12.xyz * r6.xxx;
                    r6.z = cmp(r12.w < 0);
                    r8.w = r6.z ? 0.000000 : 0;
                    r13.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r12.xyxy;
                    r9.w = -r12.z * r6.x + 1;
                    r9.w = max(0.00100000005, r9.w);
                    r10.xy = r13.xy / r9.ww;
                    r10.xy = float2(0.5, 0.5) + r10.xy;
                    r6.x = r12.z * r6.x + 1;
                    r6.x = max(0.00100000005, r6.x);
                    r11.zw = r13.zw / r6.xx;
                    r11.zw = float2(0.5, 0.5) + r11.zw;
                    r6.xz = r6.zz ? r10.xy : r11.zw;
                    r6.xz = r6.xz * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
                    r12.y = asint(cb12[146].x);
                    r12.z = (int) r8.w;
                    r12.xw = float2(0, 0);
                    r6.xz = r12.zw + r6.xz;
                    r6.xz = r12.xy + r6.xz;
                    r6.xz = float2(0.5, 0.142857149) * r6.xz;
                    r12.xyz = t23.SampleLevel(s11_s, r6.xz, 0).xyz;
                    r9.xyz = r5.www * r12.xyz + r9.xyz;
                }
            }
            r5.w = cmp(r2.x < 0.999000013);
            r2.w = r2.w ? r5.w : 0;
            if (r2.w != 0)
            {
                r12.xyz = cb12[150].xyz * r3.yyy;
                r12.xyz = cb12[149].xyz * r3.xxx + r12.xyz;
                r12.xyz = cb12[151].xyz * r3.zzz + r12.xyz;
                r12.xyz = cb12[152].xyz + r12.xyz;
                r12.xyz = float3(1, 1, 1) + -abs(r12.xyz);
                r13.xyz = cmp(float3(0, 0, 0) < r12.xyz);
                r5.w = r13.y ? r13.x : 0;
                r5.w = r13.z ? r5.w : 0;
                if (r5.w != 0)
                {
                    r12.xyz = saturate(cb12[148].xyz * r12.xyz);
                    r5.w = 1 + -r2.x;
                    r5.w = cb12[147].x * r5.w;
                    r6.x = r12.x * r12.y;
                    r6.x = r6.x * r12.z;
                    r6.z = r6.x * r5.w;
                    r2.x = r5.w * r6.x + r2.x;
                    r5.w = cb12[153].x * r6.z;
                    r12.xyz = cb12[155].xyz * r4.yyy;
                    r12.xyz = cb12[154].xyz * r4.xxx + r12.xyz;
                    r12.xyz = cb12[156].xyz * r4.zzz + r12.xyz;
                    r13.xyz = cb12[155].xyz * r3.yyy;
                    r13.xyz = cb12[154].xyz * r3.xxx + r13.xyz;
                    r13.xyz = cb12[156].xyz * r3.zzz + r13.xyz;
                    r13.xyz = cb12[157].xyz + r13.xyz;
                    r12.xyz = float3(1, 1, 1) / r12.xyz;
                    r14.xyz = -r13.xyz * r12.xyz + r12.xyz;
                    r12.xyz = -r13.xyz * r12.xyz + -r12.xyz;
                    r12.xyz = max(r14.xyz, r12.xyz);
                    r6.x = min(r12.y, r12.z);
                    r6.x = min(r12.x, r6.x);
                    r12.xyz = r4.xyz * r6.xxx + r3.xyz;
                    r12.xyz = -cb12[147].yzw + r12.xyz;
                    r6.x = dot(r12.xyz, r12.xyz);
                    r6.x = rsqrt(r6.x);
                    r12.xyw = r12.xyz * r6.xxx;
                    r6.z = cmp(r12.w < 0);
                    r8.w = r6.z ? 0.000000 : 0;
                    r13.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r12.xyxy;
                    r9.w = -r12.z * r6.x + 1;
                    r9.w = max(0.00100000005, r9.w);
                    r10.xy = r13.xy / r9.ww;
                    r10.xy = float2(0.5, 0.5) + r10.xy;
                    r6.x = r12.z * r6.x + 1;
                    r6.x = max(0.00100000005, r6.x);
                    r11.zw = r13.zw / r6.xx;
                    r11.zw = float2(0.5, 0.5) + r11.zw;
                    r6.xz = r6.zz ? r10.xy : r11.zw;
                    r6.xz = r6.xz * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
                    r12.y = asint(cb12[158].x);
                    r12.z = (int) r8.w;
                    r12.xw = float2(0, 0);
                    r6.xz = r12.zw + r6.xz;
                    r6.xz = r12.xy + r6.xz;
                    r6.xz = float2(0.5, 0.142857149) * r6.xz;
                    r12.xyz = t23.SampleLevel(s11_s, r6.xz, 0).xyz;
                    r9.xyz = r5.www * r12.xyz + r9.xyz;
                }
            }
            r5.w = cmp(r2.x < 0.999000013);
            r2.w = r2.w ? r5.w : 0;
            if (r2.w != 0)
            {
                r12.xyz = cb12[162].xyz * r3.yyy;
                r12.xyz = cb12[161].xyz * r3.xxx + r12.xyz;
                r12.xyz = cb12[163].xyz * r3.zzz + r12.xyz;
                r12.xyz = cb12[164].xyz + r12.xyz;
                r12.xyz = float3(1, 1, 1) + -abs(r12.xyz);
                r13.xyz = cmp(float3(0, 0, 0) < r12.xyz);
                r5.w = r13.y ? r13.x : 0;
                r5.w = r13.z ? r5.w : 0;
                if (r5.w != 0)
                {
                    r12.xyz = saturate(cb12[160].xyz * r12.xyz);
                    r5.w = 1 + -r2.x;
                    r5.w = cb12[159].x * r5.w;
                    r6.x = r12.x * r12.y;
                    r6.x = r6.x * r12.z;
                    r6.z = r6.x * r5.w;
                    r2.x = r5.w * r6.x + r2.x;
                    r5.w = cb12[165].x * r6.z;
                    r12.xyz = cb12[167].xyz * r4.yyy;
                    r12.xyz = cb12[166].xyz * r4.xxx + r12.xyz;
                    r12.xyz = cb12[168].xyz * r4.zzz + r12.xyz;
                    r13.xyz = cb12[167].xyz * r3.yyy;
                    r13.xyz = cb12[166].xyz * r3.xxx + r13.xyz;
                    r13.xyz = cb12[168].xyz * r3.zzz + r13.xyz;
                    r13.xyz = cb12[169].xyz + r13.xyz;
                    r12.xyz = float3(1, 1, 1) / r12.xyz;
                    r14.xyz = -r13.xyz * r12.xyz + r12.xyz;
                    r12.xyz = -r13.xyz * r12.xyz + -r12.xyz;
                    r12.xyz = max(r14.xyz, r12.xyz);
                    r6.x = min(r12.y, r12.z);
                    r6.x = min(r12.x, r6.x);
                    r12.xyz = r4.xyz * r6.xxx + r3.xyz;
                    r12.xyz = -cb12[159].yzw + r12.xyz;
                    r6.x = dot(r12.xyz, r12.xyz);
                    r6.x = rsqrt(r6.x);
                    r12.xyw = r12.xyz * r6.xxx;
                    r6.z = cmp(r12.w < 0);
                    r8.w = r6.z ? 0.000000 : 0;
                    r13.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r12.xyxy;
                    r9.w = -r12.z * r6.x + 1;
                    r9.w = max(0.00100000005, r9.w);
                    r10.xy = r13.xy / r9.ww;
                    r10.xy = float2(0.5, 0.5) + r10.xy;
                    r6.x = r12.z * r6.x + 1;
                    r6.x = max(0.00100000005, r6.x);
                    r11.zw = r13.zw / r6.xx;
                    r11.zw = float2(0.5, 0.5) + r11.zw;
                    r6.xz = r6.zz ? r10.xy : r11.zw;
                    r6.xz = r6.xz * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
                    r12.y = asint(cb12[170].x);
                    r12.z = (int) r8.w;
                    r12.xw = float2(0, 0);
                    r6.xz = r12.zw + r6.xz;
                    r6.xz = r12.xy + r6.xz;
                    r6.xz = float2(0.5, 0.142857149) * r6.xz;
                    r12.xyz = t23.SampleLevel(s11_s, r6.xz, 0).xyz;
                    r9.xyz = r5.www * r12.xyz + r9.xyz;
                }
            }
            r5.w = cmp(r2.x < 0.999000013);
            r2.w = r2.w ? r5.w : 0;
            if (r2.w != 0)
            {
                r12.xyz = cb12[174].xyz * r3.yyy;
                r12.xyz = cb12[173].xyz * r3.xxx + r12.xyz;
                r12.xyz = cb12[175].xyz * r3.zzz + r12.xyz;
                r12.xyz = cb12[176].xyz + r12.xyz;
                r12.xyz = float3(1, 1, 1) + -abs(r12.xyz);
                r13.xyz = cmp(float3(0, 0, 0) < r12.xyz);
                r2.w = r13.y ? r13.x : 0;
                r2.w = r13.z ? r2.w : 0;
                if (r2.w != 0)
                {
                    r12.xyz = saturate(cb12[172].xyz * r12.xyz);
                    r2.w = 1 + -r2.x;
                    r2.w = cb12[171].x * r2.w;
                    r5.w = r12.x * r12.y;
                    r5.w = r5.w * r12.z;
                    r6.x = r5.w * r2.w;
                    r2.x = r2.w * r5.w + r2.x;
                    r2.w = cb12[177].x * r6.x;
                    r12.xyz = cb12[179].xyz * r4.yyy;
                    r12.xyz = cb12[178].xyz * r4.xxx + r12.xyz;
                    r12.xyz = cb12[180].xyz * r4.zzz + r12.xyz;
                    r13.xyz = cb12[179].xyz * r3.yyy;
                    r13.xyz = cb12[178].xyz * r3.xxx + r13.xyz;
                    r13.xyz = cb12[180].xyz * r3.zzz + r13.xyz;
                    r13.xyz = cb12[181].xyz + r13.xyz;
                    r12.xyz = float3(1, 1, 1) / r12.xyz;
                    r14.xyz = -r13.xyz * r12.xyz + r12.xyz;
                    r12.xyz = -r13.xyz * r12.xyz + -r12.xyz;
                    r12.xyz = max(r14.xyz, r12.xyz);
                    r5.w = min(r12.y, r12.z);
                    r5.w = min(r12.x, r5.w);
                    r12.xyz = r4.xyz * r5.www + r3.xyz;
                    r12.xyz = -cb12[171].yzw + r12.xyz;
                    r5.w = dot(r12.xyz, r12.xyz);
                    r5.w = rsqrt(r5.w);
                    r12.xyw = r12.xyz * r5.www;
                    r6.x = cmp(r12.w < 0);
                    r6.z = r6.x ? 0.000000 : 0;
                    r13.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r12.xyxy;
                    r8.w = -r12.z * r5.w + 1;
                    r8.w = max(0.00100000005, r8.w);
                    r10.xy = r13.xy / r8.ww;
                    r10.xy = float2(0.5, 0.5) + r10.xy;
                    r5.w = r12.z * r5.w + 1;
                    r5.w = max(0.00100000005, r5.w);
                    r11.zw = r13.zw / r5.ww;
                    r11.zw = float2(0.5, 0.5) + r11.zw;
                    r10.xy = r6.xx ? r10.xy : r11.zw;
                    r10.xy = r10.xy * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
                    r12.y = asint(cb12[182].x);
                    r12.z = (int) r6.z;
                    r12.xw = float2(0, 0);
                    r6.xz = r12.zw + r10.xy;
                    r6.xz = r12.xy + r6.xz;
                    r6.xz = float2(0.5, 0.142857149) * r6.xz;
                    r12.xyz = t23.SampleLevel(s11_s, r6.xz, 0).xyz;
                    r9.xyz = r2.www * r12.xyz + r9.xyz;
                }
            }
            r2.w = cmp(r2.x < 0.999000013);
            if (r2.w != 0)
            {
                r2.w = 1 + -r2.x;
                r5.w = cb12[99].x * r2.w;
                r2.x = r2.w * cb12[99].x + r2.x;
                r2.w = cb12[105].x * r5.w;
                r5.w = cmp(r4.z < 0);
                r6.x = r5.w ? 0.000000 : 0;
                r12.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r4.xyxy;
                r4.x = 1 + -r4.z;
                r4.x = max(0.00100000005, r4.x);
                r4.xy = r12.xy / r4.xx;
                r4.xy = float2(0.5, 0.5) + r4.xy;
                r4.z = 1 + r4.z;
                r4.z = max(0.00100000005, r4.z);
                r10.xy = r12.zw / r4.zz;
                r10.xy = float2(0.5, 0.5) + r10.xy;
                r4.xy = r5.ww ? r4.xy : r10.xy;
                r4.xy = r4.xy * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
                r12.y = asint(cb12[110].x);
                r12.z = (int) r6.x;
                r12.xw = float2(0, 0);
                r4.xy = r12.zw + r4.xy;
                r4.xy = r12.xy + r4.xy;
                r4.xy = float2(0.5, 0.142857149) * r4.xy;
                r4.xyz = t23.SampleLevel(s11_s, r4.xy, 0).xyz;
                r9.xyz = r2.www * r4.xyz + r9.xyz;
            }
            r2.x = 1 / r2.x;
            r8.xyz = r9.xyz * r2.xxx;
        }
        r4.xyz = -r8.xyz + r5.xyz;
        r5.xyz = r1.xxx * r4.xyz + r8.xyz;
        r0.z = r0.z * 4 + -1;
        r0.z = saturate(2.5 * r0.z);
        r3.w = 1;
        r1.x = dot(cb3[10].xyzw, r3.xyzw);
        r2.x = dot(cb3[11].xyzw, r3.xyzw);
        r2.w = dot(cb3[12].xyzw, r3.xyzw);
        r4.xyz = cb12[14].xyw * r2.xxx;
        r4.xyz = cb12[13].xyw * r1.xxx + r4.xyz;
        r4.xyz = cb12[15].xyw * r2.www + r4.xyz;
        r4.xyz = cb12[16].xyw + r4.xyz;
        r2.xw = r4.xy / r4.zz;
        r2.xw = r2.xw * r7.xy + r7.zw;
        r1.x = cmp(r1.y == 1.000000);
        r1.y = cmp(0 < r0.z);
        r1.x = r1.y ? r1.x : 0;
        if (r1.x != 0)
        {
            r1.x = r4.w * cb12[22].x + cb12[22].y;
            r4.xy = r11.xy + -r7.zw;
            r4.xy = r4.xy / r7.xy;
            r8.xyzw = cb12[207].xyzw * r4.yyyy;
            r4.xyzw = cb12[206].xyzw * r4.xxxx + r8.xyzw;
            r4.xyzw = cb12[208].xyzw * r1.xxxx + r4.xyzw;
            r4.xyzw = cb12[209].xyzw + r4.xyzw;
            r4.xyz = r4.xyz / r4.www;
            r1.x = cb3[2].z + -r3.z;
            r1.y = r1.x + r4.z;
            r1.y = r1.y + -r3.z;
            r1.x = r1.x / r1.y;
            r4.xy = -cb3[2].xy + r4.xy;
            r3.xy = r1.xx * r4.xy + cb3[2].xy;
            r1.x = dot(cb3[10].xyzw, r3.xyzw);
            r1.y = dot(cb3[11].xyzw, r3.xyzw);
            r3.x = dot(cb3[12].xyzw, r3.xyzw);
            r3.yzw = cb12[14].xyw * r1.yyy;
            r3.yzw = cb12[13].xyw * r1.xxx + r3.yzw;
            r3.xyz = cb12[15].xyw * r3.xxx + r3.yzw;
            r3.xyz = cb12[16].xyw + r3.xyz;
            r1.xy = r3.xy / r3.zz;
            r1.xy = r1.xy * r7.xy + r7.zw;
            r1.xy = r1.xy + -r2.xw;
            r2.xw = r0.zz * r1.xy + r2.xw;
        }
        r1.xy = max(r2.xw, r6.yw);
        r1.xy = min(r1.xy, r10.zw);
        r2.xw = cmp(r2.xw == r1.xy);
        r0.z = r2.w ? r2.x : 0;
        r2.x = ~(int) r0.z;
        r1.xy = r1.xy / cb3[3].xx;
        r1.xy = r0.zz ? r1.xy : r2.yz;
        r5.w = 1;
    }
    else
    {
        r0.w = 0;
        r0.x = t2.Load(r0.xyw).x;
        r0.yz = r1.zw / cb3[0].xy;
        r0.yz = r0.yz * float2(2, 2) + float2(-1, -1);
        r3.xyzw = cb12[207].xyzw * -r0.zzzz;
        r3.xyzw = cb12[206].xyzw * r0.yyyy + r3.xyzw;
        r0.xyzw = cb12[208].xyzw * r0.xxxx + r3.xyzw;
        r0.xyzw = cb12[209].xyzw + r0.xyzw;
        r0.xyz = r0.xyz / r0.www;
        r0.w = 1;
        r1.z = dot(cb3[10].xyzw, r0.xyzw);
        r1.w = dot(cb3[11].xyzw, r0.xyzw);
        r0.x = dot(cb3[12].xyzw, r0.xyzw);
        r0.yzw = cb12[14].xyw * r1.www;
        r0.yzw = cb12[13].xyw * r1.zzz + r0.yzw;
        r0.xyz = cb12[15].xyw * r0.xxx + r0.yzw;
        r0.xyz = cb12[16].xyw + r0.xyz;
        r0.xy = r0.xy / r0.zz;
        r3.xyzw = float4(0.5, -0.5, 0.5, 0.5) * cb3[0].xyxy;
        r3.xyzw = r3.xyzw / cb3[0].zwzw;
        r0.xy = r0.xy * r3.xy + r3.zw;
        r0.zw = float2(0.5, 0.5) / cb3[0].zw;
        r1.zw = float2(-1.5, -1.5) + cb3[0].xy;
        r1.zw = r1.zw / cb3[0].zw;
        r0.xy = max(r0.xy, r0.zw);
        r1.xy = min(r0.xy, r1.zw);
        r5.xyzw = float4(0, 0, 0, 0);
        r2.x = 0;
    }
    r0.x = dot(float4(0.333000004, 0.333000004, 0.333000004, 0.333000004), r5.xyzw);
    r0.x = cmp(r0.x != r0.x);
    r3.xyzw = max(float4(0, 0, 0, 0), r5.xyzw);
    o0.xyzw = r0.xxxx ? float4(0, 0, 0, 0) : r3.xyzw;
    r0.xyzw = t3.SampleLevel(s1_s, r1.xy, 0).xyzw;
    r1.x = dot(float4(0.333000004, 0.333000004, 0.333000004, 0.333000004), r0.xyzw);
    r1.x = cmp(r1.x != r1.x);
    r0.xyzw = max(float4(0, 0, 0, 0), r0.xyzw);
    r0.xyzw = r1.xxxx ? float4(0, 0, 0, 0) : r0.xyzw;
    o1.xyzw = r2.xxxx ? r5.xyzw : r0.xyzw;
    return;
}