tool
extends Container

signal hovered(child)
signal selected(child)

const MIN_WIDTH = 0.01

export(PackedScene) var center_node setget set_center_node

export(float, 0, 1) var width_max = 1.0 setget set_width_max;
export(float, 0, 1) var width_min = 0.5 setget set_width_min;

export(float, 0, 3.1416) var cursor_size = 0.4 setget set_cursor_size;
export(float, -3.1416, 3.1416) var cursor_deg = 0.4 setget set_cursor_deg;

export(Color, RGBA) var color_bg = Color(0.4, 0.4, 0.4, 1.0) setget set_color_bg;
export(Color, RGBA) var color_fg = Color(0.17, 0.69, 1.0, 1.0) setget set_color_fg;

func set_shader_param(name: String, new_value):
	if not len(self.get_children()): return
	$RadialMenu/Background.material.set_shader_param(name, new_value)

func set_center_node(new_node: PackedScene):
	center_node = new_node

	var old_nodes = $RadialMenu/CenterNode.get_children()
	for child in old_nodes:
		child.set_visible(false)
		child.queue_free()

	$RadialMenu/CenterNode.add_child(new_node.instance())

func set_width_max(new_value: float):
	if new_value - MIN_WIDTH < 0: return

	width_max = new_value
	self.set_shader_param("width_max", new_value)

	# Handle case where we're now smaller than the minimum size
	if new_value - width_min < MIN_WIDTH:
		self.set_width_min(new_value - MIN_WIDTH * 2)

	self.emit_signal("sort_children")

func set_width_min(new_value: float):
	if new_value + MIN_WIDTH > 1: return

	width_min = new_value
	self.set_shader_param("width_min", new_value)

	# Handle case where we're now bigger than the minimum size
	if width_max - new_value < MIN_WIDTH:
		self.set_width_max(new_value + MIN_WIDTH * 2)

	var min_width = get_bounding_rect() * new_value
	$RadialMenu/CenterNode.rect_min_size = Vector2(min_width, min_width)

	self.emit_signal("sort_children")

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

func setup():
	self.set_shader_param("color_bg", color_bg)
	self.set_shader_param("color_fg", color_fg)
	self.set_shader_param("width_max", width_max)
	self.set_shader_param("width_min", width_min)
	self.set_shader_param("cursor_deg", cursor_deg)
	self.set_shader_param("cursor_size", cursor_size)

# We want to remove our own scene children
# so that we're only processing user added nodes
func get_children():
	var to_return = .get_children()

	# Remove as many child nodes as we have for the RadialMenu
	# the remaining array will be all user added children
	to_return.pop_front()

	return to_return

func get_bounding_rect():
	var size = self.get_size()
	return min(size.x, size.y)

#Repositions the buttons
func place_buttons():
	var buttons = get_children()
	if not len(buttons): return

	var angle_increment = (2 * PI) / len(buttons)
	var center = self.get_size() / 2
	center.y *= -1

	var rect = self.get_bounding_rect() / 2

	var max_size = rect * self.width_max
	var min_size = rect * self.width_min

	var width = max_size - min_size
	var half_size = min_size + width / 2

	var angle = -PI + PI / 4 #in radians
	for button in buttons:
		var size = button.get_size() / 2

		# Handle edge case where the radial is very thin
		if width < size.x: size.x = 0
		if width < size.y: size.y = 0

		#calculate the x and y positions for the button at that angle
		var x = center.x + cos(angle) * (half_size + size.x)
		var y = center.y + sin(angle) * (half_size + size.y)

		var corner_pos = Vector2(x, -y) - (button.get_size() / 2)
		button.set_position(corner_pos)

		#Advance to next angle position
		angle += angle_increment

func add_button(btn):
	self.add_child(btn)
	self.place_buttons()

func _on_sort_children():
	self.place_buttons()

	var min_size = self.get_bounding_rect()

	$RadialMenu.anchor_left = ANCHOR_BEGIN
	$RadialMenu.anchor_top = ANCHOR_BEGIN
	$RadialMenu.anchor_right = ANCHOR_END
	$RadialMenu.anchor_bottom = ANCHOR_END

	# Resize the background
	$RadialMenu/Background.set_custom_minimum_size(Vector2(min_size, min_size))
	$RadialMenu/Background.set_pivot_offset(Vector2(min_size / 2, min_size / 2))

	# Tell our cursor how many can be selected
	if not Engine.editor_hint:
		$RadialMenu/CursorPos.set_count(len(self.get_children()))

func _on_selected(index: int):
	var child = get_children()[index]

	if child is Control:
		child.grab_focus()

	if child is BaseButton:
		child.set_pressed(true)
		child.emit_signal("pressed")

	self.emit_signal("selected", child)

func _on_hover(index: int):
	var child = get_children()[index]

	if child is Control:
		child.grab_focus()

	self.emit_signal("hovered", child)

func _input(_event: InputEvent):
	 var pos = $RadialMenu/CursorPos.cursor
	 self.cursor_deg = atan2(pos.y, pos.x)

func _init():
	self.add_child(preload("./RadialMenu.tscn").instance())

func _ready():
	self.setup()
	self.place_buttons()

	var _e
	_e = self.connect("sort_children", self, "_on_sort_children")
	_e = $RadialMenu/CursorPos.connect("hover", self, "_on_hover")
	_e = $RadialMenu/CursorPos.connect("selected", self, "_on_selected")
