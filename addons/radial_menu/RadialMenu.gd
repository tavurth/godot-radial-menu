@tool
extends Container

signal hovered(child)
signal selected(child)

const MIN_WIDTH = 0.01

@export var center_node: PackedScene : set = set_center_node

@export_range(0, 1, 0.01) var width_max: float = 1.0: set = set_width_max; # (float, 0, 1)
@export_range(0, 1, 0.01) var width_min: float = 0.5: set = set_width_min; # (float, 0, 1)

@export_range(0, PI, 0.1) var cursor_size: float = 0.4: set = set_cursor_size; # (float, 0, 3.1416)
@export var cursor_deg = 0.4: set = set_cursor_deg; # (float, -3.1416, 3.1416) # Use range when #41183 is solved

@export var color_bg: Color = Color("202431"): set = set_color_bg; # (Color, RGBA)
@export var color_fg: Color = Color("595f70"): set = set_color_fg; # (Color, RGBA)

@export_range(0, 1, 0.01) var bevel_width: float = 0.5: set = set_bevel_width # (float, 0, 1)
@export var bevel_enabled: bool = false: set = set_bevel_enabled
@export var bevel_color: Color = Color("333a4f"): set = set_bevel_color # (Color, RGBA)

@export var modulate_enabled: bool = false : set = set_modulate_enabled
@export var modulate_hover: Color = Color.WHITE: set = set_modulate_hover # (Color, RGBA)
@export var modulate_default: Color = Color("b6b6b6"): set = set_modulate_default # (Color, RGBA)


func set_modulate_enabled(new_value: bool):
	modulate_enabled = new_value
	self.do_modulate()


func set_modulate_hover(new_value: Color):
	modulate_hover = new_value
	self.do_modulate()


func set_modulate_default(new_value: Color):
	modulate_default = new_value
	self.do_modulate()


func set_shader_parameter(name: String, new_value):
	if not len(self.get_children()): return
	$RadialMenu/Background.material.set_shader_parameter(name, new_value)


func set_bevel_enabled(new_value: bool):
	bevel_enabled = new_value
	set_shader_parameter("bevel_enabled", new_value)


func set_bevel_color(new_value: Color):
	bevel_color = new_value
	set_shader_parameter("bevel_color", new_value)


func set_bevel_width(new_value: float):
	bevel_width = new_value
	set_shader_parameter("bevel_width", new_value / 5.0)


func set_center_node(new_node: PackedScene = null):
	center_node = new_node
	var Menu = $RadialMenu/CenterNode

	var old_nodes = Menu.get_children()
	for child in old_nodes:
		child.set_visible(false)
		child.queue_free()

	if not new_node: 
		return
	
	Menu.add_child(new_node.instantiate())


func set_width_max(new_value: float):
	if new_value - MIN_WIDTH < 0: return

	width_max = new_value
	self.set_shader_parameter("width_max", new_value)

	# Handle case where we're now smaller than the minimum size
	if new_value - width_min < MIN_WIDTH:
		self.set_width_min(new_value - MIN_WIDTH * 2)

	self.emit_signal("sort_children")


func set_width_min(new_value: float):
	if new_value + MIN_WIDTH > 1: return

	width_min = new_value
	self.set_shader_parameter("width_min", new_value)

	# Handle case where we're now bigger than the minimum size
	if width_max - new_value < MIN_WIDTH:
		self.set_width_max(new_value + MIN_WIDTH * 2)

	var min_width = get_bounding_rect() * new_value
	$RadialMenu/CenterNode.custom_minimum_size = Vector2(min_width, min_width)

	self.emit_signal("sort_children")


func set_cursor_deg(new_value: float):
	cursor_deg = new_value
	self.set_shader_parameter("cursor_deg", new_value)


func set_cursor_size(new_value: float):
	cursor_size = new_value
	self.set_shader_parameter("cursor_size", new_value)


func set_color_bg(new_value: Color):
	color_bg = new_value
	self.set_shader_parameter("color_bg", new_value)


func set_color_fg(new_value: Color):
	color_fg = new_value
	self.set_shader_parameter("color_fg", new_value)


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

# We want to remove_at our own scene children
# so that we're only processing user added nodes
func get_children(include_internal: bool = false):
	var to_return = super.get_children(include_internal)

	# Remove as many child nodes as we have for the RadialMenu
	# the remaining array will be all user added children
	to_return.pop_front()

	return to_return


func get_bounding_rect():
	var size = self.get_size()
	return min(size.x, size.y)


#Repositions the buttons
func place_buttons():
	var buttons = self.get_children()
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
		var size = button.get_size() / 3 * button.scale

		# Make sure our buttons are centered
		button.pivot_offset = button.get_size() / 2

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
	if not Engine.is_editor_hint():
		$RadialMenu/CursorPos.set_count(len(self.get_children()))


func do_modulate(hovered: Node = null):
	var default_color = Color.WHITE

	if self.modulate_enabled:
		default_color = modulate_default

	for child in self.get_children():
		child.set_modulate(default_color)

	if hovered:
		hovered.set_modulate(modulate_hover)


func _on_selected(index: int):
	var child = self.get_children()[index]

	if child is BaseButton:
		child.set_pressed(true)
		child.emit_signal("pressed")

	self.emit_signal("selected", child)

	if modulate_enabled:
		self.do_modulate(null)


func _on_hover(index: int):
	var child = self.get_children()[index]

	self.emit_signal("hovered", child)

	if modulate_enabled:
		self.do_modulate(child)


func _input(_event: InputEvent):
	var pos = $RadialMenu/CursorPos.cursor
	self.cursor_deg = atan2(pos.y, pos.x)


func _init():
	self.add_child(preload("./RadialMenu.tscn").instantiate())


func _ready():
	self.setup()
	self.place_buttons()

	var _e
	_e = $RadialMenu/CursorPos.hover.connect(_on_hover)
	_e = $RadialMenu/CursorPos.selected.connect(_on_selected)


func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		self._on_sort_children()
