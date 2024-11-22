#include "renderer_base.h"
#include "rendering/shader.h"
#include "rendering/resource_manager.h"
#include "rendering/pipeline_state_manager.h"

using namespace w3;

RendererBase::RendererBase(PipelineStateManager& pipeline_state_manager)
	: _pipeline_state_manager(pipeline_state_manager)
{
}
void RendererBase::OnResize(int width, int height)
{
    _resolution = { width, height };
}
