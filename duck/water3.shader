shader_type spatial;
render_mode depth_draw_opaque;
uniform vec2 amplitude = vec2(0.0, 0.0);
uniform vec2 frequency = vec2(1.0, 1.0);
uniform vec2 time_factor = vec2(2.0, 3.0);
uniform float time = 0.0;

uniform vec2 uv_scale = vec2(0.1, 0.1);
uniform vec4 main_color : hint_color;
uniform vec4 wave_color : hint_color;

varying flat float wave_height;
varying float noise_factor;

uniform sampler2D noise;
uniform vec4 noise_params;

varying vec2 vert_coord;
varying float vert_dist;

float noise3D(vec3 p) {
	float iz = floor(p.z);
	float fz = fract(p.z);
	vec2 a_off = vec2(0.852, 29.0) * iz*0.643;
	vec2 b_off = vec2(0.852, 29.0) * (iz+1.0)*0.643;
	float a = texture(noise, p.xy + a_off).r;
	float b = texture(noise, p.xy + b_off).r;
	
	return mix(a, b, fz);
}

float height(vec2 pos) {
	float h = amplitude.x * sin(pos.x * frequency.x + time * time_factor.x) + amplitude.y * sin(pos.y * frequency.y + time * time_factor.y) - 0.5;
	if(noise_params.w > 0.0)
		h += noise3D(vec3(pos.xy*noise_params.y, time*noise_params.z))*noise_params.x;
	return h;
}

vec3 wave_normal(vec2 pos, float res) {
	
	vec2 rPos = pos + vec2(res, 0.0);
	vec2 lPos = pos - vec2(res, 0.0);
	vec2 uPos = pos + vec2(0.0, res);
	vec2 dPos = pos - vec2(0.0, res);
	
	vec3 left = vec3(lPos.x, height(lPos), lPos.y);
	vec3 right = vec3(rPos.x, height(rPos), rPos.y);
	vec3 up = vec3(uPos.x, height(uPos), uPos.y);
	vec3 down = vec3(dPos.x, height(dPos), dPos.y);
	
	return -normalize(cross(right-left, down-up));
}

void vertex() {
	VERTEX.y += height(VERTEX.xz);
//	TANGENT = normalize( vec3(0.0, height(VERTEX.xz + vec2(0.0, 0.2)) - height(VERTEX.xz + vec2(0.0, -0.2)), 0.4));
//	BINORMAL = normalize( vec3(0.4, height(VERTEX.xz + vec2(0.2, 0.0)) - height(VERTEX.xz + vec2(-0.2, 0.0)), 0.0));
//NORMAL = cross(TANGENT, BINORMAL);

	vert_coord = VERTEX.xz;
	vert_dist = length(VERTEX);

}

void fragment() {
	NORMAL = wave_normal(vert_coord, vert_dist / 40.0);
	NORMAL = mix(NORMAL, vec3(0, -1, 0), min(vert_dist/1000.0, 1));
	vec2 tiled_uvs = UV * uv_scale;
	vec2 uv_offset = vec2(0, 0);

	ALBEDO = mix(main_color.rgb, wave_color.rgb, (wave_height + 0.5 + noise_factor));
	METALLIC = 0.6;
	ROUGHNESS = 0.2;
	SPECULAR = 1.0;
}