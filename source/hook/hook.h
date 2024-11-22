#pragma once
#include <windows.h>
#include <cstdint>
#include <unordered_map>
#include <unordered_set>


namespace w3
{
class Hooks
{
public:
    template<typename T>
    static void Install(T replacement, FARPROC original, bool detour_function = true);

	static void Initialize();

    template<typename T>
    static T Call(T replacement);

	static void Terminate();
private:
	static void InitializeD3d11Hooks();
	static void InitializeDxgiHooks();

    static void InstallInternal(void* replacement, void* original, bool detour_function);
    

    static void* Call(void* replacement);

    static HMODULE d3d11_dll;
    static std::unordered_map<void*, void*> hooked_functions;
    static std::unordered_set<void*> detoured_functions;
};

template <typename T>
void Hooks::Install(T replacement, FARPROC original, bool detour_function)
{
    InstallInternal(static_cast<void*>(replacement), static_cast<void*>(original), detour_function);
}
template <typename T>
T Hooks::Call(T replacement)
{
    return static_cast<T>(Call(static_cast<void*>(replacement)));
}
}
