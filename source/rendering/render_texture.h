#pragma once
#include "d3d_interface.h"
#include "shader.h"
#include "core/tuple_hash.h"

#include "wrl/client.h"
#include <dxgi.h>

#include <cstdint>
#include <vector>


namespace w3
{
enum RENDER_TEXTURE_BIND : uint8_t
{
	RENDER_TEXTURE_BIND_SRV = 0x1,
	RENDER_TEXTURE_BIND_UAV = 0x2,
	RENDER_TEXTURE_BIND_RTV = 0x4
};

struct RenderTextureDescription
{
	DXGI_FORMAT format;
	uint8_t bind_flags = 0;
	uint32_t width = 8;
	uint32_t height = 8;
	uint32_t depth = 0;
	uint8_t mip_levels = 1;
};

class RenderTexture : D3DInterface
{
public:
	RenderTexture(DXGI_FORMAT format, uint8_t bind_flags, int scale = 1);
	RenderTexture(DXGI_FORMAT format, uint8_t bind_flags, int scale, UINT mip_levels);
	bool Create(int width, int height, int depth = 0, bool generate_mips = false);
	void Release();
	void CopyFromSRV(ID3D11DeviceContext* d3d_context, int source_slot, SHADER_TYPE source_shader);

    ID3D11Resource* GetResource() const;
	ID3D11ShaderResourceView* GetShaderResourceView() const;
	ID3D11UnorderedAccessView* GetUnorderedAccessView(uint8_t mip_slice = 0) const;
	ID3D11RenderTargetView* GetRenderTargetView(uint8_t mip_slice = 0) const;

	static RenderTexture* GetTemporary(DXGI_FORMAT format, uint8_t bind_flags, uint32_t width, uint32_t height, uint32_t depth = 0);
	static RenderTexture* GetTemporary(const RenderTextureDescription& description);
	static void ReleaseTemporary(RenderTexture* temporary_render_texture);
	static void OnPresent();
private:
	static std::unordered_map<std::tuple<DXGI_FORMAT, uint8_t, uint32_t, uint32_t, uint32_t, uint8_t>, std::vector<std::pair<RenderTexture*, int>>, TupleHasher<DXGI_FORMAT, uint8_t, uint32_t, uint32_t, uint32_t, uint8_t>> render_texture_pool;
	
	const DXGI_FORMAT _format;
	const uint8_t _bind_flags;
    uint32_t _width;
    uint32_t _height;
    uint32_t _depth;
	int _scale;
    UINT _mip_levels;
		
	Microsoft::WRL::ComPtr<ID3D11Resource> _resource;
	Microsoft::WRL::ComPtr<ID3D11ShaderResourceView> _shader_resource_view;
	std::vector<Microsoft::WRL::ComPtr<ID3D11RenderTargetView>> _render_target_views;
	std::vector<Microsoft::WRL::ComPtr<ID3D11UnorderedAccessView>> _unordered_access_views;
};

inline ID3D11Resource* RenderTexture::GetResource() const
{
    return _resource.Get();
}
inline ID3D11ShaderResourceView* RenderTexture::GetShaderResourceView() const
{
	return _shader_resource_view.Get();
}
inline ID3D11UnorderedAccessView* RenderTexture::GetUnorderedAccessView(uint8_t mip_slice) const
{
	return _unordered_access_views[mip_slice].Get();
}
inline ID3D11RenderTargetView* RenderTexture::GetRenderTargetView(uint8_t mip_slice) const
{
	return _render_target_views[mip_slice].Get();
}


}
