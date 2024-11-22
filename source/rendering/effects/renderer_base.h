#pragma once
#include "rendering/pipeline_state_manager.h"
#include <DirectXMath.h>

namespace w3
{

class RendererBase
{
public:
	explicit RendererBase(PipelineStateManager& pipeline_state_manager);
	virtual ~RendererBase() = default;
	virtual void Initialize() = 0;
	virtual void Terminate() = 0;
	virtual void OnResize(int width, int height);
protected:
	PipelineStateManager& _pipeline_state_manager;

    DirectX::XMINT2 _resolution;
};
}
