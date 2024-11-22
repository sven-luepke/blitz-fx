#include "config.h"

using namespace w3;

#define EMPLACE_VARIABLE(variable, name) \
    { \
        auto base = reinterpret_cast<uint64_t>(&config); \
        uint64_t offset = reinterpret_cast<uint64_t>(&(variable)) - base; \
        map[name] = VariableInfo{offset, &typeid(variable)}; \
    }

std::unordered_map<std::string, Configuration::VariableInfo> Configuration::CreateNameToVariableMap()
{
    Configuration config;
    std::unordered_map<std::string, VariableInfo> map;

    EMPLACE_VARIABLE(config.toggle_blitz_fx_key, "ToggleBlitzFXKey")
    EMPLACE_VARIABLE(config.open_settings_key, "OpenSettingsKey")

    EMPLACE_VARIABLE(config.v_sync_interval, "ForceVSyncInterval")
    EMPLACE_VARIABLE(config.enable_motion_blur, "MotionBlur")
    EMPLACE_VARIABLE(config.bloom_scattering, "BloomScattering")
    EMPLACE_VARIABLE(config.physical_ao, "PhysicalAO")
    EMPLACE_VARIABLE(config.enable_tonemap, "Tonemap")
    EMPLACE_VARIABLE(config.physical_sun, "PhysicalSun")
    EMPLACE_VARIABLE(config.enable_custom_sun_radius, "EnableCustomSunRadius")
    EMPLACE_VARIABLE(config.sun_radius, "SunRadius")
    EMPLACE_VARIABLE(config.exposure_scale, "ExposureScale")
    EMPLACE_VARIABLE(config.hdr_saturation, "HDRSaturation")
    EMPLACE_VARIABLE(config.hdr_contrast, "HDRContrast")
    EMPLACE_VARIABLE(config.enable_hdr_color_filter, "EnableHDRColorFilter")
    EMPLACE_VARIABLE(config.hdr_color_filter, "HDRColorFilter")
    EMPLACE_VARIABLE(config.unify_player_light_influence, "UnifyPlayerLightInfluence")
    EMPLACE_VARIABLE(config.player_light_scale, "PlayerLightScale")
    EMPLACE_VARIABLE(config.disable_parametric_balance, "DisableParametricBalance")
    EMPLACE_VARIABLE(config.cinematic_border_gameplay, "CinematicBorderGameplay")
    EMPLACE_VARIABLE(config.cinematic_border_cutscene, "CinematicBorderCutscene")
    EMPLACE_VARIABLE(config.vignette_intensity, "VignetteIntensity")
    EMPLACE_VARIABLE(config.vignette_exponent, "VignetteExponent")
    EMPLACE_VARIABLE(config.vignette_start_offset, "VignetteStartOffset")
    EMPLACE_VARIABLE(config.enable_water, "EnableWater")
    EMPLACE_VARIABLE(config.underwater_fog_diffusion, "UnderwaterFogDiffusion")
    EMPLACE_VARIABLE(config.hairworks_shadow_quality, "HairworksShadowQuality")
    EMPLACE_VARIABLE(config.water_config_mode, "WaterConfigMode")
    EMPLACE_VARIABLE(config.underwater_fog_color, "UnderwaterFogColor")
    EMPLACE_VARIABLE(config.underwater_fog_density, "UnderwaterFogDensity")
    EMPLACE_VARIABLE(config.underwater_fog_anisotropy, "UnderwaterFogAnisotropy")
    EMPLACE_VARIABLE(config.underwater_fog_color_max_luma, "UnderwaterFogColorMaxLuma")
    EMPLACE_VARIABLE(config.underwater_fog_density_scale, "UnderwaterFogDensityScale")
    EMPLACE_VARIABLE(config.water_depth_scale, "WaterDepthScale")
    EMPLACE_VARIABLE(config.enable_refractive_raindrops, "EnableRefractiveRaindrops")
    EMPLACE_VARIABLE(config.anti_aliasing_method, "AntiAliasingMethod")
    EMPLACE_VARIABLE(config.taa_sharpening, "TAASharpening")
    EMPLACE_VARIABLE(config.taa_history_sharpening, "TAAHistorySharpening")
    EMPLACE_VARIABLE(config.taa_resolve_filter_width, "TAAResolveFilterWidth")
    EMPLACE_VARIABLE(config.enable_aurora, "EnableAurora")
    EMPLACE_VARIABLE(config.enable_pbr_lighting, "EnablePBRLighting")
    EMPLACE_VARIABLE(config.aurora_brightness, "AuroraBrightness")
    EMPLACE_VARIABLE(config.aurora_color_bottom, "AuroraColorBottom")
    EMPLACE_VARIABLE(config.aurora_color_top, "AuroraColorTop")
    EMPLACE_VARIABLE(config.enable_soft_shadows, "EnableSoftShadows")
    EMPLACE_VARIABLE(config.enable_contact_shadows, "EnableContactShadows")
    EMPLACE_VARIABLE(config.gameplay_dof_config_mode, "GameplayDofConfigMode")
    EMPLACE_VARIABLE(config.gameplay_dof_blur_type, "GameplayDofBlurType")
    EMPLACE_VARIABLE(config.gameplay_dof_intensity_scale, "GameplayDofIntensityScale")
    EMPLACE_VARIABLE(config.gameplay_dof_intensity, "GameplayDofIntensity")
    EMPLACE_VARIABLE(config.gameplay_dof_focus_distance, "GameplayDofFocusDistance")
    EMPLACE_VARIABLE(config.gameplay_dof_blur_distance, "GameplayDofBlurDistance")

    return map;
}
const std::unordered_map<std::string, Configuration::VariableInfo> Configuration::name_to_variable_map = CreateNameToVariableMap();


std::unordered_map<std::string, std::string> Configuration::ToMap(const Configuration& config)
{
    std::unordered_map<std::string, std::string> map;
    for (const auto& pair : name_to_variable_map)
    {
        const std::type_info& type_info = *pair.second.type_info;
        void* variable_ptr = reinterpret_cast<void*>(reinterpret_cast<uint64_t>(&config) + pair.second.address_offset);
        if (type_info == typeid(bool))
        {
            bool variable = *static_cast<bool*>(variable_ptr);
            map[pair.first] = variable ? "1" : "0";
        }
        if (type_info == typeid(int))
        {
            int variable = *static_cast<int*>(variable_ptr);
            map[pair.first] = std::to_string(variable);
        }
        else if (type_info == typeid(float))
        {
            float variable = *static_cast<float*>(variable_ptr);
            map[pair.first] = std::to_string(variable);
        }
        else if (type_info == typeid(float3))
        {
            float3 variable = *static_cast<float3*>(variable_ptr);
            map[pair.first + "R"] = std::to_string(variable.x);
            map[pair.first + "G"] = std::to_string(variable.y);
            map[pair.first + "B"] = std::to_string(variable.z);
        }
    }
    return map;
}
Configuration Configuration::FromMap(const std::unordered_map<std::string, std::string>& map)
{
    Configuration config;
    for (const auto& pair : map)
    {
        std::string variable_name = pair.first;
        const std::string& variable_value_str = pair.second;

        auto iterator = name_to_variable_map.find(variable_name);
        if (iterator == name_to_variable_map.end())
        {
            // remove last character in case the key is one of 3 RGB values
            variable_name.pop_back();
            iterator = name_to_variable_map.find(variable_name);
            if (iterator == name_to_variable_map.end())
            {
                continue;
            }
        }

        const VariableInfo& variable_info = iterator->second;
        const std::type_info& type_info = *variable_info.type_info;
        void* variable_ptr = reinterpret_cast<void*>(reinterpret_cast<uint64_t>(&config) + variable_info.address_offset);
        if (type_info == typeid(bool))
        {
            bool variable = variable_value_str != "0";
            *static_cast<bool*>(variable_ptr) = variable;
        }
        else if (type_info == typeid(int))
        {
            int variable = std::stoi(variable_value_str);
            *static_cast<int*>(variable_ptr) = variable;
        }
        else if (type_info == typeid(float))
        {
            float variable = std::stof(variable_value_str);
            *static_cast<float*>(variable_ptr) = variable;
        }
        else if (type_info == typeid(float3))
        {
            float3 variable = {};
            auto map_iterator = map.find(variable_name + "R");
            if (map_iterator != map.end())
            {
                variable.x = std::stof(map_iterator->second);
            }
            map_iterator = map.find(variable_name + "G");
            if (map_iterator != map.end())
            {
                variable.y = std::stof(map_iterator->second);
            }
            map_iterator = map.find(variable_name + "B");
            if (map_iterator != map.end())
            {
                variable.z = std::stof(map_iterator->second);
            }
            *static_cast<float3*>(variable_ptr) = variable;
        }
    }
    return config;
}
