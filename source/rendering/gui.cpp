#include "gui.h"
#include "external/imgui/imgui_hotkey.h"
#include "windows.h"

void w3::gui::InitializeStyle()
{
    ImGuiStyle& style = ImGui::GetStyle();

    style.Colors[ImGuiCol_Text] = ImVec4(0.86f, 0.93f, 0.89f, 0.78f);
    style.Colors[ImGuiCol_TextDisabled] = ImVec4(0.86f, 0.93f, 0.89f, 0.28f);
    style.Colors[ImGuiCol_WindowBg] = ImVec4(0.13f, 0.14f, 0.17f, 0.85f);
    style.Colors[ImGuiCol_Border] = ImVec4(0.31f, 0.31f, 1.00f, 0.00f);
    style.Colors[ImGuiCol_BorderShadow] = ImVec4(0.00f, 0.00f, 0.00f, 0.00f);
    style.Colors[ImGuiCol_FrameBg] = ImVec4(0.20f, 0.22f, 0.27f, 1.00f);
    style.Colors[ImGuiCol_FrameBgHovered] = ImVec4(0.92f, 0.18f, 0.29f, 0.78f);
    style.Colors[ImGuiCol_FrameBgActive] = ImVec4(0.92f, 0.18f, 0.29f, 1.00f);
    style.Colors[ImGuiCol_TitleBg] = ImVec4(0.20f, 0.22f, 0.27f, 1.00f);
    style.Colors[ImGuiCol_TitleBgCollapsed] = ImVec4(0.20f, 0.22f, 0.27f, 0.75f);
    style.Colors[ImGuiCol_TitleBgActive] = ImVec4(0.92f, 0.18f, 0.29f, 1.00f);
    style.Colors[ImGuiCol_MenuBarBg] = ImVec4(0.20f, 0.22f, 0.27f, 0.47f);
    style.Colors[ImGuiCol_ScrollbarBg] = ImVec4(0.20f, 0.22f, 0.27f, 1.00f);
    style.Colors[ImGuiCol_ScrollbarGrab] = ImVec4(0.09f, 0.15f, 0.16f, 1.00f);
    style.Colors[ImGuiCol_ScrollbarGrabHovered] = ImVec4(0.92f, 0.18f, 0.29f, 0.78f);
    style.Colors[ImGuiCol_ScrollbarGrabActive] = ImVec4(0.92f, 0.18f, 0.29f, 1.00f);
    style.Colors[ImGuiCol_CheckMark] = ImVec4(0.71f, 0.22f, 0.27f, 1.00f);
    style.Colors[ImGuiCol_SliderGrab] = ImVec4(0.47f, 0.77f, 0.83f, 0.14f);
    style.Colors[ImGuiCol_SliderGrabActive] = ImVec4(0.92f, 0.18f, 0.29f, 1.00f);
    style.Colors[ImGuiCol_Button] = ImVec4(0.47f, 0.77f, 0.83f, 0.14f);
    style.Colors[ImGuiCol_ButtonHovered] = ImVec4(0.92f, 0.18f, 0.29f, 0.86f);
    style.Colors[ImGuiCol_ButtonActive] = ImVec4(0.92f, 0.18f, 0.29f, 1.00f);
    style.Colors[ImGuiCol_Header] = ImVec4(0.92f, 0.18f, 0.29f, 0.76f);
    style.Colors[ImGuiCol_HeaderHovered] = ImVec4(0.92f, 0.18f, 0.29f, 0.86f);
    style.Colors[ImGuiCol_HeaderActive] = ImVec4(0.92f, 0.18f, 0.29f, 1.00f);
    style.Colors[ImGuiCol_Separator] = ImVec4(0.14f, 0.16f, 0.19f, 1.00f);
    style.Colors[ImGuiCol_SeparatorHovered] = ImVec4(0.92f, 0.18f, 0.29f, 0.78f);
    style.Colors[ImGuiCol_SeparatorActive] = ImVec4(0.92f, 0.18f, 0.29f, 1.00f);
    style.Colors[ImGuiCol_ResizeGrip] = ImVec4(0.47f, 0.77f, 0.83f, 0.04f);
    style.Colors[ImGuiCol_ResizeGripHovered] = ImVec4(0.92f, 0.18f, 0.29f, 0.78f);
    style.Colors[ImGuiCol_ResizeGripActive] = ImVec4(0.92f, 0.18f, 0.29f, 1.00f);
    style.Colors[ImGuiCol_PlotLines] = ImVec4(0.86f, 0.93f, 0.89f, 0.63f);
    style.Colors[ImGuiCol_PlotLinesHovered] = ImVec4(0.92f, 0.18f, 0.29f, 1.00f);
    style.Colors[ImGuiCol_PlotHistogram] = ImVec4(0.86f, 0.93f, 0.89f, 0.63f);
    style.Colors[ImGuiCol_PlotHistogramHovered] = ImVec4(0.92f, 0.18f, 0.29f, 1.00f);
    style.Colors[ImGuiCol_TextSelectedBg] = ImVec4(0.92f, 0.18f, 0.29f, 0.43f);
    style.Colors[ImGuiCol_PopupBg] = ImVec4(0.20f, 0.22f, 0.27f, 0.9f);
    style.Colors[ImGuiCol_ModalWindowDarkening] = ImVec4(0.20f, 0.22f, 0.27f, 0.73f);
}
void w3::gui::ScaleGUI(float scale)
{
    static float previous_scale = 1.0f;

    ImGui::GetIO().FontGlobalScale = scale;

    ImGuiStyle& style = ImGui::GetStyle();

    style.ScaleAllSizes(scale / previous_scale);
    previous_scale = scale;
}
bool w3::gui::HandleInput(Configuration& config, bool is_blitz_fx_enabled)
{
    static const float max_window_width = 0.9f;
    bool toggle_blitz_fx = false;
    if (is_blitz_fx_enabled)
    {
        if (ImGui::Button("Disable BlitzFX"))
        {
            toggle_blitz_fx = true;
        }
    }
    else
    {
        if (ImGui::Button("Enable BlitzFX"))
        {
            toggle_blitz_fx = true;
        }
    }

    if (is_blitz_fx_enabled)
    {
        ImGui::Dummy(ImVec2(0.0f, 13.0f));
    }
    else
    {
        ImGui::TextColored(ImVec4(1.0f, 0.0f, 0.0f, 1.0f), "BlitzFX is disabled");
    }

    static const char* options[] = {"Disable", "1", "2", "3", "4"};
    ImGui::Text("Force VSync Interval");
    ImGui::SameLine();
    ImGui::PushItemWidth(ImGui::GetWindowWidth() * 0.3f);
    ImGui::Combo("##label", &config.v_sync_interval, options, 5);
    ImGui::PushItemWidth(ImGui::GetWindowWidth() * max_window_width);

    if (ImGui::CollapsingHeader("Key Bindings"))
    {
        ImGui::Hotkey("Toggle BlitzFX ", &config.toggle_blitz_fx_key);
        ImGui::Hotkey("Open Settings  ", &config.open_settings_key);
    }

    if (ImGui::CollapsingHeader("Lighting"))
    {
        ImGui::Checkbox("Soft Shadows", &config.enable_soft_shadows);
        ImGui::Checkbox("Contact Shadows", &config.enable_contact_shadows);

        static const char* options_2[] = {"Low", "Medium", "High", "Ultra"};
        ImGui::Text("HairWorks Shadow Quality");
        ImGui::SameLine();
        ImGui::PushItemWidth(ImGui::GetWindowWidth() * 0.25f);
        ImGui::Combo("##hwq", &config.hairworks_shadow_quality, options_2, 4);
        ImGui::PushItemWidth(ImGui::GetWindowWidth() * max_window_width);

        ImGui::Checkbox("Physical Ambient Occlusion", &config.physical_ao);
        ImGui::Checkbox("Unify Player Light Influence", &config.unify_player_light_influence);
        ImGui::DragFloat("##slider3", &config.player_light_scale, 0.01, 0.0, 1.0, "Player Light Scale = %.2f");
        config.player_light_scale = std::clamp(config.player_light_scale, 0.0f, 1.0f);

        ImGui::Checkbox("PBR Lighting", &config.enable_pbr_lighting);
    }

    if (ImGui::CollapsingHeader("Physical Sun"))
    {
        ImGui::Checkbox("Enable Physical Sun", &config.physical_sun);
        if (config.physical_sun)
        {
            static const char* options_3[] = { "Env", "Global" };
            ImGui::Text("Configuration Mode");
            ImGui::SameLine();
            ImGui::PushItemWidth(ImGui::GetWindowWidth() * 0.25f);
            int current_sun_config_mode = config.enable_custom_sun_radius ? 1 : 0;
            ImGui::Combo("##sun_config_mode", &current_sun_config_mode, options_3, 2);
            config.enable_custom_sun_radius = current_sun_config_mode == 1;
            ImGui::PushItemWidth(ImGui::GetWindowWidth() * max_window_width);
            if (config.enable_custom_sun_radius)
            {
                ImGui::DragFloat("##slider2", &config.sun_radius, 0.01, 0.2, 8.0, "Sun Size = %.2f");
                config.sun_radius = std::clamp(config.sun_radius, 0.2f, 8.0f);
            }
        }
    }

    if (ImGui::CollapsingHeader("Aurora"))
    {
        ImGui::Checkbox("Enable Aurora", &config.enable_aurora);

        if (config.enable_aurora)
        {
            ImGui::DragFloat("##aurorabrightness", &config.aurora_brightness, 0.01, 1.0f, 1000.0f, "Aurora Brightness = %.2f");
            config.aurora_brightness = std::clamp(config.aurora_brightness, 1.0f, 1000.0f);
            ImGui::Text("Aurora Color Bottom");
            ImGui::ColorEdit4("##ACB", reinterpret_cast<float*>(&config.aurora_color_bottom), ImGuiColorEditFlags_NoAlpha);
            ImGui::Text("Aurora Color Top");
            ImGui::ColorEdit4("##ACT", reinterpret_cast<float*>(&config.aurora_color_top), ImGuiColorEditFlags_NoAlpha);
        }
    }

    if (ImGui::CollapsingHeader("Water"))
    {
        ImGui::Checkbox("Enable Water", &config.enable_water);

        if (config.enable_water)
        {
            static const char* options_3[] = {"Env", "Global"};
            ImGui::Text("Configuration Mode");
            ImGui::SameLine();
            ImGui::PushItemWidth(ImGui::GetWindowWidth() * 0.25f);
            int current_water_config_mode = config.water_config_mode;
            ImGui::Combo("##wcm", &current_water_config_mode, options_3, 2);
            config.water_config_mode = static_cast<CONFIG_MODE>(current_water_config_mode);
            ImGui::PushItemWidth(ImGui::GetWindowWidth() * max_window_width);
            if (config.water_config_mode == CONFIG_MODE_GLOBAL)
            {
                ImGui::Text("Underwater Fog Color");
                ImGui::ColorEdit4("##UFC", reinterpret_cast<float*>(&config.underwater_fog_color), ImGuiColorEditFlags_NoAlpha);
                ImGui::DragFloat("##underwaterFogDensity", &config.underwater_fog_density, 0.001, 0.0, 2.0,
                                 "Underwater Fog Density = %.3f");
                config.underwater_fog_density = std::clamp(config.underwater_fog_density, 0.0f, 2.0f);
            }
            else
            {
                ImGui::DragFloat("##underwaterFogColorMaxLuma", &config.underwater_fog_color_max_luma, 0.001, 0.0, 1.0,
                                 "Underwater Fog Color Max Luma = %.3f");
                config.underwater_fog_color_max_luma = std::clamp(config.underwater_fog_color_max_luma, 0.0f, 1.0f);
                ImGui::DragFloat("##underwaterFogDensityScale", &config.underwater_fog_density_scale, 0.001, 0.0, 10.0,
                                 "Underwater Fog Density Scale = %.3f");
                config.underwater_fog_density_scale = std::clamp(config.underwater_fog_density_scale, 0.0f, 10.0f);
            }

            ImGui::DragFloat("##underwaterFogAnisotropy", &config.underwater_fog_anisotropy, 0.001, 0.0, 0.9,
                             "Underwater Fog Anisotropy = %.3f");
            config.underwater_fog_anisotropy = std::clamp(config.underwater_fog_anisotropy, 0.0f, 0.9f);
            ImGui::DragFloat("##slider_underwater_fog_diffusion", &config.underwater_fog_diffusion, 0.001, 0.0, 1.0,
                             "Underwater Fog Diffusion = %.3f");
            config.underwater_fog_diffusion = std::clamp(config.underwater_fog_diffusion, 0.0f, 1.0f);
            ImGui::DragFloat("##waterDepthScale", &config.water_depth_scale, 0.01, 1.0, 2.0, "Water Depth Scale = %.2f");
            config.water_depth_scale = std::clamp(config.water_depth_scale, 1.0f, 2.0f);
        }
    }

    if (ImGui::CollapsingHeader("Rain"))
    {
        ImGui::Checkbox("Refractive Raindrops", &config.enable_refractive_raindrops);
    }

    if (ImGui::CollapsingHeader("Anti-aliasing"))
    {
        static const char* options_3[] = {"Vanilla", "Vanilla+", "TAA"};
        ImGui::Text("Anti-aliasing Method");
        ImGui::SameLine();
        ImGui::PushItemWidth(ImGui::GetWindowWidth() * 0.3f);
        int current_aa_method = config.anti_aliasing_method;
        ImGui::Combo("##aam", &current_aa_method, options_3, 3);
        config.anti_aliasing_method = static_cast<ANTI_ALIASING_METHOD>(current_aa_method);
        ImGui::PushItemWidth(ImGui::GetWindowWidth() * max_window_width);

        if (config.anti_aliasing_method == ANTI_ALIASING_METHOD_TAA)
        {
            ImGui::DragFloat("##slider_resolve_radius", &config.taa_resolve_filter_width, 0.001, 1.5f, 2.0,
                             "TAA Resolve Filter Width = %.3f");
            config.taa_resolve_filter_width = std::clamp(config.taa_resolve_filter_width, 1.5f, 2.0f);

            ImGui::DragFloat("##slider_history_sharpen", &config.taa_history_sharpening, 0.001, 0.0, 1.0, "TAA History Sharpening = %.3f");
            config.taa_history_sharpening = std::clamp(config.taa_history_sharpening, 0.0f, 1.0f);

            ImGui::DragFloat("##slider_sharpen", &config.taa_sharpening, 0.001, 0.0, 1.0, "TAA Post Sharpening = %.3f");
            config.taa_sharpening = std::clamp(config.taa_sharpening, 0.0f, 1.0f);
        }
    }

    if (ImGui::CollapsingHeader("HDR Post-processing"))
    {
        ImGui::Checkbox("Motion Blur", &config.enable_motion_blur);
        ImGui::DragFloat("##slider0", &config.bloom_scattering, 0.001, 0.0, 0.5, "Bloom Scattering = %.3f");
        config.bloom_scattering = std::clamp(config.bloom_scattering, 0.0f, 0.5f);

        ImGui::Checkbox("Tonemap", &config.enable_tonemap);
        ImGui::DragFloat("##slider00", &config.exposure_scale, 0.01, 0.1, 10, "Exposure Scale = %.2f");
        config.exposure_scale = std::clamp(config.exposure_scale, 0.1f, 10.0f);
        ImGui::DragFloat("##slider1", &config.hdr_saturation, 0.01, 0.0, 1.0, "HDR Saturation = %.2f");
        config.hdr_saturation = std::clamp(config.hdr_saturation, 0.0f, 1.0f);
        ImGui::DragFloat("##slider6", &config.hdr_contrast, 0.01, 0.5, 2.0, "HDR Contrast = %.2f");
        config.hdr_contrast = std::clamp(config.hdr_contrast, 0.5f, 2.0f);
        ImGui::Checkbox("HDR Color Filter", &config.enable_hdr_color_filter);
        if (config.enable_hdr_color_filter)
        {
            ImGui::ColorEdit4("##HDRCF", reinterpret_cast<float*>(&config.hdr_color_filter), ImGuiColorEditFlags_NoAlpha);
        }
    }
    if (ImGui::CollapsingHeader("Vignette"))
    {
        ImGui::DragFloat("##slider7", &config.vignette_intensity, 0.01, 0.0, 1.0, "Vignette Intensity = %.2f");
        config.vignette_intensity = std::clamp(config.vignette_intensity, 0.0f, 1.0f);
        ImGui::DragFloat("##slider8", &config.vignette_exponent, 0.01, 1.0, 10.0, "Vignette Shape = %.2f");
        config.vignette_exponent = std::clamp(config.vignette_exponent, 1.0f, 10.0f);
        ImGui::DragFloat("##slider9", &config.vignette_start_offset, 0.01, 0.0, 1.0, "Vignette Offset = %.2f");
        config.vignette_start_offset = std::clamp(config.vignette_start_offset, 0.0f, 1.0f);
    }

    if (ImGui::CollapsingHeader("Cinematic Borders"))
    {
        ImGui::DragFloat("##slider4", &config.cinematic_border_gameplay, 0.01, 0.0, 0.9, "Cinematic Borders Gameplay = %.2f");
        config.cinematic_border_gameplay = std::clamp(config.cinematic_border_gameplay, 0.0f, 0.9f);

        ImGui::DragFloat("##slider5", &config.cinematic_border_cutscene, 0.01, 0.0, 0.9, "Cinematic Borders Cutscene = %.2f");
        config.cinematic_border_cutscene = std::clamp(config.cinematic_border_cutscene, 0.0f, 0.9f);
    }

    if (ImGui::CollapsingHeader("Gameplay Depth of Field"))
    {
        static const char* options_4[] = { "Vanilla", "Bokeh" };
        ImGui::Text("Blur Type");
        ImGui::SameLine();
        ImGui::PushItemWidth(ImGui::GetWindowWidth() * 0.3f);
        int current_dof_blur_type = config.gameplay_dof_blur_type;
        ImGui::Combo("##aam", &current_dof_blur_type, options_4, 2);
        config.gameplay_dof_blur_type = static_cast<DEPTH_OF_FIELD_BLUR_TYPE>(current_dof_blur_type);
        ImGui::PushItemWidth(ImGui::GetWindowWidth() * max_window_width);

        static const char* options_3[] = { "Env", "Global" };
        ImGui::Text("Configuration Mode");
        ImGui::SameLine();
        ImGui::PushItemWidth(ImGui::GetWindowWidth() * 0.25f);
        int current_dof_config_mode = config.gameplay_dof_config_mode;
        ImGui::Combo("##dofcm", &current_dof_config_mode, options_3, 2);
        config.gameplay_dof_config_mode = static_cast<CONFIG_MODE>(current_dof_config_mode);
        ImGui::PushItemWidth(ImGui::GetWindowWidth() * max_window_width);
        if (config.gameplay_dof_config_mode == CONFIG_MODE_GLOBAL)
        {
            ImGui::DragFloat("##slider_dof_0", &config.gameplay_dof_intensity, 0.01, 0.0, 1.0, "Intensity = %.2f");
            config.gameplay_dof_intensity = std::clamp(config.gameplay_dof_intensity, 0.0f, 1.0f);

            ImGui::DragFloat("##slider_dof_1", &config.gameplay_dof_focus_distance, 0.1, 0.0, config.gameplay_dof_blur_distance, "Focus Distance = %.1f");
            config.gameplay_dof_focus_distance = std::clamp(config.gameplay_dof_focus_distance, 0.0f, config.gameplay_dof_blur_distance);

            ImGui::DragFloat("##slider_dof_2", &config.gameplay_dof_blur_distance, 0.1, config.gameplay_dof_focus_distance, 10000.0f, "Blur Distance = %.1f");
            config.gameplay_dof_blur_distance = std::clamp(config.gameplay_dof_blur_distance, config.gameplay_dof_focus_distance, 10000.0f);
        }
        else
        {
            ImGui::DragFloat("##slider_dof_44", &config.gameplay_dof_intensity_scale, 0.1, 0.0, 100.0, "Intensity Scale = %.1f");
            config.gameplay_dof_intensity_scale = std::clamp(config.gameplay_dof_intensity_scale, 0.0f, 100.0f);
        }
    }

    if (ImGui::CollapsingHeader("LDR Post-processing"))
    {
        ImGui::Checkbox("Disable Original Color Filter", &config.disable_parametric_balance);
    }


    ImGui::Dummy(ImVec2(0.0f, 6.0f));
    if (ImGui::Button("Restore Default Settings"))
    {
        Configuration std_config;
        config = std_config;
    }

#ifndef PUBLIC_RELEASE
    static const char* debug_view_options[] = { "Off", "Depth", "Albedo", "Normal", "Roughness", "Specular", "AO", "Shadow"};
    ImGui::Text("Debug View");
    ImGui::SameLine();
    ImGui::PushItemWidth(ImGui::GetWindowWidth() * 0.35f);
    ImGui::Combo(" ", &config.debug_view_mode, debug_view_options, 8);
    ImGui::Text("Version 1.1.0 - Development");
#else
    ImGui::Dummy(ImVec2(0.0f, 12.0f));
    ImGui::Text("Version 1.1.0");
#endif
    ImGui::Text("Copyright (c) 2024 KnighTec");

    return toggle_blitz_fx;
}
