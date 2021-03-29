shader_type canvas_item;

const vec2 MIDPOINT = vec2(0.5, 0.5);

uniform float radius_max = 1.0;
uniform float radius_min = 0.9;

float circle(vec2 uv, float radius) {
  float dist = length(uv - MIDPOINT);

  return 1. - smoothstep
    (
     radius - (radius * 0.01),
     radius + (radius * 0.01),
     (dist * dist) * 4.0
    );
}

float should_discard(vec2 uv) {
  return circle(uv, radius_max) - circle(uv, radius_min / 2.);
}

void fragment() {
  COLOR = vec4(1., 0., 0., 1.) * should_discard(UV);
}
