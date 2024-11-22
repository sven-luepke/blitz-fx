#pragma once
#include <algorithm>

#include "config.h"
#include "external/imgui/imgui.h"

namespace w3::gui
{
void InitializeStyle();
void ScaleGUI(float scale);
bool HandleInput(Configuration& config, bool is_blitz_fx_enabled);
}
