shader_type canvas_item;

uniform float border_width: hint_range(0.0, 1.0);
uniform float angle_separation: hint_range(0.0, 360.0);
uniform int segments: hint_range(0, 1000);

const vec2 CENTER = vec2(0.5);
const float LENGTH = 0.5;

void fragment() {
	vec2 uv = UV;
	vec2 fromCenter = uv - CENTER;
	float distanceFromCenter = length(fromCenter);

    float angleFromCenter = atan(fromCenter.y, fromCenter.x);

	if (distanceFromCenter >= LENGTH - border_width && distanceFromCenter <= LENGTH) {
		if (angleFromCenter > 0.0 && angleFromCenter < PI * 0.5) {
			//if (mod(angleFromCenter)
			COLOR = vec4(0.0);
		} else {
			COLOR = vec4(vec3(0.0), 1.0);
		}
	} else {
		COLOR = vec4(0.0);
	}
}
