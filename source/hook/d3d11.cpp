#include "hook.h"

#include "d3d11_wrapper/d3d11_device.hpp"
#include "d3d11_wrapper/d3d11_device_context.hpp"
#include "external/detours.h"

#include <d3d11_4.h>

#include <cassert>
#include <string>


#include "core/log.h"
#include "external/aixlog.h"

#include "rendering/rendering_interceptor.h"

using namespace w3;
using namespace Microsoft::WRL;

struct UserData
{
    char* name;
};

void Hooks::InitializeD3d11Hooks()
{
    wchar_t path[MAX_PATH];
    HMODULE hm = nullptr;

    if (GetModuleHandleEx(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS |
        GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
        L"D3D11CreateDevice", &hm) == 0)
    {
        int ret = GetLastError();
        fprintf(stderr, "GetModuleHandle failed, error = %d\n", ret);
        // Return or however you want to handle an error.
    }
    if (GetModuleFileNameW(hm, path, sizeof(path)) == 0)
    {
        int ret = GetLastError();
        fprintf(stderr, "GetModuleFileName failed, error = %d\n", ret);
        // Return or however you want to handle an error.
    }
    std::wstring dll_path_string(path);

    // only detour functions when not loading via d3d11.dll but via dll/asi loader
    bool detour_functions = dll_path_string.find(L"d3d11.dll") == std::wstring::npos;
    
    Install(D3D11CreateDevice, GetProcAddress(d3d11_dll, "D3D11CreateDevice"), detour_functions);
    Install(D3D11CreateDeviceAndSwapChain, GetProcAddress(d3d11_dll, "D3D11CreateDeviceAndSwapChain"), detour_functions);
}


#pragma comment( linker, "/export:D3D11CreateDevice" )
HRESULT WINAPI D3D11CreateDevice(
    _In_opt_ IDXGIAdapter* pAdapter,
    D3D_DRIVER_TYPE DriverType,
    HMODULE Software,
    UINT Flags,
    _In_opt_ const D3D_FEATURE_LEVEL* pFeatureLevels,
    UINT FeatureLevels,
    UINT SDKVersion,
    _Out_opt_ ID3D11Device** ppDevice,
    _Out_opt_ D3D_FEATURE_LEVEL* pFeatureLevel,
    _Out_opt_ ID3D11DeviceContext** ppImmediateContext)
{
    LOG(INFO) << "Calling hooked D3D11CreateDevice" << std::endl;

    HRESULT hr;
    CHECK_HR(Hooks::Call(D3D11CreateDevice)(
        pAdapter, DriverType, Software, Flags, pFeatureLevels, FeatureLevels, SDKVersion, ppDevice, pFeatureLevel, ppImmediateContext
    ));

    if (FAILED(hr))
    {
        return hr;
    }
    // It is valid for the device out parameter to be NULL if the application wants to check feature level support, so just return early in that case
    if (ppDevice == nullptr)
    {
        assert(ppImmediateContext == nullptr);
        return hr;
    }

    ID3D11Device* device = *ppDevice;
    // Query for the DXGI device and immediate device context since we need to reference them in the hooked device
    IDXGIDevice1* dxgi_device = nullptr;
    hr = device->QueryInterface(&dxgi_device);
    assert(SUCCEEDED(hr));
    ID3D11DeviceContext* device_context = nullptr;
    device->GetImmediateContext(&device_context);
    auto* dev = new D3D11Device(dxgi_device, device, device_context);

    *ppDevice = dev;
    if (ppImmediateContext != nullptr)
    {
        dev->GetImmediateContext(ppImmediateContext);
    }

    // pAdapter != nullptr is probably a call by Ansel
    static bool init = false;
    if (!init && pAdapter == nullptr)
    {
        LOG(INFO) << "Using D3D11Device(" << dev << ") for effect injection..." << std::endl;
        dev->AddRef();
        ID3D11DeviceContext* con = dynamic_cast<D3D11DeviceContext*>(dev->_immediate_context)->_orig;
        RenderingInterceptor::Get().Initialize(device, con);
        init = true;
    }

    return hr;
}

#pragma comment( linker, "/export:D3D11CreateDeviceAndSwapChain" )
HRESULT WINAPI D3D11CreateDeviceAndSwapChain(IDXGIAdapter* pAdapter, D3D_DRIVER_TYPE DriverType, HMODULE Software, UINT Flags,
                                             const D3D_FEATURE_LEVEL* pFeatureLevels, UINT FeatureLevels, UINT SDKVersion,
                                             const DXGI_SWAP_CHAIN_DESC* pSwapChainDesc, IDXGISwapChain** ppSwapChain,
                                             ID3D11Device** ppDevice, D3D_FEATURE_LEVEL* pFeatureLevel,
                                             ID3D11DeviceContext** ppImmediateContext)
{
    LOG(INFO) << "Calling hooked D3D11CreateDeviceAndSwapChain" << std::endl;

    HRESULT hr;
    CHECK_HR(Hooks::Call(D3D11CreateDeviceAndSwapChain)(
        pAdapter, DriverType, Software, Flags, pFeatureLevels, FeatureLevels, SDKVersion, pSwapChainDesc, ppSwapChain, ppDevice,
        pFeatureLevel,
        ppImmediateContext));
    return hr;
}
