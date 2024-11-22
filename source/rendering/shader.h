#pragma once
#include "d3d_interface.h"
#include "sampler.h"

#include "core/string_id.h"

#include "wrl/client.h"

#include <unordered_map>
#include <cstdlib>


namespace w3
{

enum SHADER_TYPE
{
	SHADER_TYPE_VERTEX = 0x1,
	SHADER_TYPE_HULL = 0x2,
	SHADER_TYPE_DOMAIN = 0x4,
	SHADER_TYPE_GEOMETRY = 0x8,
	SHADER_TYPE_PIXEL = 0x10,
	SHADER_TYPE_COMPUTE = 0x20,
};

class Shader : protected D3DInterface
{
public:	
	Shader(const char* source_path, SHADER_TYPE shader_type, const char* entry_point, const char* compiler_target);
    Shader(ID3DBlob* bytecode, SHADER_TYPE shader_type);
	virtual ~Shader() = default;

	void Compile();

	virtual void Create();
	virtual void Release() = 0;
	virtual void Bind() = 0;

	const StringId& GetSourcePath();
	bool IsCreated() const;
	SHADER_TYPE GetType() const;
    ID3DBlob* GetBytecode() const;

	const auto& GetReflectedTextures() const;
	const auto& GetReflectedConstantBuffers() const;
	const auto& GetReflectedSamplers() const;
protected:
	void ReflectShader();

	StringId _source_path;
	const SHADER_TYPE _type;
	const char* _entry_point;
	const char* _compiler_target;
	bool _is_created;

	Microsoft::WRL::ComPtr<ID3DBlob> _shader_blob;

	// map resources to the slot they are bound to
	std::unordered_map<StringIdHash, uint32_t> _reflected_textures;
	std::unordered_map<StringIdHash, uint32_t> _reflected_constant_buffers;
	std::vector<std::pair<SamplerDescription, uint32_t>> _reflected_samplers;
};

inline const auto& Shader::GetReflectedTextures() const
{
	return _reflected_textures;
}
inline const auto& Shader::GetReflectedConstantBuffers() const
{
	return _reflected_constant_buffers;
}
inline const auto& Shader::GetReflectedSamplers() const
{
	return _reflected_samplers;
}


class ShaderFactory
{
public:
	static Shader* CreateShader(const std::string& filename);
    static Shader* CreateShader(ID3DBlob* bytecode, SHADER_TYPE shader_type);
};

inline bool Shader::IsCreated() const
{
	return _is_created;
}
inline SHADER_TYPE Shader::GetType() const
{
	return _type;
}
inline ID3DBlob* Shader::GetBytecode() const
{
    return _shader_blob.Get();
}


struct ShaderSignature
{
	ShaderSignature() = default;
	ShaderSignature(const ShaderSignature& shader_signature);
	ShaderSignature(const void* shader_bytecode);
	ShaderSignature(uint64_t checksum0, uint64_t checksum1);

	ShaderSignature(const char* signature);

    static ShaderSignature FromRenderDocHash(const char* renderdoc_shader_hash);
	
	bool operator==(const ShaderSignature& other) const;
	uint64_t GetHash() const;
	std::pair<uint64_t, uint64_t> GetSignature() const;
private:
	//std::pair<uint64_t, uint64_t> _signature;
	uint64_t _signature_lower;
	uint64_t _signature_upper;
};

inline ShaderSignature::ShaderSignature(const ShaderSignature& shader_signature)
{
	_signature_upper = shader_signature._signature_upper;
	_signature_lower = shader_signature._signature_lower;
}
inline ShaderSignature::ShaderSignature(const void* shader_bytecode)
{
	const char* ptr = static_cast<const char*>(shader_bytecode);
	_signature_lower = *reinterpret_cast<const uint64_t*>(ptr + 4);
	_signature_upper = *reinterpret_cast<const uint64_t*>(ptr + 12);
}
inline ShaderSignature::ShaderSignature(uint64_t checksum0, uint64_t checksum1)
	: _signature_lower(checksum0), _signature_upper(checksum1)
{
}
inline ShaderSignature::ShaderSignature(const char* signature)
{
	char buffer[17];
	
	memcpy_s(buffer, 17, &signature[2], 16);
	buffer[16] = '\0';
	_signature_lower = strtoull(buffer, nullptr, 16);
	
	memcpy_s(buffer, 17, &signature[18], 16);
	buffer[16] = '\0';
	_signature_upper = strtoull(buffer, nullptr, 16);
}


inline bool ShaderSignature::operator==(const ShaderSignature& other) const
{
	return _signature_lower == other._signature_lower && _signature_upper == other._signature_upper;
}
inline uint64_t ShaderSignature::GetHash() const
{
	auto Splittable64 = [](uint64_t x) -> uint64_t
	{
		x ^= x >> 30;
		x *= UINT64_C(0xbf58476d1ce4e5b9);
		x ^= x >> 27;
		x *= UINT64_C(0x94d049bb133111eb);
		x ^= x >> 31;
		return x;
	};
	uint64_t lower_hash = Splittable64(_signature_lower);
	uint64_t upper_hash = Splittable64(_signature_upper);
	uint64_t rotated_upper = upper_hash << 31 | upper_hash >> 33;
	return lower_hash ^ rotated_upper;
}
inline std::pair<uint64_t, uint64_t> ShaderSignature::GetSignature() const
{
	return std::make_pair(_signature_lower, _signature_upper);
}
}

namespace std
{
template <>
struct hash<w3::ShaderSignature>
{
	std::size_t operator()(const w3::ShaderSignature& shader_signature) const noexcept
	{
		return shader_signature.GetHash();
	}
};
}
