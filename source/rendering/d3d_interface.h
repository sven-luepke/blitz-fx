#pragma once
#include "d3d11_4.h"

#include "comdef.h"

#include <cassert>
#include <string>

//#ifdef _DEBUG
//#define HR(hr) do { \
//		HRESULT h_result = hr; \
//		if (FAILED(h_result)) { \
//			std::wstring msg(_com_error(h_result).ErrorMessage()); \
//			msg += std::to_wstring(hr); \
//			msg += L" in\n"; \
//			msg += L#hr; \
//			MessageBoxW(nullptr, msg.c_str(), TEXT("DirectX Error"), MB_OK | MB_ICONERROR); \
//		} \
//	} while (false)
//#else
#define HR(hr) hr
//#endif

namespace w3
{
class D3DInterface
{
protected:
	static ID3D11Device* GetD3DDevice();
	static ID3D11DeviceContext* GetD3DContext();
	static void Initialize(ID3D11Device* d3d_device, ID3D11DeviceContext* d3d_context);

    static void SetD3DContext(ID3D11DeviceContext* d3d_context)
    {
        D3DInterface::d3d_context = d3d_context;
    }
private:
	static ID3D11Device* d3d_device;
	static ID3D11DeviceContext* d3d_context;
};

inline ID3D11Device* D3DInterface::GetD3DDevice()
{
	return d3d_device;
}
inline ID3D11DeviceContext* D3DInterface::GetD3DContext()
{
	return d3d_context;
}
inline void D3DInterface::Initialize(ID3D11Device* d3d_device, ID3D11DeviceContext* d3d_context)
{
	D3DInterface::d3d_device = d3d_device;
	D3DInterface::d3d_context = d3d_context;
}
}
