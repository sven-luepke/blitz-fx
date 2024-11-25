#pragma once
#include "d3d_interface.h"
#include "shader.h"

#include "d3d11_4.h"
#include "wrl/client.h"

namespace w3
{
template <typename T>
class ConstantBuffer : D3DInterface
{
public:
	ConstantBuffer() = default;
	void Create(bool enable_cpu_write);
	/*
	 * Copy data from a currently bound constant buffer
	 */
	void CopyFrom(int source_slot, SHADER_TYPE source_shader);
	void Wrap(int source_slot, SHADER_TYPE source_shader);
	void Release();
	void Bind(int slot, SHADER_TYPE shader_type);
	void UploadBuffer();
	T* operator->();
	ID3D11Buffer* GetBuffer() const;
private:
	Microsoft::WRL::ComPtr<ID3D11Buffer> _buffer;
	T _data;
};

template <typename T>
void ConstantBuffer<T>::Create(bool enable_cpu_write)
{
	D3D11_BUFFER_DESC buffer_desc;
	buffer_desc.ByteWidth = sizeof(T);
	buffer_desc.BindFlags = D3D11_BIND_CONSTANT_BUFFER;
	if (enable_cpu_write)
	{
		buffer_desc.Usage = D3D11_USAGE_DYNAMIC;
		buffer_desc.CPUAccessFlags = D3D11_CPU_ACCESS_WRITE;
	}
	else
	{
		buffer_desc.Usage = D3D11_USAGE_DEFAULT;
		buffer_desc.CPUAccessFlags = 0;
	}
	buffer_desc.MiscFlags = 0;
	buffer_desc.StructureByteStride = 0;

	T dummy_data = {};
	D3D11_SUBRESOURCE_DATA initData;
	initData.pSysMem = &dummy_data;
	initData.SysMemPitch = 0;
	initData.SysMemSlicePitch = 0;

	HR(GetD3DDevice()->CreateBuffer(&buffer_desc, &initData, _buffer.GetAddressOf()));
}
template <typename T>
void ConstantBuffer<T>::CopyFrom(int source_slot, SHADER_TYPE source_shader)
{
	ID3D11Buffer* tmp = nullptr;
	switch (source_shader)
	{
	case SHADER_TYPE::SHADER_TYPE_VERTEX:
		GetD3DContext()->VSGetConstantBuffers(source_slot, 1, &tmp);
		break;
	case SHADER_TYPE::SHADER_TYPE_HULL:
		GetD3DContext()->HSGetConstantBuffers(source_slot, 1, &tmp);
		break;
	case SHADER_TYPE::SHADER_TYPE_DOMAIN:
		GetD3DContext()->DSGetConstantBuffers(source_slot, 1, &tmp);
		break;
	case SHADER_TYPE::SHADER_TYPE_GEOMETRY:
		GetD3DContext()->GSGetConstantBuffers(source_slot, 1, &tmp);
		break;
	case SHADER_TYPE::SHADER_TYPE_PIXEL:
		GetD3DContext()->PSGetConstantBuffers(source_slot, 1, &tmp);
		break;
	case SHADER_TYPE::SHADER_TYPE_COMPUTE:
		GetD3DContext()->CSGetConstantBuffers(source_slot, 1, &tmp);
		break;
	default:
		break;
	}
	GetD3DContext()->CopyResource(_buffer.Get(), tmp);
	tmp->Release();
}
template <typename T>
void ConstantBuffer<T>::Wrap(int source_slot, SHADER_TYPE source_shader)
{
	switch (source_shader)
	{
	case SHADER_TYPE::SHADER_TYPE_VERTEX:
		GetD3DContext()->VSGetConstantBuffers(source_slot, 1, _buffer.ReleaseAndGetAddressOf());
		break;
	case SHADER_TYPE::SHADER_TYPE_HULL:
		GetD3DContext()->HSGetConstantBuffers(source_slot, 1, _buffer.ReleaseAndGetAddressOf());
		break;
	case SHADER_TYPE::SHADER_TYPE_DOMAIN:
		GetD3DContext()->DSGetConstantBuffers(source_slot, 1, _buffer.ReleaseAndGetAddressOf());
		break;
	case SHADER_TYPE::SHADER_TYPE_GEOMETRY:
		GetD3DContext()->GSGetConstantBuffers(source_slot, 1, _buffer.ReleaseAndGetAddressOf());
		break;
	case SHADER_TYPE::SHADER_TYPE_PIXEL:
		GetD3DContext()->PSGetConstantBuffers(source_slot, 1, _buffer.ReleaseAndGetAddressOf());
		break;
	case SHADER_TYPE::SHADER_TYPE_COMPUTE:
		GetD3DContext()->CSGetConstantBuffers(source_slot, 1, _buffer.ReleaseAndGetAddressOf());
		break;
	default:
		break;
	}
}
template <typename T>
void ConstantBuffer<T>::Release()
{
	_buffer.Reset();
}
template <typename T>
void ConstantBuffer<T>::Bind(int slot, SHADER_TYPE shader_type)
{
	if (shader_type & SHADER_TYPE::SHADER_TYPE_VERTEX)
	{
		GetD3DContext()->VSSetConstantBuffers(slot, 1, _buffer.GetAddressOf());
	}
	if (shader_type & SHADER_TYPE::SHADER_TYPE_HULL)
	{
		GetD3DContext()->HSSetConstantBuffers(slot, 1, _buffer.GetAddressOf());
	}
	if (shader_type & SHADER_TYPE::SHADER_TYPE_DOMAIN)
	{
		GetD3DContext()->DSSetConstantBuffers(slot, 1, _buffer.GetAddressOf());
	}
	if (shader_type & SHADER_TYPE::SHADER_TYPE_GEOMETRY)
	{
		GetD3DContext()->GSSetConstantBuffers(slot, 1, _buffer.GetAddressOf());
	}
	if (shader_type & SHADER_TYPE::SHADER_TYPE_PIXEL)
	{
		GetD3DContext()->PSSetConstantBuffers(slot, 1, _buffer.GetAddressOf());
	}
	if (shader_type & SHADER_TYPE::SHADER_TYPE_COMPUTE)
	{
		GetD3DContext()->CSSetConstantBuffers(slot, 1, _buffer.GetAddressOf());
	}
}
template <typename T>
void ConstantBuffer<T>::UploadBuffer()
{
	D3D11_MAPPED_SUBRESOURCE mapped_data;
	GetD3DContext()->Map(_buffer.Get(), 0, D3D11_MAP_WRITE_DISCARD, 0, &mapped_data);
	memcpy_s(mapped_data.pData, sizeof(T), &_data, sizeof(T));
	GetD3DContext()->Unmap(_buffer.Get(), 0);
}
template <typename T>
T* ConstantBuffer<T>::operator->()
{
	return &_data;
}
template <typename T>
ID3D11Buffer* ConstantBuffer<T>::GetBuffer() const
{
	return _buffer.Get();
}
}
