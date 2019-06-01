shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : hint_color;
uniform float specular : hint_range(0,1);
uniform float roughness : hint_range(0,1);
uniform float subsurface_scattering_strength : hint_range(0,1);

void fragment() {
	vec2 base_uv = UV;
	ALBEDO = albedo.rgb;
	ROUGHNESS = roughness;
	SPECULAR = specular;
	SSS_STRENGTH=subsurface_scattering_strength;
}
