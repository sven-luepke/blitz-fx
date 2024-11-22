#include "pipeline_state_manager.h"
#include "resource_manager.h"

using namespace w3;


class w3::PipelineState : D3DInterface
{
	/*
	 * Stores the original graphics pipeline state
	 */
public:
	void SetVertexShader(ID3D11VertexShader* vertex_shader);
    void SetDomainShader(ID3D11DomainShader* domain_shader);
	void SetPixelShader(ID3D11PixelShader* pixel_shader);
	void SetComputeShader(ID3D11ComputeShader* compute_shader);

	void SetVSShaderResource(uint32_t slot, ID3D11ShaderResourceView* shader_resource_view);
	void SetVSConstantBuffer(uint32_t slot, ID3D11Buffer* constant_buffer);
	void SetVSSampler(uint32_t slot, ID3D11SamplerState* sampler);

    void SetDSShaderResource(uint32_t slot, ID3D11ShaderResourceView* shader_resource_view);
    void SetDSConstantBuffer(uint32_t slot, ID3D11Buffer* constant_buffer);
    void SetDSSampler(uint32_t slot, ID3D11SamplerState* sampler);

	void SetPSShaderResource(uint32_t slot, ID3D11ShaderResourceView* shader_resource_view);
	void SetPSConstantBuffer(uint32_t slot, ID3D11Buffer* constant_buffer);
	void SetPSSampler(uint32_t slot, ID3D11SamplerState* sampler);
	void SetPSUnorderedAccessViews(uint32_t slot, ID3D11UnorderedAccessView* uav);

	void SetCSShaderResource(uint32_t slot, ID3D11ShaderResourceView* shader_resource_view);
	void SetCSConstantBuffer(uint32_t slot, ID3D11Buffer* constant_buffer);
	void SetCSSampler(uint32_t slot, ID3D11SamplerState* sampler);
	void SetCSUnorderedAccessViews(uint32_t slot, ID3D11UnorderedAccessView* uav);

    void Clear();
	void RestoreState();
private:
	ID3D11VertexShader* _vertex_shader = nullptr;
	bool _saved_vertex_shader = false;
    ID3D11DomainShader* _domain_shader = nullptr;
    bool _saved_domain_shader = false;
	ID3D11PixelShader* _pixel_shader = nullptr;
	bool _saved_pixel_shader = false;
	ID3D11ComputeShader* _compute_shader = nullptr;
	bool _saved_compute_shader = false;

	// map slots to resources
	std::unordered_map<uint32_t, ID3D11ShaderResourceView*> _vs_shader_resources;
	std::unordered_map<uint32_t, ID3D11Buffer*> _vs_constant_buffers;
	std::unordered_map<uint32_t, ID3D11SamplerState*> _vs_samplers;

    std::unordered_map<uint32_t, ID3D11ShaderResourceView*> _ds_shader_resources;
    std::unordered_map<uint32_t, ID3D11Buffer*> _ds_constant_buffers;
    std::unordered_map<uint32_t, ID3D11SamplerState*> _ds_samplers;

	std::unordered_map<uint32_t, ID3D11ShaderResourceView*> _ps_shader_resources;
	std::unordered_map<uint32_t, ID3D11Buffer*> _ps_constant_buffers;
	std::unordered_map<uint32_t, ID3D11SamplerState*> _ps_samplers;
	std::unordered_map<uint32_t, ID3D11UnorderedAccessView*> _ps_unordered_access_views;

	std::unordered_map<uint32_t, ID3D11ShaderResourceView*> _cs_shader_resources;
	std::unordered_map<uint32_t, ID3D11Buffer*> _cs_constant_buffers;
	std::unordered_map<uint32_t, ID3D11SamplerState*> _cs_samplers;
	std::unordered_map<uint32_t, ID3D11UnorderedAccessView*> _cs_unordered_access_views;
};


void PipelineState::SetVertexShader(ID3D11VertexShader* vertex_shader)
{
	// don't overwrite the stored state
	if (!_saved_vertex_shader)
	{
		_vertex_shader = vertex_shader;
		_saved_vertex_shader = true;
	}
	else if (vertex_shader != nullptr)
	{
		vertex_shader->Release();
	}
}
void PipelineState::SetDomainShader(ID3D11DomainShader* domain_shader)
{
    if (!_saved_domain_shader)
    {
        _domain_shader = domain_shader;
        _saved_domain_shader = true;
    }
    else if (domain_shader != nullptr)
    {
        domain_shader->Release();
    }
}
void PipelineState::SetPixelShader(ID3D11PixelShader* pixel_shader)
{
	if (!_saved_pixel_shader)
	{
		_pixel_shader = pixel_shader;
		_saved_pixel_shader = true;
	}
	else if (pixel_shader != nullptr)
	{
		pixel_shader->Release();
	}
}
void PipelineState::SetComputeShader(ID3D11ComputeShader* compute_shader)
{
	if (!_saved_compute_shader)
	{
		_compute_shader = compute_shader;
		_saved_compute_shader = true;
	}
	else if (compute_shader != nullptr)
	{
		compute_shader->Release();
	}
}
void PipelineState::SetVSShaderResource(uint32_t slot, ID3D11ShaderResourceView* shader_resource_view)
{
	auto it = _vs_shader_resources.find(slot);
	if (it == _vs_shader_resources.end())
	{
		_vs_shader_resources[slot] = shader_resource_view;
	}
	else if (shader_resource_view != nullptr)
	{
		shader_resource_view->Release();
	}
}
void PipelineState::SetVSConstantBuffer(uint32_t slot, ID3D11Buffer* constant_buffer)
{
	auto it = _vs_constant_buffers.find(slot);
	if (it == _vs_constant_buffers.end())
	{
		_vs_constant_buffers[slot] = constant_buffer;
	}
	else if (constant_buffer != nullptr)
	{
		constant_buffer->Release();
	}
}
void PipelineState::SetVSSampler(uint32_t slot, ID3D11SamplerState* sampler)
{
	auto it = _vs_samplers.find(slot);
	if (it == _vs_samplers.end())
	{
		_vs_samplers[slot] = sampler;
	}
	else if (sampler != nullptr)
	{
		sampler->Release();
	}
}
void PipelineState::SetDSShaderResource(uint32_t slot, ID3D11ShaderResourceView* shader_resource_view)
{
    auto it = _ds_shader_resources.find(slot);
    if (it == _ds_shader_resources.end())
    {
        _ds_shader_resources[slot] = shader_resource_view;
    }
    else if (shader_resource_view != nullptr)
    {
        shader_resource_view->Release();
    }
}
void PipelineState::SetDSConstantBuffer(uint32_t slot, ID3D11Buffer* constant_buffer)
{
    auto it = _ds_constant_buffers.find(slot);
    if (it == _ds_constant_buffers.end())
    {
        _ds_constant_buffers[slot] = constant_buffer;
    }
    else if (constant_buffer != nullptr)
    {
        constant_buffer->Release();
    }
}
void PipelineState::SetDSSampler(uint32_t slot, ID3D11SamplerState* sampler)
{
    auto it = _ds_samplers.find(slot);
    if (it == _ds_samplers.end())
    {
        _ds_samplers[slot] = sampler;
    }
    else if (sampler != nullptr)
    {
        sampler->Release();
    }
}
void PipelineState::SetPSShaderResource(uint32_t slot, ID3D11ShaderResourceView* shader_resource_view)
{
	auto it = _ps_shader_resources.find(slot);
	if (it == _ps_shader_resources.end())
	{
		_ps_shader_resources[slot] = shader_resource_view;
	}
	else if (shader_resource_view != nullptr)
	{
		shader_resource_view->Release();
	}
}
void PipelineState::SetPSConstantBuffer(uint32_t slot, ID3D11Buffer* constant_buffer)
{
	auto it = _ps_constant_buffers.find(slot);
	if (it == _ps_constant_buffers.end())
	{
		_ps_constant_buffers[slot] = constant_buffer;
	}
	else if (constant_buffer != nullptr)
	{
		constant_buffer->Release();
	}
}
void PipelineState::SetPSSampler(uint32_t slot, ID3D11SamplerState* sampler)
{
	auto it = _ps_samplers.find(slot);
	if (it == _ps_samplers.end())
	{
		_ps_samplers[slot] = sampler;
	}
	else if (sampler != nullptr)
	{
		sampler->Release();
	}
}
void PipelineState::SetPSUnorderedAccessViews(uint32_t slot, ID3D11UnorderedAccessView* uav)
{
	auto it = _ps_unordered_access_views.find(slot);
	if (it == _ps_unordered_access_views.end())
	{
		_ps_unordered_access_views[slot] = uav;
	}
	else if (uav != nullptr)
	{
		uav->Release();
	}
}
void PipelineState::SetCSShaderResource(uint32_t slot, ID3D11ShaderResourceView* shader_resource_view)
{
	auto it = _cs_shader_resources.find(slot);
	if (it == _cs_shader_resources.end())
	{
		_cs_shader_resources[slot] = shader_resource_view;
	}
	else if (shader_resource_view != nullptr)
	{
		shader_resource_view->Release();
	}
}
void PipelineState::SetCSConstantBuffer(uint32_t slot, ID3D11Buffer* constant_buffer)
{
	auto it = _cs_constant_buffers.find(slot);
	if (it == _cs_constant_buffers.end())
	{
		_cs_constant_buffers[slot] = constant_buffer;
	}
	else if (constant_buffer != nullptr)
	{
		constant_buffer->Release();
	}
}
void PipelineState::SetCSSampler(uint32_t slot, ID3D11SamplerState* sampler)
{
	auto it = _cs_samplers.find(slot);
	if (it == _cs_samplers.end())
	{
		_cs_samplers[slot] = sampler;
	}
	else if (sampler != nullptr)
	{
		sampler->Release();
	}
}
void PipelineState::SetCSUnorderedAccessViews(uint32_t slot, ID3D11UnorderedAccessView* uav)
{
	auto it = _cs_unordered_access_views.find(slot);
	if (it == _cs_unordered_access_views.end())
	{
		_cs_unordered_access_views[slot] = uav;
	}
	else if (uav != nullptr)
	{
		uav->Release();
	}
}
void PipelineState::Clear()
{
    _saved_vertex_shader = false;
    _vertex_shader = nullptr;
    _saved_domain_shader = false;
    _domain_shader = nullptr;
    _saved_pixel_shader = false;
    _pixel_shader = nullptr;
    _saved_compute_shader = false;
    _compute_shader = nullptr;

    _vs_shader_resources.clear();
    _vs_constant_buffers.clear();
    _vs_samplers.clear();

    _ds_shader_resources.clear();
    _ds_constant_buffers.clear();
    _ds_samplers.clear();

    _ps_shader_resources.clear();
    _ps_constant_buffers.clear();
    _ps_samplers.clear();
    _ps_unordered_access_views.clear();

    _cs_shader_resources.clear();
    _cs_constant_buffers.clear();
    _cs_samplers.clear();
    _cs_unordered_access_views.clear();
}
void PipelineState::RestoreState()
{
	ID3D11DeviceContext* d3d_context = GetD3DContext();
	if (_saved_vertex_shader)
	{
		d3d_context->VSSetShader(_vertex_shader, nullptr, 0);
	}
    if (_saved_domain_shader)
    {
        d3d_context->DSSetShader(_domain_shader, nullptr, 0);
    }
	if (_saved_pixel_shader)
	{
		d3d_context->PSSetShader(_pixel_shader, nullptr, 0);
	}
	if (_saved_compute_shader)
	{
		d3d_context->CSSetShader(_compute_shader, nullptr, 0);
	}

	// restore vertex shader bindings
	for (auto& vs_shader_resource : _vs_shader_resources)
	{
		d3d_context->VSSetShaderResources(vs_shader_resource.first, 1, &vs_shader_resource.second);
		if (vs_shader_resource.second != nullptr)
		{
			vs_shader_resource.second->Release();
		}
	}
	for (auto& vs_constant_buffer : _vs_constant_buffers)
	{
		d3d_context->VSSetConstantBuffers(vs_constant_buffer.first, 1, &vs_constant_buffer.second);
		if (vs_constant_buffer.second != nullptr)
		{
			vs_constant_buffer.second->Release();
		}
	}
	for (auto& vs_sampler : _vs_samplers)
	{
		d3d_context->VSSetSamplers(vs_sampler.first, 1, &vs_sampler.second);
		if (vs_sampler.second != nullptr) 
		{
			vs_sampler.second->Release();
		}
	}

    // restore domain shader bindings
    for (auto& ds_shader_resource : _ds_shader_resources)
    {
        d3d_context->DSSetShaderResources(ds_shader_resource.first, 1, &ds_shader_resource.second);
        if (ds_shader_resource.second != nullptr)
        {
            ds_shader_resource.second->Release();
        }
    }
    for (auto& ds_constant_buffer : _ds_constant_buffers)
    {
        d3d_context->DSSetConstantBuffers(ds_constant_buffer.first, 1, &ds_constant_buffer.second);
        if (ds_constant_buffer.second != nullptr)
        {
            ds_constant_buffer.second->Release();
        }
    }
    for (auto& ds_sampler : _ds_samplers)
    {
        d3d_context->DSSetSamplers(ds_sampler.first, 1, &ds_sampler.second);
        if (ds_sampler.second != nullptr)
        {
            ds_sampler.second->Release();
        }
    }

	// restore pixel shader bindings
	for (auto& ps_shader_resource : _ps_shader_resources)
	{
		d3d_context->PSSetShaderResources(ps_shader_resource.first, 1, &ps_shader_resource.second);
		if (ps_shader_resource.second != nullptr)
		{
			ps_shader_resource.second->Release();
		}
	}
	for (auto& ps_constant_buffer : _ps_constant_buffers)
	{
		d3d_context->PSSetConstantBuffers(ps_constant_buffer.first, 1, &ps_constant_buffer.second);
		if (ps_constant_buffer.second != nullptr)
		{
			ps_constant_buffer.second->Release();
		}
	}
	for (auto& ps_sampler : _ps_samplers)
	{
		d3d_context->PSSetSamplers(ps_sampler.first, 1, &ps_sampler.second);
		if (ps_sampler.second != nullptr) 
		{
			ps_sampler.second->Release();
		}
	}
	for (auto& ps_uav : _ps_unordered_access_views)
	{
		d3d_context->OMSetRenderTargetsAndUnorderedAccessViews(D3D11_KEEP_RENDER_TARGETS_AND_DEPTH_STENCIL, nullptr, nullptr, ps_uav.first, 1, &ps_uav.second, nullptr);
		if (ps_uav.second != nullptr)
		{
			ps_uav.second->Release();
		}
	}

	// restore compute shader bindings
	for (auto& cs_shader_resource : _cs_shader_resources)
	{
		d3d_context->CSSetShaderResources(cs_shader_resource.first, 1, &cs_shader_resource.second);
		if (cs_shader_resource.second != nullptr) 
		{
			cs_shader_resource.second->Release();
		}
	}
	for (auto& cs_constant_buffer : _cs_constant_buffers)
	{
		d3d_context->CSSetConstantBuffers(cs_constant_buffer.first, 1, &cs_constant_buffer.second);
		if (cs_constant_buffer.second != nullptr)
		{
			cs_constant_buffer.second->Release();
		}
	}
	for (auto& cs_sampler : _cs_samplers)
	{
		d3d_context->CSSetSamplers(cs_sampler.first, 1, &cs_sampler.second);
		if (cs_sampler.second != nullptr)
		{
			cs_sampler.second->Release();
		}
	}
	for (auto& cs_uav : _cs_unordered_access_views)
	{
		d3d_context->CSSetUnorderedAccessViews(cs_uav.first, 1, &cs_uav.second, nullptr);
		if (cs_uav.second != nullptr)
		{
			cs_uav.second->Release();
		}
	}

    Clear();
}


PipelineStateManager::PipelineStateManager(ResourceManager& resource_manager) : _resource_manager(resource_manager),
                                                                                _current_bound_vertex_shader(nullptr),
                                                                                _current_bound_domain_shader(nullptr),
                                                                                _current_bound_pixel_shader(nullptr),
                                                                                _current_bound_compute_shader(nullptr),
                                                                                _original_pipeline_state(new PipelineState())
{
}
void PipelineStateManager::SetGlobalTexture(StringIdHash texture_file_name, StringIdHash shader_texture_name)
{
	auto* srv = _resource_manager.GetTextureShaderResourceView(texture_file_name);
	SetGlobalShaderResource(srv, shader_texture_name);
}
void PipelineStateManager::SetGlobalShaderResource(ID3D11ShaderResourceView* shader_resource_view, uint64_t name_string_id)
{
	_global_shader_resources[name_string_id] = shader_resource_view;
}
void PipelineStateManager::SetGlobalConstantBuffer(ID3D11Buffer* constant_buffer, uint64_t name_string_id)
{
	_global_constant_buffers[name_string_id] = constant_buffer;
}
void PipelineStateManager::BindShader(uint64_t shader_name_string_id)
{
	Shader* shader = _resource_manager.GetShader(shader_name_string_id);
	if (shader != nullptr)
	{
		switch (shader->GetType())
		{
		case SHADER_TYPE_VERTEX:
			_current_bound_vertex_shader = shader;
			{
				ID3D11VertexShader* vertex_shader;
				GetD3DContext()->VSGetShader(&vertex_shader, nullptr, nullptr);
				_original_pipeline_state->SetVertexShader(vertex_shader);
			}
			break;
		case SHADER_TYPE_HULL:
            assert(false);
            break;
		case SHADER_TYPE_DOMAIN:
            _current_bound_domain_shader = shader;
            {
                ID3D11DomainShader* domain_shader;
                GetD3DContext()->DSGetShader(&domain_shader, nullptr, nullptr);
                _original_pipeline_state->SetDomainShader(domain_shader);
            }
            break;
		case SHADER_TYPE_GEOMETRY:
			assert(false);
			break;
		case SHADER_TYPE_PIXEL:
			_current_bound_pixel_shader = shader;
			{
				ID3D11PixelShader* pixel_shader;
				GetD3DContext()->PSGetShader(&pixel_shader, nullptr, nullptr);
				_original_pipeline_state->SetPixelShader(pixel_shader);
			}
			break;
		case SHADER_TYPE_COMPUTE:
			_current_bound_compute_shader = shader;
			{
				ID3D11ComputeShader* compute_shader;
				GetD3DContext()->CSGetShader(&compute_shader, nullptr, nullptr);
				_original_pipeline_state->SetComputeShader(compute_shader);
			}
			break;
		default:
			break;
		}
		shader->Bind();
	}
}
void PipelineStateManager::BindResourcesForCurrentShaders(AUTO_BIND auto_bind_flags)
{
	//assert(_saved_original_pipeline_state);
	
	if (auto_bind_flags & AUTO_BIND_SHADER_RESOURCE_VIEWS) 
	{
		BindGlobalShaderResources();
	}
	if (auto_bind_flags & AUTO_BIND_CONSTANT_BUFFERS) 
	{
		BindGlobalConstantBuffers();
	}
	if (auto_bind_flags & AUTO_BIND_SAMPLERS) 
	{
		BindSamplers();
	}
}
void PipelineStateManager::RestoreOriginalPipelineState()
{
	_original_pipeline_state->RestoreState();
	_current_bound_vertex_shader = nullptr;
    _current_bound_domain_shader = nullptr;
	_current_bound_pixel_shader = nullptr;
	_current_bound_compute_shader = nullptr;
}
void PipelineStateManager::SetShaderResourceView(ID3D11ShaderResourceView* shader_resource_view, SHADER_TYPE shader_type, UINT slot)
{
	ID3D11DeviceContext* d3d_context = GetD3DContext();
	ID3D11ShaderResourceView* srvs[] = {shader_resource_view};
	switch (shader_type)
	{
	case SHADER_TYPE_VERTEX:
		{
			ID3D11ShaderResourceView* srv;
			d3d_context->VSGetShaderResources(slot, 1, &srv);
			_original_pipeline_state->SetVSShaderResource(slot, srv);
		}
		d3d_context->VSSetShaderResources(slot, 1, srvs);
		break;
	case SHADER_TYPE_HULL:
        assert(false);
        break;
	case SHADER_TYPE_DOMAIN:
        {
            ID3D11ShaderResourceView* srv;
            d3d_context->DSGetShaderResources(slot, 1, &srv);
            _original_pipeline_state->SetDSShaderResource(slot, srv);
        }
        d3d_context->DSSetShaderResources(slot, 1, srvs);
        break;
	case SHADER_TYPE_GEOMETRY:
		assert(false);
		break;
	case SHADER_TYPE_PIXEL:
		{
			ID3D11ShaderResourceView* srv;
			d3d_context->PSGetShaderResources(slot, 1, &srv);
			_original_pipeline_state->SetPSShaderResource(slot, srv);
		}
		d3d_context->PSSetShaderResources(slot, 1, srvs);
		break;
	case SHADER_TYPE_COMPUTE:
		{
			ID3D11ShaderResourceView* srv;
			d3d_context->CSGetShaderResources(slot, 1, &srv);
			_original_pipeline_state->SetCSShaderResource(slot, srv);
		}
		d3d_context->CSSetShaderResources(slot, 1, srvs);
		break;
	}
}
void PipelineStateManager::SetUnorderedAccessView(ID3D11UnorderedAccessView* unordered_access_view, SHADER_TYPE shader_type, UINT slot)
{	
	ID3D11DeviceContext* d3d_context = GetD3DContext();
	ID3D11UnorderedAccessView* uavs[] = {unordered_access_view};
	switch (shader_type)
	{
	case SHADER_TYPE_VERTEX:
	case SHADER_TYPE_HULL:
	case SHADER_TYPE_DOMAIN:
	case SHADER_TYPE_GEOMETRY:
		assert(false);
		break;
	case SHADER_TYPE_PIXEL:
		{
			ID3D11UnorderedAccessView* uav;
			d3d_context->OMGetRenderTargetsAndUnorderedAccessViews(0, nullptr, nullptr, slot, 1, &uav);
			_original_pipeline_state->SetPSUnorderedAccessViews(slot, uav);
		}
		d3d_context->OMSetRenderTargetsAndUnorderedAccessViews(
			D3D11_KEEP_RENDER_TARGETS_AND_DEPTH_STENCIL, nullptr, nullptr, slot, 1, uavs, nullptr);
		break;
	case SHADER_TYPE_COMPUTE:
		{
			ID3D11UnorderedAccessView* uav;
			d3d_context->CSGetUnorderedAccessViews(slot, 1, &uav);
			_original_pipeline_state->SetCSUnorderedAccessViews(slot, uav);
		}
		d3d_context->CSSetUnorderedAccessViews(slot, 1, uavs, nullptr);
		break;
	}
}
void PipelineStateManager::SetSamplerState(ID3D11SamplerState* sampler_state, SHADER_TYPE shader_type, UINT slot)
{
    ID3D11DeviceContext* d3d_context = GetD3DContext();
    ID3D11SamplerState* sampler_states[] = { sampler_state };
    switch (shader_type)
    {
    case SHADER_TYPE_VERTEX:
    {
        ID3D11SamplerState* orig_sampler;
        d3d_context->VSGetSamplers(slot, 1, &orig_sampler);
        _original_pipeline_state->SetVSSampler(slot, orig_sampler);
        d3d_context->VSSetSamplers(slot, 1, sampler_states);
    }
    break;
    case SHADER_TYPE_HULL:
        assert(false);
        break;
    case SHADER_TYPE_DOMAIN:
        {
            ID3D11SamplerState* orig_sampler;
            d3d_context->DSGetSamplers(slot, 1, &orig_sampler);
            _original_pipeline_state->SetDSSampler(slot, orig_sampler);
            d3d_context->DSSetSamplers(slot, 1, sampler_states);
        }
        break;
    case SHADER_TYPE_GEOMETRY:
        assert(false);
        break;
    case SHADER_TYPE_PIXEL:
    {
        ID3D11SamplerState* orig_sampler;
        d3d_context->PSGetSamplers(slot, 1, &orig_sampler);
        _original_pipeline_state->SetPSSampler(slot, orig_sampler);
        d3d_context->PSSetSamplers(slot, 1, sampler_states);
    }
    break;
    case SHADER_TYPE_COMPUTE:
    {
        ID3D11SamplerState* orig_sampler;
        d3d_context->CSGetSamplers(slot, 1, &orig_sampler);
        _original_pipeline_state->SetCSSampler(slot, orig_sampler);
        d3d_context->CSSetSamplers(slot, 1, sampler_states);
    }
    break;
    }
}
void PipelineStateManager::Clear()
{
    _original_pipeline_state->Clear();
    _current_bound_vertex_shader = nullptr;
    _current_bound_domain_shader = nullptr;
    _current_bound_pixel_shader = nullptr;
    _current_bound_compute_shader = nullptr;
}
void PipelineStateManager::BindGlobalShaderResources()
{
	ID3D11DeviceContext* d3d_context = GetD3DContext();
	// vertex shader SRVs
	if (_current_bound_vertex_shader != nullptr) {
		auto current_vertex_shader_textures = _current_bound_vertex_shader->GetReflectedTextures();

		for (const auto& texture_name_slot : current_vertex_shader_textures)
		{
			auto it = _global_shader_resources.find(texture_name_slot.first);
			if (it != _global_shader_resources.end())
			{
				// save original SRV
				ID3D11ShaderResourceView* orig_srv;
				d3d_context->VSGetShaderResources(texture_name_slot.second, 1, &orig_srv);
				_original_pipeline_state->SetVSShaderResource(texture_name_slot.second, orig_srv);

				// set reflected SRV
				d3d_context->VSSetShaderResources(texture_name_slot.second, 1, &it->second);
			}
		}
	}

    // domain shader SRVs
    if (_current_bound_domain_shader != nullptr) {
        auto current_domain_shader_textures = _current_bound_domain_shader->GetReflectedTextures();

        for (const auto& texture_name_slot : current_domain_shader_textures)
        {
            auto it = _global_shader_resources.find(texture_name_slot.first);
            if (it != _global_shader_resources.end())
            {
                // save original SRV
                ID3D11ShaderResourceView* orig_srv;
                d3d_context->DSGetShaderResources(texture_name_slot.second, 1, &orig_srv);
                _original_pipeline_state->SetDSShaderResource(texture_name_slot.second, orig_srv);

                // set reflected SRV
                d3d_context->DSSetShaderResources(texture_name_slot.second, 1, &it->second);
            }
        }
    }
	
	// pixel shader SRVs
	if (_current_bound_pixel_shader != nullptr) {
		auto current_pixel_shader_textures = _current_bound_pixel_shader->GetReflectedTextures();

		for (const auto& texture_name_slot : current_pixel_shader_textures)
		{
			auto it = _global_shader_resources.find(texture_name_slot.first);
			if (it != _global_shader_resources.end())
			{
				// save original SRV
				ID3D11ShaderResourceView* orig_srv;
				d3d_context->PSGetShaderResources(texture_name_slot.second, 1, &orig_srv);
				_original_pipeline_state->SetPSShaderResource(texture_name_slot.second, orig_srv);

				// set reflected SRV
				d3d_context->PSSetShaderResources(texture_name_slot.second, 1, &it->second);
			}
		}
	}
	// compute shader SRVs
	if (_current_bound_compute_shader != nullptr) {
		auto current_compute_shader_textures = _current_bound_compute_shader->GetReflectedTextures();

		for (const auto& texture_name_slot : current_compute_shader_textures)
		{
			auto it = _global_shader_resources.find(texture_name_slot.first);
			if (it != _global_shader_resources.end())
			{
				// save original SRV
				ID3D11ShaderResourceView* orig_srv;
				d3d_context->CSGetShaderResources(texture_name_slot.second, 1, &orig_srv);
				_original_pipeline_state->SetCSShaderResource(texture_name_slot.second, orig_srv);

				// set reflected SRV
				d3d_context->CSSetShaderResources(texture_name_slot.second, 1, &it->second);
			}
		}
	}
}
void PipelineStateManager::BindGlobalConstantBuffers()
{
	ID3D11DeviceContext* d3d_context = GetD3DContext();
	// vertex shader constant buffers
	if (_current_bound_vertex_shader != nullptr) {
		auto current_vertex_shader_cbuffers = _current_bound_vertex_shader->GetReflectedConstantBuffers();

		for (const auto& cbuffer_name_slot : current_vertex_shader_cbuffers)
		{
			auto it = _global_constant_buffers.find(cbuffer_name_slot.first);
			if (it != _global_constant_buffers.end())
			{
				// save original constant buffer
				ID3D11Buffer* orig_cbuffers;
				d3d_context->VSGetConstantBuffers(cbuffer_name_slot.second, 1, &orig_cbuffers);
				_original_pipeline_state->SetVSConstantBuffer(cbuffer_name_slot.second, orig_cbuffers);

				// set reflected constant buffer
				d3d_context->VSSetConstantBuffers(cbuffer_name_slot.second, 1, &it->second);
			}
		}
	}
    // domain shader constant buffers
    if (_current_bound_domain_shader != nullptr) {
        auto current_domain_shader_cbuffers = _current_bound_domain_shader->GetReflectedConstantBuffers();

        for (const auto& cbuffer_name_slot : current_domain_shader_cbuffers)
        {
            auto it = _global_constant_buffers.find(cbuffer_name_slot.first);
            if (it != _global_constant_buffers.end())
            {
                // save original constant buffer
                ID3D11Buffer* orig_cbuffers;
                d3d_context->DSGetConstantBuffers(cbuffer_name_slot.second, 1, &orig_cbuffers);
                _original_pipeline_state->SetDSConstantBuffer(cbuffer_name_slot.second, orig_cbuffers);

                // set reflected constant buffer
                d3d_context->DSSetConstantBuffers(cbuffer_name_slot.second, 1, &it->second);
            }
        }
    }
	// pixel shader constant buffers
	if (_current_bound_pixel_shader != nullptr) {
		auto current_pixel_shader_cbuffers = _current_bound_pixel_shader->GetReflectedConstantBuffers();

		for (const auto& cbuffer_name_slot : current_pixel_shader_cbuffers)
		{
			auto it = _global_constant_buffers.find(cbuffer_name_slot.first);
			if (it != _global_constant_buffers.end())
			{
				// save original constant buffer
				ID3D11Buffer* orig_cbuffers;
				d3d_context->PSGetConstantBuffers(cbuffer_name_slot.second, 1, &orig_cbuffers);
				_original_pipeline_state->SetPSConstantBuffer(cbuffer_name_slot.second, orig_cbuffers);

				// set reflected constant buffer
				d3d_context->PSSetConstantBuffers(cbuffer_name_slot.second, 1, &it->second);
			}
		}
	}
	// compute shader constant buffers
	if (_current_bound_compute_shader != nullptr) {
		auto current_compute_shader_cbuffers = _current_bound_compute_shader->GetReflectedConstantBuffers();

		for (const auto& cbuffer_name_slot : current_compute_shader_cbuffers)
		{
			auto it = _global_constant_buffers.find(cbuffer_name_slot.first);
			if (it != _global_constant_buffers.end())
			{
				// save original constant buffer
				ID3D11Buffer* orig_cbuffers;
				d3d_context->CSGetConstantBuffers(cbuffer_name_slot.second, 1, &orig_cbuffers);
				_original_pipeline_state->SetCSConstantBuffer(cbuffer_name_slot.second, orig_cbuffers);

				// set reflected constant buffer
				d3d_context->CSSetConstantBuffers(cbuffer_name_slot.second, 1, &it->second);
			}
		}
	}
}
void PipelineStateManager::BindSamplers()
{
	ID3D11DeviceContext* d3d_context = GetD3DContext();
	// vertex shader samplers
	if (_current_bound_vertex_shader != nullptr) {
		auto current_vertex_shader_samplers = _current_bound_vertex_shader->GetReflectedSamplers();

		for (const auto& sampler_slot : current_vertex_shader_samplers)
		{
			// save original sampler
			ID3D11SamplerState* orig_sampler;
			d3d_context->VSGetSamplers(sampler_slot.second, 1, &orig_sampler);
			_original_pipeline_state->SetVSSampler(sampler_slot.second, orig_sampler);

			// set reflected sampler
			_sampler_manager.BindSampler(sampler_slot.second, SHADER_TYPE_VERTEX, sampler_slot.first);
		}
	}

    // domain shader samplers
    if (_current_bound_domain_shader != nullptr) {
        auto current_domain_shader_samplers = _current_bound_domain_shader->GetReflectedSamplers();

        for (const auto& sampler_slot : current_domain_shader_samplers)
        {
            // save original sampler
            ID3D11SamplerState* orig_sampler;
            d3d_context->DSGetSamplers(sampler_slot.second, 1, &orig_sampler);
            _original_pipeline_state->SetDSSampler(sampler_slot.second, orig_sampler);

            // set reflected sampler
            _sampler_manager.BindSampler(sampler_slot.second, SHADER_TYPE_DOMAIN, sampler_slot.first);
        }
    }

	// pixel shader samplers
	if (_current_bound_pixel_shader != nullptr) {
		auto current_pixel_shader_samplers = _current_bound_pixel_shader->GetReflectedSamplers();

		for (const auto& sampler_slot : current_pixel_shader_samplers)
		{
			// save original sampler
			ID3D11SamplerState* orig_sampler;
			d3d_context->PSGetSamplers(sampler_slot.second, 1, &orig_sampler);
			_original_pipeline_state->SetPSSampler(sampler_slot.second, orig_sampler);

			// set reflected sampler
			_sampler_manager.BindSampler(sampler_slot.second, SHADER_TYPE_PIXEL, sampler_slot.first);
		}
	}

	// compute shader samplers
	if (_current_bound_compute_shader != nullptr) {
		auto current_compute_shader_samplers = _current_bound_compute_shader->GetReflectedSamplers();

		for (const auto& sampler_slot : current_compute_shader_samplers)
		{
			// save original sampler
			ID3D11SamplerState* orig_sampler;
			d3d_context->CSGetSamplers(sampler_slot.second, 1, &orig_sampler);
			_original_pipeline_state->SetCSSampler(sampler_slot.second, orig_sampler);

			// set reflected sampler
			_sampler_manager.BindSampler(sampler_slot.second, SHADER_TYPE_COMPUTE, sampler_slot.first);
		}
	}
}
