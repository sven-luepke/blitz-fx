#ifndef COMMON_HLSLI
#define COMMON_HLSLI

////////////////
// constants
////////////////
#define PI 3.141592654
#define PI_2 6.283185307
#define PI_RCP (1.0 / 3.141592654)

////////////////
// functions
////////////////
float3 SafeHdr(float3 hdr)
{
    float3 color = min(hdr, 650000);
    color = color == 650000 ? 0 : color;
    return color;
}
float Square(float x)
{
	return x * x;
}
float2 Square(float2 x)
{
    return x * x;
}
float3 Square(float3 x)
{
    return x * x;
}
float4 Square(float4 x)
{
    return x * x;
}

float Rescale(float value_min, float value_max, float value)
{
	return saturate((value - value_min) / (value_max - value_min));
}
float4 Rescale(float value_min, float value_max, float4 value)
{
    return saturate((value - value_min) / (value_max - value_min));
}
float Remap(float value, float original_min, float original_max, float new_min, float new_max)
{
	return new_min + ((value - original_min) / (original_max - original_min)) * (new_max - new_min);
}
float Luminance(float3 color)
{
    return color.r * 0.2126f + color.g * 0.7152 + color.b * 0.0722;
}
float Checkerboard(uint2 position)
{
    return (position.x + position.y) % 2;
}
float Linearstep(float min, float max, float v)
{
    return saturate((v - min) / (max - min));
}

float Min3(float3 values)
{
    return min(values.x, min(values.y, values.z));
}
float Max3(float3 values)
{
    return max(values.x, max(values.y, values.z));
}

float Min4(float4 values)
{ 
    return min(values.x, min(values.y, min(values.z, values.w)));
}
float Max4(float4 values)
{
    return max(values.x, max(values.y, max(values.z, values.w)));
}

float2 ThreadIdToTexCoord(uint2 thread_id, float2 rcp_texture_dimensions)
{
    return (thread_id.xy + 0.5) * rcp_texture_dimensions;
}

uint2 TexCoordToThreadId(float2 tex_coord, float2 texture_dimensions)
{
    return tex_coord * texture_dimensions - 0.5;
}

float2 NdcXYToTexCoord(float2 ndc_xy)
{
    float2 tex_coord = ndc_xy.xy * 0.5 + 0.5;
    tex_coord.y = 1 - tex_coord.y;
    return tex_coord;
}
float2 TexCoordToNdcXY(float2 tex_coord)
{
    float2 ndc = tex_coord;
    ndc.y = 1 - ndc.y;
    return ndc * 2 - 1;

}

float InterpolateGatheredBilinear(float4 gathered_samples, float2 tex_coord, float2 texture_dimensions)
{
    float2 fract = frac(tex_coord * texture_dimensions + 0.5);
    float2 rows = lerp(gathered_samples.wx, gathered_samples.zy, fract.x);
    return lerp(rows.x, rows.y, fract.y);
}

void RaySphereIntersect(in float3 ray_origin, in float3 ray_direction, in float3 sphere_center, in float sphere_radius,
	out bool intersects, out float distance, out float3 intersection_point)
{
	// source: Real-Time Rendering Fourth Edition
    float3 l = sphere_center - ray_origin;
    float s = dot(l, ray_direction);
    float l_squared = dot(l, l);
    float r_squared = Square(sphere_radius);
	if (s < 0 && l_squared > r_squared)
	{
        intersects = false;
        distance = 0;
        intersection_point = 0;
		return;
    }
    float m_squared = l_squared - Square(s);
	if (m_squared > r_squared)
	{
        intersects = false;
        distance = 0;
        intersection_point = 0;
		return;
    }
    float q = sqrt(r_squared - m_squared);
    distance = l_squared > r_squared ? s - q : s + q;
    intersects = true;
    intersection_point = ray_origin + distance * ray_direction;
}

float3 SphericalToCartesian(float theta, float phi, float radius)
{
    float3 cartesian;
    float cos_theta, sin_theta;
    sincos(theta, sin_theta, cos_theta);
    float cos_phi, sin_phi;
    sincos(phi, sin_phi, cos_phi);
    cartesian.x = sin_theta * sin_phi * radius;
    cartesian.y = cos_theta * sin_phi * radius;
    cartesian.z = cos_phi * radius;
    return cartesian;
}
float3 SphericalToCartesianNormalized(float theta, float phi)
{
    // theta (azimuth) in [0; 2*PI]
	// phi (zenith) in [0; PI]
    float3 cartesian;
    float cos_theta, sin_theta;
    sincos(theta, sin_theta, cos_theta);
    float cos_phi, sin_phi;
    sincos(phi, sin_phi, cos_phi);
    cartesian.x = sin_theta * sin_phi;
    cartesian.y = cos_theta * sin_phi;
    cartesian.z = cos_phi;
    return cartesian;
}
float3 CartesianToSpherical(float3 cartesian_coord)
{
    float radius = length(cartesian_coord);
    float theta = atan2(cartesian_coord.x, cartesian_coord.y);
    float phi = acos(cartesian_coord.z / radius);
    return float3(theta, phi, radius);
}
float2 CartesianToSphericalNormalized(float3 cartesian_coord)
{
    float theta = atan2(cartesian_coord.x, cartesian_coord.y);
    float phi = acos(cartesian_coord.z);
    return float2(theta, phi);
}

#define SCREEN_SPACE_VARIANCE 0.25
#define ROUGHNESS_THRESHOLD 0.18

float FilterNDF(float3 normal, float roughness)
{
    // https://yusuketokuyoshi.com/papers/2017/Error%20Reduction%20and%20Simplification%20for%20Shading%20Anti-Aliasing.pdf
    float3 delta_u = ddx(normal);
    float3 delta_v = ddy(normal);
    float variance = 0.25 * (dot(delta_u, delta_u) + dot(delta_v, delta_v));
    float kernel_squared_roughness = min(2.0 * variance, ROUGHNESS_THRESHOLD);
    float squared_roughness = saturate(roughness * roughness + kernel_squared_roughness);
    return sqrt(squared_roughness);
}

float2 GetParaboloidTexCoord(float3 view_direction)
{
	// based on https://www.opengl.org/archives/resources/code/samples/sig99/advanced99/notes/node187.html
    float2 tex_coord = -view_direction.xy / (1 + view_direction.z);
    tex_coord.xy = tex_coord * 0.5 + 0.5;
    return tex_coord;
}
float3 GetParaboloidDirection(float2 tex_coord)
{
	// based on https://www.opengl.org/archives/resources/code/samples/sig99/advanced99/notes/node187.html
    tex_coord = tex_coord * 2 - 1;
    float2 tex_coord_squared = Square(tex_coord);
	
    float3 direction;
    direction.x = -2 * tex_coord.x;
    direction.y = -2 * tex_coord.y;
    direction.z = 1 - tex_coord_squared.x - tex_coord_squared.y;
    return direction / (tex_coord_squared.x + tex_coord_squared.y + 1);
}

float ComputeMipLevel(float2 tex_coords, float2 texture_dimensions) // in texel units
{
    tex_coords *= texture_dimensions;
    float2 dx_vtc = ddx(tex_coords);
    float2 dy_vtc = ddy(tex_coords);
    float delta_max_sqr = max(dot(dx_vtc, dx_vtc), dot(dy_vtc, dy_vtc));
    return 0.5 * log2(delta_max_sqr);
}

float2 GetObjectMotionVector(float3 previous_clip_pos_xyw, float3 current_clip_pos_xyw)
{
    float2 previous_frame_tex_coord = NdcXYToTexCoord(previous_clip_pos_xyw.xy / previous_clip_pos_xyw.z);
    float2 current_frame_tex_coord = NdcXYToTexCoord(current_clip_pos_xyw.xy / current_clip_pos_xyw.z);
    float2 motion_vector = previous_frame_tex_coord - current_frame_tex_coord;

    if (length(motion_vector) > 0.1)
    {
        motion_vector = 0;
    }
    return motion_vector;
}

////////////////
// structs
////////////////
struct BlitVSOutput
{
	float4 position : SV_POSITION;
	float2 tex_coord : TEXCOORD0;
};

#endif
