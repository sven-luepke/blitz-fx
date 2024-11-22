#include "CustomData.hlsli"
#include "WaterCommon.hlsli"
#include "GBuffer.hlsli"

Texture2D<float4> ao_shadow_interior_texture : register(t16);
Texture2D<float4> t7 : register(t7);
Texture2D<float4> t6 : register(t6);
Texture2D<float4> specular_mask_texture : register(t4);
Texture2D<uint2> stencil_texture : register(t3);
Texture2D<float4> normal_roughness_texture : register(t2);
Texture2D<float4> albedo_translucency_texture : register(t1);
Texture2D<float> depth_texture : register(t0);

SamplerState s6_s : register(s6);

cbuffer cb13 : register(b13)
{
float4 cb13[57];
}

cbuffer cb12 : register(b12)
{
float4 cb12[219];
}

#define cmp -

RWTexture2D<float4> output : register(u0);


float3 FresnelSchlick(float cosTheta, float3 F0, float3 F90)
{
    return F0 + (F90 - F0) * pow(clamp(1.0 - cosTheta, 0.0, 1.0), 5.0);
}


float _DistributionGGX(float3 N, float3 H, float roughness)
{
    float a = roughness * roughness;
    float a2 = a * a;
    float NdotH = max(dot(N, H), 0.0);
    float NdotH2 = NdotH * NdotH;

    float num = a2;
    float denom = (NdotH2 * (a2 - 1.0) + 1.0);
    denom = PI * denom * denom;

    return num / denom;
}

float _GeometrySchlickGGX(float NdotV, float roughness)
{
    // roughness remapping from Ryse: Son of Rome
    float r = (roughness * 0.5 + 0.8);
    float k = (r * r) / 2.0;

    float num = NdotV;
    float denom = NdotV * (1.0 - k) + k;

    return num / denom;
}
float _GeometrySmith(float3 N, float3 V, float3 L, float roughness)
{
   // roughness = roughness * 0.5 + 0.8;
    float NdotV = max(dot(N, V), 0.00001);
    float NdotL = max(dot(N, L), 0.0);
    float ggx2 = _GeometrySchlickGGX(NdotV, roughness);
    float ggx1 = _GeometrySchlickGGX(NdotL, roughness);

    return ggx1 * ggx2;
}

float Fr_DisneyDiffuse(float NdotV, float NdotL, float LdotH, float linearRoughness)
{
    float energyBias = lerp(0, 0.5, linearRoughness);
    float energyFactor = lerp(1.0, 1.0 / 1.51, linearRoughness);
    float fd90 = energyBias + 2.0 * LdotH * LdotH * linearRoughness;
    float3 f0 = float3(1.0f, 1.0f, 1.0f);
    float lightScatter = FresnelSchlick(NdotL, f0, fd90).r;
    float viewScatter = FresnelSchlick(NdotV, f0, fd90).r;
    return lightScatter * viewScatter * energyFactor;
}

float3 OrenNayarDiffuse(float l_dot_v, float n_dot_l, float n_dot_v, float roughness, float3 albedo)
{
    float s = l_dot_v - n_dot_l * n_dot_v;
    float t = lerp(1.0, max(n_dot_l, n_dot_v), step(0.0, s));

    float sigma2 = roughness * roughness;
    float3 A = 1.0 + sigma2 * (albedo / (sigma2 + 0.13) + 0.5 / (sigma2 + 0.33));
    float B = 0.45 * sigma2 / (sigma2 + 0.09);

    return albedo * (A + B * s / t) * PI_RCP;
}


[numthreads(16, 16, 1)]
void CSMain(uint3 thread_id : SV_DispatchThreadID)
{
    float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19;

    r0.xy = thread_id.xy;
    r0.zw = float2(0, 0);
    r1.x = depth_texture.Load(r0.xyw).x;
    r1.y = r1.x * cb12[22].x + cb12[22].y;
    r1.y = cmp(r1.y < 1);

    float3 direct = 0;

    // used to simulate wetness
    float albedo_scale = 1;
    float water_depth = _water_depth.Load(int3(thread_id.xy, 0));

    [branch]
    if (r1.y != 0)
    {
        r1.y = albedo_translucency_texture.Load(r0.xyw).w;
        r2.xyzw = normal_roughness_texture.Load(r0.xyw).xyzw;

        float roughness = r2.w;

        r2.xyz = float3(-0.5, -0.5, -0.5) + r2.xyz;
        r1.z = dot(r2.xyz, r2.xyz);
        r1.z = rsqrt(r1.z);
        r3.xyz = r2.xyz * r1.zzz;
        float3 normal = r3.xyz;
        r2.xy = (uint2)r0.xy;
        r4.xyzw = cb12[211].xyzw * r2.yyyy;
        r4.xyzw = cb12[210].xyzw * r2.xxxx + r4.xyzw;
        r4.xyzw = cb12[212].xyzw * r1.xxxx + r4.xyzw;
        r4.xyzw = cb12[213].xyzw + r4.xyzw;
        r4.xyz = r4.xyz / r4.www;

        float3 world_position = r4.xyz;

        r5.xyz = cb12[0].xyz + -r4.xyz;
        r1.x = dot(r5.xyz, r5.xyz);
        r1.x = rsqrt(r1.x);
        r6.xyz = r5.xyz * r1.xxx;
        float3 v = r6.xyz;
        r7.xyzw = ao_shadow_interior_texture.Load(r0.xyw).xyzw;
        float shadow_factor = r7.y;

        float exterior_lighting_scale = r7.z;

        r8.xyzw = specular_mask_texture.Load(r0.xyw).xyzw;
        r8.xyz = log2(r8.xyz);
        r8.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r8.xyz;
        r8.xyz = exp2(r8.xyz);

        float3 F0 = r8.xyz;

        float3 specular_color = r8.xyz;

        // emulate wetness with reduced albedo (https://seblagarde.wordpress.com/2013/04/14/water-drop-3b-physically-based-wet-surfaces/)
        float porosity = saturate((roughness - 0.5) / 0.4);
        float metalness = saturate((dot(specular_color, 0.33) * 1000 - 500));
        albedo_scale = lerp(1, 0.2, (1 - metalness) * porosity);

        r1.w = r8.w * 255 + 0.5;
        r1.w = (uint)r1.w;

        uint stencil_mask = stencil_texture.Load(int3(thread_id.xy, 0)).y;
        uint mask = r1.w;
        if (stencil_mask != STENCIL_BIT_VEGETATION)
        {
              F0 = max(0.02, F0);
        }

        r2.x = (int)r1.w & 11;
        r2.x = r2.x ? 0 : 1;
        r2.y = cmp(0 < r7.y);
        if (r2.y != 0)
        {
            r1.w = (int)r1.w & 8;
            r9.xy = r1.ww ? cb13[3].xy : float2(1, 0);
            r1.w = dot(cb13[0].xyz, r3.xyz);
            r2.y = saturate(r1.w);
            r3.w = r2.y + r9.y;
            r3.w = r3.w + r1.y;
            r3.w = cmp(0 < r3.w);
            if (r3.w != 0)
            {
                r3.w = r1.w * r9.x + r9.y;
                r9.xyz = saturate(r3.www);
                r5.xyz = r5.xyz * r1.xxx + cb13[0].xyz;
                r1.x = dot(r5.xyz, r5.xyz);
                r1.x = rsqrt(r1.x);
                r5.xyz = r5.xyz * r1.xxx;
                r1.x = dot(r5.xyz, r6.xyz);
                r1.x = 1 + -abs(r1.x);
                r1.x = max(0, r1.x);
                r3.w = r1.x * r1.x;
                r3.w = r3.w * r3.w;
                r1.x = r3.w * r1.x;
                r3.w = 1 + -r2.w;
                r10.xyz = float3(1, 1, 1) + -r8.xyz;
                r11.xyz = max(float3(0, 0, 0), r10.xyz);
                r11.xyz = cb13[56].xxx * r11.xyz;
                r11.xyz = r11.xyz * r1.xxx;
                r1.x = 1 + cb13[56].z;
                r1.x = -cb13[56].z * r3.w + r1.x;
                r11.xyz = r11.xyz / r1.xxx;
                r11.xyz = r11.xyz + r8.xyz;
                r12.xyz = float3(1, 1, 1) + -r11.xyz;
                r12.xyz = r12.xyz * r9.zzz;
                r12.xyz = float3(0.318309873, 0.318309873, 0.318309873) * r12.xyz;
                r1.x = cmp(0 < r1.y);
                if (r1.x != 0)
                {
                    r1.x = 1 + r1.w;
                    r1.x = 0.5 * r1.x;
                    r3.w = dot(cb13[0].xyz, -r6.xyz);
                    r3.w = 1 + r3.w;
                    r3.w = 0.5 * r3.w;
                    r4.w = dot(r3.xyz, -r6.xyz);
                    r4.w = 1 + r4.w;
                    r4.w = cb12[36].w * r4.w;
                    r3.w = r3.w * r3.w;
                    r4.w = 0.5 * r4.w;
                    r3.w = r3.w * r3.w + -r1.x;
                    r1.x = cb12[36].x * r3.w + r1.x;
                    r1.x = r4.w * r1.x;
                    r3.w = cb12[36].y * r1.y;
                    r10.xyz = cb12[36].zzz * r10.xyz + -r12.xyz;
                    r10.xyz = r3.www * r10.xyz + r12.xyz;
                    r12.xyz = r1.xxx * r1.yyy + r10.xyz;
                }
                r10.xy = -cb12[0].xy + r4.xy;
                r1.x = dot(r10.xy, r10.xy);
                r1.x = sqrt(r1.x);
                r3.w = saturate(r4.z * cb12[218].z + cb12[218].w);
                r10.xyz = -cb13[52].xyz + cb13[51].xyz;
                r10.xyz = r3.www * r10.xyz + cb13[52].xyz;
                r1.x = saturate(r1.x * cb12[218].x + cb12[218].y);
                r10.xyz = -cb13[1].xyz + r10.xyz;
                r10.xyz = r1.xxx * r10.xyz + cb13[1].xyz;
                r12.xyz = r12.xyz * r7.yyy;
                r12.xyz = r12.xyz * r10.xyz;
                r1.x = cmp(0 < r1.w);
                if (r1.x != 0)
                {
                    r1.x = saturate(dot(r3.xyz, r5.xyz));
                    r1.w = dot(r3.xyz, r6.xyz);
                    r3.w = r2.w * r2.w;
                    r4.w = r3.w * r3.w;
                    r1.x = r1.x * r1.x;
                    r3.w = r3.w * r3.w + -1;
                    r1.x = r1.x * r3.w + 1;
                    r1.x = r1.x * r1.x;
                    r1.x = 3.14152002 * r1.x;
                    r1.x = r4.w / r1.x;
                    r3.w = 1 + r2.w;
                    r3.w = r3.w * r3.w;
                    r4.w = 0.125 * r3.w;
                    r3.w = -r3.w * 0.125 + 1;
                    r5.x = r2.y * r3.w + r4.w;
                    r5.x = r2.y / r5.x;
                    r3.w = abs(r1.w) * r3.w + r4.w;
                    r3.w = abs(r1.w) / r3.w;
                    r3.w = r5.x * r3.w;
                    r1.x = r3.w * r1.x;
                    r5.xyz = r1.xxx * r11.xyz;
                    r1.x = r2.y * abs(r1.w);
                    r1.x = 4 * r1.x;
                    r5.xyz = r5.xyz / r1.xxx;
                    r5.xyz = r5.xyz * r2.yyy;
                }
                else
                {
                    r5.xyz = float3(0, 0, 0);
                }
                r5.xyz = r7.yyy * r5.xyz;
                r5.xyz = r5.xyz * r10.xyz;
            }
            else
            {
                r9.xyz = float3(0, 0, 0);
                r12.xyz = float3(0, 0, 0);
                r5.xyz = float3(0, 0, 0);
            }
        }
        else
        {
            r9.xyz = float3(0, 0, 0);
            r12.xyz = float3(0, 0, 0);
            r5.xyz = float3(0, 0, 0);
        }


         [branch]
        if (enable_pbr_lighting) 
        {
            r5.xyz = 0;
            float3 l = cb13[0].xyz;
            float n_dot_l = dot(normal, l);
            float3 half_vector = normalize(l + v.xyz);
            float n_dot_v = max(0, dot(normal, v));
            float l_dot_h = max(0, dot(l, half_vector));
            float l_dot_v = dot(l, v);
            float3 F90 = min(1, F0 * 50);
            if (0 < dot(normal, l) && shadow_factor > 0 && n_dot_v >= 0)
            {
                float NDF = _DistributionGGX(normal, half_vector, roughness);
                float G = _GeometrySmith(normal, v, l.xyz, roughness);

                float3 F = FresnelSchlick(max(dot(half_vector, v), 0.0), F0, F90);

                float3 numerator = NDF * G * F;
                float denominator = 4.0 * max(dot(normal, v) * n_dot_l, 0.00001);
                r5.xyz = numerator / denominator;
            }
            float3 specular_direct = r5.xyz;

            // tone down specular under water
            specular_direct *= 0.1 + 0.9 * smoothstep(0, -0.1, water_depth);

            float4 albedo_translucency = albedo_translucency_texture.Load(r0.xyz).xyzw;
            float3 albedo = pow(albedo_translucency.xyz, 2.2);

        
            if (n_dot_l > 0)
            {
                float3 diffuse_direct = Fr_DisneyDiffuse(n_dot_v, n_dot_l, l_dot_h, Square(roughness));
                diffuse_direct = lerp(1, diffuse_direct, F90);
                diffuse_direct *= albedo * PI_RCP;

                direct = (diffuse_direct + specular_direct) * cb13[1].rgb * shadow_factor * n_dot_l;
            }
            float translucency = albedo_translucency.w;
            if (translucency > 0 && n_dot_l < 0)
            {
                float3 sss = cb13[1].rgb * shadow_factor * (HenyeyGreensteinPhase(0.4, dot(l, -v)) + HenyeyGreensteinPhase(0.1, dot(l, -v)));
                sss *= translucency * albedo;
                sss *= (1 - FresnelSchlick(max(dot(-normal, l), 0.0), F0, F90));
                direct += sss * 2 * shadow_factor;
            }
        }

        r9.xyz = min(r9.xyz, r7.yyy);
        r1.xw = -cb12[0].xy + r4.xy;
        r1.x = dot(r1.xw, r1.xw);
        r1.x = sqrt(r1.x);
        r1.x = saturate(r1.x * cb12[218].x + cb12[218].y);
        r1.w = -1 + cb12[184].z;
        r1.x = r1.x * r1.w + 1;
        r1.w = cb12[183].x + -cb12[183].y;
        r10.xyz = r9.xyz * r1.www + cb12[183].yyy;
        r10.xyz = r10.xyz * r1.xxx;
        r1.w = cb12[184].x + -cb12[184].y;
        r11.xyz = r9.xyz * r1.www + cb12[184].yyy;
        r11.xyz = r11.xyz * r1.xxx;
        r13.xyzw = (int4)r0.xyxy + int4(0, 1, 1, 0);
        r14.xy = r13.zw;
        r14.zw = float2(0, 0);
        r14.xyz = normal_roughness_texture.Load(r14.xyz).xyz;
        r13.zw = float2(0, 0);
        r13.xyz = normal_roughness_texture.Load(r13.xyz).xyz;
        r14.xyz = float3(-0.5, -0.5, -0.5) + r14.xyz;
        r1.x = dot(r14.xyz, r14.xyz);
        r1.x = rsqrt(r1.x);
        r14.xyz = r14.xyz * r1.xxx;
        r13.xyz = float3(-0.5, -0.5, -0.5) + r13.xyz;
        r1.x = dot(r13.xyz, r13.xyz);
        r1.x = rsqrt(r1.x);
        r13.xyz = r13.xyz * r1.xxx;
        r1.x = dot(r3.xyz, r14.xyz);
        r1.w = dot(r3.xyz, r13.xyz);
        r1.x = min(r1.x, r1.w);
        r1.w = 1 + -abs(r1.x);
        r1.w = sqrt(r1.w);
        r2.y = abs(r1.x) * -0.0187292993 + 0.0742610022;
        r2.y = r2.y * abs(r1.x) + -0.212114394;
        r2.y = r2.y * abs(r1.x) + 1.57072878;
        r3.w = r2.y * r1.w;
        r3.w = r3.w * -2 + 3.14159274;
        r1.x = cmp(r1.x < -r1.x);
        r1.x = r1.x ? r3.w : 0;
        r1.x = r2.y * r1.w + r1.x;
        r1.x = 81.4873276 * r1.x;
        r1.x = log2(r1.x);
        r1.w = dot(-r6.xyz, r3.xyz);
        r1.w = r1.w + r1.w;
        r13.xyz = r3.xyz * -r1.www + -r6.xyz;
        r1.w = r2.w * r2.w;
        r1.xw = float2(0.625, 10.5) * r1.xw;
        r1.x = max(r1.w, r1.x);
        r1.w = cmp(r3.z < 0);
        r2.y = r1.w ? 1.000000 : 0;
        r14.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r3.xyxy;
        r3.w = -r2.z * r1.z + 1;
        r3.w = max(0.00100000005, r3.w);
        r14.xy = r14.xy / r3.ww;
        r1.z = r2.z * r1.z + 1;
        r1.z = max(0.00100000005, r1.z);
        r14.zw = r14.zw / r1.zz;
        r14.xyzw = float4(0.5, 0.5, 0.5, 0.5) + r14.xyzw;
        r1.zw = r1.ww ? r14.xy : r14.zw;
        r1.zw = r1.zw * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
        r14.x = (int)r2.y;
        r14.y = 0;
        r1.zw = r14.xy + r1.zw;
        r14.xy = float2(0.5, 0.142857149) * r1.zw;
        r15.xyz = cb12[114].xyz * r4.yyy;
        r15.xyz = cb12[113].xyz * r4.xxx + r15.xyz;
        r15.xyz = cb12[115].xyz * r4.zzz + r15.xyz;
        r15.xyz = cb12[116].xyz + r15.xyz;
        r15.xyz = float3(1, 1, 1) + -abs(r15.xyz);
        r1.z = cmp(r7.z != -1.000000);
        if (r1.z != 0)
        {
            r2.yz = asint(cb12[117].yy) & int2(1, 2);
            r1.w = r2.y ? 1 : r7.z;
            r2.y = 1 + -r7.z;
            r2.y = r2.z ? 1 : r2.y;
            r1.w = r2.y * r1.w;
        }
        else
        {
            r1.w = 1;
        }
        r16.xyz = cmp(float3(0, 0, 0) < r15.xyz);
        r2.y = r16.y ? r16.x : 0;
        r2.y = r16.z ? r2.y : 0;
        r2.z = cmp(0 < r1.w);
        r2.y = r2.z ? r2.y : 0;
        if (r2.y != 0)
        {
            r15.xyz = saturate(cb12[112].xyz * r15.xyz);
            r1.w = cb12[111].x * r1.w;
            r1.w = 0.999989986 * r1.w;
            r2.y = r15.x * r15.y;
            r2.y = r2.y * r15.z;
            r2.z = r2.y * r1.w;
            r1.w = r1.w * r2.y + 9.99999975e-006;
            r2.y = cb12[117].x * r2.z;
            r2.z = asint(cb12[122].x);
            r14.z = r2.z * 0.142857149 + r14.y;
            r15.xyz = t6.SampleLevel(s6_s, r14.xz, 0).xyz;
            r15.xyz = r15.xyz * r2.yyy;
            r16.xyz = cb12[119].xyz * r13.yyy;
            r16.xyz = cb12[118].xyz * r13.xxx + r16.xyz;
            r16.xyz = cb12[120].xyz * r13.zzz + r16.xyz;
            r17.xyz = cb12[119].xyz * r4.yyy;
            r17.xyz = cb12[118].xyz * r4.xxx + r17.xyz;
            r17.xyz = cb12[120].xyz * r4.zzz + r17.xyz;
            r17.xyz = cb12[121].xyz + r17.xyz;
            r16.xyz = float3(1, 1, 1) / r16.xyz;
            r18.xyz = -r17.xyz * r16.xyz + r16.xyz;
            r16.xyz = -r17.xyz * r16.xyz + -r16.xyz;
            r16.xyz = max(r18.xyz, r16.xyz);
            r2.z = min(r16.y, r16.z);
            r2.z = min(r16.x, r2.z);
            r16.xyz = r13.xyz * r2.zzz + r4.xyz;
            r16.xyz = -cb12[111].yzw + r16.xyz;
            r2.z = dot(r16.xyz, r16.xyz);
            r2.z = rsqrt(r2.z);
            r16.xyw = r16.xyz * r2.zzz;
            r3.w = cmp(r16.w < 0);
            r4.w = r3.w ? 1.000000 : 0;
            r17.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r16.xyxy;
            r5.w = -r16.z * r2.z + 1;
            r5.w = max(0.00100000005, r5.w);
            r16.xy = r17.xy / r5.ww;
            r2.z = r16.z * r2.z + 1;
            r2.z = max(0.00100000005, r2.z);
            r16.zw = r17.zw / r2.zz;
            r16.xyzw = float4(0.5, 0.5, 0.5, 0.5) + r16.xyzw;
            r16.xy = r3.ww ? r16.xy : r16.zw;
            r16.xy = r16.xy * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
            r17.y = asint(cb12[122].x);
            r17.z = (int)r4.w;
            r17.xw = float2(0, 0);
            r16.xy = r17.zw + r16.xy;
            r16.xy = r17.xy + r16.xy;
            r16.xy = float2(0.5, 0.142857149) * r16.xy;
            r16.xyz = t7.SampleLevel(s6_s, r16.xy, r1.x).xyz;
            r16.xyz = r16.xyz * r2.yyy;
        }
        else
        {
            r15.xyz = float3(0, 0, 0);
            r16.xyz = float3(0, 0, 0);
            r1.w = 9.99999975e-006;
        }
        r2.y = cmp(r1.w < 0.999000013);
        if (r2.y != 0)
        {
            r17.xyz = cb12[126].xyz * r4.yyy;
            r17.xyz = cb12[125].xyz * r4.xxx + r17.xyz;
            r17.xyz = cb12[127].xyz * r4.zzz + r17.xyz;
            r17.xyz = cb12[128].xyz + r17.xyz;
            r17.xyz = float3(1, 1, 1) + -abs(r17.xyz);
            if (r1.z != 0)
            {
                r18.xy = asint(cb12[129].yy) & int2(1, 2);
                r2.z = r18.x ? 1 : r7.z;
                r3.w = 1 + -r7.z;
                r3.w = r18.y ? 1 : r3.w;
                r2.z = r3.w * r2.z;
            }
            else
            {
                r2.z = 1;
            }
            r18.xyz = cmp(float3(0, 0, 0) < r17.xyz);
            r3.w = r18.y ? r18.x : 0;
            r3.w = r18.z ? r3.w : 0;
            r4.w = cmp(0 < r2.z);
            r3.w = r4.w ? r3.w : 0;
            if (r3.w != 0)
            {
                r17.xyz = saturate(cb12[124].xyz * r17.xyz);
                r3.w = 1 + -r1.w;
                r2.z = r3.w * r2.z;
                r2.z = cb12[123].x * r2.z;
                r3.w = r17.x * r17.y;
                r3.w = r3.w * r17.z;
                r4.w = r3.w * r2.z;
                r1.w = r2.z * r3.w + r1.w;
                r2.z = cb12[129].x * r4.w;
                r3.w = asint(cb12[134].x);
                r14.w = r3.w * 0.142857149 + r14.y;
                r17.xyz = t6.SampleLevel(s6_s, r14.xw, 0).xyz;
                r15.xyz = r2.zzz * r17.xyz + r15.xyz;
                r17.xyz = cb12[131].xyz * r13.yyy;
                r17.xyz = cb12[130].xyz * r13.xxx + r17.xyz;
                r17.xyz = cb12[132].xyz * r13.zzz + r17.xyz;
                r18.xyz = cb12[131].xyz * r4.yyy;
                r18.xyz = cb12[130].xyz * r4.xxx + r18.xyz;
                r18.xyz = cb12[132].xyz * r4.zzz + r18.xyz;
                r18.xyz = cb12[133].xyz + r18.xyz;
                r17.xyz = float3(1, 1, 1) / r17.xyz;
                r19.xyz = -r18.xyz * r17.xyz + r17.xyz;
                r17.xyz = -r18.xyz * r17.xyz + -r17.xyz;
                r17.xyz = max(r19.xyz, r17.xyz);
                r3.w = min(r17.y, r17.z);
                r3.w = min(r17.x, r3.w);
                r17.xyz = r13.xyz * r3.www + r4.xyz;
                r17.xyz = -cb12[123].yzw + r17.xyz;
                r3.w = dot(r17.xyz, r17.xyz);
                r3.w = rsqrt(r3.w);
                r17.xyw = r17.xyz * r3.www;
                r4.w = cmp(r17.w < 0);
                r5.w = r4.w ? 1.000000 : 0;
                r18.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r17.xyxy;
                r6.w = -r17.z * r3.w + 1;
                r6.w = max(0.00100000005, r6.w);
                r14.zw = r18.xy / r6.ww;
                r14.zw = float2(0.5, 0.5) + r14.zw;
                r3.w = r17.z * r3.w + 1;
                r3.w = max(0.00100000005, r3.w);
                r17.xy = r18.zw / r3.ww;
                r17.xy = float2(0.5, 0.5) + r17.xy;
                r14.zw = r4.ww ? r14.zw : r17.xy;
                r14.zw = r14.zw * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
                r17.y = asint(cb12[134].x);
                r17.z = (int)r5.w;
                r17.xw = float2(0, 0);
                r14.zw = r17.zw + r14.zw;
                r14.zw = r17.xy + r14.zw;
                r14.zw = float2(0.5, 0.142857149) * r14.zw;
                r17.xyz = t7.SampleLevel(s6_s, r14.zw, r1.x).xyz;
                r16.xyz = r2.zzz * r17.xyz + r16.xyz;
            }
        }
        r2.z = cmp(r1.w < 0.999000013);
        r2.y = r2.z ? r2.y : 0;
        if (r2.y != 0)
        {
            r17.xyz = cb12[138].xyz * r4.yyy;
            r17.xyz = cb12[137].xyz * r4.xxx + r17.xyz;
            r17.xyz = cb12[139].xyz * r4.zzz + r17.xyz;
            r17.xyz = cb12[140].xyz + r17.xyz;
            r17.xyz = float3(1, 1, 1) + -abs(r17.xyz);
            if (r1.z != 0)
            {
                r14.zw = asint(cb12[141].yy) & int2(1, 2);
                r2.z = r14.z ? 1 : r7.z;
                r3.w = 1 + -r7.z;
                r3.w = r14.w ? 1 : r3.w;
                r2.z = r3.w * r2.z;
            }
            else
            {
                r2.z = 1;
            }
            r18.xyz = cmp(float3(0, 0, 0) < r17.xyz);
            r3.w = r18.y ? r18.x : 0;
            r3.w = r18.z ? r3.w : 0;
            r4.w = cmp(0 < r2.z);
            r3.w = r4.w ? r3.w : 0;
            if (r3.w != 0)
            {
                r17.xyz = saturate(cb12[136].xyz * r17.xyz);
                r3.w = 1 + -r1.w;
                r2.z = r3.w * r2.z;
                r2.z = cb12[135].x * r2.z;
                r3.w = r17.x * r17.y;
                r3.w = r3.w * r17.z;
                r4.w = r3.w * r2.z;
                r1.w = r2.z * r3.w + r1.w;
                r2.z = cb12[141].x * r4.w;
                r3.w = asint(cb12[146].x);
                r17.y = r3.w * 0.142857149 + r14.y;
                r17.x = r14.x;
                r17.xyz = t6.SampleLevel(s6_s, r17.xy, 0).xyz;
                r15.xyz = r2.zzz * r17.xyz + r15.xyz;
                r17.xyz = cb12[143].xyz * r13.yyy;
                r17.xyz = cb12[142].xyz * r13.xxx + r17.xyz;
                r17.xyz = cb12[144].xyz * r13.zzz + r17.xyz;
                r18.xyz = cb12[143].xyz * r4.yyy;
                r18.xyz = cb12[142].xyz * r4.xxx + r18.xyz;
                r18.xyz = cb12[144].xyz * r4.zzz + r18.xyz;
                r18.xyz = cb12[145].xyz + r18.xyz;
                r17.xyz = float3(1, 1, 1) / r17.xyz;
                r19.xyz = -r18.xyz * r17.xyz + r17.xyz;
                r17.xyz = -r18.xyz * r17.xyz + -r17.xyz;
                r17.xyz = max(r19.xyz, r17.xyz);
                r3.w = min(r17.y, r17.z);
                r3.w = min(r17.x, r3.w);
                r17.xyz = r13.xyz * r3.www + r4.xyz;
                r17.xyz = -cb12[135].yzw + r17.xyz;
                r3.w = dot(r17.xyz, r17.xyz);
                r3.w = rsqrt(r3.w);
                r17.xyw = r17.xyz * r3.www;
                r4.w = cmp(r17.w < 0);
                r5.w = r4.w ? 1.000000 : 0;
                r18.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r17.xyxy;
                r6.w = -r17.z * r3.w + 1;
                r6.w = max(0.00100000005, r6.w);
                r14.zw = r18.xy / r6.ww;
                r14.zw = float2(0.5, 0.5) + r14.zw;
                r3.w = r17.z * r3.w + 1;
                r3.w = max(0.00100000005, r3.w);
                r17.xy = r18.zw / r3.ww;
                r17.xy = float2(0.5, 0.5) + r17.xy;
                r14.zw = r4.ww ? r14.zw : r17.xy;
                r14.zw = r14.zw * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
                r17.y = asint(cb12[146].x);
                r17.z = (int)r5.w;
                r17.xw = float2(0, 0);
                r14.zw = r17.zw + r14.zw;
                r14.zw = r17.xy + r14.zw;
                r14.zw = float2(0.5, 0.142857149) * r14.zw;
                r17.xyz = t7.SampleLevel(s6_s, r14.zw, r1.x).xyz;
                r16.xyz = r2.zzz * r17.xyz + r16.xyz;
            }
        }
        r2.z = cmp(r1.w < 0.999000013);
        r2.y = r2.z ? r2.y : 0;
        if (r2.y != 0)
        {
            r17.xyz = cb12[150].xyz * r4.yyy;
            r17.xyz = cb12[149].xyz * r4.xxx + r17.xyz;
            r17.xyz = cb12[151].xyz * r4.zzz + r17.xyz;
            r17.xyz = cb12[152].xyz + r17.xyz;
            r17.xyz = float3(1, 1, 1) + -abs(r17.xyz);
            if (r1.z != 0)
            {
                r14.zw = asint(cb12[153].yy) & int2(1, 2);
                r2.z = r14.z ? 1 : r7.z;
                r3.w = 1 + -r7.z;
                r3.w = r14.w ? 1 : r3.w;
                r2.z = r3.w * r2.z;
            }
            else
            {
                r2.z = 1;
            }
            r18.xyz = cmp(float3(0, 0, 0) < r17.xyz);
            r3.w = r18.y ? r18.x : 0;
            r3.w = r18.z ? r3.w : 0;
            r4.w = cmp(0 < r2.z);
            r3.w = r4.w ? r3.w : 0;
            if (r3.w != 0)
            {
                r17.xyz = saturate(cb12[148].xyz * r17.xyz);
                r3.w = 1 + -r1.w;
                r2.z = r3.w * r2.z;
                r2.z = cb12[147].x * r2.z;
                r3.w = r17.x * r17.y;
                r3.w = r3.w * r17.z;
                r4.w = r3.w * r2.z;
                r1.w = r2.z * r3.w + r1.w;
                r2.z = cb12[153].x * r4.w;
                r3.w = asint(cb12[158].x);
                r17.y = r3.w * 0.142857149 + r14.y;
                r17.x = r14.x;
                r17.xyz = t6.SampleLevel(s6_s, r17.xy, 0).xyz;
                r15.xyz = r2.zzz * r17.xyz + r15.xyz;
                r17.xyz = cb12[155].xyz * r13.yyy;
                r17.xyz = cb12[154].xyz * r13.xxx + r17.xyz;
                r17.xyz = cb12[156].xyz * r13.zzz + r17.xyz;
                r18.xyz = cb12[155].xyz * r4.yyy;
                r18.xyz = cb12[154].xyz * r4.xxx + r18.xyz;
                r18.xyz = cb12[156].xyz * r4.zzz + r18.xyz;
                r18.xyz = cb12[157].xyz + r18.xyz;
                r17.xyz = float3(1, 1, 1) / r17.xyz;
                r19.xyz = -r18.xyz * r17.xyz + r17.xyz;
                r17.xyz = -r18.xyz * r17.xyz + -r17.xyz;
                r17.xyz = max(r19.xyz, r17.xyz);
                r3.w = min(r17.y, r17.z);
                r3.w = min(r17.x, r3.w);
                r17.xyz = r13.xyz * r3.www + r4.xyz;
                r17.xyz = -cb12[147].yzw + r17.xyz;
                r3.w = dot(r17.xyz, r17.xyz);
                r3.w = rsqrt(r3.w);
                r17.xyw = r17.xyz * r3.www;
                r4.w = cmp(r17.w < 0);
                r5.w = r4.w ? 1.000000 : 0;
                r18.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r17.xyxy;
                r6.w = -r17.z * r3.w + 1;
                r6.w = max(0.00100000005, r6.w);
                r14.zw = r18.xy / r6.ww;
                r14.zw = float2(0.5, 0.5) + r14.zw;
                r3.w = r17.z * r3.w + 1;
                r3.w = max(0.00100000005, r3.w);
                r17.xy = r18.zw / r3.ww;
                r17.xy = float2(0.5, 0.5) + r17.xy;
                r14.zw = r4.ww ? r14.zw : r17.xy;
                r14.zw = r14.zw * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
                r17.y = asint(cb12[158].x);
                r17.z = (int)r5.w;
                r17.xw = float2(0, 0);
                r14.zw = r17.zw + r14.zw;
                r14.zw = r17.xy + r14.zw;
                r14.zw = float2(0.5, 0.142857149) * r14.zw;
                r17.xyz = t7.SampleLevel(s6_s, r14.zw, r1.x).xyz;
                r16.xyz = r2.zzz * r17.xyz + r16.xyz;
            }
        }
        r2.z = cmp(r1.w < 0.999000013);
        r2.y = r2.z ? r2.y : 0;
        if (r2.y != 0)
        {
            r17.xyz = cb12[162].xyz * r4.yyy;
            r17.xyz = cb12[161].xyz * r4.xxx + r17.xyz;
            r17.xyz = cb12[163].xyz * r4.zzz + r17.xyz;
            r17.xyz = cb12[164].xyz + r17.xyz;
            r17.xyz = float3(1, 1, 1) + -abs(r17.xyz);
            if (r1.z != 0)
            {
                r14.zw = asint(cb12[165].yy) & int2(1, 2);
                r2.z = r14.z ? 1 : r7.z;
                r3.w = 1 + -r7.z;
                r3.w = r14.w ? 1 : r3.w;
                r2.z = r3.w * r2.z;
            }
            else
            {
                r2.z = 1;
            }
            r18.xyz = cmp(float3(0, 0, 0) < r17.xyz);
            r3.w = r18.y ? r18.x : 0;
            r3.w = r18.z ? r3.w : 0;
            r4.w = cmp(0 < r2.z);
            r3.w = r4.w ? r3.w : 0;
            if (r3.w != 0)
            {
                r17.xyz = saturate(cb12[160].xyz * r17.xyz);
                r3.w = 1 + -r1.w;
                r2.z = r3.w * r2.z;
                r2.z = cb12[159].x * r2.z;
                r3.w = r17.x * r17.y;
                r3.w = r3.w * r17.z;
                r4.w = r3.w * r2.z;
                r1.w = r2.z * r3.w + r1.w;
                r2.z = cb12[165].x * r4.w;
                r3.w = asint(cb12[170].x);
                r17.y = r3.w * 0.142857149 + r14.y;
                r17.x = r14.x;
                r17.xyz = t6.SampleLevel(s6_s, r17.xy, 0).xyz;
                r15.xyz = r2.zzz * r17.xyz + r15.xyz;
                r17.xyz = cb12[167].xyz * r13.yyy;
                r17.xyz = cb12[166].xyz * r13.xxx + r17.xyz;
                r17.xyz = cb12[168].xyz * r13.zzz + r17.xyz;
                r18.xyz = cb12[167].xyz * r4.yyy;
                r18.xyz = cb12[166].xyz * r4.xxx + r18.xyz;
                r18.xyz = cb12[168].xyz * r4.zzz + r18.xyz;
                r18.xyz = cb12[169].xyz + r18.xyz;
                r17.xyz = float3(1, 1, 1) / r17.xyz;
                r19.xyz = -r18.xyz * r17.xyz + r17.xyz;
                r17.xyz = -r18.xyz * r17.xyz + -r17.xyz;
                r17.xyz = max(r19.xyz, r17.xyz);
                r3.w = min(r17.y, r17.z);
                r3.w = min(r17.x, r3.w);
                r17.xyz = r13.xyz * r3.www + r4.xyz;
                r17.xyz = -cb12[159].yzw + r17.xyz;
                r3.w = dot(r17.xyz, r17.xyz);
                r3.w = rsqrt(r3.w);
                r17.xyw = r17.xyz * r3.www;
                r4.w = cmp(r17.w < 0);
                r5.w = r4.w ? 1.000000 : 0;
                r18.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r17.xyxy;
                r6.w = -r17.z * r3.w + 1;
                r6.w = max(0.00100000005, r6.w);
                r14.zw = r18.xy / r6.ww;
                r14.zw = float2(0.5, 0.5) + r14.zw;
                r3.w = r17.z * r3.w + 1;
                r3.w = max(0.00100000005, r3.w);
                r17.xy = r18.zw / r3.ww;
                r17.xy = float2(0.5, 0.5) + r17.xy;
                r14.zw = r4.ww ? r14.zw : r17.xy;
                r14.zw = r14.zw * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
                r17.y = asint(cb12[170].x);
                r17.z = (int)r5.w;
                r17.xw = float2(0, 0);
                r14.zw = r17.zw + r14.zw;
                r14.zw = r17.xy + r14.zw;
                r14.zw = float2(0.5, 0.142857149) * r14.zw;
                r17.xyz = t7.SampleLevel(s6_s, r14.zw, r1.x).xyz;
                r16.xyz = r2.zzz * r17.xyz + r16.xyz;
            }
        }
        r2.z = cmp(r1.w < 0.999000013);
        r2.y = r2.z ? r2.y : 0;
        if (r2.y != 0)
        {
            r17.xyz = cb12[174].xyz * r4.yyy;
            r17.xyz = cb12[173].xyz * r4.xxx + r17.xyz;
            r17.xyz = cb12[175].xyz * r4.zzz + r17.xyz;
            r17.xyz = cb12[176].xyz + r17.xyz;
            r17.xyz = float3(1, 1, 1) + -abs(r17.xyz);
            if (r1.z != 0)
            {
                r2.yz = asint(cb12[177].yy) & int2(1, 2);
                r1.z = r2.y ? 1 : r7.z;
                r2.y = 1 + -r7.z;
                r2.y = r2.z ? 1 : r2.y;
                r1.z = r2.y * r1.z;
            }
            else
            {
                r1.z = 1;
            }
            r18.xyz = cmp(float3(0, 0, 0) < r17.xyz);
            r2.y = r18.y ? r18.x : 0;
            r2.y = r18.z ? r2.y : 0;
            r2.z = cmp(0 < r1.z);
            r2.y = r2.z ? r2.y : 0;
            if (r2.y != 0)
            {
                r17.xyz = saturate(cb12[172].xyz * r17.xyz);
                r2.y = 1 + -r1.w;
                r1.z = r2.y * r1.z;
                r1.z = cb12[171].x * r1.z;
                r2.y = r17.x * r17.y;
                r2.y = r2.y * r17.z;
                r2.z = r2.y * r1.z;
                r1.w = r1.z * r2.y + r1.w;
                r1.z = cb12[177].x * r2.z;
                r2.y = asint(cb12[182].x);
                r17.y = r2.y * 0.142857149 + r14.y;
                r17.x = r14.x;
                r17.xyz = t6.SampleLevel(s6_s, r17.xy, 0).xyz;
                r15.xyz = r1.zzz * r17.xyz + r15.xyz;
                r17.xyz = cb12[179].xyz * r13.yyy;
                r17.xyz = cb12[178].xyz * r13.xxx + r17.xyz;
                r17.xyz = cb12[180].xyz * r13.zzz + r17.xyz;
                r18.xyz = cb12[179].xyz * r4.yyy;
                r18.xyz = cb12[178].xyz * r4.xxx + r18.xyz;
                r18.xyz = cb12[180].xyz * r4.zzz + r18.xyz;
                r18.xyz = cb12[181].xyz + r18.xyz;
                r17.xyz = float3(1, 1, 1) / r17.xyz;
                r19.xyz = -r18.xyz * r17.xyz + r17.xyz;
                r17.xyz = -r18.xyz * r17.xyz + -r17.xyz;
                r17.xyz = max(r19.xyz, r17.xyz);
                r2.y = min(r17.y, r17.z);
                r2.y = min(r17.x, r2.y);
                r4.xyz = r13.xyz * r2.yyy + r4.xyz;
                r4.xyz = -cb12[171].yzw + r4.xyz;
                r2.y = dot(r4.xyz, r4.xyz);
                r2.y = rsqrt(r2.y);
                r4.xyw = r4.xyz * r2.yyy;
                r2.z = cmp(r4.w < 0);
                r3.w = r2.z ? 1.000000 : 0;
                r17.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r4.xyxy;
                r4.x = -r4.z * r2.y + 1;
                r4.x = max(0.00100000005, r4.x);
                r4.xy = r17.xy / r4.xx;
                r2.y = r4.z * r2.y + 1;
                r2.y = max(0.00100000005, r2.y);
                r4.zw = r17.zw / r2.yy;
                r4.xyzw = float4(0.5, 0.5, 0.5, 0.5) + r4.xyzw;
                r2.yz = r2.zz ? r4.xy : r4.zw;
                r2.yz = r2.yz * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
                r4.y = asint(cb12[182].x);
                r4.z = (int)r3.w;
                r4.xw = float2(0, 0);
                r2.yz = r4.zw + r2.yz;
                r2.yz = r4.xy + r2.yz;
                r2.yz = float2(0.5, 0.142857149) * r2.yz;
                r4.xyz = t7.SampleLevel(s6_s, r2.yz, r1.x).xyz;
                r16.xyz = r1.zzz * r4.xyz + r16.xyz;
            }
        }
        r1.z = cmp(r1.w < 0.999000013);
        if (r1.z != 0)
        {
            r1.z = 1 + -r1.w;
            r2.y = cb12[99].x * r1.z;
            r1.w = r1.z * cb12[99].x + r1.w;
            r1.z = cb12[105].x * r2.y;
            r2.y = asint(cb12[110].x);
            r14.y = r2.y * 0.142857149 + r14.y;
            r4.xyz = t6.SampleLevel(s6_s, r14.xy, 0).xyz;
            r15.xyz = r1.zzz * r4.xyz + r15.xyz;
            r2.y = cmp(r13.z < 0);
            r2.z = r2.y ? 1.000000 : 0;
            r4.xyzw = float4(0.5, -0.5, -0.5, 0.5) * r13.xyxy;
            r3.w = 1 + -r13.z;
            r3.w = max(0.00100000005, r3.w);
            r4.xy = r4.xy / r3.ww;
            r3.w = 1 + r13.z;
            r3.w = max(0.00100000005, r3.w);
            r4.zw = r4.zw / r3.ww;
            r4.xyzw = float4(0.5, 0.5, 0.5, 0.5) + r4.xyzw;
            r4.xy = r2.yy ? r4.xy : r4.zw;
            r4.xy = r4.xy * float2(0.666666627, 0.666666627) + float2(0.166666672, 0.166666672);
            r13.y = asint(cb12[110].x);
            r13.z = (int)r2.z;
            r13.xw = float2(0, 0);
            r2.yz = r13.zw + r4.xy;
            r2.yz = r13.xy + r2.yz;
            r2.yz = float2(0.5, 0.142857149) * r2.yz;
            r4.xyz = t7.SampleLevel(s6_s, r2.yz, r1.x).xyz;
            r16.xyz = r1.zzz * r4.xyz + r16.xyz;
        }
        r1.x = 1 / r1.w;
        r4.xyz = r15.xyz * r1.xxx;
        r1.xzw = r16.xyz * r1.xxx;
        r2.y = stencil_texture.Load(r0.xyw).y;
        r2.y = (int)r2.y & 2;
        r7.yz = cb13[54].xz + -cb13[54].yw;
        r13.xyz = r9.xyz * r7.yyy + cb13[54].yyy;
        r9.xyz = r9.xyz * r7.zzz + cb13[54].www;
        r13.xyz = r13.xyz * r4.xyz;
        r9.xyz = r9.xyz * r1.xzw;
        r4.xyz = r2.yyy ? r13.xyz : r4.xyz;
        r1.xzw = r2.yyy ? r9.xyz : r1.xzw;
        r9.xyz = cb12[183].zzz * r12.xyz;
        r5.xyz = cb12[183].www * r5.xyz;
        r4.xyz = r10.xyz * r4.xyz;
        r2.y = dot(r3.xyz, r6.xyz);
        r2.y = max(abs(r2.y), abs(r2.y));
        r2.y = 1 + -r2.y;
        r2.y = max(0, r2.y);
        r2.z = r2.y * r2.y;
        r2.z = r2.z * r2.z;
        r2.y = r2.z * r2.y;
        r2.z = 1 + -r2.w;
        r2.x = min(cb13[56].y, r2.x);
        r3.xyz = float3(1, 1, 1) + -r8.xyz;
        r3.xyz = max(float3(0, 0, 0), r3.xyz);
        r3.xyz = r3.xyz * r2.xxx;
        r2.xyw = r3.xyz * r2.yyy;
        r3.x = 1 + cb13[56].w;
        r2.z = -cb13[56].w * r2.z + r3.x;
        r2.xyz = r2.xyw / r2.zzz;
        r2.xyz = r8.xyz + r2.xyz;
        r3.xyz = float3(1, 1, 1) + -r2.xyz;
        r3.xyz = r4.xyz * r3.xyz;
        r1.xzw = r11.xyz * r1.xzw;
        r1.xzw = r1.xzw * r2.xyz;
        r2.xyz = saturate(r7.xxx * cb12[186].xyz + cb12[187].xyz);
        r2.w = -1 + cb12[69].z;
        r1.y = r1.y * r2.w + 1;
        r2.xyz = float3(-1, -1, -1) + r2.xyz;
        r2.xyz = r1.yyy * r2.xyz + float3(1, 1, 1);
        r4.xyz = r7.www * r2.xyz;
        r2.xyz = cb12[69].xxx * r2.xyz + cb12[69].yyy;
        r3.xyz = r4.xyz * r3.xyz;
        r1.xyz = r4.xyz * r1.xzw;
        r4.xyz = r9.xyz * r2.xyz;
        r2.xyz = r5.xyz * r2.xyz;

        // modify direct lighting
        float3 directional_light_scale = GetUnderwaterDirectionalLightScale(water_depth, world_position);
        r2.xyz *= directional_light_scale;
        r4.xyz *= directional_light_scale;
        direct *= directional_light_scale; 

        UnderwaterModifyAmbientLighting(water_depth, exterior_lighting_scale, r3.rgb, r1.rgb);
    }
    else
    {
        r3.xyz = float3(0, 0, 0);
        r4.xyz = float3(0, 0, 0);
        r2.xyz = float3(0, 0, 0);
        r1.xyz = float3(0, 0, 0);
    }

    [branch]
    if (enable_pbr_lighting) 
    {
        // remove direct light computed by the original shader
        r4.xyz = 0;
        r2.xyz = 0;
    }

    r5.xyz = albedo_translucency_texture.Load(r0.xyz).xyz;
    r5.xyz = log2(r5.xyz);
    r5.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r5.xyz;
    r5.xyz = exp2(r5.xyz);

    // reduce albedo to simulate wetness
    r5.rgb *= lerp(1, albedo_scale, smoothstep(-0.07, 0.03, water_depth));

    r3.xyz = r4.xyz + r3.xyz;
    r3.xyz = max(float3(0, 0, 0), r3.xyz);
    r1.xyz = r2.xyz + r1.xyz;
    r1.xyz = max(float3(0, 0, 0), r1.xyz);
    r1.xyz = r5.xyz * r3.xyz + r1.xyz;
    r1.w = 1;

    output[thread_id.xy] = r1.xyzw + float4(direct, 0);
}
