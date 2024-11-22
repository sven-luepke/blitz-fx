#pragma once
#include "shader_types.h"

#include <unordered_map>
#include <string>
#include <typeinfo>

#include "windows.h"

namespace w3
{

enum CONFIG_MODE : int
{
    CONFIG_MODE_ENV = 0,
    CONFIG_MODE_GLOBAL = 1,
};

enum ANTI_ALIASING_METHOD : int
{
    ANTI_ALIASING_METHOD_VANILLA = 0,
    ANTI_ALIASING_METHOD_VANILLA_PLUS = 1,
    ANTI_ALIASING_METHOD_TAA = 2,
};

enum DEPTH_OF_FIELD_BLUR_TYPE : int
{
    DEPTH_OF_FIELD_BLUR_TYPE_VANILLA = 0,
    DEPTH_OF_FIELD_BLUR_TYPE_BOKEH = 1,
};

struct Configuration
{
    int v_sync_interval = 0;

    int toggle_blitz_fx_key = VK_F7;
    int open_settings_key = VK_F8;

    bool enable_soft_shadows = true;
    bool enable_contact_shadows = true;

    bool enable_motion_blur = true;
    float bloom_scattering = 0.1f;
    float hdr_saturation = 0.96f;
    float hdr_contrast = 1.0f;
    bool physical_ao = true;
    bool enable_tonemap = true;
    bool physical_sun = true;
    float exposure_scale = 1.0f;
    bool enable_hdr_color_filter = false;
    float3 hdr_color_filter {1.0f, 1.0f, 1.0f};

    bool enable_custom_sun_radius = true;
    float sun_radius = 0.7f;

    bool unify_player_light_influence = true;
    float player_light_scale = 0.5f;

    bool disable_parametric_balance = false;

    float cinematic_border_gameplay = 0.0f;
    float cinematic_border_cutscene = 0.0f;

    int debug_view_mode = 0;

    float vignette_intensity = 0.8f;
    float vignette_exponent = 2.0f;
    float vignette_start_offset = 0.2f;

    bool enable_water = true;
    int water_config_mode = CONFIG_MODE_ENV;
    float3 underwater_fog_color{ 0.0f, 0.16f, 0.22f };
    float underwater_fog_density = 0.05f;
    float underwater_fog_diffusion = 0.7f;
    float underwater_fog_anisotropy = 0.1f;
    float underwater_fog_color_max_luma = 0.1f;
    float underwater_fog_density_scale = 0.1f;
    float water_depth_scale = 2.0f;

    bool enable_aurora = false;
    float aurora_brightness = 64.0f;
    float3 aurora_color_bottom = { 0.0f, 1.0f, 0.3f };
    float3 aurora_color_top = { 0.0f, 0.13f, 0.65f };

    int hairworks_shadow_quality = 2;

    bool enable_refractive_raindrops = true;
    bool enable_pbr_lighting = true;

    int anti_aliasing_method = ANTI_ALIASING_METHOD_TAA;
    float taa_resolve_filter_width = 2.0f;
    float taa_history_sharpening = 0.7f;
    float taa_sharpening = 0.9f;

    int gameplay_dof_config_mode = CONFIG_MODE_ENV;
    int gameplay_dof_blur_type = DEPTH_OF_FIELD_BLUR_TYPE_VANILLA;
    float gameplay_dof_intensity_scale = 1.0f;
    float gameplay_dof_intensity = 0.4f;
    float gameplay_dof_focus_distance = 15.0f;
    float gameplay_dof_blur_distance = 30.0f;

    static std::unordered_map<std::string, std::string> ToMap(const Configuration& config);
    static Configuration FromMap(const std::unordered_map<std::string, std::string>& map);

private:
    struct VariableInfo
    {
        uint64_t address_offset;
        const std::type_info* type_info;
    };
    static const std::unordered_map<std::string, VariableInfo> name_to_variable_map;
    static std::unordered_map<std::string, VariableInfo> CreateNameToVariableMap();
};
}
