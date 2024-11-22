#include "sampler.h"
#include "shader.h"

using namespace w3;

void Sampler::Bind(int slot, const SHADER_TYPE& target_shader)
{
	switch (target_shader)
	{
	case SHADER_TYPE::SHADER_TYPE_VERTEX:
		GetD3DContext()->VSSetSamplers(slot, 1, d3d_sampler.GetAddressOf());
		break;
	case SHADER_TYPE::SHADER_TYPE_HULL:
		GetD3DContext()->HSSetSamplers(slot, 1, d3d_sampler.GetAddressOf());
		break;
	case SHADER_TYPE::SHADER_TYPE_DOMAIN:
		GetD3DContext()->DSSetSamplers(slot, 1, d3d_sampler.GetAddressOf());
		break;
	case SHADER_TYPE::SHADER_TYPE_GEOMETRY:
		GetD3DContext()->GSSetSamplers(slot, 1, d3d_sampler.GetAddressOf());
		break;
	case SHADER_TYPE::SHADER_TYPE_PIXEL:
		GetD3DContext()->PSSetSamplers(slot, 1, d3d_sampler.GetAddressOf());
		break;
	case SHADER_TYPE::SHADER_TYPE_COMPUTE:
		GetD3DContext()->CSSetSamplers(slot, 1, d3d_sampler.GetAddressOf());
		break;
	default:
		break;
	}
}
void Sampler::create(D3D11_FILTER d3d_filter)
{
	D3D11_SAMPLER_DESC desc = {};
    desc.MinLOD = 0;
    desc.MaxLOD = D3D11_FLOAT32_MAX;
	desc.Filter = d3d_filter;
	desc.AddressU = D3D11_TEXTURE_ADDRESS_CLAMP;
	desc.AddressV = D3D11_TEXTURE_ADDRESS_CLAMP;
	desc.AddressW = D3D11_TEXTURE_ADDRESS_CLAMP;
	desc.MipLODBias = 0;
	desc.MaxAnisotropy = 0;
	desc.ComparisonFunc = D3D11_COMPARISON_NEVER;
	desc.BorderColor[0] = 0;
	desc.BorderColor[1] = 0;
	desc.BorderColor[2] = 0;
	desc.BorderColor[3] = 1;
	HR(GetD3DDevice()->CreateSamplerState(&desc, d3d_sampler.GetAddressOf()));
}
void Sampler::release()
{
	d3d_sampler.Reset();
}
void SamplerManager::BindSampler(int slot, const SHADER_TYPE& target_shader, const SamplerDescription& sampler_description)
{
	auto it = _samplers.find(sampler_description);
	ID3D11SamplerState* sampler = nullptr;
	if (it == _samplers.end())
	{
		D3D11_SAMPLER_DESC desc = {};
        desc.MinLOD = 0;
        desc.MaxLOD = D3D11_FLOAT32_MAX;
		desc.Filter = sampler_description.filter;
		desc.AddressU = sampler_description.address_mode;
		desc.AddressV = sampler_description.address_mode;
		desc.AddressW = sampler_description.address_mode;
		desc.MipLODBias = 0;
		desc.MaxAnisotropy = 16;
		desc.ComparisonFunc = sampler_description.comparison_func;
		HR(GetD3DDevice()->CreateSamplerState(&desc, &sampler));
		_samplers[sampler_description] = sampler;
	}
	else
	{
		sampler = it->second;
	}

	switch (target_shader)
	{
	case SHADER_TYPE_VERTEX:
		GetD3DContext()->VSSetSamplers(slot, 1, &sampler);
		break;
	case SHADER_TYPE_HULL:
		GetD3DContext()->HSSetSamplers(slot, 1, &sampler);
		break;
	case SHADER_TYPE_DOMAIN:
		GetD3DContext()->DSSetSamplers(slot, 1, &sampler);
		break;
	case SHADER_TYPE_GEOMETRY:
		GetD3DContext()->GSSetSamplers(slot, 1, &sampler);
		break;
	case SHADER_TYPE_PIXEL:
		GetD3DContext()->PSSetSamplers(slot, 1, &sampler);
		break;
	case SHADER_TYPE_COMPUTE:
		GetD3DContext()->CSSetSamplers(slot, 1, &sampler);
		break;
	}
	
}
