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

export(Color, RGBA) var color_bg = Color("202431") setget set_color_bg;
export(Color, RGBA) var color_fg = Color("595f70") setget set_color_fg;

export(float, 0, 1) var bevel_width = 0.5 setget set_bevel_width
export(bool) var bevel_enabled = false setget set_bevel_enabled
export(Color, RGBA) var bevel_color = Color("333a4f") setget set_bevel_color

export(bool) var modulate_enabled = false setget set_modulate_enabled
export(Color, RGBA) var modulate_hover = Color.white setget set_modulate_hover
export(Color, RGBA) var modulate_default = Color("b6b6b6") setget set_modulate_default


func set_modulate_enabled(new_value: bool):
	modulate_enabled = new_value
	self.do_modulate()


func set_modulate_hover(new_value: Color):
	modulate_hover = new_value
	self.do_modulate()


func set_modulate_default(new_value: Color):
	modulate_default = new_value
	self.do_modulate()


func set_shader_param(name: String, new_value):
	if not len(self.get_children()): return
	$RadialMenu/Background.material.set_shader_param(name, new_value)


func set_bevel_enabled(new_value: bool):
	bevel_enabled = new_value
	set_shader_param("bevel_enabled", new_value)


func set_bevel_color(new_value: Color):
	bevel_color = new_value
	set_shader_param("bevel_color", new_value)


func set_bevel_width(new_value: float):
	bevel_width = new_value
	set_shader_param("bevel_width", new_value / 5.0)


func set_center_node(new_node: PackedScene = null):
	center_node = new_node
	var Menu = $RadialMenu/CenterNode

	var old_nodes = Menu.get_children()
	for child in old_nodes:
		child.set_visible(false)
		child.queue_free()

	if not new_node: 
		return
	
	Menu.add_child(new_node.instance())


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
	self.set_bevel_color(bevel_color)
	self.set_bevel_enabled(bevel_enabled)
	self.set_bevel_width(bevel_width)
	self.set_center_node(center_node)
	self.set_color_bg(color_bg)
	self.set_color_fg(color_fg)
	self.set_cursor_deg(cursor_deg)
	self.set_cursor_size(cursor_size)
	self.set_modulate_default(modulate_default)
	self.set_modulate_enabled(modulate_enabled)
	self.set_modulate_hover(modulate_hover)
	self.set_width_max(width_max)
	self.set_width_min(width_min)

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

	var angle = -PI + PI / 4 # In radians
	for button in buttons:
		var size = button.get_size() / 3 * button.rect_scale

		# Make sure our buttons are centered
		button.rect_pivot_offset = button.get_size() / 2

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

		# Disable focus rectangle
		button.set_focus_mode(BaseButton.FOCUS_NONE)

	self.do_modulate()

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


func do_modulate(hovered: Node = null):
	var default_color = Color.white

	if self.modulate_enabled:
		default_color = modulate_default

	for child in self.get_children():
		child.set_modulate(default_color)

	if hovered:
		hovered.set_modulate(modulate_hover)


func _on_selected(index: int):
	var child = get_children()[index]

	if child is BaseButton:
		child.set_pressed(true)
		child.emit_signal("pressed")

	self.emit_signal("selected", child)

	if modulate_enabled:
		self.do_modulate(null)


func _on_hover(index: int):
	var child = get_children()[index]

	self.emit_signal("hovered", child)

	if modulate_enabled:
		self.do_modulate(child)


func _input(_event: InputEvent):
	 var pos = $RadialMenu/CursorPos.cursor
	 self.cursor_deg = atan2(pos.y, pos.x)


func _init():
	self.add_child(preload("./RadialMenu.tscn").instance())


func _ready():
	self.setup()
	self.place_buttons()

	var _e
	_e = $RadialMenu/CursorPos.connect("hover", self, "_on_hover")
	_e = $RadialMenu/CursorPos.connect("selected", self, "_on_selected")


func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		self._on_sort_children()
