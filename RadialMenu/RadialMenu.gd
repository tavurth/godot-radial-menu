tool
extends Container

const MIN_WIDTH = 0.05

export(float, 0, 1) var width_max = 1.0 setget set_width_max;
export(float, 0, 1) var width_min = 0.5 setget set_width_min;

export(float, 0, 3.1416) var cursor_size = 0.4 setget set_cursor_size;
export(float, -3.1416, 3.1416) var cursor_deg = 0.4 setget set_cursor_deg;

export(Color, RGBA) var color_bg = Color(0.4, 0.4, 0.4, 1.0) setget set_color_bg;
export(Color, RGBA) var color_fg = Color(0.17, 0.69, 1.0, 1.0) setget set_color_fg;

func set_shader_param(name: String, new_value):
	$CenterContainer/Background.material.set_shader_param(name, new_value)

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

# We want to remove our own scene children
# so that we're only processing user added nodes
func get_children():
	var to_return = .get_children()

	# Remove as many child nodes as we have for the RadialMenu
	# the remaining array will be all user added children
	to_return.pop_front()

	return to_return

#Repositions the buttons
func place_buttons():
	var buttons = get_children()
	if not len(buttons): return

	var angle_increment = (2*PI) / len(buttons)
	var center = self.get_size() / 2
	center.y *= -1

	var angle = 0 #in radians
	for button in buttons:
		#calculate the x and y positions for the button at that angle
		var x = center.x + cos(angle) * (width_max + width_min) * 100
		var y = center.y + sin(angle) * (width_max + width_min) * 100

		var corner_pos = Vector2(x, -y) - (button.get_size() / 2)
		button.set_position(corner_pos)

		#Advance to next angle position
		angle += angle_increment

func add_button(btn):
	self.add_child(btn)
	self.place_buttons()

func _on_sort_children():
	self.place_buttons()

	var size = self.get_size()
	var min_size = min(size.x, size.y)

	$CenterContainer.anchor_right = ANCHOR_END
	$CenterContainer.anchor_bottom = ANCHOR_END
	$CenterContainer/Background.set_custom_minimum_size(Vector2(min_size, min_size))
	$CenterContainer/Background.set_pivot_offset(Vector2(min_size / 2, min_size / 2))

func _input(_event: InputEvent):
	 var pos = $CenterContainer/CursorPos.cursor
	 self.cursor_deg = atan2(pos.y, pos.x)

func _ready():
	self.place_buttons()

	var _e = self.connect("sort_children", self, "_on_sort_children")
