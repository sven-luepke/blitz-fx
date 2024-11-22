#pragma once
#include "shader.h"
#include "pipeline_state_manager.h"
#include "resource_manager.h"
#include "d3d_interface.h"
#include "core/singleton.h"
#include "red_shader_ids.h"
#include "cbuffer_structs.h"
#include "constant_buffer.h"

#include <unordered_map>

#include "rendering_engine.h"
#include "shader_config.h"


namespace w3
{
class RenderingInterceptor : public Singleton<RenderingInterceptor>, D3DInterface
{
	friend class Singleton<RenderingInterceptor>;
public:
	void Initialize(ID3D11Device* d3d_device, ID3D11DeviceContext* d3d_context);
	void Terminate();
	void OnResize(int width, int height);

    bool IsEnabled() const;

	void OnMap(ID3D11Resource* pResource, UINT Subresource, D3D11_MAP MapType, UINT MapFlags, D3D11_MAPPED_SUBRESOURCE* pMappedResource);
	void OnUnmap(ID3D11Resource* pResource, UINT Subresource);

	void OnCopySubresourceRegion(
		ID3D11DeviceContext* d3d_context,
		ID3D11Resource  *pDstResource,
		UINT            DstSubresource,
		UINT            DstX,
		UINT            DstY,
		UINT            DstZ,
		ID3D11Resource  *pSrcResource,
		UINT            SrcSubresource,
		const D3D11_BOX *pSrcBox
	);

	void OnSetRenderTargets(ID3D11DeviceContext* d3d_context, UINT num_views, ID3D11RenderTargetView* const * render_target_views,
	                        ID3D11DepthStencilView* depth_stencil_view);

private:
    enum REPLACEMENT_SHADER_INDEX
    {
        REPLACEMENT_SHADER_INDEX_VERTEX = 0,
        REPLACEMENT_SHADER_INDEX_HULL = 1,
        REPLACEMENT_SHADER_INDEX_DOMAIN = 2,
        REPLACEMENT_SHADER_INDEX_GEOMETRY = 3,
        REPLACEMENT_SHADER_INDEX_PIXEL = 4,
        REPLACEMENT_SHADER_INDEX_COMPUTE = 5,
    };

    void AssignReplacementShader(const ShaderSignature& shader_signature, const ID3D11DeviceChild* shader);
    bool BindReplacementShader(const ID3D11DeviceChild* shader, REPLACEMENT_SHADER_INDEX index);

public:
	void OnCreatedVertexShader(const void* shader_bytecode, const ID3D11VertexShader* vertex_shader);
	void OnCreatedHullShader(const void* shader_bytecode, const ID3D11HullShader* hull_shader);
    void OnCreatedDomainShader(const void* shader_bytecode, const ID3D11DomainShader* domain_shader);
    void OnCreatedGeometryShader(const void* shader_bytecode, const ID3D11GeometryShader* geometry_shader);
	void OnCreatedPixelShader(const void* shader_bytecode, const ID3D11PixelShader* pixel_shader);
	void OnCreatedComputeShader(const void* shader_bytecode, const ID3D11ComputeShader* compute_shader);

    bool OnSetVertexShader(const ID3D11VertexShader* vertex_shader);
    bool OnSetHullShader(const ID3D11HullShader* hull_shader);
    bool OnSetDomainShader(const ID3D11DomainShader* domain_shader);
    bool OnSetGeometryShader(const ID3D11GeometryShader* geometry_shader);
	bool OnSetPixelShader(const ID3D11PixelShader* pixel_shader);
    bool OnSetComputeShader(const ID3D11ComputeShader* compute_shader);

    void VSSetContantBuffers(ID3D11DeviceContext* d3d_context, UINT start_slot, UINT num_buffers, ID3D11Buffer* const * constant_buffers);

	void Draw(ID3D11DeviceContext* d3d_context, UINT vertex_count, UINT start_vertex_location);
	void DrawInstanced(ID3D11DeviceContext* d3d_context, UINT vertex_count_per_instance, UINT instance_count, UINT start_vertex_location,
	                   UINT start_instance_location);
	void DrawIndexed(ID3D11DeviceContext* d3d_context, UINT index_count, UINT start_index_location, INT base_vertex_location);
	void DrawIndexedInstanced(ID3D11DeviceContext* d3d_context, UINT index_count_per_instance, UINT instance_count,
	                          UINT start_index_location, INT base_vertex_location, UINT start_instance_location);
	void Dispatch(ID3D11DeviceContext* d3d_context, UINT thread_group_count_x, UINT thread_group_count_y, UINT thread_group_count_z);

    void Toggle();
    void Reload();
	void OnMenu();
    void OnCloseMenu();
	void OnPresent();

    const Configuration& GetConfiguration() const;
private:
	RenderingInterceptor();

	void PreDraw();
	void PostDraw();
	void DisableCulling(ID3D11DeviceContext* d3d_context);

	bool _enabled = false;
    bool _initialized = false;
    bool _loaded_config = false;

	DirectX::XMINT2 _resolution;

    ShaderConfig _shader_config;
	ResourceManager _resource_manager;
    bool _schedule_reload = false;
	PipelineStateManager _pipeline_state_manager;

    RenderingEngine _rendering_engine;

	std::unordered_map<const ID3D11VertexShader*, RedVertexShaderId> _red_vertex_shaders;
	std::unordered_map<const ID3D11HullShader*, RedHullShaderId> _red_hull_shaders;
    std::unordered_map<const ID3D11DomainShader*, RedDomainShaderId> _red_domain_shaders;
	std::unordered_map<const ID3D11PixelShader*, RedPixelShaderId> _red_pixel_shaders;
	std::unordered_map<const ID3D11ComputeShader*, RedComputeShaderId> _red_compute_shaders;
	RedVertexShaderId _current_bound_vertex_shader;
	RedHullShaderId _current_bound_hull_shader;
    RedDomainShaderId _current_bound_domain_shader;
	RedPixelShaderId _current_bound_pixel_shader;
	RedComputeShaderId _current_bound_compute_shader;

	std::unordered_map<const ID3D11DeviceChild*, ReplacementShader> _replacement_shaders;
    StringIdHash _current_replacement_shaders[6];

	void* _mapped_data = nullptr;
    UINT _mapped_row_pitch = 0;

    // game constant buffers
    Microsoft::WRL::ComPtr<ID3D11Buffer> _game_water_texture_cbuffer;
	Microsoft::WRL::ComPtr<ID3D11Buffer> _game_frame_cb_cbuffer;
	Microsoft::WRL::ComPtr<ID3D11Buffer> _game_frame_data_cbuffer;
	Microsoft::WRL::ComPtr<ID3D11Buffer> _game_lighting_data_cbuffer;
	Microsoft::WRL::ComPtr<ID3D11Buffer> _game_terrain_data_cbuffer;
    Microsoft::WRL::ComPtr<ID3D11Buffer> _game_water_data_cbuffer;

    // game g-buffers
    Microsoft::WRL::ComPtr<ID3D11ShaderResourceView> _g_buffer_depth_srv;
    Microsoft::WRL::ComPtr<ID3D11ShaderResourceView> _g_buffer_albedo_translucency_srv;
    Microsoft::WRL::ComPtr<ID3D11ShaderResourceView> _g_buffer_normal_roughness_srv;
    Microsoft::WRL::ComPtr<ID3D11ShaderResourceView> _g_buffer_stencil_srv;
    Microsoft::WRL::ComPtr<ID3D11ShaderResourceView> _g_buffer_specular_mask_srv;
    Microsoft::WRL::ComPtr<ID3D11ShaderResourceView> _ao_shadow_interior_mask;

	ConstantBuffer<CustomFrameData> _custom_frame_data_cbuffer;

	bool _is_depth_buffer_bound = false;
	bool _is_render_target_bound = false;

	std::unordered_map<ID3D11RasterizerState*, ID3D11RasterizerState*> _rasterizer_to_cull_none_map;
	
    bool _is_after_first_g_buffer_pass = false;
    int _g_buffer_bind_count = 0;
    bool _is_before_lighting = true;
    bool _grabbed_frame_cb = false;

    RenderTexture _velocity_g_buffer{DXGI_FORMAT_R16G16_FLOAT, RENDER_TEXTURE_BIND_SRV | RENDER_TEXTURE_BIND_RTV};

    // maps each WindDynamicsCB to the buffer that contains its data from the previous frame
    std::unordered_map<ID3D11Resource*, ConstantBuffer<WindDynamicsCB>*> _wind_dynamics_cbuffer_map;
};


inline bool RenderingInterceptor::IsEnabled() const
{
    return _enabled;
}
inline const Configuration& RenderingInterceptor::GetConfiguration() const
{
    return _rendering_engine.GetConfiguration();
}

}
