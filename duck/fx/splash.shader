shader_type spatial;
//render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;
render_mode blend_mix,unshaded;
uniform sampler2D texture_albedo : hint_albedo;
uniform float specular;
uniform sampler2D texture_normal : hint_normal;
uniform float normal_scale : hint_range(-16,16);
uniform float softness;

void vertex() {
	mat4 mat_world = mat4(normalize(CAMERA_MATRIX[0])*length(WORLD_MATRIX[0]),normalize(CAMERA_MATRIX[1])*length(WORLD_MATRIX[0]),normalize(CAMERA_MATRIX[2])*length(WORLD_MATRIX[2]),WORLD_MATRIX[3]);
	mat_world = mat_world * mat4( vec4(cos(INSTANCE_CUSTOM.x),-sin(INSTANCE_CUSTOM.x), 0.0, 0.0), vec4(sin(INSTANCE_CUSTOM.x), cos(INSTANCE_CUSTOM.x), 0.0, 0.0),vec4(0.0, 0.0, 1.0, 0.0),vec4(0.0, 0.0, 0.0, 1.0));
	MODELVIEW_MATRIX = INV_CAMERA_MATRIX * mat_world;
}




void fragment() {
	float erosion = 1.0 - COLOR.a;
	vec4 albedo_tex = texture(texture_albedo, UV);
	vec3 base_color = clamp(albedo_tex.rgb - erosion, 0.0, 1.0);
	ALBEDO = base_color * COLOR.rgb;
	ALPHA = clamp(base_color.r / softness, 0.0, 1.0);
	
	METALLIC = 0.9;
	ROUGHNESS = 0.2;
	SPECULAR = 1.0;

	NORMALMAP = texture(texture_normal, UV).rgb;
	NORMALMAP_DEPTH = normal_scale;
}
