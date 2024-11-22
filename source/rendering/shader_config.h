#pragma once
#include <unordered_map>

#include "red_shader_ids.h"
#include "shader.h"

namespace w3
{

enum class ReplacementShaderType
{
    GENERIC, // can require arbitrary additional buffers/textures
    SIMPLE, // just replaces the shader code; no additional buffers needed
};

enum REPLACEMENT_SHADER_CONDITION
{
    REPLACEMENT_SHADER_CONDITION_NONE = 0x00,
    REPLACEMENT_SHADER_CONDITION_WATER_ENABLED = 0x01,
    REPLACEMENT_SHADER_CONDITION_TAA_ENABLED = 0x02,
    REPLACEMENT_SHADER_CONDITION_CUSTOM_VANILLA_DOF_ENABLED = 0x04,
};

struct ReplacementShader
{
    StringIdHash shader_name_string_id_hash;
    ReplacementShaderType type;
    REPLACEMENT_SHADER_CONDITION condition;
};

class ShaderConfig
{
public:
    const ReplacementShader& GetReplacementShader(const ShaderSignature& shader_signature) const;

    RedVertexShaderId GetCheckpointVertexShaderId(const ShaderSignature& shader_signature) const;
    RedHullShaderId GetCheckpointHullShaderId(const ShaderSignature& shader_signature) const;
    RedDomainShaderId GetCheckpointDomainShaderId(const ShaderSignature& shader_signature) const;
    RedPixelShaderId GetCheckpointPixelShaderId(const ShaderSignature& shader_signature) const;
    RedComputeShaderId GetCheckpointComputeShaderId(const ShaderSignature& shader_signature) const;

private:
    static const std::unordered_map<ShaderSignature, ReplacementShader> generic_replacement_shaders;

    static const std::unordered_map<ShaderSignature, RedVertexShaderId> vertex_shader_ids;
    static const std::unordered_map<ShaderSignature, RedHullShaderId> hull_shader_ids;
    static const std::unordered_map<ShaderSignature, RedDomainShaderId> domain_shader_ids;
    static const std::unordered_map<ShaderSignature, RedPixelShaderId> pixel_shader_ids;
    static const std::unordered_map<ShaderSignature, RedComputeShaderId> compute_shader_ids;
};
}
