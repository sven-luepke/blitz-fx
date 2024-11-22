#include "shader_config.h"

using namespace w3;

const std::unordered_map<ShaderSignature, ReplacementShader> ShaderConfig::generic_replacement_shaders = {
    {ShaderSignature::FromRenderDocHash("8d2938ce-68218c07-97226a89-1178afb1"), {"SkinHiResShadowPS"_id, ReplacementShaderType::GENERIC}},
    {ShaderSignature::FromRenderDocHash("b2d57d4b-c5646c95-4e2fa1b9-edf02923"), {"VegetationBranchVS"_id, ReplacementShaderType::SIMPLE, REPLACEMENT_SHADER_CONDITION_TAA_ENABLED}},
    {ShaderSignature::FromRenderDocHash("1858dc24-933a14dc-a6197903-aa4a8d62"), {"VegetationBranchPS"_id, ReplacementShaderType::SIMPLE, REPLACEMENT_SHADER_CONDITION_TAA_ENABLED}},
    {ShaderSignature::FromRenderDocHash("c4417718-fa6d1df3-99d04fca-abf78781"), {"Foliage0VS"_id, ReplacementShaderType::SIMPLE, REPLACEMENT_SHADER_CONDITION_TAA_ENABLED}},
    {ShaderSignature::FromRenderDocHash("94150938-941de307-940b2e5a-eebf19d7"), {"Foliage0PS"_id, ReplacementShaderType::SIMPLE, REPLACEMENT_SHADER_CONDITION_TAA_ENABLED}},
    {ShaderSignature::FromRenderDocHash("a242ab0b-df49c386-ff916b16-7ddca4c0"), {"Foliage1VS"_id, ReplacementShaderType::SIMPLE, REPLACEMENT_SHADER_CONDITION_TAA_ENABLED}},
    {ShaderSignature::FromRenderDocHash("ff95e806-bf6f05d5-515f6195-c1d26c17"), {"Foliage2VS"_id, ReplacementShaderType::SIMPLE, REPLACEMENT_SHADER_CONDITION_TAA_ENABLED}},
    {ShaderSignature::FromRenderDocHash("16beda73-8121a8a6-788d52c3-78d430fe"), {"GrassVS"_id, ReplacementShaderType::SIMPLE, REPLACEMENT_SHADER_CONDITION_TAA_ENABLED}},
    {ShaderSignature::FromRenderDocHash("03df1dbe-3a96b119-9148ff1c-f39e6138"), {"GrassPS"_id, ReplacementShaderType::SIMPLE, REPLACEMENT_SHADER_CONDITION_TAA_ENABLED}},
    {ShaderSignature::FromRenderDocHash("cfcf0d92-5f42d853-86466229-8cb46960"), {"HairGBuffer0PS"_id, ReplacementShaderType::SIMPLE}},
    {ShaderSignature::FromRenderDocHash("e56fd3fc-baee5bbf-a57cb427-c4ece546"), {"TreeSpriteVS"_id, ReplacementShaderType::SIMPLE}},
    {ShaderSignature::FromRenderDocHash("83078f60-6a2618d5-ba5a511f-8004c580"), {"ChainmailPS"_id, ReplacementShaderType::SIMPLE}},
    {ShaderSignature::FromRenderDocHash("5a777fda-050ca8fb-ac4c8ced-84bfe55a"), {"ArmorMetalAttachmentsPS"_id, ReplacementShaderType::SIMPLE}},
    {ShaderSignature::FromRenderDocHash("9adb8310-19bc432a-e3fcdcd1-bf3e8689"), {"SwordMetalPS"_id, ReplacementShaderType::SIMPLE}},
    {ShaderSignature::FromRenderDocHash("16bd8f7a-9fda07f3-694a342b-f2593f9e"), {"ScabbardMetalPS"_id, ReplacementShaderType::SIMPLE}},
    {ShaderSignature::FromRenderDocHash("3f5c83c2-83ebfd40-35bfa221-3492326c"), {"ArmorMetal0PS"_id, ReplacementShaderType::SIMPLE}},
    {ShaderSignature::FromRenderDocHash("e2db4542-3ed8c184-bdd23801-616114c0"), {"ArmorMetal1PS"_id, ReplacementShaderType::SIMPLE}},
    {ShaderSignature::FromRenderDocHash("3ef63b03-bff60d6e-f8cb0019-0ea26148"), {"ArmorMetal2PS"_id, ReplacementShaderType::SIMPLE}},
    {ShaderSignature::FromRenderDocHash("37ca30b7-84465515-a16c5459-721fdd81"), {"ArmorMetal3PS"_id, ReplacementShaderType::SIMPLE}},
    {ShaderSignature::FromRenderDocHash("77da59d8-db86f52a-608b47fd-69cc301a"), {"PbrDetailPS"_id, ReplacementShaderType::SIMPLE}},
    {ShaderSignature::FromRenderDocHash("da0e2d5e-7a258404-8b728d8b-4f466971"), {"WindowPS"_id, ReplacementShaderType::SIMPLE}},
    {ShaderSignature::FromRenderDocHash("1f35287c-6185abe6-62d5c7d3-1c02b65f"), {"TerrainSurface0PS"_id, ReplacementShaderType::SIMPLE}},
    {ShaderSignature::FromRenderDocHash("0e50c050-b1d9be9f-b0102ea4-2957aed2"), {"TerrainSurface1PS"_id, ReplacementShaderType::SIMPLE}},
    {ShaderSignature::FromRenderDocHash("9fa3cf38-587cbceb-bcf6aa26-28dceb37"), {"TerrainSurface2PS"_id, ReplacementShaderType::SIMPLE}},
    {ShaderSignature::FromRenderDocHash("4dfdf166-8c757f04-342c4883-d999a91d"), {"PreSSRDownsamplePS"_id, ReplacementShaderType::GENERIC, REPLACEMENT_SHADER_CONDITION_WATER_ENABLED}},
    {ShaderSignature::FromRenderDocHash("bb78ddce-9854bc9f-3d2c621a-dcfa26d7"), {"PreSSRDownsampleDepthPS"_id, ReplacementShaderType::GENERIC, REPLACEMENT_SHADER_CONDITION_WATER_ENABLED}},
    {ShaderSignature::FromRenderDocHash("30b9d7bc-c42c8260-5e334a8b-952badbf"), {"WaterSSRTracePS"_id, ReplacementShaderType::GENERIC, REPLACEMENT_SHADER_CONDITION_WATER_ENABLED}},
    {ShaderSignature::FromRenderDocHash("0778b434-b8a8c8ee-92be8a48-67d596e5"), {"WaterSSRCompositePS"_id, ReplacementShaderType::GENERIC, REPLACEMENT_SHADER_CONDITION_WATER_ENABLED}},
    {ShaderSignature::FromRenderDocHash("e559d0e8-db813a9d-7d3ef2b1-48497fbf"), {"CatPotionPS"_id, ReplacementShaderType::GENERIC}},
    {ShaderSignature(0x6b76d2f56521e838, 0xd2eb713f2c40cc54), {"FinalColorCorrection0PS"_id, ReplacementShaderType::GENERIC}},
    {ShaderSignature(0xa729846648df82a0, 0x9672b915bf525033), {"FinalColorCorrection1PS"_id, ReplacementShaderType::GENERIC}},
    {ShaderSignature(0x518160e42072b15e, 0x8682949a6cc2bcae), {"FinalColorCorrection2PS"_id, ReplacementShaderType::GENERIC}},
    {ShaderSignature(0x2ac60bd84503acd9, 0x7d8440f06024e973), {"FinalColorCorrection3PS"_id, ReplacementShaderType::GENERIC}},
    {ShaderSignature::FromRenderDocHash("cb36f0f9-b215a932-de903eb9-44cd810c"), {"FinalColorCorrection4PS"_id, ReplacementShaderType::GENERIC}},
    {ShaderSignature::FromRenderDocHash("bd93b125-4d54982b-c90d94c7-5380387f"), {"FinalColorCorrection5PS"_id, ReplacementShaderType::GENERIC}},
    {ShaderSignature::FromRenderDocHash("97ba4c1a-d9a48a11-ef95f374-bcc55b4b"), {"FinalColorCorrection6PS"_id, ReplacementShaderType::GENERIC}},
    {ShaderSignature::FromRenderDocHash("d20741db-0a985c6c-4d8f45bb-c9c6098e"), {"FinalColorCorrectionBob0PS"_id, ReplacementShaderType::GENERIC}},
    {ShaderSignature::FromRenderDocHash("098e4ce5-da33fed7-59c80513-02c21273"), {"FinalColorCorrectionBob1PS"_id, ReplacementShaderType::GENERIC}},
    {ShaderSignature::FromRenderDocHash("3ba148f5-dfc9caaa-1bd8545f-dec158d5"), {"FinalColorCorrectionBob2PS"_id, ReplacementShaderType::GENERIC}},
    {ShaderSignature::FromRenderDocHash("e5d32d08-55da2898-4d478166-2b300f9c"), {"FinalColorCorrectionBob3PS"_id, ReplacementShaderType::GENERIC}},
    {ShaderSignature::FromRenderDocHash("a4f7a516-6eb34bf0-d9d90348-93756296"), {"FinalColorCorrectionBob4PS"_id, ReplacementShaderType::GENERIC}},
    {ShaderSignature::FromRenderDocHash("a832fead-d010e6e2-efb44ba8-43f2a362"), {"SkinPS"_id, ReplacementShaderType::GENERIC}},
};

const std::unordered_map<ShaderSignature, RedVertexShaderId> ShaderConfig::vertex_shader_ids = {
    {ShaderSignature::FromRenderDocHash("46c75e48-64f57bde-60c8c596-5e9b98b5"), RedVertexShaderId::VEGETATION_SHADOW_0},
    {ShaderSignature::FromRenderDocHash("99bec19a-4b4e0136-e84fd005-fe67af5a"), RedVertexShaderId::VEGETATION_SHADOW_1},
    {ShaderSignature::FromRenderDocHash("f843f446-acda2c95-b75e6066-7c846631"), RedVertexShaderId::VEGETATION_SHADOW_2},
    {ShaderSignature::FromRenderDocHash("b2d57d4b-c5646c95-4e2fa1b9-edf02923"), RedVertexShaderId::VEGETATION_BRANCH},
    {ShaderSignature::FromRenderDocHash("c4417718-fa6d1df3-99d04fca-abf78781"), RedVertexShaderId::FOLIAGE_0},
    {ShaderSignature::FromRenderDocHash("a242ab0b-df49c386-ff916b16-7ddca4c0"), RedVertexShaderId::FOLIAGE_1},
    {ShaderSignature::FromRenderDocHash("ff95e806-bf6f05d5-515f6195-c1d26c17"), RedVertexShaderId::FOLIAGE_2},
    {ShaderSignature::FromRenderDocHash("16beda73-8121a8a6-788d52c3-78d430fe"), RedVertexShaderId::GRASS},
    {ShaderSignature::FromRenderDocHash("e56fd3fc-baee5bbf-a57cb427-c4ece546"), RedVertexShaderId::TREE_BILLBOARD},
    {ShaderSignature(0xbaee5bbfe56fd3fc, 0xc4ece546a57cb427), RedVertexShaderId::TREE_BILLBOARD},
    {ShaderSignature(0x558e63878bcde244, 0xe7d47ecf41ae9bac), RedVertexShaderId::HAIR},
    {ShaderSignature(0xe280b3964894b066, 0x9dc2136db9c87771), RedVertexShaderId::CLOUD_DOME},
    {ShaderSignature(0x5ca70eb291b274e3, 0x4dc5a7c9b12f892b), RedVertexShaderId::CLOUD_DOME_STORM},
    {ShaderSignature(0xfdd86ba7c39a8aad, 0x1b3e9d44553949d5), RedVertexShaderId::CLOUD_SPRITE},
    {ShaderSignature(0xf07434c67b4a07d4, 0xa703fdb1eea14e4f), RedVertexShaderId::WATER},
    {ShaderSignature(0xb4f0bb879c08242e, 0x018159728b54de82), RedVertexShaderId::HAIR_TRANSPARENCY},
    {ShaderSignature(0xc75f43b8b4dfdb5b, 0x4b0787ea52adc893), RedVertexShaderId::SMOKE_SPRITE}
};
const std::unordered_map<ShaderSignature, RedHullShaderId> ShaderConfig::hull_shader_ids = {
    {ShaderSignature(0x7df3a1102308dcce, 0xf546bab912f9be3a), RedHullShaderId::TERRAIN_0},
    {ShaderSignature(0x8e40b405a89d120b, 0xca4fb28ba4e14bf2), RedHullShaderId::TERRAIN_1}
};
const std::unordered_map<ShaderSignature, RedDomainShaderId> ShaderConfig::domain_shader_ids = {
};
const std::unordered_map<ShaderSignature, RedPixelShaderId> ShaderConfig::pixel_shader_ids = {
    {ShaderSignature(0x54bdb94d87985f00, 0x1cbe7a8aaa01e99c), RedPixelShaderId::REFLECTION_PROBE_SHADOW},
    {ShaderSignature(0x9063b4d52ce67d51, 0xd7f06f0a3a5773fe), RedPixelShaderId::REFLECTION_PROBE_FOG_AMBIENT},
    {ShaderSignature(0x779185c22773e923, 0x0a4a85f8a5954540), RedPixelShaderId::IRRADIANCE_PROBE},
    {ShaderSignature::FromRenderDocHash("8d6ef19d-cabc6a87-a57d7783-2cae2c3a"), RedPixelShaderId::REFLECTION_PROBE_BLUR},
    {ShaderSignature(0x6343a74ea0aa9ae8, 0xe4389a0f849a3526), RedPixelShaderId::TERRAIN_NOVIGRAD},

    {ShaderSignature::FromRenderDocHash("77f3e239-65ff7dcb-08621dcb-b1a094f6"), RedPixelShaderId::UNDERWATER_MODIFY_GBUFFER},
    {ShaderSignature(0xc9b62732bbbdacc9, 0x545547f5acbb937e), RedPixelShaderId::SHADOW},
    {ShaderSignature(0x7358f2fb6b8a59a8, 0x9b9fdf17f0d7c98f), RedPixelShaderId::SHADOW_ANSEL},
    {ShaderSignature(0x1b3b47387059ea95, 0xcdd1efe78e9d6d97), RedPixelShaderId::DEFERRED_POINT_LIGHT_0},
    {ShaderSignature(0x4cf360411efb7282, 0xf03b72e1fd2560c2), RedPixelShaderId::DEFERRED_POINT_LIGHT_1},
    {ShaderSignature(0xc881670ac6f7b6ad, 0x80e2381554e7409a), RedPixelShaderId::DEFERRED_POINT_LIGHT_2},
    {ShaderSignature(0x7d3d33fc15e1edb2, 0x82f15c73b325a96a), RedPixelShaderId::DEFERRED_POINT_LIGHT_3},
    {ShaderSignature(0x013837ea9c5ef751, 0x75bd36d013206873), RedPixelShaderId::DEFERRED_POINT_LIGHT_SHADOWED_0},
    {ShaderSignature(0x39f11568ccc3d8c5, 0xec6c9cdab7b8532d), RedPixelShaderId::DEFERRED_POINT_LIGHT_SHADOWED_1},
    {ShaderSignature(0x3f96324995be46c2, 0x2349d54af0d3ba31), RedPixelShaderId::DEFERRED_POINT_LIGHT_SHADOWED_2},
    {ShaderSignature(0xd0773927ef25b2c0, 0x190c3deef1dc3cbb), RedPixelShaderId::DEFERRED_POINT_LIGHT_SHADOWED_3},
    {ShaderSignature(0x8512cc4a1e1bdfdd, 0x6724bb15021744d3), RedPixelShaderId::DEFERRED_POINT_LIGHT_UNKNOWN},
    {ShaderSignature(0x653849cda8d44836, 0x5ba24a3e6e015e35), RedPixelShaderId::HAIR},
    {ShaderSignature::FromRenderDocHash("ef50114d-19f27f85-97c01095-346fa3f4"), RedPixelShaderId::HAIRWORKS},
    {ShaderSignature::FromRenderDocHash("3b90fbe9-795e5f52-f31e8365-82a695a8"), RedPixelShaderId::HAIRWORKS_POST_RESOLVE},
    {ShaderSignature(0x81d1cceeb1077291, 0x548ff6f558b09190), RedPixelShaderId::FOG},
    {ShaderSignature(0xe453af5849a31997, 0x0aa62e4a81be2303), RedPixelShaderId::SKY},
    {ShaderSignature::FromRenderDocHash("23923b8a-4b6cf452-1eca8910-a9fe5f74"), RedPixelShaderId::SKY_BOB},
    {ShaderSignature(0xf3847d0f99f21bb3, 0x1fb20129778bedd3), RedPixelShaderId::SUN},
    {ShaderSignature(0x3772d4e1a81d8bf5, 0x3981b1d4de38bbb0), RedPixelShaderId::CLOUD_DOME},
    {ShaderSignature(0xbb99538dc9636ffd, 0xe8d58867d9162b70), RedPixelShaderId::CLOUD_DOME_STORM},
    {ShaderSignature(0x3429c12204ea36d9, 0x169edf14f062d323), RedPixelShaderId::CLOUD_SPRITE},
    {ShaderSignature(0x9bd8aabca95ea6c8, 0x5e2bacb0636b4305), RedPixelShaderId::WATER},
    {ShaderSignature(0xa2d365c93c02baae, 0x0a0d9ae53fcc612d), RedPixelShaderId::WATER_SKY_REFLECTION_PARABOLOID},
    {ShaderSignature(0xc42c826030b9d7bc, 0x952badbf5e334a8b), RedPixelShaderId::WATER_REFLECTION_FALLBACK_0},
    {ShaderSignature(0xf50638f9c346f7c0, 0x26961e07b7b6b267), RedPixelShaderId::WATER_REFLECTION_FALLBACK_1},
    {ShaderSignature::FromRenderDocHash("157f7b36-128ec9da-1f5ca25b-98967e5c"), RedPixelShaderId::UNDERWATER_MASK},
    {ShaderSignature(0x0f02aabf4f6986e1, 0x3c2081ff574034e1), RedPixelShaderId::HAIR_TRANSPARENCY},
    {ShaderSignature::FromRenderDocHash("84e297a4-23732821-41c41df4-a517acc2"), RedPixelShaderId::UNDERWATER_FOG},
    {ShaderSignature::FromRenderDocHash("6669597b-5e93d3d4-c946e881-67c0b2cc"), RedPixelShaderId::FIRE_SPARK},
    {ShaderSignature::FromRenderDocHash("3a441bf0-ff1dfeb7-1a74256f-7f44c139"), RedPixelShaderId::RAIN_DROPS},
    {ShaderSignature::FromRenderDocHash("f9f50b21-2cdf1d3b-47e5b173-fe557f8d"), RedPixelShaderId::RAIN_DROPS_BOB},
    {ShaderSignature(0xd76205c8be90516e, 0x6816f057077e93ac), RedPixelShaderId::TONEMAP_0},
    {ShaderSignature(0x67c8a98028843a6f, 0x29d43caf84edc7cb), RedPixelShaderId::TONEMAP_1},
    {ShaderSignature::FromRenderDocHash("d6193c2a-d7ee1e6f-4b0650be-da70c326"), RedPixelShaderId::DOF_GAMEPLAY_SETUP},
    {ShaderSignature::FromRenderDocHash("f3802f03-31243b41-7a3592a7-5870849c"), RedPixelShaderId::DOF_GAMEPLAY_BLUR},
    {ShaderSignature(0xd8e76cd11747706b, 0x5a4872195acfeea5), RedPixelShaderId::DOF_CUTSCENE_BLUR},
    {ShaderSignature(0x6cf12dd1d8f4b91c, 0xcd1b7688358f2a8b), RedPixelShaderId::DOF_CUTSCENE_COMBINE},
    {ShaderSignature(0x9058d1d0443c37be, 0x365b297d11366705), RedPixelShaderId::ANTI_ALIASING},
};
const std::unordered_map<ShaderSignature, RedComputeShaderId> ShaderConfig::compute_shader_ids = {
    {ShaderSignature::FromRenderDocHash("b435511f-da5b654b-b71538b7-615669dc"), RedComputeShaderId::WATER_FFT_INIT},
    {ShaderSignature::FromRenderDocHash("06fa5368-ffe2a0a7-d2d324ed-7c0190ae"), RedComputeShaderId::WATER_FFT_TO_TEXTURE},
    {ShaderSignature(0xed5e2ff3d529704f, 0xd287e9d89ceb523c), RedComputeShaderId::DEFERRED_LIGHTING},
};

const ReplacementShader& ShaderConfig::GetReplacementShader(const ShaderSignature& shader_signature) const
{
    auto iterator = generic_replacement_shaders.find(shader_signature);
    if (iterator != generic_replacement_shaders.end())
    {
        return iterator->second;
    }
    static const ReplacementShader default_value = { 0, ReplacementShaderType::SIMPLE };
    return default_value;
}
RedVertexShaderId ShaderConfig::GetCheckpointVertexShaderId(const ShaderSignature& shader_signature) const
{
    auto it = vertex_shader_ids.find(shader_signature);
    if (it != vertex_shader_ids.end())
    {
        return it->second;
    }
    return RedVertexShaderId::UNKNOWN;
}
RedHullShaderId ShaderConfig::GetCheckpointHullShaderId(const ShaderSignature& shader_signature) const
{
    auto it = hull_shader_ids.find(shader_signature);
    if (it != hull_shader_ids.end())
    {
        return it->second;
    }
    return RedHullShaderId::UNKNOWN;
}
RedDomainShaderId ShaderConfig::GetCheckpointDomainShaderId(const ShaderSignature& shader_signature) const
{
    auto it = domain_shader_ids.find(shader_signature);
    if (it != domain_shader_ids.end())
    {
        return it->second;
    }
    return RedDomainShaderId::UNKNOWN;
}
RedPixelShaderId ShaderConfig::GetCheckpointPixelShaderId(const ShaderSignature& shader_signature) const
{
    auto it = pixel_shader_ids.find(shader_signature);
    if (it != pixel_shader_ids.end())
    {
        return it->second;
    }
    return RedPixelShaderId::UNKNOWN;
}
RedComputeShaderId ShaderConfig::GetCheckpointComputeShaderId(const ShaderSignature& shader_signature) const
{
    auto it = compute_shader_ids.find(shader_signature);
    if (it != compute_shader_ids.end())
    {
        return it->second;
    }
    return RedComputeShaderId::UNKNOWN;
}
