#include "resource_manager.h"

#include <fstream>
#include <iostream>
#include <thread>
#include <filesystem>

#include <d3dcompiler.h>
#include "external/WICTextureLoader11.h"
#include "external/aixlog.h"
#include "external/ini.h"

// needed for the texture loaders
#pragma comment( lib, "dxguid.lib")

#ifdef PUBLIC_RELEASE
#define READ_SHADER_CACHE
#endif

using namespace w3;
using namespace DirectX;

namespace fs = std::filesystem;

namespace
{
template <typename T>
void WriteValue(std::ofstream& stream, T value)
{
    stream.write(reinterpret_cast<char*>(&value), sizeof(T));
}
template <typename T>
void ReadValue(std::ifstream& stream, T& value)
{
    stream.read(reinterpret_cast<char*>(&value), sizeof(T));
}
}


ResourceManager::ResourceManager(const std::string& resources_directory) :
    _resources_directory(resources_directory),
    _shaders_directory(resources_directory + "shaders_v2\\"),
    _textures_directory(resources_directory + "textures\\"),
    _config_path(_resources_directory + "blitz.settings")
{
    Initialize();
}
ResourceManager::~ResourceManager()
{
    Terminate();
}
void ResourceManager::Initialize()
{
    //HRESULT hr = CoInitializeEx(nullptr, COINIT_MULTITHREADED); // seems like this is already called somewhere else
    //	if (hr != RPC_E_CHANGED_MODE)
    {
        //	HR(hr);
    }
    LoadTextures();
    LoadShaders();
}
void ResourceManager::Terminate()
{
    for (auto& shader : _shaders)
    {
        if (shader.second != nullptr && shader.second->IsCreated())
        {
            shader.second->Release();
            delete shader.second;
            shader.second = nullptr;
        }
    }
    for (auto& texture : _textures)
    {
        texture.second->Release();
    }
}
void ResourceManager::ReloadTextures()
{
    LoadTextures();
}
void ResourceManager::ReloadShaders()
{
    std::list<std::thread> threads;
    for (auto& pair : _shaders)
    {
        if (pair.second != nullptr)
        {
            pair.second->Release();
            threads.emplace_back(std::thread(&Shader::Compile, pair.second));
        }
    }
    for (std::thread& thread : threads)
    {
        thread.join();
    }
    for (auto& pair : _shaders)
    {
        if (pair.second != nullptr)
        {
            pair.second->Create();
        }
    }
}
Configuration ResourceManager::LoadConfig() const
{
    fs::path absolute_path = fs::absolute(_config_path);
    std::string absolute_path_string = absolute_path.string();
    LOG(INFO) << "Loading config from: " << absolute_path_string << std::endl;
    mINI::INIFile file(absolute_path_string);
    mINI::INIStructure ini_data;
    file.read(ini_data);

    const auto& settings = ini_data["Settings"];
    std::unordered_map<std::string, std::string> map;
    for (const auto& pair : settings)
    {
        map[pair.first] = pair.second;
    }
    return Configuration::FromMap(map);
}
void ResourceManager::SaveConfig(const Configuration& config) const
{
    std::unordered_map<std::string, std::string> map = Configuration::ToMap(config);
    mINI::INIStructure ini_data;
    for (const auto& pair : map)
    {
        ini_data["Settings"][pair.first] = pair.second;
    }

    fs::path absolute_path = fs::absolute(_config_path);
    std::string absolute_path_string = absolute_path.string();
    LOG(INFO) << "Saving config to: " << absolute_path_string << std::endl;
    mINI::INIFile file(absolute_path_string);
    file.write(ini_data);
}
Shader* ResourceManager::GetShader(uint64_t shader_name_string_id, bool create)
{
    Shader* shader = _shaders[shader_name_string_id];
    // create shader on first access
    if (shader != nullptr && create && !shader->IsCreated())
    {
        shader->Create();
    }
    return shader;
}
ID3D11ShaderResourceView* ResourceManager::GetTextureShaderResourceView(uint64_t texture_name_string_id)
{
    auto it = _textures.find(texture_name_string_id);
    if (it == _textures.end())
    {
        std::wstring path = _texture_paths[texture_name_string_id];
        CreateWICTextureFromFile(GetD3DDevice(), path.c_str(), nullptr, &_textures[texture_name_string_id]);
    }
    return _textures[texture_name_string_id];
}
void ResourceManager::LoadTextures()
{
    for (const auto& directory_entry : fs::recursive_directory_iterator(_textures_directory))
    {
        if (directory_entry.path().extension() == ".png")
        {
            if (!fs::exists(directory_entry))
            {
                continue;
            }
            if (directory_entry.file_size() == 0)
            {
                continue;
            }
            std::error_code error_code;
            auto current_last_write_time = fs::last_write_time(directory_entry.path(), error_code);

            StringId texture_file_id(directory_entry.path().filename().stem().string().c_str());
            auto it = _last_write_times.find(texture_file_id.GetHash());
            if (it != _last_write_times.end())
            {
                if (it->second != current_last_write_time)
                {
                    //_textures[texture_file_id.GetHash()]->Release();
                    CreateWICTextureFromFile(GetD3DDevice(), directory_entry.path().wstring().c_str(), nullptr,
                                             &_textures[texture_file_id.GetHash()]);
                }
            }
            else
            {
                // defer creation until texture is used and the D3D11 Device is initalized
                _texture_paths[texture_file_id.GetHash()] = directory_entry.path().wstring();
            }
            _last_write_times[texture_file_id.GetHash()] = current_last_write_time;
        }
    }
}
void ResourceManager::LoadShaders()
{
#ifdef READ_SHADER_CACHE
    LOG(INFO) << "Loading shaders from cache" << std::endl;
    ReadShaderCache();
#else
    LOG(INFO) << "Compiling shaders..." << std::endl;
    for (const auto& directory_entry : fs::recursive_directory_iterator(_shaders_directory))
    {
        if (directory_entry.path().extension() == ".hlsl")
        {
            StringId shader_file_id(directory_entry.path().filename().stem().string().c_str());
            _shaders[shader_file_id.GetHash()] = ShaderFactory::CreateShader(directory_entry.path().string());
        }
    }
    std::vector<std::thread> threads;
    for (auto& pair : _shaders)
    {
        threads.emplace_back(std::thread(&Shader::Compile, pair.second));
    }
    for (std::thread& thread : threads)
    {
        thread.join();
    }
    WriteShaderCache();
#endif
}
void ResourceManager::WriteShaderCache()
{
    std::ofstream shader_cache_file(_resources_directory + "blitz.shaders", std::ios::out | std::ios::binary | std::ios::trunc);

    uint32_t shader_count = _shaders.size();
    WriteValue(shader_cache_file, shader_count);
    for (auto& hash_shader : _shaders)
    {
        WriteValue(shader_cache_file, hash_shader.first);
        WriteValue(shader_cache_file, static_cast<uint8_t>(hash_shader.second->GetType()));
        WriteValue(shader_cache_file, static_cast<uint32_t>(hash_shader.second->GetBytecode()->GetBufferSize()));
    }
    for (auto& hash_shader : _shaders)
    {
        ID3DBlob* bytecode = hash_shader.second->GetBytecode();
        shader_cache_file.write(static_cast<char*>(bytecode->GetBufferPointer()), bytecode->GetBufferSize());
    }
}
void ResourceManager::ReadShaderCache()
{
    std::ifstream shader_cache_file(_resources_directory + "blitz.shaders", std::ios::in | std::ios::binary);

    struct ShaderMetaData
    {
        uint64_t shader_file_name_hash;
        SHADER_TYPE shader_type;
        uint32_t shader_size;
    };

    std::vector<ShaderMetaData> shader_meta_datas;
    uint32_t shader_count;
    ReadValue(shader_cache_file, shader_count);
    for (int i = 0; i < shader_count; i++)
    {
        ShaderMetaData meta_data;

        ReadValue(shader_cache_file, meta_data.shader_file_name_hash);

        uint8_t shader_type_int;
        ReadValue(shader_cache_file, shader_type_int);
        meta_data.shader_type = SHADER_TYPE(shader_type_int);

        ReadValue(shader_cache_file, meta_data.shader_size);
        shader_meta_datas.emplace_back(meta_data);
    }
    for (const ShaderMetaData& meta_data : shader_meta_datas)
    {
        ID3DBlob* bytecode;
        D3DCreateBlob(meta_data.shader_size, &bytecode);
        shader_cache_file.read(static_cast<char*>(bytecode->GetBufferPointer()), meta_data.shader_size);
        _shaders[meta_data.shader_file_name_hash] = ShaderFactory::CreateShader(bytecode, meta_data.shader_type);
    }
}
