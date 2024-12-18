#include "hook/hook.h"
#include "windows.h"
#include <iomanip>
#include <cstdio>

#include "external/aixlog.h"
#include "rendering/rendering_interceptor.h"

#pragma comment(lib, "D3DCompiler")

using namespace w3;

void SetupConsole()
{
#ifndef PUBLIC_RELEASE
	AllocConsole();
	SetConsoleTitleA("Witcher 3 Console");
	FILE* file;
	freopen_s(&file, "CONOUT$", "w", stdout);
	freopen_s(&file, "CONOUT$", "w", stderr);
	freopen_s(&file, "CONIN$", "r", stdin);
#endif
}

void SetupLogger()
{
    auto sink = AixLog::Log::init<AixLog::SinkFile>(AixLog::Severity::trace, "blitz.log");
}



BOOL APIENTRY DllMain(HMODULE h_module, DWORD ul_reason_for_call, LPVOID lp_reserved)
{
	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH:
		// https://www.unknowncheats.me/forum/direct3d/223947-swapchain-hooking.html
		DisableThreadLibraryCalls(h_module);
		SetupConsole();
        SetupLogger();
		CreateThread(nullptr, 0, reinterpret_cast<LPTHREAD_START_ROUTINE>(Hooks::Initialize), nullptr, 0, nullptr);
		return TRUE;
	case DLL_PROCESS_DETACH:
        if (lp_reserved != nullptr)  // process is exiting
        {
            // don't free resources? (https://devblogs.microsoft.com/oldnewthing/20120105-00/?p=8683)
            //RenderingInterceptor::Get().Terminate();
            Hooks::Terminate();
        }
		return TRUE;
	case DLL_THREAD_ATTACH:
		return TRUE;
	case DLL_THREAD_DETACH:
		return TRUE;
	default:
		break;
	}
	return TRUE;
}
