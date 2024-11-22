struct DS_OUTPUT
{
    float4 sv_position : SV_Position0;
    float2 v1 : TEXCOORD0;
    float water_surface_scene_depth : TEXCOORD2;
    float4 world_position : TEXCOORD3;
    float4 aerial_fog : TEXCOORD4;
    float4 fog : TEXCOORD5;
};
struct BEZIER_CONTROL_POINT
{
    float3 position : CPPOS;
    float4 fog : PMFOG;
    float4 material : PMAERIAL;
};

struct HS_CONSTANT_DATA_OUTPUT
{
    float t1 : SV_TessFactor0;
    float clipmap_level : CMLEVEL;
    float t2 : SV_TessFactor1;
    float t3 : SV_TessFactor2;
    float t4 : SV_TessFactor3;
    float t5 : SV_InsideTessFactor0;
    float t6 : SV_InsideTessFactor1;
};

Texture2D<float4> t17 : register(t17);
Texture2D<float4> t5 : register(t5);
Texture2DArray<float4> t4 : register(t4);

SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);

cbuffer cb5 : register(b5)
{
    float4 cb5[1];
}
cbuffer cb4 : register(b4)
{
    float4 cb4[116];
}
cbuffer cb1 : register(b1)
{
    float4 cb1[9];
}

#define cmp -

[domain("quad")]
DS_OUTPUT DSMain(HS_CONSTANT_DATA_OUTPUT input,
                        float2 vDomain : SV_DomainLocation,
                        const OutputPatch<BEZIER_CONTROL_POINT, 4> patch)
{
    float4 r0, r1, r2, r3, r4, r5, r6;
    uint4 bitmask;
    float4 fDest;

    r0.xyz = patch[1].position.xyz + -patch[0].position.xyz;
    r0.xyz = vDomain.xxx * r0.xyz + patch[0].position.xyz;
    r1.xyz = patch[3].position.xyz + -patch[2].position.xyz;
    r1.xyz = vDomain.xxx * r1.xyz + patch[2].position.xyz;
    r1.xyz = r1.xyz + -r0.xyz;
    r0.xyz = vDomain.yyy * r1.xyz + r0.xyz;
    r1.x = cmp((int) input.clipmap_level >= 0);
    if (r1.x != 0)
    {
        r1.x = input.clipmap_level;
        r1.yzw = float3(1, 0, 0);
        r2.xyzw = t17.Load(r1.xww).xyzw;
        r1.xyzw = t17.Load(r1.xyz).xyzw;
        t4.GetDimensions(0, fDest.x, fDest.y, fDest.z, fDest.w);
        r3.xy = fDest.xy;
        r3.zw = -r2.xy + r0.xy;
        r2.xy = r2.zw + -r2.xy;
        r2.xy = r3.zw / r2.xy;
        r2.zw = float2(0.5, 0.5) / r3.xy;
        r2.xy = abs(r2.xy) + r2.zw;
        r1.zw = r1.zw + -r1.xy;
        r1.xy = r2.xy * r1.zw + r1.xy;
        r1.z = (int) input.clipmap_level;
        r1.x = t4.SampleLevel(s4_s, r1.xyz, 0).x;
        r1.x = saturate(r1.x);
        r1.y = cb5[0].y + -cb5[0].x;
        r1.x = r1.x * r1.y + cb5[0].x;
    }
    else
    {
        r1.x = -10;
    }
    r1.x = -r1.x + r0.z;
    r1.y = -0.100000001 + abs(r1.x);
    r1.xyz = saturate(float3(-0.100000001, 0.204081625, 0.526315808) * r1.xyy);
    r1.yz = r1.yz * float2(0.699999988, 0.399999976) + float2(0.300000012, 0.600000024);
    r1.x = 1 + -r1.x;
    r1.x = r1.x * 0.899999976 + 0.100000001;
    r2.xy = -cb1[8].xy + r0.xy;
    r1.w = dot(r2.xy, r2.xy);
    r1.w = sqrt(r1.w);
    r1.w = 250 + -r1.w;
    r1.w = 0.00400000019 * r1.w;
    r1.w = max(0, r1.w);
    r2.xyzw = r0.xyxy / cb4[0].xxyy;
    r3.xy = t5.SampleLevel(s5_s, r2.xy, 0).xy;
    r3.zw = t5.SampleLevel(s5_s, r2.zw, 0).xy;
    r4.xy = cb4[3].xy * r1.xx;
    r2.xy = r4.xx * r3.xy + r2.xy;
    r5.xyw = t5.SampleLevel(s5_s, r2.xy, 0).xyw;
    r5.z = 0.000150000007;
    r2.x = dot(r5.xyz, r5.xyz);
    r2.x = rsqrt(r2.x);
    r2.xy = r5.xy * r2.xx;
    r2.zw = r4.yy * r3.zw + r2.zw;
    r3.xyw = t5.SampleLevel(s5_s, r2.zw, 0).xyw;
    r3.z = 0.000349999988;
    r2.z = dot(r3.xyz, r3.xyz);
    r2.z = rsqrt(r2.z);
    r2.zw = r3.xy * r2.zz;
    r1.yz = cb4[1].xy * r1.yz;
    r1.z = r1.z * r3.w;
    r1.y = r1.y * r5.w + r1.z;
    r1.x = r1.x * r1.w;
    r1.x = r1.x * r1.y + r0.z;
    r1.yz = -r4.xx * r2.xy + r0.xy;
    r1.yz = -r4.yy * r2.zw + r1.yz;
    r2.xyz = r1.yzx;
    r1.w = 0;
    while (true)
    {
        r3.x = cmp((uint) r1.w >= asuint(cb4[51].x));
        if (r3.x != 0)
            break;
        r3.x = (uint) r1.w << 2;
        bitmask.y = ((~(-1 << 30)) << 2) & 0xffffffff;
        r3.y = (((uint) r1.w << 2) & bitmask.y) | ((uint) 1 & ~bitmask.y);
        bitmask.z = ((~(-1 << 30)) << 2) & 0xffffffff;
        r3.z = (((uint) r1.w << 2) & bitmask.z) | ((uint) 2 & ~bitmask.z);
        bitmask.w = ((~(-1 << 30)) << 2) & 0xffffffff;
        r3.w = (((uint) r1.w << 2) & bitmask.w) | ((uint) 3 & ~bitmask.w);
        r4.xy = float2(-0.300000012, 0.300000012) + r2.zz;
        r4.x = max(cb4[r3.w + 52].z, r4.x);
        r4.x = min(r4.x, r4.y);
        r5.xy = -cb4[r3.w + 52].xy;
        r5.z = -r4.x;
        r4.xyz = r5.xyz + r2.xyz;
        r3.w = dot(r4.xyz, cb4[r3.x + 52].xyz);
        r4.w = dot(cb4[r3.x + 52].xyz, cb4[r3.x + 52].xyz);
        r5.x = r3.w / r4.w;
        r3.w = dot(r4.xyz, cb4[r3.y + 52].xyz);
        r5.w = dot(cb4[r3.y + 52].xyz, cb4[r3.y + 52].xyz);
        r5.y = r3.w / r5.w;
        r3.w = dot(r4.xyz, cb4[r3.z + 52].xyz);
        r4.x = dot(cb4[r3.z + 52].xyz, cb4[r3.z + 52].xyz);
        r5.z = r3.w / r4.x;
        r6.x = -cb4[r3.x + 52].z / r4.w;
        r6.y = -cb4[r3.y + 52].z / r5.w;
        r6.z = -cb4[r3.z + 52].z / r4.x;
        r3.w = dot(r6.xyz, r6.xyz);
        r3.w = rsqrt(r3.w);
        r4.xyz = r6.xyz * r3.www;
        r3.w = dot(r5.xyz, r4.xyz);
        r4.w = dot(r5.xyz, r5.xyz);
        r4.w = -1 + r4.w;
        r4.w = r3.w * r3.w + -r4.w;
        r5.x = cmp(r4.w >= 0);
        r4.w = sqrt(r4.w);
        r5.y = r4.w + -r3.w;
        r3.w = -r4.w + -r3.w;
        r3.w = max(r5.y, r3.w);
        r4.w = cmp(0 < r3.w);
        r4.xyz = r4.xyz * r3.www;
        r5.yzw = cb4[r3.y + 52].xyz * r4.yyy;
        r3.xyw = r4.xxx * cb4[r3.x + 52].xyz + r5.yzw;
        r3.xyz = r4.zzz * cb4[r3.z + 52].xyz + r3.xyw;
        r3.xyz = r3.xyz * float3(0.400000006, 0.400000006, 0.400000006) + r2.xyz;
        r3.xyz = r4.www ? r3.xyz : r2.xyz;
        r2.xyz = r5.xxx ? r3.xyz : r2.xyz;
        r1.w = (int) r1.w + 1;
    }
    r2.w = 1;

    DS_OUTPUT output;

    output.sv_position.x = dot(r2.xyzw, cb1[0].xyzw);
    output.sv_position.y = dot(r2.xyzw, cb1[1].xyzw);
    output.sv_position.z = dot(r2.xyzw, cb1[2].xyzw);
    output.sv_position.w = dot(r2.xyzw, cb1[3].xyzw);
    r0.w = dot(r2.xyzw, cb1[6].xyzw);
    r1.xyzw = patch[1].fog.xyzw + -patch[0].fog.xyzw;
    r1.xyzw = vDomain.xxxx * r1.xyzw + patch[0].fog.xyzw;
    r3.xyzw = patch[3].fog.xyzw + -patch[2].fog.xyzw;
    r3.xyzw = vDomain.xxxx * r3.xyzw + patch[2].fog.xyzw;
    r3.xyzw = r3.xyzw + -r1.xyzw;
    output.aerial_fog.xyzw = vDomain.yyyy * r3.xyzw + r1.xyzw;
    r1.xyzw = patch[1].material.xyzw + -patch[0].material.xyzw;
    r1.xyzw = vDomain.xxxx * r1.xyzw + patch[0].material.xyzw;
    r3.xyzw = patch[3].material.xyzw + -patch[2].material.xyzw;
    r3.xyzw = vDomain.xxxx * r3.xyzw + patch[2].material.xyzw;
    r3.xyzw = r3.xyzw + -r1.xyzw;
    output.fog.xyzw = vDomain.yyyy * r3.xyzw + r1.xyzw;
    output.world_position.xyz = r2.xyz;
    output.world_position.w = r0.z;
    output.v1.xy = r0.xy;
    output.water_surface_scene_depth = r0.w;

    return output;
}