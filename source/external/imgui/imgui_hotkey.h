#pragma once
//#define IMGUI_DISABLE_OBSOLETE_FUNCTIONS
#include "imgui.h"
#define IMGUI_DEFINE_MATH_OPERATORS
//#define IMGUI_DEFINE_PLACEMENT_NEW

namespace ImGui {
    bool ToggleButton(const char * label, bool * v, const ImVec2 & size_arg = ImVec2(0, 0));
    bool BeginGroupBox(const char * name, const ImVec2 & size_arg = ImVec2(0, 0));
    void EndGroupBox();
    bool Hotkey(const char * label, int * k, const ImVec2 & size_arg = ImVec2(0, 0));
}