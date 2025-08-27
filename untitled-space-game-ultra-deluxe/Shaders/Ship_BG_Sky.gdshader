shader_type sky;

#include "res://addons/ShaderLib_v2_2_4/Artistic/Artistic.gdshaderinc"
#include "res://addons/ShaderLib_v2_2_4/UV/UV.gdshaderinc"

uniform float star_height = 5.0;
uniform float star_blend : hint_range(0.0, 1.0, 0.1) = 0.1;
uniform float depth_blend : hint_range(0.0, 1.0, 0.1) = 0.1;
uniform float flare_ratio : hint_range(0.0, 1.0, 0.1) = 0.1;
uniform float star_size = 5.0;
uniform int star_layers = 3;

vec2 RandomVec2(vec2 seed) {
	seed = fract(seed * vec2(123.45, 783.29));
	seed += dot(seed, seed + 875.34);
	float x = fract(seed.x * 164.32);
	float y = fract(seed.y * 287.21);
	return vec2(x, y) - 0.5; // vec2 from -0.5 to 0.5
}

float Star(vec2 uv, float flare) {
	float star = 0.01 / length(uv);
	float rays = max(0, 1.0 - abs(uv.x * uv.y) * 1000.0) * star;
	star += rays * flare;
	return pow(star, 3.0);
}

vec3 StarLayer(vec2 uv) {
	vec2 grid_uv = fract(uv) - 0.5;
	vec2 grid_id = floor(uv);
	vec3 stars = vec3(0);
	
	for(float y = -1.0; y <= 1.0; y++) {
		for(float x = -1.0; x <= 1.0; x++) {
			vec2 offset = vec2(x, y);
			vec2 rv = RandomVec2(grid_id + offset);
			float size = (rv.x + 0.5) * star_size;
			float animated_size = (sin(TIME * rv.x * 2.0) * 0.4 + 0.6) * size;
			float flare = smoothstep(star_size * (1.0 - flare_ratio), star_size, size);
			vec3 star_color = hue(vec3(1, 1, 1), rv.y, 1);
			stars += Star(grid_uv - offset - rv, flare) * animated_size * star_color;
		}
	}
	return stars;
}

void sky() {
	float blend = smoothstep(star_blend, 1.0, abs(EYEDIR.y));
	float depth_curve = pow(abs(EYEDIR.y), depth_blend);
	
	for(float i = 1.0; i <= float(star_layers); i++) {
		vec2 uv = EYEDIR.xz / depth_curve * star_height * i;
		uv += RandomVec2(vec2(i, i + 54.2)) * i * 10.3;
		if(EYEDIR.y < 0.0)
		uv = rotate_uv(uv, vec2(0, 0), 246, true);
		COLOR += StarLayer(uv) * blend;
	}
}