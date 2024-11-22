#include "hook.h"
#include "rendering/rendering_interceptor.h"
#include "rendering/gui.h"

#include "external/detours.h"
#include "external/imgui/imgui.h"
#include "external/imgui/imgui_impl_win32.h"
#include "external/imgui/imgui_impl_dx11.h"

#define DIRECTINPUT_VERSION 0x0800
#include "dinput.h"

#include <d3d11.h>
#include <windows.h>

#include "external/aixlog.h"
#include "core/log.h"

#pragma comment(lib, "dinput8")
#pragma comment(lib,"d3d11.lib")

using namespace w3;
using namespace Microsoft::WRL;

HRESULT __fastcall Present(
    IDXGISwapChain* swap_chain,
    UINT sync_interval,
    UINT flags
);
HRESULT __fastcall ResizeBuffers(
    IDXGISwapChain* swap_chain,
    UINT buffer_count,
    UINT width,
    UINT height,
    DXGI_FORMAT new_format,
    UINT swap_chain_flags
);

HRESULT WINAPI DirectInputDevice8_GetDeviceData(IDirectInputDevice8* pThis, DWORD cbObjectData, LPDIDEVICEOBJECTDATA rgdod,
    LPDWORD pdwInOut, DWORD dwFlags);

enum IDXGI_SWAP_CHAIN_VMT : UINT
{
    QueryInterface,
    AddRef,
    Release,
    SetPrivateData,
    SetPrivateDataInterface,
    GetPrivateData,
    IDXGI_SWAP_CHAIN_VMT_GET_PARENT,
    GetDevice,
    IDXGI_SWAP_CHAIN_VMT_PRESENT,
    GetBuffer,
    SetFullscreenState,
    GetFullscreenState,
    GetDesc,
    IDXGI_SWAP_CHAIN_VMT_RESIZE_BUFFERS,
    ResizeTarget,
    GetContainingOutput,
    GetFrameStatistics,
    GetLastPresentCount,
};

void Hooks::InitializeDxgiHooks()
{
    namespace fs = std::filesystem;

    // wait until ReShade is done with its DXGI hook setup
    fs::path working_dir = fs::current_path();
    if (fs::exists(working_dir / "dxgi.dll"))
    {
        LOG(INFO) << "Detected dxgi.dll; Delaying DXGI hook..." << std::endl;
        Sleep(100);
    }

    // TODO: use this to figure out crash locations
    //void(*foo)(void) = reinterpret_cast<void(*)()>(reinterpret_cast<uint64_t>(D3D11CreateDeviceAndSwapChain) + 0x39f24);
    //foo();

    // Create a dummy device, get swapchain vmt, hook present.
    ComPtr<IDXGISwapChain> dxgi_swap_chain;
    ComPtr<ID3D11Device> d3d11_device;
    D3D_FEATURE_LEVEL feature_level = D3D_FEATURE_LEVEL_11_0;
    DXGI_SWAP_CHAIN_DESC swap_chain_desc = {};
    swap_chain_desc.BufferCount = 1;
    swap_chain_desc.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT;
    swap_chain_desc.BufferDesc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
    swap_chain_desc.BufferDesc.Height = 800;
    swap_chain_desc.BufferDesc.Width = 600;
    swap_chain_desc.BufferDesc.RefreshRate = {60, 1};
    swap_chain_desc.OutputWindow = GetForegroundWindow();
    swap_chain_desc.Windowed = TRUE;
    swap_chain_desc.SwapEffect = DXGI_SWAP_EFFECT_DISCARD;
    swap_chain_desc.SampleDesc.Count = 1;
    swap_chain_desc.SampleDesc.Quality = 0;
    HRESULT hr;
    CHECK_HR(D3D11CreateDeviceAndSwapChain(
        nullptr, D3D_DRIVER_TYPE_HARDWARE, nullptr, 0, &feature_level, 1, D3D11_SDK_VERSION,
        &swap_chain_desc, dxgi_swap_chain.GetAddressOf(), d3d11_device.GetAddressOf(),
        nullptr, nullptr));

    FARPROC present;
    FARPROC resize_buffers;
    if (FAILED(hr))
    {
        LOG(INFO) << "Hooking swapchain via offset" << std::endl;
        auto dxgi_handle = reinterpret_cast<DWORD_PTR>(GetModuleHandleA("dxgi.dll"));

        present = reinterpret_cast<FARPROC>(static_cast<DWORD_PTR>(dxgi_handle) + 0xF2F00);
        resize_buffers = reinterpret_cast<FARPROC>(static_cast<DWORD_PTR>(dxgi_handle) + 0xF3160);
    }
    else
    {
        LOG(INFO) << "Hooking swapchain via vtable" << std::endl;
        void** swapchain_vtable = *reinterpret_cast<void***>(dxgi_swap_chain.Get());

        present = FARPROC(swapchain_vtable[IDXGI_SWAP_CHAIN_VMT_PRESENT]);
        resize_buffers = FARPROC(swapchain_vtable[IDXGI_SWAP_CHAIN_VMT_RESIZE_BUFFERS]);
    }

    // hook direct input
    auto* hInst = static_cast<HINSTANCE>(GetModuleHandle(nullptr));
    IDirectInput8* pDirectInput = nullptr;
    CHECK_HR(DirectInput8Create(hInst, DIRECTINPUT_VERSION, IID_IDirectInput8, reinterpret_cast<LPVOID*>(&pDirectInput), nullptr));
    IDirectInputDevice8* lpdi_mouse;
    CHECK_HR(pDirectInput->CreateDevice(GUID_SysMouse, &lpdi_mouse, nullptr));
    if (FAILED(hr))
    {
        pDirectInput->Release();
    }
    else
    {
        LOG(INFO) << "Hooking DInputDevice via vtable" << std::endl;
        void** dinput_vtable = *reinterpret_cast<void***>(lpdi_mouse);

        Install(DirectInputDevice8_GetDeviceData, FARPROC(dinput_vtable[10]));
    }
    Install(Present, present);
    Install(ResizeBuffers, resize_buffers);
}

namespace
{
bool show_menu = false;
bool previous_show_menu = false;
ID3D11Device* d3d_device = nullptr;
ID3D11DeviceContext* d3d_context = nullptr;
ID3D11RenderTargetView* imgui_render_target_view = nullptr;
WNDPROC original_wnd_proc_handler = nullptr;
bool init_ansel = false;
float gui_scale = 1.0f;
}

HRESULT DirectInputDevice8_GetDeviceData(IDirectInputDevice8W* pThis, DWORD cbObjectData, LPDIDEVICEOBJECTDATA rgdod, LPDWORD pdwInOut, DWORD dwFlags)
{
    HRESULT hr = Hooks::Call(DirectInputDevice8_GetDeviceData)(pThis, cbObjectData, rgdod, pdwInOut, dwFlags);
    if (show_menu)
    {
        // call the original to clear the input buffer
        *pdwInOut = 0;
        return DI_OK;
    }
    return hr;
}

// Definition of WndProc Hook. Its here to avoid dragging dependencies on <windows.h> types.
extern LRESULT ImGui_ImplWin32_WndProcHandler(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);

LRESULT CALLBACK WindowProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
    const Configuration& config = w3::RenderingInterceptor::Get().GetConfiguration();
    if (uMsg == WM_KEYDOWN && wParam == VK_ESCAPE)
    {
        if (show_menu)
        {
            show_menu = false;
        }
    }
    if (uMsg == WM_KEYUP || uMsg == WM_SYSKEYUP)
    {
        switch (wParam)
        {
#ifndef PUBLIC_RELEASE
        case VK_F6:
            w3::RenderingInterceptor::Get().Reload();    
            break;  
#endif            
        default:
            break;
        }

        if (wParam == config.open_settings_key)
        {
            show_menu = true;
        }
        else if (wParam == config.toggle_blitz_fx_key)
        {
            RenderingInterceptor::Get().Toggle();
        }
    }
    if (show_menu)
    {
        if (ImGui_ImplWin32_WndProcHandler(hWnd, uMsg, wParam, lParam))
        {
            return true;
        }
        switch (uMsg)
        {
        case WM_MOUSEMOVE:
        case WM_LBUTTONUP:
        case WM_LBUTTONDOWN:
        case WM_INPUT:
            return 1;
        default:
            break;
        }
    }
    return CallWindowProc(original_wnd_proc_handler, hWnd, uMsg, wParam, lParam);
}

HRESULT Present(IDXGISwapChain* swap_chain, UINT sync_interval, UINT flags)
{
    RenderingInterceptor::Get().OnPresent();

    if (d3d_device == nullptr)
    {
        LOG(INFO) << "Initializing ImGui" << std::endl;
        if (FAILED(swap_chain->GetDevice(__uuidof(ID3D11Device), reinterpret_cast<PVOID*>(&d3d_device))))
        {
            MessageBoxA(nullptr, "IDXGISwapChain::GetDevice(...) failed", nullptr, MB_OK | MB_ICONERROR);
            return -1;
        }
        d3d_device->GetImmediateContext(&d3d_context);

        DXGI_SWAP_CHAIN_DESC swap_chain_desc;
        swap_chain->GetDesc(&swap_chain_desc);
        ImGui::CreateContext();
        ImGuiIO& io = ImGui::GetIO();
        io.IniFilename = nullptr;
        io.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard;
        HWND window = swap_chain_desc.OutputWindow;

        //Set OriginalWndProcHandler to the Address of the Original WndProc function
        original_wnd_proc_handler = WNDPROC(SetWindowLongPtr(window, GWLP_WNDPROC, LONG_PTR(WindowProc)));

        ImGui_ImplWin32_Init(window);
        ImGui_ImplDX11_Init(d3d_device, d3d_context);
        ImGui::GetIO().ImeWindowHandle = window;

        // set style
        gui::InitializeStyle();
    }

    if (show_menu != previous_show_menu && !show_menu)
    {
        RenderingInterceptor::Get().OnCloseMenu();
        ImGui::GetIO().ClearInputCharacters();
    }
    previous_show_menu = show_menu;

    if (show_menu && d3d_device && imgui_render_target_view)
    {
        ImGui_ImplWin32_NewFrame();
        ImGui_ImplDX11_NewFrame();
        ImGui::NewFrame();

        ImGui::SetNextWindowPos(ImVec2(0, 0), ImGuiCond_Once);
        ImGui::SetNextWindowSize(ImVec2(300 * gui_scale, 800 * gui_scale), ImGuiCond_Always);
        ImGui::Begin("BlitzFX Settings", &show_menu, ImGuiWindowFlags_NoResize);

        RenderingInterceptor::Get().OnMenu();
        
        ImGui::End();
        ImGui::EndFrame();

        ImGui::GetIO().MouseDrawCursor = show_menu;
        ImGui::Render();
        d3d_context->OMSetRenderTargets(1, &imgui_render_target_view, nullptr);
        ImGui_ImplDX11_RenderDrawData(ImGui::GetDrawData());
    }
    int custom_vsync_interval = RenderingInterceptor::Get().GetConfiguration().v_sync_interval;
    sync_interval = custom_vsync_interval > 0 ? custom_vsync_interval : sync_interval;

    HRESULT hr;
    CHECK_HR(Hooks::Call(Present)(swap_chain, sync_interval, flags));
    return hr;
}

HRESULT ResizeBuffers(IDXGISwapChain* swap_chain, UINT buffer_count, UINT width, UINT height, DXGI_FORMAT new_format, UINT swap_chain_flags)
{
    if (imgui_render_target_view)
    {
        // release the rendertarget so that ResizeBuffer does not fail
        imgui_render_target_view->Release();
    }

    HRESULT hr;
    CHECK_HR(Hooks::Call(ResizeBuffers)(swap_chain, buffer_count, width, height, new_format, swap_chain_flags));

    static DirectX::XMUINT2 current_resolution(1, 1);
    if (width != current_resolution.x || height != current_resolution.y)
    {
        LOG(INFO) << "Resizing window: width = " << width << ", height = " << height << std::endl;
        RenderingInterceptor::Get().OnResize(width, height);
        current_resolution = { width, height };

        gui_scale = static_cast<float>(current_resolution.y) / 1080.0f;
        gui::ScaleGUI(gui_scale);
    }

    if (d3d_device)
    {
        ID3D11Texture2D* pBackBuffer;
        swap_chain->GetBuffer(0, __uuidof(ID3D11Texture2D), reinterpret_cast<LPVOID*>(&pBackBuffer));
        d3d_device->CreateRenderTargetView(pBackBuffer, nullptr, &imgui_render_target_view);
        pBackBuffer->Release();
    }
    return hr;
}
