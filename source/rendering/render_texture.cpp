#include "render_texture.h"
#include "shader.h"

#include <cmath>
#include <cassert>

using namespace w3;
using namespace Microsoft::WRL;

std::unordered_map<std::tuple<DXGI_FORMAT, uint8_t, uint32_t, uint32_t, uint32_t, uint8_t>, std::vector<std::pair<RenderTexture*, int>>,
                   TupleHasher<
                       DXGI_FORMAT, uint8_t, uint32_t, uint32_t, uint32_t, uint8_t>> RenderTexture::render_texture_pool;

RenderTexture::RenderTexture(DXGI_FORMAT format, uint8_t bind_flags, int scale)
    : _format{format}, _bind_flags(bind_flags), _scale(scale), _mip_levels(1), _render_target_views(_mip_levels),
      _unordered_access_views(_mip_levels)
{
}
RenderTexture::RenderTexture(DXGI_FORMAT format, uint8_t bind_flags, int scale, UINT mip_levels)
    : _format{format}, _bind_flags(bind_flags), _scale(scale), _mip_levels(mip_levels), _render_target_views(_mip_levels),
      _unordered_access_views(_mip_levels)
{
}
bool RenderTexture::Create(int width, int height, int depth, bool generate_mips)
{
    _width = max(width, 1);
    _height = max(height, 0);
    _depth = depth;
    UINT misc_flags = 0;
    if (generate_mips)
    {
        misc_flags |= D3D11_RESOURCE_MISC_GENERATE_MIPS;
    }
    if (depth != 0)
    {
        //assert(!(_bind_flags & BIND_RTV));
        D3D11_TEXTURE3D_DESC tex_3d_desc;
        tex_3d_desc.Width = width * _scale;
        tex_3d_desc.Height = height * _scale;
        tex_3d_desc.Depth = depth * _scale;
        tex_3d_desc.Format = _format;
        tex_3d_desc.MipLevels = _mip_levels;
        tex_3d_desc.Usage = D3D11_USAGE_DEFAULT;
        tex_3d_desc.BindFlags = 0;
        if (_bind_flags & RENDER_TEXTURE_BIND_SRV)
        {
            tex_3d_desc.BindFlags |= D3D11_BIND_SHADER_RESOURCE;
        }
        if (_bind_flags & RENDER_TEXTURE_BIND_UAV)
        {
            tex_3d_desc.BindFlags |= D3D11_BIND_UNORDERED_ACCESS;
        }
        tex_3d_desc.CPUAccessFlags = 0;
        tex_3d_desc.MiscFlags = misc_flags;
        HR(GetD3DDevice()->CreateTexture3D(&tex_3d_desc, nullptr, reinterpret_cast<ID3D11Texture3D**>(_resource.GetAddressOf())));
    }
    else
    {
        D3D11_TEXTURE2D_DESC tex_2d_desc;
        tex_2d_desc.Width = width * _scale;
        tex_2d_desc.Height = height * _scale;
        tex_2d_desc.MipLevels = _mip_levels;
        tex_2d_desc.ArraySize = 1;
        tex_2d_desc.Format = _format;
        tex_2d_desc.SampleDesc.Count = 1;
        tex_2d_desc.SampleDesc.Quality = 0;
        tex_2d_desc.Usage = D3D11_USAGE_DEFAULT;
        tex_2d_desc.BindFlags = 0;
        if (_bind_flags & RENDER_TEXTURE_BIND_RTV)
        {
            tex_2d_desc.BindFlags |= D3D11_BIND_RENDER_TARGET;
        }
        if (_bind_flags & RENDER_TEXTURE_BIND_SRV)
        {
            tex_2d_desc.BindFlags |= D3D11_BIND_SHADER_RESOURCE;
        }
        if (_bind_flags & RENDER_TEXTURE_BIND_UAV)
        {
            tex_2d_desc.BindFlags |= D3D11_BIND_UNORDERED_ACCESS;
        }
        tex_2d_desc.CPUAccessFlags = 0;
        tex_2d_desc.MiscFlags = misc_flags;
        HR(GetD3DDevice()->CreateTexture2D(&tex_2d_desc, nullptr, reinterpret_cast<ID3D11Texture2D**>(_resource.GetAddressOf())));
    }

    if (_bind_flags & RENDER_TEXTURE_BIND_RTV)
    {
        D3D11_RENDER_TARGET_VIEW_DESC rtvDesc;
        rtvDesc.Format = _format;
        rtvDesc.ViewDimension = D3D11_RTV_DIMENSION_TEXTURE2D;
        for (int i = 0; i < _mip_levels; i++)
        {
            rtvDesc.Texture2D.MipSlice = i;
            HR(GetD3DDevice()->CreateRenderTargetView(_resource.Get(), &rtvDesc, _render_target_views[i].GetAddressOf()));
        }
    }
    if (_bind_flags & RENDER_TEXTURE_BIND_SRV)
    {
        D3D11_SHADER_RESOURCE_VIEW_DESC srv_desc;
        srv_desc.Format = _format;
        if (depth != 0)
        {
            srv_desc.ViewDimension = D3D11_SRV_DIMENSION_TEXTURE3D;
            srv_desc.Texture3D.MipLevels = _mip_levels;
            srv_desc.Texture3D.MostDetailedMip = 0;
        }
        else
        {
            srv_desc.ViewDimension = D3D11_SRV_DIMENSION_TEXTURE2D;
            srv_desc.Texture2D.MipLevels = _mip_levels;
            srv_desc.Texture2D.MostDetailedMip = 0;
        }
        HR(GetD3DDevice()->CreateShaderResourceView(_resource.Get(), &srv_desc, _shader_resource_view.GetAddressOf()));
    }
    if (_bind_flags & RENDER_TEXTURE_BIND_UAV)
    {
        D3D11_UNORDERED_ACCESS_VIEW_DESC uav_desc;
        uav_desc.Format = _format;
        for (int i = 0; i < _mip_levels; i++)
        {
            if (depth != 0)
            {
                uav_desc.ViewDimension = D3D11_UAV_DIMENSION_TEXTURE3D;
                uav_desc.Texture3D.MipSlice = i;
                uav_desc.Texture3D.FirstWSlice = 0;
                uav_desc.Texture3D.WSize = depth;
            }
            else
            {
                uav_desc.ViewDimension = D3D11_UAV_DIMENSION_TEXTURE2D;
                uav_desc.Texture2D.MipSlice = i;
            }
            HR(GetD3DDevice()->CreateUnorderedAccessView(_resource.Get(), &uav_desc, _unordered_access_views[i].GetAddressOf()));
        }
    }
    return true;
}

void RenderTexture::Release()
{
    if (_bind_flags & RENDER_TEXTURE_BIND_UAV)
    {
        for (auto& uav : _unordered_access_views)
        {
            uav.Reset();
        }
    }
    if (_bind_flags & RENDER_TEXTURE_BIND_SRV)
    {
        _shader_resource_view.Reset();
    }
    if (_bind_flags & RENDER_TEXTURE_BIND_RTV)
    {
        for (auto& rtv : _render_target_views)
        {
            rtv.Reset();
        }
    }
    _resource.Reset();
}
void RenderTexture::CopyFromSRV(ID3D11DeviceContext* d3d_context, int source_slot, SHADER_TYPE source_shader)
{
    ID3D11ShaderResourceView* tmp_srv = nullptr;
    switch (source_shader)
    {
    case SHADER_TYPE_VERTEX:
        d3d_context->VSGetShaderResources(source_slot, 1, &tmp_srv);
        break;
    case SHADER_TYPE_HULL:
        d3d_context->HSGetShaderResources(source_slot, 1, &tmp_srv);
        break;
    case SHADER_TYPE_DOMAIN:
        d3d_context->DSGetShaderResources(source_slot, 1, &tmp_srv);
        break;
    case SHADER_TYPE_GEOMETRY:
        d3d_context->GSGetShaderResources(source_slot, 1, &tmp_srv);
        break;
    case SHADER_TYPE_PIXEL:
        d3d_context->PSGetShaderResources(source_slot, 1, &tmp_srv);
        break;
    case SHADER_TYPE_COMPUTE:
        d3d_context->CSGetShaderResources(source_slot, 1, &tmp_srv);
        break;
    default:
        break;
    }
    if (tmp_srv != nullptr)
    {
        ComPtr<ID3D11Resource> tmp_res;
        tmp_srv->GetResource(tmp_res.GetAddressOf());
        d3d_context->CopySubresourceRegion(_resource.Get(), 0, 0, 0, 0, tmp_res.Get(), 0, nullptr);
        tmp_srv->Release();
    }
}
RenderTexture* RenderTexture::GetTemporary(DXGI_FORMAT format, uint8_t bind_flags, uint32_t width, uint32_t height, uint32_t depth)
{
    RenderTextureDescription desc;
    desc.format = format;
    desc.bind_flags = bind_flags;
    desc.width = width;
    desc.height = height;
    desc.depth = depth;
    desc.mip_levels = 1;
    return GetTemporary(desc);

    // TODO: release render textures that are not used for 100 frames
}
RenderTexture* RenderTexture::GetTemporary(const RenderTextureDescription& description)
{
    auto key = std::make_tuple(description.format, description.bind_flags, description.width, description.height, description.depth,
                               description.mip_levels);
    auto it = render_texture_pool.find(key);
    if (it == render_texture_pool.end() || it->second.empty())
    {
        auto* render_texture = new RenderTexture(description.format, description.bind_flags, 1, description.mip_levels);
        render_texture->Create(description.width, description.height, description.depth);
        render_texture_pool[key].push_back(std::make_pair(render_texture, 0));
    }
    auto& candidate_textures = render_texture_pool[key];
    auto* output = candidate_textures.back().first;
    candidate_textures.pop_back();
    return output;
}
void RenderTexture::ReleaseTemporary(RenderTexture* temporary_render_texture)
{
    auto key = std::make_tuple(temporary_render_texture->_format, temporary_render_texture->_bind_flags, temporary_render_texture->_width,
                               temporary_render_texture->_height,
                               temporary_render_texture->_depth, temporary_render_texture->_mip_levels);
    render_texture_pool[key].push_back(std::make_pair(temporary_render_texture, 0));
}
void RenderTexture::OnPresent()
{
    //for (auto& pair : render_texture_pool)
    //{
    //	auto iterator = pair.second.begin();
    //	while (iterator != pair.second.end())
    //	{
    //		if (iterator->second > 100)
    //		{
    //			// TODO: fix nullptr exeption
    //			// release the render texture if it was not used for more than 100 frames
    //			//iterator->first->Release();
    //			//delete iterator->first;
    //			//iterator = pair.second.erase(iterator);
    //		}
    //		else
    //		{
    //			//iterator->second++;
    //		}
    //	}
    //}
}
