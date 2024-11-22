#ifndef NOISE_HLSLI
#define NOISE_HLSLI

#include "CustomData.hlsli"

#define GOLDEN_RATIO 1.61803398875

Texture2D<float4> _blue_noise : register(t69);

float4 GetStaticBlueNoise(int2 pixel_coord)
{
    return _blue_noise.Load(int3(pixel_coord & 255, 0));
}

float4 GetAnimatedBlueNoise(int2 pixel_coord)
{
    // https://blog.demofox.org/2017/10/31/animating-noise-for-integration-over-time/
    // http://blog.tuxedolabs.com/2018/12/07/the-importance-of-good-noise.html
    return frac(GetStaticBlueNoise(pixel_coord) + (frame_counter & 511) * GOLDEN_RATIO);
}

float4 GetAnimatedBlueNoiseRepeat(int2 pixel_coord, uint n)
{
    // https://blog.demofox.org/2017/10/31/animating-noise-for-integration-over-time/
    // http://blog.tuxedolabs.com/2018/12/07/the-importance-of-good-noise.html
    return frac(GetStaticBlueNoise(pixel_coord) + (frame_counter % n) * GOLDEN_RATIO);
}

float InterleavedGradientNoise(float2 position)
{
    float3 magic = float3(0.06711056, 0.00583715, 52.9829189);
    return frac(magic.z * frac(dot(position, magic.xy)));
}

float AnimatedInterleavedGradientNoise(float2 position)
{
    return frac(InterleavedGradientNoise(position) + (frame_counter & 127) * GOLDEN_RATIO);
}

// animated IGN that repeats itself every n frames
float AnimatedInterleavedGradientNoiseRepeat(float2 position, uint n)
{
    return frac(InterleavedGradientNoise(position) + (frame_counter % n) * GOLDEN_RATIO);
}


// Hash by David_Hoskins
#define UI0 1597334673U
#define UI1 3812015801U
#define UI2 uint2(UI0, UI1)
#define UI3 uint3(UI0, UI1, 2798796415U)
#define UIF (1.0 / float(0xffffffffU))

float3 Hash(float3 p)
{
    uint3 q = uint3(int3(p)) * UI3;
    q = (q.x ^ q.y ^ q.z) * UI3;
    return -1. + 2. * float3(q) * UIF;
}

// Gradient noise by Inigo Quilez

float GradientNoise(float3 x)
{
    // grid
    float3 p = floor(x);
    float3 w = frac(x);

    // quintic interpolant
    float3 u = w * w * w * (w * (w * 6.0 - 15.0) + 10.0);

    // gradients
    float3 ga = Hash(p + float3(0.0, 0.0, 0.0));
    float3 gb = Hash(p + float3(1.0, 0.0, 0.0));
    float3 gc = Hash(p + float3(0.0, 1.0, 0.0));
    float3 gd = Hash(p + float3(1.0, 1.0, 0.0));
    float3 ge = Hash(p + float3(0.0, 0.0, 1.0));
    float3 gf = Hash(p + float3(1.0, 0.0, 1.0));
    float3 gg = Hash(p + float3(0.0, 1.0, 1.0));
    float3 gh = Hash(p + float3(1.0, 1.0, 1.0));

    // projections
    float va = dot(ga, w - float3(0.0, 0.0, 0.0));
    float vb = dot(gb, w - float3(1.0, 0.0, 0.0));
    float vc = dot(gc, w - float3(0.0, 1.0, 0.0));
    float vd = dot(gd, w - float3(1.0, 1.0, 0.0));
    float ve = dot(ge, w - float3(0.0, 0.0, 1.0));
    float vf = dot(gf, w - float3(1.0, 0.0, 1.0));
    float vg = dot(gg, w - float3(0.0, 1.0, 1.0));
    float vh = dot(gh, w - float3(1.0, 1.0, 1.0));

    // interpolation
    return va +
        u.x * (vb - va) +
        u.y * (vc - va) +
        u.z * (ve - va) +
        u.x * u.y * (va - vb - vc + vd) +
        u.y * u.z * (va - vc - ve + vg) +
        u.z * u.x * (va - vb - ve + vf) +
        u.x * u.y * u.z * (-va + vb + vc - vd + ve - vf - vg + vh);
}

float TileableGradientNoise(float3 x, float frequency)
{
    // grid
    float3 p = floor(x);
    float3 w = frac(x);

    // quintic interpolant
    float3 u = w * w * w * (w * (w * 6.0 - 15.0) + 10.0);

    // gradients
    float3 ga = Hash((p + float3(0.0, 0.0, 0.0)) % frequency);
    float3 gb = Hash((p + float3(1.0, 0.0, 0.0)) % frequency);
    float3 gc = Hash((p + float3(0.0, 1.0, 0.0)) % frequency);
    float3 gd = Hash((p + float3(1.0, 1.0, 0.0)) % frequency);
    float3 ge = Hash((p + float3(0.0, 0.0, 1.0)) % frequency);
    float3 gf = Hash((p + float3(1.0, 0.0, 1.0)) % frequency);
    float3 gg = Hash((p + float3(0.0, 1.0, 1.0)) % frequency);
    float3 gh = Hash((p + float3(1.0, 1.0, 1.0)) % frequency);

    // projections
    float va = dot(ga, w - float3(0.0, 0.0, 0.0));
    float vb = dot(gb, w - float3(1.0, 0.0, 0.0));
    float vc = dot(gc, w - float3(0.0, 1.0, 0.0));
    float vd = dot(gd, w - float3(1.0, 1.0, 0.0));
    float ve = dot(ge, w - float3(0.0, 0.0, 1.0));
    float vf = dot(gf, w - float3(1.0, 0.0, 1.0));
    float vg = dot(gg, w - float3(0.0, 1.0, 1.0));
    float vh = dot(gh, w - float3(1.0, 1.0, 1.0));

    // interpolation
    return va +
        u.x * (vb - va) +
        u.y * (vc - va) +
        u.z * (ve - va) +
        u.x * u.y * (va - vb - vc + vd) +
        u.y * u.z * (va - vc - ve + vg) +
        u.z * u.x * (va - vb - ve + vf) +
        u.x * u.y * u.z * (-va + vb + vc - vd + ve - vf - vg + vh);
}

float3 TileableGradientNoiseDerivatives(float3 x, float frequency)
{
    // grid
    float3 p = floor(x);
    float3 w = frac(x);

    // quintic interpolant
    float3 u = w * w * w * (w * (w * 6.0 - 15.0) + 10.0);
    float3 du = 30.0 * w * w * (w * (w - 2.0) + 1.0);

    // gradients
    float3 ga = Hash((p + float3(0.0, 0.0, 0.0)) % frequency);
    float3 gb = Hash((p + float3(1.0, 0.0, 0.0)) % frequency);
    float3 gc = Hash((p + float3(0.0, 1.0, 0.0)) % frequency);
    float3 gd = Hash((p + float3(1.0, 1.0, 0.0)) % frequency);
    float3 ge = Hash((p + float3(0.0, 0.0, 1.0)) % frequency);
    float3 gf = Hash((p + float3(1.0, 0.0, 1.0)) % frequency);
    float3 gg = Hash((p + float3(0.0, 1.0, 1.0)) % frequency);
    float3 gh = Hash((p + float3(1.0, 1.0, 1.0)) % frequency);

    // projections
    float va = dot(ga, w - float3(0.0, 0.0, 0.0));
    float vb = dot(gb, w - float3(1.0, 0.0, 0.0));
    float vc = dot(gc, w - float3(0.0, 1.0, 0.0));
    float vd = dot(gd, w - float3(1.0, 1.0, 0.0));
    float ve = dot(ge, w - float3(0.0, 0.0, 1.0));
    float vf = dot(gf, w - float3(1.0, 0.0, 1.0));
    float vg = dot(gg, w - float3(0.0, 1.0, 1.0));
    float vh = dot(gh, w - float3(1.0, 1.0, 1.0));

    // interpolations
    return float3(
        ga + u.x * (gb - ga) + u.y * (gc - ga) + u.z * (ge - ga) + u.x * u.y * (ga - gb - gc + gd) + u.y * u.z * (ga - gc - ge + gg) + u.z *
        u.x * (ga - gb - ge + gf) + (-ga + gb + gc - gd + ge - gf - gg + gh) * u.x * u.y * u.z +
        du * (float3(vb, vc, ve) - va + u.yzx * float3(va - vb - vc + vd, va - vc - ve + vg, va - vb - ve + vf) + u.zxy * float3(
            va - vb - ve + vf, va - vb - vc + vd, va - vc - ve + vg) + u.yzx * u.zxy * (-va + vb + vc - vd + ve - vf - vg + vh)));
}

// simplex noise functions from https://gist.github.com/patriciogonzalezvivo/670c22f3966e662d2f83
float3 permute(float3 x)
{
    return (((x * 34.0) + 1.0) * x) % 289.0;
}

float SimplexNoise2D(float2 v)
{
    const float4 C = float4(0.211324865405187, 0.366025403784439,
                            -0.577350269189626, 0.024390243902439);
    float2 i = floor(v + dot(v, C.yy));
    float2 x0 = v - i + dot(i, C.xx);
    float2 i1;
    i1 = (x0.x > x0.y) ? float2(1.0, 0.0) : float2(0.0, 1.0);
    float4 x12 = x0.xyxy + C.xxzz;
    x12.xy -= i1;
    i = i % 289.0;
    float3 p = permute(permute(i.y + float3(0.0, i1.y, 1.0))
        + i.x + float3(0.0, i1.x, 1.0));
    float3 m = max(0.5 - float3(dot(x0, x0), dot(x12.xy, x12.xy),
                                dot(x12.zw, x12.zw)), 0.0);
    m = m * m;
    m = m * m;
    float3 x = 2.0 * frac(p * C.www) - 1.0;
    float3 h = abs(x) - 0.5;
    float3 ox = floor(x + 0.5);
    float3 a0 = x - ox;
    m *= 1.79284291400159 - 0.85373472095314 * (a0 * a0 + h * h);
    float3 g;
    g.x = a0.x * x0.x + h.x * x0.y;
    g.yz = a0.yz * x12.xz + h.yz * x12.yw;
    return 130.0 * dot(m, g);
}

//	Simplex 3D Noise 
//	by Ian McEwan, Ashima Arts
//
float4 permute(float4 x)
{
    return (((x * 34.0) + 1.0) * x) % 289.0;
}
float4 taylorInvSqrt(float4 r)
{
    return 1.79284291400159 - 0.85373472095314 * r;
}

float SimplexNoise3D(float3 v)
{
    const float2 C = float2(1.0 / 6.0, 1.0 / 3.0);
    const float4 D = float4(0.0, 0.5, 1.0, 2.0);

    // First corner
    float3 i = floor(v + dot(v, C.yyy));
    float3 x0 = v - i + dot(i, C.xxx);

    // Other corners
    float3 g = step(x0.yzx, x0.xyz);
    float3 l = 1.0 - g;
    float3 i1 = min(g.xyz, l.zxy);
    float3 i2 = max(g.xyz, l.zxy);

    //  x0 = x0 - 0. + 0.0 * C 
    float3 x1 = x0 - i1 + 1.0 * C.xxx;
    float3 x2 = x0 - i2 + 2.0 * C.xxx;
    float3 x3 = x0 - 1. + 3.0 * C.xxx;

    // Permutations
    i = i % 289.0;
    float4 p = permute(permute(permute(
                i.z + float4(0.0, i1.z, i2.z, 1.0))
            + i.y + float4(0.0, i1.y, i2.y, 1.0))
        + i.x + float4(0.0, i1.x, i2.x, 1.0));

    // Gradients
    // ( N*N points uniformly over a square, mapped onto an octahedron.)
    float n_ = 1.0 / 7.0; // N=7
    float3 ns = n_ * D.wyz - D.xzx;

    float4 j = p - 49.0 * floor(p * ns.z * ns.z); //  mod(p,N*N)

    float4 x_ = floor(j * ns.z);
    float4 y_ = floor(j - 7.0 * x_); // mod(j,N)

    float4 x = x_ * ns.x + ns.yyyy;
    float4 y = y_ * ns.x + ns.yyyy;
    float4 h = 1.0 - abs(x) - abs(y);

    float4 b0 = float4(x.xy, y.xy);
    float4 b1 = float4(x.zw, y.zw);

    float4 s0 = floor(b0) * 2.0 + 1.0;
    float4 s1 = floor(b1) * 2.0 + 1.0;
    float4 sh = -step(h, 0.0);

    float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
    float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;

    float3 p0 = float3(a0.xy, h.x);
    float3 p1 = float3(a0.zw, h.y);
    float3 p2 = float3(a1.xy, h.z);
    float3 p3 = float3(a1.zw, h.w);

    //Normalise gradients
    float4 norm = taylorInvSqrt(float4(dot(p0, p0), dot(p1, p1), dot(p2, p2), dot(p3, p3)));
    p0 *= norm.x;
    p1 *= norm.y;
    p2 *= norm.z;
    p3 *= norm.w;

    // Mix final noise value
    float4 m = max(0.6 - float4(dot(x0, x0), dot(x1, x1), dot(x2, x2), dot(x3, x3)), 0.0);
    m = m * m;
    return 42.0 * dot(m * m, float4(dot(p0, x0), dot(p1, x1),
                                    dot(p2, x2), dot(p3, x3)));
}


// 3D worley noise from https://www.shadertoy.com/view/3dVXDc
float WorleyNoise(float3 uv)
{
    float3 id = floor(uv);
    float3 p = frac(uv);

    float minDist = 10000.;
    for (float x = -1.; x <= 1.; ++x)
    {
        for (float y = -1.; y <= 1.; ++y)
        {
            for (float z = -1.; z <= 1.; ++z)
            {
                float3 offset = float3(x, y, z);
                float3 h = Hash(id + offset) * .5 + .5;
                h += offset;
                float3 d = p - h;
                minDist = min(minDist, dot(d, d));
            }
        }
    }
    // inverted worley noise
    return 1. - minDist;
}

float TileableWorleyNoise(float3 uv, float frequency)
{
    float3 id = floor(uv);
    float3 p = frac(uv);

    float minDist = 10000.;
    for (float x = -1.; x <= 1.; ++x)
    {
        for (float y = -1.; y <= 1.; ++y)
        {
            for (float z = -1.; z <= 1.; ++z)
            {
                float3 offset = float3(x, y, z);
                float3 h = Hash((id + offset) % frequency) * .5 + .5;
                h += offset;
                float3 d = p - h;
                minDist = min(minDist, dot(d, d));
            }
        }
    }
    // inverted worley noise
    return 1. - minDist;
}

float Simplex2DFbm(float2 uv, int num_octaves, float lacunarity, float gain)
{
    float noise_sum = 0.;
    float amplitude_sum = 0.;
    float amplitude = 1.;
    for (int i = 0; i < num_octaves; i++)
    {
        noise_sum += amplitude * SimplexNoise2D(uv);
        amplitude_sum += amplitude;

        amplitude *= gain;
        uv *= lacunarity;
    }
    return noise_sum / amplitude_sum;
}

float PerlinFbm(float3 uv, int num_octaves, float lacunarity, float gain)
{
    float noise_sum = 0.;
    float amplitude_sum = 0.;
    float amplitude = 1.;
    for (int i = 0; i < num_octaves; i++)
    {
        noise_sum += amplitude * GradientNoise(uv);
        amplitude_sum += amplitude;

        amplitude *= gain;
        uv *= lacunarity;
    }
    return noise_sum / amplitude_sum;
}

float TileablePerlinFbm(float3 uv, int num_octaves, float lacunarity, float gain, float frequency)
{
    float noise_sum = 0.;
    float amplitude_sum = 0.;
    float amplitude = 1.;
    for (int i = 0; i < num_octaves; i++)
    {
        noise_sum += amplitude * TileableGradientNoise(uv * frequency, frequency);
        amplitude_sum += amplitude;

        amplitude *= gain;
        frequency *= lacunarity;
    }
    return noise_sum / amplitude_sum;
}

float3 TileablePerlinDerivativesFbm(float3 uv, int num_octaves, float lacunarity, float gain, float frequency)
{
    float3 noise_sum = 0.;
    float amplitude_sum = 0.;
    float amplitude = 1.;
    for (int i = 0; i < num_octaves; i++)
    {
        noise_sum += amplitude * TileableGradientNoiseDerivatives(uv * frequency, frequency);
        amplitude_sum += amplitude;

        amplitude *= gain;
        frequency *= lacunarity;
    }
    return noise_sum / amplitude_sum;
}

float WorleyFbm(float3 uv, int num_octaves, float lacunarity, float gain)
{
    float noise_sum = 0.;
    float amplitude_sum = 0.;
    float amplitude = 1.;
    for (int i = 0; i < num_octaves; i++)
    {
        noise_sum += amplitude * WorleyNoise(uv);
        amplitude_sum += amplitude;

        amplitude *= gain;
        uv *= lacunarity;
    }
    return noise_sum / amplitude_sum;
}

float TileableWorleyFbm(float3 uv, int num_octaves, float lacunarity, float gain, float frequency)
{
    float noise_sum = 0.;
    float amplitude_sum = 0.;
    float amplitude = 1.;
    for (int i = 0; i < num_octaves; i++)
    {
        noise_sum += amplitude * TileableWorleyNoise(uv * frequency, frequency);
        amplitude_sum += amplitude;

        amplitude *= gain;
        frequency *= lacunarity;
    }
    return noise_sum / amplitude_sum;
}

#endif
