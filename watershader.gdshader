shader_type canvas_item;

uniform vec4 color : source_color;

uniform sampler2D fast_noise : repeat_enable;
uniform sampler2D screen_content : hint_screen_texture;

uniform vec2 speed = vec2(0.03 , 0.07);

uniform float wave_strength = 2;


void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
