/**
 * Copyright (C) 2014 Patrick Mours. All rights reserved.
 * License: https://github.com/crosire/reshade#license
 */

#include "d3d11_device.hpp"
#include "d3d11_device_context.hpp"
#include "dxgi_device.hpp"
#include <cassert>
#include <string>
#include "external/aixlog.h"
#include "rendering/rendering_interceptor.h"
#include <iostream>

D3D11Device::D3D11Device(IDXGIDevice1* dxgi_device, ID3D11Device* original, ID3D11DeviceContext* immediate_context) :
    _orig(original),
    _interface_version(0),
    _dxgi_device(new DXGIDevice(dxgi_device, this)),
    _immediate_context(new D3D11DeviceContext(this, immediate_context))
{
    assert(_orig != nullptr);
    LOG(INFO) << "Creating D3D11Device(" << this << ")..." << std::endl;
}

bool D3D11Device::check_and_upgrade_interface(REFIID riid)
{
    if (riid == __uuidof(this))
        // IUnknown is handled by DXGIDevice
        return true;

    static const IID iid_lookup[] = {
        __uuidof(ID3D11Device),
        __uuidof(ID3D11Device1),
        __uuidof(ID3D11Device2),
        __uuidof(ID3D11Device3),
        __uuidof(ID3D11Device4),
        __uuidof(ID3D11Device5),
    };

    for (unsigned int version = 0; version < ARRAYSIZE(iid_lookup); ++version)
    {
        if (riid != iid_lookup[version])
            continue;

        if (version > _interface_version)
        {
            IUnknown* new_interface = nullptr;
            if (FAILED(_orig->QueryInterface(riid, reinterpret_cast<void **>(&new_interface))))
                return false;

            _orig->Release();
            _orig = static_cast<ID3D11Device*>(new_interface);
            _interface_version = version;
        }

        return true;
    }

    return false;
}

HRESULT STDMETHODCALLTYPE D3D11Device::QueryInterface(REFIID riid, void** ppvObj)
{
    if (ppvObj == nullptr)
        return E_POINTER;

    if (check_and_upgrade_interface(riid))
    {
        AddRef();
        *ppvObj = this;
        return S_OK;
    }

    // Note: Objects must have an identity, so use DXGIDevice for IID_IUnknown
    // See https://docs.microsoft.com/en-us/windows/desktop/com/rules-for-implementing-queryinterface
    if (_dxgi_device->check_and_upgrade_interface(riid))
    {
        _dxgi_device->AddRef();
        *ppvObj = _dxgi_device;
        return S_OK;
    }

    return _orig->QueryInterface(riid, ppvObj);
}
ULONG STDMETHODCALLTYPE D3D11Device::AddRef()
{
    _orig->AddRef();

    // Add references to other objects that are coupled with the device
    _dxgi_device->AddRef();
    _immediate_context->AddRef();

    return InterlockedIncrement(&_ref);
}
ULONG STDMETHODCALLTYPE D3D11Device::Release()
{
    // Release references to other objects that are coupled with the device
    _immediate_context->Release(); // Release context before device since it may hold a reference to it
    _dxgi_device->Release();

    const ULONG ref = InterlockedDecrement(&_ref);
    if (ref != 0)
        return _orig->Release(), ref;

    LOG(INFO) << "Destroying D3D11Device(" << this << ")..." << std::endl;
    const ULONG ref_orig = _orig->Release();

    delete this;

    return 0;
}

HRESULT STDMETHODCALLTYPE D3D11Device::CreateBuffer(const D3D11_BUFFER_DESC* pDesc, const D3D11_SUBRESOURCE_DATA* pInitialData,
                                                    ID3D11Buffer** ppBuffer)
{
    return _orig->CreateBuffer(pDesc, pInitialData, ppBuffer);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateTexture1D(const D3D11_TEXTURE1D_DESC* pDesc, const D3D11_SUBRESOURCE_DATA* pInitialData,
                                                       ID3D11Texture1D** ppTexture1D)
{
    return _orig->CreateTexture1D(pDesc, pInitialData, ppTexture1D);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateTexture2D(const D3D11_TEXTURE2D_DESC* pDesc, const D3D11_SUBRESOURCE_DATA* pInitialData,
                                                       ID3D11Texture2D** ppTexture2D)
{
    return _orig->CreateTexture2D(pDesc, pInitialData, ppTexture2D);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateTexture3D(const D3D11_TEXTURE3D_DESC* pDesc, const D3D11_SUBRESOURCE_DATA* pInitialData,
                                                       ID3D11Texture3D** ppTexture3D)
{
    return _orig->CreateTexture3D(pDesc, pInitialData, ppTexture3D);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateShaderResourceView(ID3D11Resource* pResource, const D3D11_SHADER_RESOURCE_VIEW_DESC* pDesc,
                                                                ID3D11ShaderResourceView** ppSRView)
{
    return _orig->CreateShaderResourceView(pResource, pDesc, ppSRView);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateUnorderedAccessView(ID3D11Resource* pResource, const D3D11_UNORDERED_ACCESS_VIEW_DESC* pDesc,
                                                                 ID3D11UnorderedAccessView** ppUAView)
{
    return _orig->CreateUnorderedAccessView(pResource, pDesc, ppUAView);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateRenderTargetView(ID3D11Resource* pResource, const D3D11_RENDER_TARGET_VIEW_DESC* pDesc,
                                                              ID3D11RenderTargetView** ppRTView)
{
    return _orig->CreateRenderTargetView(pResource, pDesc, ppRTView);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateDepthStencilView(ID3D11Resource* pResource, const D3D11_DEPTH_STENCIL_VIEW_DESC* pDesc,
                                                              ID3D11DepthStencilView** ppDepthStencilView)
{
    return _orig->CreateDepthStencilView(pResource, pDesc, ppDepthStencilView);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateInputLayout(const D3D11_INPUT_ELEMENT_DESC* pInputElementDescs, UINT NumElements,
                                                         const void* pShaderBytecodeWithInputSignature, SIZE_T BytecodeLength,
                                                         ID3D11InputLayout** ppInputLayout)
{
    return _orig->CreateInputLayout(pInputElementDescs, NumElements, pShaderBytecodeWithInputSignature, BytecodeLength, ppInputLayout);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateVertexShader(const void* pShaderBytecode, SIZE_T BytecodeLength,
                                                          ID3D11ClassLinkage* pClassLinkage, ID3D11VertexShader** ppVertexShader)
{
    //w3::ExtractVertexShader(pShaderBytecode, BytecodeLength);
    HRESULT hr = _orig->CreateVertexShader(pShaderBytecode, BytecodeLength, pClassLinkage, ppVertexShader);
    if (ppVertexShader != nullptr) // https://docs.microsoft.com/en-us/windows/win32/api/d3d11/nf-d3d11-id3d11device-createvertexshader
    {
        w3::RenderingInterceptor::Get().OnCreatedVertexShader(pShaderBytecode, *ppVertexShader);
    }
    return hr;
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateGeometryShader(const void* pShaderBytecode, SIZE_T BytecodeLength,
                                                            ID3D11ClassLinkage* pClassLinkage, ID3D11GeometryShader** ppGeometryShader)
{
    HRESULT hr = _orig->CreateGeometryShader(pShaderBytecode, BytecodeLength, pClassLinkage, ppGeometryShader);
    if (ppGeometryShader != nullptr)
    {
        w3::RenderingInterceptor::Get().OnCreatedGeometryShader(pShaderBytecode, *ppGeometryShader);
    }
    return hr;
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateGeometryShaderWithStreamOutput(const void* pShaderBytecode, SIZE_T BytecodeLength,
                                                                            const D3D11_SO_DECLARATION_ENTRY* pSODeclaration,
                                                                            UINT NumEntries, const UINT* pBufferStrides, UINT NumStrides,
                                                                            UINT RasterizedStream, ID3D11ClassLinkage* pClassLinkage,
                                                                            ID3D11GeometryShader** ppGeometryShader)
{
    HRESULT hr = _orig->CreateGeometryShaderWithStreamOutput(pShaderBytecode, BytecodeLength, pSODeclaration, NumEntries, pBufferStrides,
                                                       NumStrides, RasterizedStream, pClassLinkage, ppGeometryShader);
    if (ppGeometryShader != nullptr)
    {
        w3::RenderingInterceptor::Get().OnCreatedGeometryShader(pShaderBytecode, *ppGeometryShader);
    }
    return hr;
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreatePixelShader(const void* pShaderBytecode, SIZE_T BytecodeLength,
                                                         ID3D11ClassLinkage* pClassLinkage, ID3D11PixelShader** ppPixelShader)
{
    HRESULT hr = _orig->CreatePixelShader(pShaderBytecode, BytecodeLength, pClassLinkage, ppPixelShader);
    if (ppPixelShader != nullptr)
    {
        w3::RenderingInterceptor::Get().OnCreatedPixelShader(pShaderBytecode, *ppPixelShader);
    }
    return hr;
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateHullShader(const void* pShaderBytecode, SIZE_T BytecodeLength,
                                                        ID3D11ClassLinkage* pClassLinkage, ID3D11HullShader** ppHullShader)
{
    HRESULT hr = _orig->CreateHullShader(pShaderBytecode, BytecodeLength, pClassLinkage, ppHullShader);
    if (ppHullShader != nullptr)
    {
        w3::RenderingInterceptor::Get().OnCreatedHullShader(pShaderBytecode, *ppHullShader);
    }
    return hr;
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateDomainShader(const void* pShaderBytecode, SIZE_T BytecodeLength,
                                                          ID3D11ClassLinkage* pClassLinkage, ID3D11DomainShader** ppDomainShader)
{
    HRESULT hr = _orig->CreateDomainShader(pShaderBytecode, BytecodeLength, pClassLinkage, ppDomainShader);
    if (ppDomainShader != nullptr)
    {
        w3::RenderingInterceptor::Get().OnCreatedDomainShader(pShaderBytecode, *ppDomainShader);
    }
    return hr;
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateComputeShader(const void* pShaderBytecode, SIZE_T BytecodeLength,
                                                           ID3D11ClassLinkage* pClassLinkage, ID3D11ComputeShader** ppComputeShader)
{
    HRESULT hr = _orig->CreateComputeShader(pShaderBytecode, BytecodeLength, pClassLinkage, ppComputeShader);
    if (ppComputeShader != nullptr)
    {
        w3::RenderingInterceptor::Get().OnCreatedComputeShader(pShaderBytecode, *ppComputeShader);
    }
    return hr;
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateClassLinkage(ID3D11ClassLinkage** ppLinkage)
{
    return _orig->CreateClassLinkage(ppLinkage);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateBlendState(const D3D11_BLEND_DESC* pBlendStateDesc, ID3D11BlendState** ppBlendState)
{
    return _orig->CreateBlendState(pBlendStateDesc, ppBlendState);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateDepthStencilState(const D3D11_DEPTH_STENCIL_DESC* pDepthStencilDesc,
                                                               ID3D11DepthStencilState** ppDepthStencilState)
{
    return _orig->CreateDepthStencilState(pDepthStencilDesc, ppDepthStencilState);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateRasterizerState(const D3D11_RASTERIZER_DESC* pRasterizerDesc,
                                                             ID3D11RasterizerState** ppRasterizerState)
{
    return _orig->CreateRasterizerState(pRasterizerDesc, ppRasterizerState);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateSamplerState(const D3D11_SAMPLER_DESC* pSamplerDesc, ID3D11SamplerState** ppSamplerState)
{
    D3D11_SAMPLER_DESC newDesc = *pSamplerDesc;
    if (newDesc.Filter <= D3D11_FILTER_ANISOTROPIC)
    {
        newDesc.Filter = D3D11_FILTER_ANISOTROPIC;
        newDesc.MaxAnisotropy = 16;
    }
    return _orig->CreateSamplerState(&newDesc, ppSamplerState);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateQuery(const D3D11_QUERY_DESC* pQueryDesc, ID3D11Query** ppQuery)
{
    return _orig->CreateQuery(pQueryDesc, ppQuery);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreatePredicate(const D3D11_QUERY_DESC* pPredicateDesc, ID3D11Predicate** ppPredicate)
{
    return _orig->CreatePredicate(pPredicateDesc, ppPredicate);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateCounter(const D3D11_COUNTER_DESC* pCounterDesc, ID3D11Counter** ppCounter)
{
    return _orig->CreateCounter(pCounterDesc, ppCounter);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateDeferredContext(UINT ContextFlags, ID3D11DeviceContext** ppDeferredContext)
{
    if (ppDeferredContext == nullptr)
        return E_INVALIDARG;
    const HRESULT hr = _orig->CreateDeferredContext(ContextFlags, ppDeferredContext);
    const auto device_context_proxy = new D3D11DeviceContext(this, *ppDeferredContext);
    *ppDeferredContext = device_context_proxy;
    return hr;
}
HRESULT STDMETHODCALLTYPE D3D11Device::OpenSharedResource(HANDLE hResource, REFIID ReturnedInterface, void** ppResource)
{
    return _orig->OpenSharedResource(hResource, ReturnedInterface, ppResource);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CheckFormatSupport(DXGI_FORMAT Format, UINT* pFormatSupport)
{
    return _orig->CheckFormatSupport(Format, pFormatSupport);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CheckMultisampleQualityLevels(DXGI_FORMAT Format, UINT SampleCount, UINT* pNumQualityLevels)
{
    return _orig->CheckMultisampleQualityLevels(Format, SampleCount, pNumQualityLevels);
}
void STDMETHODCALLTYPE D3D11Device::CheckCounterInfo(D3D11_COUNTER_INFO* pCounterInfo)
{
    _orig->CheckCounterInfo(pCounterInfo);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CheckCounter(const D3D11_COUNTER_DESC* pDesc, D3D11_COUNTER_TYPE* pType, UINT* pActiveCounters,
                                                    LPSTR szName, UINT* pNameLength, LPSTR szUnits, UINT* pUnitsLength, LPSTR szDescription,
                                                    UINT* pDescriptionLength)
{
    return _orig->CheckCounter(pDesc, pType, pActiveCounters, szName, pNameLength, szUnits, pUnitsLength, szDescription,
                               pDescriptionLength);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CheckFeatureSupport(D3D11_FEATURE Feature, void* pFeatureSupportData, UINT FeatureSupportDataSize)
{
    return _orig->CheckFeatureSupport(Feature, pFeatureSupportData, FeatureSupportDataSize);
}
HRESULT STDMETHODCALLTYPE D3D11Device::GetPrivateData(REFGUID guid, UINT* pDataSize, void* pData)
{
    return _orig->GetPrivateData(guid, pDataSize, pData);
}
HRESULT STDMETHODCALLTYPE D3D11Device::SetPrivateData(REFGUID guid, UINT DataSize, const void* pData)
{
    return _orig->SetPrivateData(guid, DataSize, pData);
}
HRESULT STDMETHODCALLTYPE D3D11Device::SetPrivateDataInterface(REFGUID guid, const IUnknown* pData)
{
    return _orig->SetPrivateDataInterface(guid, pData);
}
UINT STDMETHODCALLTYPE D3D11Device::GetCreationFlags()
{
    return _orig->GetCreationFlags();
}
HRESULT STDMETHODCALLTYPE D3D11Device::GetDeviceRemovedReason()
{
    return _orig->GetDeviceRemovedReason();
}
void STDMETHODCALLTYPE D3D11Device::GetImmediateContext(ID3D11DeviceContext** ppImmediateContext)
{
    if (ppImmediateContext == nullptr)
        return;
    _immediate_context->AddRef();
    *ppImmediateContext = _immediate_context;
}
HRESULT STDMETHODCALLTYPE D3D11Device::SetExceptionMode(UINT RaiseFlags)
{
    return _orig->SetExceptionMode(RaiseFlags);
}
UINT STDMETHODCALLTYPE D3D11Device::GetExceptionMode()
{
    return _orig->GetExceptionMode();
}
D3D_FEATURE_LEVEL STDMETHODCALLTYPE D3D11Device::GetFeatureLevel()
{
    return _orig->GetFeatureLevel();
}
void STDMETHODCALLTYPE D3D11Device::GetImmediateContext1(ID3D11DeviceContext1** ppImmediateContext)
{
    if (ppImmediateContext == nullptr)
        return;
    assert(_interface_version >= 1);
    assert(_immediate_context->_interface_version >= 1);
    _immediate_context->AddRef();
    *ppImmediateContext = _immediate_context;
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateDeferredContext1(UINT ContextFlags, ID3D11DeviceContext1** ppDeferredContext)
{
    if (ppDeferredContext == nullptr)
        return E_INVALIDARG;
    assert(_interface_version >= 1);
    const HRESULT hr = static_cast<ID3D11Device1*>(_orig)->CreateDeferredContext1(ContextFlags, ppDeferredContext);
    const auto device_context_proxy = new D3D11DeviceContext(this, *ppDeferredContext);
    *ppDeferredContext = device_context_proxy;
    return hr;
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateBlendState1(const D3D11_BLEND_DESC1* pBlendStateDesc, ID3D11BlendState1** ppBlendState)
{
    assert(_interface_version >= 1);
    return static_cast<ID3D11Device1*>(_orig)->CreateBlendState1(pBlendStateDesc, ppBlendState);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateRasterizerState1(const D3D11_RASTERIZER_DESC1* pRasterizerDesc,
                                                              ID3D11RasterizerState1** ppRasterizerState)
{
    assert(_interface_version >= 1);
    return static_cast<ID3D11Device1*>(_orig)->CreateRasterizerState1(pRasterizerDesc, ppRasterizerState);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateDeviceContextState(UINT Flags, const D3D_FEATURE_LEVEL* pFeatureLevels, UINT FeatureLevels,
                                                                UINT SDKVersion, REFIID EmulatedInterface,
                                                                D3D_FEATURE_LEVEL* pChosenFeatureLevel,
                                                                ID3DDeviceContextState** ppContextState)
{
    assert(_interface_version >= 1);
    return static_cast<ID3D11Device1*>(_orig)->CreateDeviceContextState(Flags, pFeatureLevels, FeatureLevels, SDKVersion,
                                                                        EmulatedInterface, pChosenFeatureLevel, ppContextState);
}
HRESULT STDMETHODCALLTYPE D3D11Device::OpenSharedResource1(HANDLE hResource, REFIID returnedInterface, void** ppResource)
{
    assert(_interface_version >= 1);
    return static_cast<ID3D11Device1*>(_orig)->OpenSharedResource1(hResource, returnedInterface, ppResource);
}
HRESULT STDMETHODCALLTYPE D3D11Device::OpenSharedResourceByName(LPCWSTR lpName, DWORD dwDesiredAccess, REFIID returnedInterface,
                                                                void** ppResource)
{
    assert(_interface_version >= 1);
    return static_cast<ID3D11Device1*>(_orig)->OpenSharedResourceByName(lpName, dwDesiredAccess, returnedInterface, ppResource);
}
void STDMETHODCALLTYPE D3D11Device::GetImmediateContext2(ID3D11DeviceContext2** ppImmediateContext)
{
    assert(_interface_version >= 2);
    static_cast<ID3D11Device2*>(_orig)->GetImmediateContext2(ppImmediateContext);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateDeferredContext2(UINT ContextFlags, ID3D11DeviceContext2** ppDeferredContext)
{
    if (ppDeferredContext == nullptr)
        return E_INVALIDARG;
    assert(_interface_version >= 2);
    const HRESULT hr = static_cast<ID3D11Device2*>(_orig)->CreateDeferredContext2(ContextFlags, ppDeferredContext);
    const auto device_context_proxy = new D3D11DeviceContext(this, *ppDeferredContext);
    *ppDeferredContext = device_context_proxy;
    return hr;
}
void STDMETHODCALLTYPE D3D11Device::GetResourceTiling(ID3D11Resource* pTiledResource, UINT* pNumTilesForEntireResource,
                                                      D3D11_PACKED_MIP_DESC* pPackedMipDesc,
                                                      D3D11_TILE_SHAPE* pStandardTileShapeForNonPackedMips, UINT* pNumSubresourceTilings,
                                                      UINT FirstSubresourceTilingToGet,
                                                      D3D11_SUBRESOURCE_TILING* pSubresourceTilingsForNonPackedMips)
{
    assert(_interface_version >= 2);
    static_cast<ID3D11Device2*>(_orig)->GetResourceTiling(pTiledResource, pNumTilesForEntireResource, pPackedMipDesc,
                                                          pStandardTileShapeForNonPackedMips, pNumSubresourceTilings,
                                                          FirstSubresourceTilingToGet, pSubresourceTilingsForNonPackedMips);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CheckMultisampleQualityLevels1(DXGI_FORMAT Format, UINT SampleCount, UINT Flags,
                                                                      UINT* pNumQualityLevels)
{
    assert(_interface_version >= 2);
    return static_cast<ID3D11Device2*>(_orig)->CheckMultisampleQualityLevels1(Format, SampleCount, Flags, pNumQualityLevels);
}

HRESULT STDMETHODCALLTYPE D3D11Device::CreateTexture2D1(const D3D11_TEXTURE2D_DESC1* pDesc1, const D3D11_SUBRESOURCE_DATA* pInitialData,
                                                        ID3D11Texture2D1** ppTexture2D)
{
    assert(pDesc1 != nullptr);
    assert(_interface_version >= 3);
    const HRESULT hr = static_cast<ID3D11Device3*>(_orig)->CreateTexture2D1(pDesc1, pInitialData, ppTexture2D);

    return hr;
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateTexture3D1(const D3D11_TEXTURE3D_DESC1* pDesc1, const D3D11_SUBRESOURCE_DATA* pInitialData,
                                                        ID3D11Texture3D1** ppTexture3D)
{
    assert(_interface_version >= 3);
    return static_cast<ID3D11Device3*>(_orig)->CreateTexture3D1(pDesc1, pInitialData, ppTexture3D);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateRasterizerState2(const D3D11_RASTERIZER_DESC2* pRasterizerDesc,
                                                              ID3D11RasterizerState2** ppRasterizerState)
{
    assert(_interface_version >= 3);
    return static_cast<ID3D11Device3*>(_orig)->CreateRasterizerState2(pRasterizerDesc, ppRasterizerState);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateShaderResourceView1(ID3D11Resource* pResource, const D3D11_SHADER_RESOURCE_VIEW_DESC1* pDesc1,
                                                                 ID3D11ShaderResourceView1** ppSRView1)
{
    assert(_interface_version >= 3);
    return static_cast<ID3D11Device3*>(_orig)->CreateShaderResourceView1(pResource, pDesc1, ppSRView1);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateUnorderedAccessView1(ID3D11Resource* pResource,
                                                                  const D3D11_UNORDERED_ACCESS_VIEW_DESC1* pDesc1,
                                                                  ID3D11UnorderedAccessView1** ppUAView1)
{
    assert(_interface_version >= 3);
    return static_cast<ID3D11Device3*>(_orig)->CreateUnorderedAccessView1(pResource, pDesc1, ppUAView1);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateRenderTargetView1(ID3D11Resource* pResource, const D3D11_RENDER_TARGET_VIEW_DESC1* pDesc1,
                                                               ID3D11RenderTargetView1** ppRTView1)
{
    assert(_interface_version >= 3);
    return static_cast<ID3D11Device3*>(_orig)->CreateRenderTargetView1(pResource, pDesc1, ppRTView1);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateQuery1(const D3D11_QUERY_DESC1* pQueryDesc1, ID3D11Query1** ppQuery1)
{
    assert(_interface_version >= 3);
    return static_cast<ID3D11Device3*>(_orig)->CreateQuery1(pQueryDesc1, ppQuery1);
}
void STDMETHODCALLTYPE D3D11Device::GetImmediateContext3(ID3D11DeviceContext3** ppImmediateContext)
{
    assert(_interface_version >= 3);
    static_cast<ID3D11Device3*>(_orig)->GetImmediateContext3(ppImmediateContext);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateDeferredContext3(UINT ContextFlags, ID3D11DeviceContext3** ppDeferredContext)
{
    if (ppDeferredContext == nullptr)
        return E_INVALIDARG;
    assert(_interface_version >= 3);
    const HRESULT hr = static_cast<ID3D11Device3*>(_orig)->CreateDeferredContext3(ContextFlags, ppDeferredContext);
    const auto device_context_proxy = new D3D11DeviceContext(this, *ppDeferredContext);
    *ppDeferredContext = device_context_proxy;
    return hr;
}
void STDMETHODCALLTYPE D3D11Device::WriteToSubresource(ID3D11Resource* pDstResource, UINT DstSubresource, const D3D11_BOX* pDstBox,
                                                       const void* pSrcData, UINT SrcRowPitch, UINT SrcDepthPitch)
{
    assert(_interface_version >= 3);
    static_cast<ID3D11Device3*>(_orig)->WriteToSubresource(pDstResource, DstSubresource, pDstBox, pSrcData, SrcRowPitch, SrcDepthPitch);
}
void STDMETHODCALLTYPE D3D11Device::ReadFromSubresource(void* pDstData, UINT DstRowPitch, UINT DstDepthPitch, ID3D11Resource* pSrcResource,
                                                        UINT SrcSubresource, const D3D11_BOX* pSrcBox)
{
    assert(_interface_version >= 3);
    static_cast<ID3D11Device3*>(_orig)->ReadFromSubresource(pDstData, DstRowPitch, DstDepthPitch, pSrcResource, SrcSubresource, pSrcBox);
}
HRESULT STDMETHODCALLTYPE D3D11Device::RegisterDeviceRemovedEvent(HANDLE hEvent, DWORD* pdwCookie)
{
    assert(_interface_version >= 4);
    return static_cast<ID3D11Device4*>(_orig)->RegisterDeviceRemovedEvent(hEvent, pdwCookie);
}
void STDMETHODCALLTYPE D3D11Device::UnregisterDeviceRemoved(DWORD dwCookie)
{
    assert(_interface_version >= 4);
    static_cast<ID3D11Device4*>(_orig)->UnregisterDeviceRemoved(dwCookie);
}
HRESULT STDMETHODCALLTYPE D3D11Device::OpenSharedFence(HANDLE hFence, REFIID ReturnedInterface, void** ppFence)
{
    assert(_interface_version >= 5);
    return static_cast<ID3D11Device5*>(_orig)->OpenSharedFence(hFence, ReturnedInterface, ppFence);
}
HRESULT STDMETHODCALLTYPE D3D11Device::CreateFence(UINT64 InitialValue, D3D11_FENCE_FLAG Flags, REFIID ReturnedInterface, void** ppFence)
{
    assert(_interface_version >= 5);
    return static_cast<ID3D11Device5*>(_orig)->CreateFence(InitialValue, Flags, ReturnedInterface, ppFence);
}
