// FidelityFX Super Resolution Sample
//
// Copyright (c) 2021 Advanced Micro Devices, Inc. All rights reserved.
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files(the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions :
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#include "CustomData.hlsli"

Texture2D<float3> source : register(t0);

#define CAS_SHARPENING_SCALE sharpening

#define FSR_RCAS_LIMIT (0.25-(1.0/16.0))
#define FSR_RCAS_DENOISE

float AMax3H1(float a, float b, float c)
{
    return Max3(float3(a, b, c));
}

float AMin3H1(float a, float b, float c)
{
    return Min3(float3(a, b, c));
}

float3 RCAS(int2 pos)
{
    float3 e = source.Load(int3(pos, 0)).rgb;
    float3 d = source.Load(int3(pos + int2(-1, 0), 0)).rgb;
    float3 f = source.Load(int3(pos + int2(1, 0), 0)).rgb;
    float3 b = source.Load(int3(pos + int2(0, -1), 0)).rgb;
    float3 h = source.Load(int3(pos + int2(0, 1), 0)).rgb;

    float bR = b.r;
    float bG = b.g;
    float bB = b.b;
    float dR = d.r;
    float dG = d.g;
    float dB = d.b;
    float eR = e.r;
    float eG = e.g;
    float eB = e.b;
    float fR = f.r;
    float fG = f.g;
    float fB = f.b;
    float hR = h.r;
    float hG = h.g;
    float hB = h.b;

    float bL = bB * (0.5) + (bR * (0.5) + bG);
    float dL = dB * (0.5) + (dR * (0.5) + dG);
    float eL = eB * (0.5) + (eR * (0.5) + eG);
    float fL = fB * (0.5) + (fR * (0.5) + fG);
    float hL = hB * (0.5) + (hR * (0.5) + hG);
    // Noise detection.
    float nz = 0.25 * bL + 0.25 * dL + 0.25 * fL + 0.25 * hL - eL;
    nz = saturate(abs(nz) * rcp(AMax3H1(AMax3H1(bL, dL, eL), fL, hL) - AMin3H1(AMin3H1(bL, dL, eL), fL, hL)));
    nz = (-0.5) * nz + (1.0);
    // Min and max of ring.
    float mn4R = Min4(float4(bR, dR, fR, hR));
    float mn4G = Min4(float4(bG, dG, fG, hG));
    float mn4B = Min4(float4(bB, dB, fB, hB));
    float mx4R = Max4(float4(bR, dR, fR, hR));
    float mx4G = Max4(float4(bG, dG, fG, hG));
    float mx4B = Max4(float4(bB, dB, fB, hB));
    // Immediate constants for peak range.
    float2 peakC = float2(1.0, -1.0 * 4.0);
    // Limiters, these need to be high precision RCPs.
    float hitMinR = min(mn4R, eR) * rcp((4.0) * mx4R);
    float hitMinG = min(mn4G, eG) * rcp((4.0) * mx4G);
    float hitMinB = min(mn4B, eB) * rcp((4.0) * mx4B);
    float hitMaxR = (peakC.x - max(mx4R, eR)) * rcp((4.0) * mn4R + peakC.y);
    float hitMaxG = (peakC.x - max(mx4G, eG)) * rcp((4.0) * mn4G + peakC.y);
    float hitMaxB = (peakC.x - max(mx4B, eB)) * rcp((4.0) * mn4B + peakC.y);
    float lobeR = max(-hitMinR, hitMaxR);
    float lobeG = max(-hitMinG, hitMaxG);
    float lobeB = max(-hitMinB, hitMaxB);
    float lobe = max(-FSR_RCAS_LIMIT, min(Max3(float3(lobeR, lobeG, lobeB)), 0.0)) * CAS_SHARPENING_SCALE;
    // Apply noise removal.
#ifdef FSR_RCAS_DENOISE
    lobe *= nz;
#endif
    // Resolve, which needs the medium precision rcp approximation to avoid visible tonality changes.
    float rcpL = rcp(4.0 * lobe + 1.0);
    float pixR = (lobe * bR + lobe * dR + lobe * hR + lobe * fR + eR) * rcpL;
    float pixG = (lobe * bG + lobe * dG + lobe * hG + lobe * fG + eG) * rcpL;
    float pixB = (lobe * bB + lobe * dB + lobe * hB + lobe * fB + eB) * rcpL;

    return float3(pixR, pixG, pixB);
}

void PSMain(float4 sv_position : SV_POSITION, out float3 output : SV_Target0)
{
    int2 pos = sv_position.xy;
    output = RCAS(pos);
}
