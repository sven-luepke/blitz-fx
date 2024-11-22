#pragma once
#include "d3d_interface.h"

#include <d3d11.h>
#include <tuple>
#include <unordered_map>
#include <wrl/client.h>

#include "core/tuple_hash.h"

namespace w3
{
struct SamplerDescription
{
	D3D11_FILTER filter = D3D11_FILTER_MIN_MAG_MIP_LINEAR;
	D3D11_TEXTURE_ADDRESS_MODE address_mode = D3D11_TEXTURE_ADDRESS_CLAMP;
    D3D11_COMPARISON_FUNC comparison_func = D3D11_COMPARISON_NEVER;
};

inline bool operator==(const SamplerDescription& sampler_description_left, const SamplerDescription& sampler_description_right)
{
	return sampler_description_left.filter == sampler_description_right.filter &&
		sampler_description_left.address_mode == sampler_description_right.address_mode;
}

struct SamplerDescriptionHasher : TupleHasher<D3D11_FILTER, D3D11_TEXTURE_ADDRESS_MODE>
{
	size_t operator()(const SamplerDescription& sampler_description) const
	{
		return TupleHasher<D3D11_FILTER, D3D11_TEXTURE_ADDRESS_MODE>::operator()(
			std::make_tuple(sampler_description.filter, sampler_description.address_mode)
		);
	}
};

enum SHADER_TYPE;

class Sampler : D3DInterface
{
	friend class SamplerManager;
public:
	void Bind(int slot, const SHADER_TYPE& target_shader);
private:
	void create(D3D11_FILTER d3d_filter);
	void release();

	Microsoft::WRL::ComPtr<ID3D11SamplerState> d3d_sampler;
};

class SamplerManager : D3DInterface
{
public:
	void BindSampler(int slot, const SHADER_TYPE& target_shader, const SamplerDescription& sampler_description);
private:
	std::unordered_map<SamplerDescription, ID3D11SamplerState*, SamplerDescriptionHasher> _samplers;
};


}
