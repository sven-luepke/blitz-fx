#include "shader.h"

#include <d3dcompiler.h>
#include <windows.h>
#include <wrl/client.h>

#include <iostream>
#include <cassert>
#include <cstdlib>
#include <fstream>
#include <thread>
#include <filesystem>
#include <sstream>
#include <string>
#include <vector>

using namespace w3;
using namespace Microsoft::WRL;

namespace fs = std::filesystem;

/*
 * Specific shader types
 */
class VertexShader : public Shader
{
public:
    explicit VertexShader(const char* filename);
    explicit VertexShader(ID3DBlob* bytecode);

    void Create() override;
    void Release() override;
    void Bind() override;
private:
    ComPtr<ID3D11VertexShader> _d3d_vertex_shader;
};

class PixelShader : public Shader
{
public:
    explicit PixelShader(const char* filename);
    explicit PixelShader(ID3DBlob* bytecode);

    void Create() override;
    void Release() override;
    void Bind() override;
private:
    ComPtr<ID3D11PixelShader> _d3d_pixel_shader;
};

class ComputeShader : public Shader
{
public:
    explicit ComputeShader(const char* filename);
    explicit ComputeShader(ID3DBlob* bytecode);

    void Create() override;
    void Release() override;
    void Bind() override;
private:
    ComPtr<ID3D11ComputeShader> _d3d_compute_shader;
};

class DomainShader : public Shader
{
public:
    explicit DomainShader(const char* filename);
    explicit DomainShader(ID3DBlob* bytecode);

    void Create() override;
    void Release() override;
    void Bind() override;
private:
    ComPtr<ID3D11DomainShader> _d3d_domain_shader;
};

class GeometryShader : public Shader
{
public:
    explicit GeometryShader(const char* filename);
    explicit GeometryShader(ID3DBlob* bytecode);

    void Create() override;
    void Release() override;
    void Bind() override;
private:
    ComPtr<ID3D11GeometryShader> _d3d_geometry_shader;
};

static UINT compile_flags = D3DCOMPILE_OPTIMIZATION_LEVEL3;

Shader::Shader(const char* source_path, SHADER_TYPE shader_type, const char* entry_point, const char* compiler_target) :
    _source_path(source_path), _type(shader_type), _entry_point(entry_point),
    _compiler_target(compiler_target), _is_created(false)
{
}
Shader::Shader(ID3DBlob* bytecode, SHADER_TYPE shader_type) : _source_path(""), _type(shader_type), _entry_point(nullptr),
                                                              _compiler_target(nullptr), _is_created(false), _shader_blob(bytecode)
{
}

class W3Include : public ID3DInclude
{
public:
    W3Include(const char* parent_file_path) : _parent_file_path(parent_file_path)
    {
    }
    HRESULT Open(D3D_INCLUDE_TYPE IncludeType, LPCSTR pFileName, LPCVOID pParentData, LPCVOID* ppData, UINT* pBytes) noexcept override
    {
        fs::path file_path;
        switch (IncludeType)
        {
        case D3D_INCLUDE_LOCAL:
            file_path = _parent_file_path.parent_path();
            break;
        case D3D_INCLUDE_SYSTEM:
            return E_FAIL;
            file_path = _parent_file_path.parent_path().parent_path();
            break;
        default:
            return E_FAIL;
        }

        // search upper level directories
        fs::path current_path = _parent_file_path.parent_path();
        bool found_file = false;
        while (!found_file)
        {
            for (const auto& directory_entry : fs::directory_iterator(current_path))
            {
                if (directory_entry.path().filename() == pFileName)
                {
                    file_path = directory_entry.path();
                    found_file = true;
                    break;
                }
            }
            if (current_path.filename() == "shaders")
            {
                break;
            }
            current_path = current_path.parent_path();
        }
        if (!found_file)
        {
            return E_FAIL;
        }
        file_path = fs::absolute(file_path);

        if (!fs::exists(file_path))
        {
            return E_FAIL;
        }

        std::ifstream file(file_path, std::ios::binary | std::ios::ate);
        std::streamsize size = file.tellg();
        *pBytes = size;
        file.seekg(0, std::ios::beg);

        auto* data = static_cast<char*>(std::malloc(*pBytes));
        file.read(data, size);
        *ppData = data;
        return S_OK;
    }
    HRESULT Close(LPCVOID pData) override
    {
        std::free(const_cast<void*>(pData));
        return S_OK;
    }
private:
    const fs::path _parent_file_path;
};

void Shader::Compile()
{
    if (_entry_point == nullptr && _compiler_target == nullptr)
    {
        // skip compilation because this shader object was created from bytecode
        return;
    }

    ComPtr<ID3DBlob> error_blob = nullptr;
    wchar_t wSourcePath[512];
    size_t count;
    mbstowcs_s(&count, wSourcePath, _source_path.c_str(), 512);
    W3Include include(_source_path.c_str());

    while (true)
    {
        HRESULT hr = D3DCompileFromFile(wSourcePath, nullptr, &include, _entry_point, _compiler_target,
                                        compile_flags, 0,
                                        _shader_blob.GetAddressOf(), error_blob.GetAddressOf());
        if (FAILED(hr))
        {
            const char* errorMsg = static_cast<const char*>(error_blob->GetBufferPointer());
            std::string title{"Shader Compilation Error: "};
            title.append(_source_path.c_str());
            if (MessageBoxA(nullptr, errorMsg, title.c_str(), MB_RETRYCANCEL) == IDCANCEL)
            {
                exit(1);
            }
            continue;
        }
        break;
    }

    ComPtr<ID3DBlob> stripped_bytecode;
    D3DStripShader(_shader_blob->GetBufferPointer(), _shader_blob->GetBufferSize(),
                   D3DCOMPILER_STRIP_DEBUG_INFO | D3DCOMPILER_STRIP_TEST_BLOBS, stripped_bytecode.GetAddressOf());
    _shader_blob.Reset();
    _shader_blob = stripped_bytecode;
}
void Shader::Create()
{
    _is_created = true;
    ReflectShader();
}
VertexShader::VertexShader(const char* filename) : Shader(filename, SHADER_TYPE_VERTEX, "VSMain", "vs_5_0")
{
}
VertexShader::VertexShader(ID3DBlob* bytecode) : Shader(bytecode, SHADER_TYPE_VERTEX)
{
}
void VertexShader::Create()
{
    Shader::Create();
    ComPtr<ID3DBlob> stripped_bytecode;
    D3DStripShader(_shader_blob->GetBufferPointer(), _shader_blob->GetBufferSize(),
                   D3DCOMPILER_STRIP_REFLECTION_DATA, stripped_bytecode.GetAddressOf());
    HR(GetD3DDevice()->CreateVertexShader(stripped_bytecode->GetBufferPointer(), stripped_bytecode->GetBufferSize(), nullptr,
        _d3d_vertex_shader.GetAddressOf()));
}
void VertexShader::Release()
{
    _is_created = false;
    _d3d_vertex_shader.Reset();
}
void VertexShader::Bind()
{
    GetD3DContext()->VSSetShader(_d3d_vertex_shader.Get(), nullptr, 0);
}

PixelShader::PixelShader(const char* filename) : Shader(filename, SHADER_TYPE_PIXEL, "PSMain", "ps_5_0")
{
}
PixelShader::PixelShader(ID3DBlob* bytecode) : Shader(bytecode, SHADER_TYPE_PIXEL)
{
}
void PixelShader::Create()
{
    Shader::Create();
    ComPtr<ID3DBlob> stripped_bytecode;
    D3DStripShader(_shader_blob->GetBufferPointer(), _shader_blob->GetBufferSize(),
                   D3DCOMPILER_STRIP_REFLECTION_DATA, stripped_bytecode.GetAddressOf());
    HR(GetD3DDevice()->CreatePixelShader(stripped_bytecode->GetBufferPointer(), stripped_bytecode->GetBufferSize(), nullptr,
        _d3d_pixel_shader.GetAddressOf()));
}
void PixelShader::Release()
{
    _is_created = false;
    _d3d_pixel_shader.Reset();
}
void PixelShader::Bind()
{
    GetD3DContext()->PSSetShader(_d3d_pixel_shader.Get(), nullptr, 0);
}

ComputeShader::ComputeShader(const char* filename) : Shader(filename, SHADER_TYPE_COMPUTE, "CSMain", "cs_5_0")
{
}
ComputeShader::ComputeShader(ID3DBlob* bytecode) : Shader(bytecode, SHADER_TYPE_COMPUTE)
{
}
void ComputeShader::Create()
{
    Shader::Create();
    ComPtr<ID3DBlob> stripped_bytecode;
    D3DStripShader(_shader_blob->GetBufferPointer(), _shader_blob->GetBufferSize(),
                   D3DCOMPILER_STRIP_REFLECTION_DATA, stripped_bytecode.GetAddressOf());
    HR(GetD3DDevice()->CreateComputeShader(stripped_bytecode->GetBufferPointer(), stripped_bytecode->GetBufferSize(), nullptr,
        _d3d_compute_shader.GetAddressOf()));
}
void ComputeShader::Release()
{
    _is_created = false;
    _d3d_compute_shader.Reset();
}
void ComputeShader::Bind()
{
    GetD3DContext()->CSSetShader(_d3d_compute_shader.Get(), nullptr, 0);
}

DomainShader::DomainShader(const char* filename) : Shader(filename, SHADER_TYPE_DOMAIN, "DSMain", "ds_5_0")
{
}
DomainShader::DomainShader(ID3DBlob* bytecode) : Shader(bytecode, SHADER_TYPE_DOMAIN)
{
}
void DomainShader::Create()
{
    Shader::Create();
    ComPtr<ID3DBlob> stripped_bytecode;
    D3DStripShader(_shader_blob->GetBufferPointer(), _shader_blob->GetBufferSize(),
                   D3DCOMPILER_STRIP_REFLECTION_DATA, stripped_bytecode.GetAddressOf());
    HR(GetD3DDevice()->CreateDomainShader(stripped_bytecode->GetBufferPointer(), stripped_bytecode->GetBufferSize(), nullptr,
        _d3d_domain_shader.GetAddressOf()));
}
void DomainShader::Release()
{
    _is_created = false;
    _d3d_domain_shader.Reset();
}
void DomainShader::Bind()
{
    GetD3DContext()->DSSetShader(_d3d_domain_shader.Get(), nullptr, 0);
}

GeometryShader::GeometryShader(const char* filename) : Shader(filename, SHADER_TYPE_GEOMETRY, "GSMain", "gs_5_0")
{
}
GeometryShader::GeometryShader(ID3DBlob* bytecode) : Shader(bytecode, SHADER_TYPE_GEOMETRY)
{
}
void GeometryShader::Create()
{
    Shader::Create();
    ComPtr<ID3DBlob> stripped_bytecode;
    D3DStripShader(_shader_blob->GetBufferPointer(), _shader_blob->GetBufferSize(),
                   D3DCOMPILER_STRIP_REFLECTION_DATA, stripped_bytecode.GetAddressOf());
    HR(GetD3DDevice()->CreateGeometryShader(stripped_bytecode->GetBufferPointer(), stripped_bytecode->GetBufferSize(), nullptr,
        _d3d_geometry_shader.GetAddressOf()));
}
void GeometryShader::Release()
{
    _is_created = false;
    _d3d_geometry_shader.Reset();
}
void GeometryShader::Bind()
{
    GetD3DContext()->GSSetShader(_d3d_geometry_shader.Get(), nullptr, 0);
}

const StringId& Shader::GetSourcePath()
{
    return _source_path;
}
void Shader::ReflectShader()
{
    _reflected_constant_buffers.clear();
    _reflected_textures.clear();
    _reflected_samplers.clear();

    ID3D11ShaderReflection* shader_reflection = nullptr;
    D3DReflect(_shader_blob->GetBufferPointer(), _shader_blob->GetBufferSize(),
               IID_ID3D11ShaderReflection, reinterpret_cast<void**>(&shader_reflection));
    D3D11_SHADER_DESC shader_desc;
    shader_reflection->GetDesc(&shader_desc);

    for (UINT i = 0; i < shader_desc.BoundResources; i++)
    {
        D3D11_SHADER_INPUT_BIND_DESC bind_desc;
        shader_reflection->GetResourceBindingDesc(i, &bind_desc);
        if (bind_desc.Name[0] != '_')
        {
            // reflect only those resources whose name starts with an underscore ('_')
            continue;
        }
        switch (bind_desc.Type)
        {
        case D3D_SIT_CBUFFER:
            _reflected_constant_buffers[StringId(bind_desc.Name).GetHash()] = bind_desc.BindPoint;
            break;
        case D3D_SIT_TEXTURE:
            _reflected_textures[StringId(bind_desc.Name).GetHash()] = bind_desc.BindPoint;
            break;
        case D3D_SIT_SAMPLER:
            {
                // TODO: add parsing of more sampler properties

                SamplerDescription sampler_description;

                bool is_comparison_sampler = false;
                if (strstr(bind_desc.Name, "comparison") != nullptr)
                {
                    is_comparison_sampler = true;
                }

                if (strstr(bind_desc.Name, "linear") != nullptr)
                {
                    sampler_description.filter
                        = is_comparison_sampler ? D3D11_FILTER_COMPARISON_MIN_MAG_MIP_LINEAR : D3D11_FILTER_MIN_MAG_MIP_LINEAR;
                }
                else if (strstr(bind_desc.Name, "point") != nullptr)
                {
                    sampler_description.filter
                        = is_comparison_sampler ? D3D11_FILTER_COMPARISON_MIN_MAG_MIP_POINT : D3D11_FILTER_MIN_MAG_MIP_POINT;
                }
                else if (strstr(bind_desc.Name, "anisotropic") != nullptr)
                {
                    sampler_description.filter 
                        = is_comparison_sampler ? D3D11_FILTER_COMPARISON_ANISOTROPIC : D3D11_FILTER_ANISOTROPIC;

                }

                if (strstr(bind_desc.Name, "clamp") != nullptr)
                {
                    sampler_description.address_mode = D3D11_TEXTURE_ADDRESS_CLAMP;
                }
                else if (strstr(bind_desc.Name, "border") != nullptr)
                {
                    sampler_description.address_mode = D3D11_TEXTURE_ADDRESS_BORDER;
                }
                else if (strstr(bind_desc.Name, "wrap") != nullptr)
                {
                    sampler_description.address_mode = D3D11_TEXTURE_ADDRESS_WRAP;
                }
                else if (strstr(bind_desc.Name, "mirror") != nullptr)
                {
                    sampler_description.address_mode = D3D11_TEXTURE_ADDRESS_MIRROR;
                }

                if (is_comparison_sampler)
                {
                    if (strstr(bind_desc.Name, "less") != nullptr)
                    {
                        sampler_description.comparison_func = D3D11_COMPARISON_LESS;
                    }
                }

                _reflected_samplers.emplace_back(std::make_pair(sampler_description, bind_desc.BindPoint));
            }
            break;
        default:
            break;
        }
    }
}
Shader* ShaderFactory::CreateShader(const std::string& filename)
{
    static const char* hlsl_suffix = ".hlsl";
    static const size_t suffix_length = strlen(hlsl_suffix);
    size_t file_name_length = filename.length();
    size_t extension_position = file_name_length - suffix_length;

    Shader* shader = nullptr;

    std::string filename_without_suffix = filename.substr(0, extension_position);
    // check shader type
    switch (filename[extension_position - 2])
    {
    case L'V':
        shader = new VertexShader(filename.c_str());
        break;
    case L'H':
        assert(false);
        break;
    case L'D':
        shader = new DomainShader(filename.c_str());
        break;
    case L'G':
        shader = new GeometryShader(filename.c_str());
        break;
    case L'P':
        shader = new PixelShader(filename.c_str());
        break;
    case L'C':
        shader = new ComputeShader(filename.c_str());
        break;
    default:
        break;
    }
    return shader;
}
Shader* ShaderFactory::CreateShader(ID3DBlob* bytecode, SHADER_TYPE shader_type)
{
    switch (shader_type)
    {
    case SHADER_TYPE_VERTEX:
        return new VertexShader(bytecode);
    case SHADER_TYPE_HULL:
        assert(false);
        return nullptr;
    case SHADER_TYPE_DOMAIN:
        return new DomainShader(bytecode);
    case SHADER_TYPE_GEOMETRY:
        return new GeometryShader(bytecode);
    case SHADER_TYPE_PIXEL:
        return new PixelShader(bytecode);
    case SHADER_TYPE_COMPUTE:
        return new ComputeShader(bytecode);
    default:
        return nullptr;
    }
}
ShaderSignature ShaderSignature::FromRenderDocHash(const char* renderdoc_shader_hash)
{
    std::stringstream hash_str(renderdoc_shader_hash);
    std::string segment;
    std::vector<uint64_t> parts;
    while (std::getline(hash_str, segment, '-'))
    {
        parts.push_back(std::stoull(segment, nullptr, 16));
    }
    uint64_t lower_part = parts[0] | (parts[1] << 32);
    uint64_t upper_part = parts[2] | (parts[3] << 32);
    return ShaderSignature(lower_part, upper_part);
}
