shader_type canvas_item;

const float PI_2 = 6.283185307;
const vec2 MIDPOINT = vec2(0.5, 0.5);

uniform float width_max = 1.0;
uniform float width_min = 0.5;

uniform float cursor_deg = 0.4;
uniform float cursor_size = 0.4;

uniform vec4 color_bg = vec4(0.4, 0.4, 0.4, 1.0);
uniform vec4 color_fg = vec4(0.17, 0.69, 1.0, 1.0);

uniform float bevel_width = 1.0;
uniform bool bevel_enabled = false;
uniform vec4 bevel_color = vec4(1., 0., 0., 1.);

float circle(vec2 uv, float radius) {
  float dist = length(uv - MIDPOINT);

  return 1. - smoothstep
    (
     radius - (radius * 0.01),
     radius + (radius * 0.01),
     (dist * dist) * 4.0
    );
}

float is_in_circle(vec2 uv) {
  return circle(uv, width_max) - circle(uv, width_min);
}

float is_in_bevel(vec2 uv) {
  float inside = circle(uv, width_min);
  float outside = circle(uv, width_max);

  return abs(
    (outside - circle(uv, width_max - bevel_width))
    +
    (circle(uv, width_min + bevel_width))
  );
}

float find_deg(vec2 uv) {
  vec2 offset = uv - MIDPOINT;
  return atan(offset.y, offset.x);
}

vec4 find_color(vec2 uv) {
  // Bevel color logic
  if (bevel_enabled && is_in_bevel(uv) > 0.) {
    return bevel_color;
  }

  float current_degree = abs(find_deg(uv) - cursor_deg);

  if (current_degree < cursor_size || current_degree > PI_2 - cursor_size) {
    return color_fg;
  }

  return color_bg;
}

void fragment() {
  COLOR = find_color(UV) * is_in_circle(UV);
}
