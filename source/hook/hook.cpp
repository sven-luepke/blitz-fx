#include "hook.h"
#include "external/aixlog.h"
#include "external/detours.h"

using namespace w3;

HMODULE Hooks::d3d11_dll = nullptr;
std::unordered_map<void*, void*> Hooks::hooked_functions;
std::unordered_set<void*> Hooks::detoured_functions;

void Hooks::Initialize()
{
    LOG(INFO) << "Initializing hooks" << std::endl;

    wchar_t buffer[512];
    GetSystemDirectoryW(buffer, 512);
    std::wstring path(buffer);
    path += L"\\d3d11.dll";
    d3d11_dll = LoadLibraryW(path.c_str());

	InitializeD3d11Hooks();
	InitializeDxgiHooks();
}
void Hooks::InstallInternal(void* replacement, void* original, bool detour_function)
{
    if (detour_function)
    {
        DetourTransactionBegin();
        DetourUpdateThread(GetCurrentThread());
        DetourAttach(&original, replacement);
        DetourTransactionCommit();
        detoured_functions.insert(replacement);
    }
    hooked_functions[replacement] = original;
}
void* Hooks::Call(void* replacement)
{
    return hooked_functions[replacement];
}
void Hooks::Terminate()
{
    LOG(INFO) << "Terminating hooks" << std::endl;

    DetourTransactionBegin();
    DetourUpdateThread(GetCurrentThread());
    for (auto& replacement_original : hooked_functions)
    {
        if (detoured_functions.find(replacement_original.first) != detoured_functions.end())
        {
            DetourDetach(&reinterpret_cast<LPVOID&>(replacement_original.second), replacement_original.first);
        }
    }
    DetourTransactionCommit();

    FreeLibrary(d3d11_dll);
}

