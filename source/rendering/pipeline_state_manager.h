#pragma once
#include <cstdint>
#include <d3d11.h>

#include "shader.h"

namespace w3
{
class ResourceManager;
class PipelineState;

enum AUTO_BIND : uint8_t
{
	AUTO_BIND_SHADER_RESOURCE_VIEWS = 0x01,
	AUTO_BIND_CONSTANT_BUFFERS = 0x02,
	AUTO_BIND_SAMPLERS = 0x04,
	AUTO_BIND_ALL = 0xff,
};

class PipelineStateManager : D3DInterface
{
	/*
	 * Handles setting and resetting the rendering pipeline to the original state expected by the game
	 */
public:
	explicit PipelineStateManager(ResourceManager& resource_manager);

    ID3D11DeviceContext* GetD3D11DeviceContext() const;

	void SetGlobalTexture(StringIdHash texture_file_name, StringIdHash shader_texture_name);
	void SetGlobalShaderResource(ID3D11ShaderResourceView* shader_resource_view, uint64_t name_string_id);
	void SetGlobalConstantBuffer(ID3D11Buffer* constant_buffer, uint64_t name_string_id);

	void BindShader(uint64_t shader_name_string_id);
	void BindResourcesForCurrentShaders(AUTO_BIND auto_bind_flags = AUTO_BIND_ALL);
	void RestoreOriginalPipelineState();
	/*
	 * Usage example in RenderingInterceptor:
	 * - In XSSetShader: Call SafeOriginalPipelineState() & BindShader()
	 * - In DrawX: Call BindResourcesForCurrentShaders() -> DrawX() -> RestoreOriginalPipelineState()
	 */

	/*
	 * Usage example in custom effect:
	 * 1. SafeOriginalPipelineState()
	 * 2. BindShader(), BindShaderResourceView(), Draw(), etc.
	 * 3. RestoreOriginalPipelineState()
	 */

	void SetShaderResourceView(ID3D11ShaderResourceView* shader_resource_view, SHADER_TYPE shader_type, UINT slot);
	void SetUnorderedAccessView(ID3D11UnorderedAccessView* unordered_access_view, SHADER_TYPE shader_type, UINT slot);
    void SetSamplerState(ID3D11SamplerState* sampler_state, SHADER_TYPE shader_type, UINT slot);

    void Clear();
private:
	void BindGlobalShaderResources();
	void BindGlobalConstantBuffers();
	void BindSamplers();
	
	ResourceManager& _resource_manager;
	SamplerManager _sampler_manager;
	
	Shader* _current_bound_vertex_shader;
    Shader* _current_bound_domain_shader;
	Shader* _current_bound_pixel_shader;
	Shader* _current_bound_compute_shader;

	std::unordered_map<uint64_t, ID3D11ShaderResourceView*> _global_shader_resources;
	std::unordered_map<uint64_t, ID3D11Buffer*> _global_constant_buffers;

	PipelineState* _original_pipeline_state;
};

inline ID3D11DeviceContext* PipelineStateManager::GetD3D11DeviceContext() const
{
    return GetD3DContext();
}

}
