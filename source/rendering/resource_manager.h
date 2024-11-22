#pragma once
#include "shader.h"
#include "config.h"
#include <filesystem>

namespace w3
{
class ResourceManager : D3DInterface
{
public:
	explicit ResourceManager(const std::string& resources_directory);
    ~ResourceManager();

	void ReloadTextures();
	void ReloadShaders();

    Configuration LoadConfig() const;
    void SaveConfig(const Configuration& config) const;

	Shader* GetShader(uint64_t shader_name_string_id, bool create = true);
	ID3D11ShaderResourceView* GetTextureShaderResourceView(uint64_t texture_name_string_id);
private:
    void Initialize();
    void Terminate();

	void LoadTextures();
	void LoadShaders();
    void WriteShaderCache();
    void ReadShaderCache();

    const std::string _resources_directory;
	const std::string _shaders_directory;
	const std::string _textures_directory;
    const std::string _config_path;

	std::unordered_map<uint64_t, Shader*> _shaders;
	std::unordered_map<uint64_t, ID3D11ShaderResourceView*> _textures;
    std::unordered_map<uint64_t, std::wstring> _texture_paths;

	std::unordered_map<uint64_t, std::filesystem::file_time_type> _last_write_times;
};
}
