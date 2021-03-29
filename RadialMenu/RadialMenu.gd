tool
extends ColorRect

const MIN_WIDTH = 0.05

export(float, 0, 1) var width_max = 1.0 setget set_width_max;
export(float, 0, 1) var width_min = 0.5 setget set_width_min;

export(float, 0, 3.1416) var cursor_size = 0.4 setget set_cursor_size;
export(float, -3.1416, 3.1416) var cursor_deg = 0.4 setget set_cursor_deg;

export(Color, RGBA) var color_bg = Color(0.4, 0.4, 0.4, 1.0) setget set_color_bg;
export(Color, RGBA) var color_fg = Color(0.17, 0.69, 1.0, 1.0) setget set_color_fg;

func set_shader_param(name: String, new_value):
	self.material.set_shader_param(name, new_value)

func set_width_max(new_value: float):
	if new_value - MIN_WIDTH < 0: return

	width_max = new_value
	self.set_shader_param("width_max", new_value)

	# Handle case where we're now smaller than the minimum size
	if new_value - width_min < MIN_WIDTH:
		self.set_width_min(new_value - MIN_WIDTH * 2)

func set_width_min(new_value: float):
	if new_value + MIN_WIDTH > 1: return

	width_min = new_value
	self.set_shader_param("width_min", new_value)

	# Handle case where we're now bigger than the minimum size
	if width_max - new_value < MIN_WIDTH:
		self.set_width_max(new_value + MIN_WIDTH * 2)

func set_cursor_deg(new_value: float):
	cursor_deg = new_value
	self.set_shader_param("cursor_deg", new_value)

func set_cursor_size(new_value: float):
	cursor_size = new_value
	self.set_shader_param("cursor_size", new_value)

func set_color_bg(new_value: Color):
	color_bg = new_value
	self.set_shader_param("color_bg", new_value)

func set_color_fg(new_value: Color):
	color_fg = new_value
	self.set_shader_param("color_fg", new_value)
