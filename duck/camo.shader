shader_type spatial;

uniform sampler2D noise1;
uniform sampler2D noise2;
uniform vec4 color1 : hint_color;
uniform vec4 color2 : hint_color;
uniform vec4 color3 : hint_color;

void fragment() {
	float t1 = texture(noise1, UV).r;
	float t2 = texture(noise2, UV).r;
	float mix3 = step(t2, 0.5);
	float mix2 = step(t1, 0.5);
	float mix1 = 1.0 - max(mix3, mix2);
	ALBEDO = (color1 * mix1 + color2 * mix2 + color3 * mix3).rgb;
	ROUGHNESS = 0.5;
	
//	vec2 tiled_uvs = UV * uv_scale;
//	vec2 uv_offset = vec2(0, 0);
//	uv_offset.x = cos(TIME + tiled_uvs.x + tiled_uvs.y) * 0.05;
//	uv_offset.y = sin(TIME + tiled_uvs.x + tiled_uvs.y) * 0.05;
//
//	ALBEDO = vec3(0.0, 0.0, 0.5);
//
//	NORMALMAP = texture(normalmap, tiled_uvs + uv_offset).rgb;
//	NORMALMAP_DEPTH = 0.2;
//
//	ROUGHNESS = 0.1;
//	float depth = texture(DEPTH_TEXTURE, SCREEN_UV).r;
//	depth = depth * 2.0 - 1.0;
//	float z = -PROJECTION_MATRIX[3][2] / (depth + PROJECTION_MATRIX[2][2]);
//	float delta = -(z - VERTEX.z);
//	float att = exp(-delta * murkiness);
//	ALPHA = clamp(1.0 - att, 0.5, 1.0);
	//ALBEDO = NORMALMAP;
//	vec3 xTangent = dFdx( VERTEX );
//    vec3 yTangent = dFdy( VERTEX );
//    vec3 faceNormal = normalize( cross( xTangent, yTangent ) );
//	NORMAL = faceNormal;
//	ALBEDO = mix(main_color.rgb, wave_color.rgb, (wave_height + 0.5 + noise_factor));
//	METALLIC = 0.9;
//	ROUGHNESS = 0.2;
//	SPECULAR = 1.0;
}