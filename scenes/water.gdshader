shader_type canvas_item;

uniform vec4 color : source_color;

uniform sampler2D fast_noise : repeat_enable;
uniform sampler2D screen_content : hint_screen_texture, filter_nearest;

uniform vec2 speed = vec2(0.03 , 0.07);

uniform float distortion_strength: hint_range(-1.0, 1.0) = 0.02;

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = UV + speed * TIME;
	vec4 noise = texture(fast_noise, UV + speed * TIME);
	float distortion = noise.r * distortion_strength;

	COLOR = vec4(color.r, color.g, color.b, 1.0) + vec4(noise.x , noise.y, 1.0, 0.0);
	COLOR *= texture(screen_content, SCREEN_UV + distortion);
}

//void fragment() {
	//vec4 noise_1 = texture(noise_texture1, UV + offset1 * TIME);
	//vec4 noise_2 = texture(noise_texture2, UV + offset2 * TIME);
//
	//float final_noise = noise_1.r * noise_2.r;
	//float distortion = final_noise * distortion_strength;
//
	//vec4 screen_colour = texture(screen_texture, SCREEN_UV + distortion);
	//COLOR = screen_colour;
//}
