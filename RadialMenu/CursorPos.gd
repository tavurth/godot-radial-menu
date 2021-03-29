extends Control

var touches = 0
var cursor = Vector2(0, 0)

func touch_start(_event: InputEventScreenTouch):
	if touches < 1:
		cursor = Vector2(0, 0)

	touches += 1

func touch_end(_event: InputEventScreenTouch):
	touches -= 1
	if touches <= 0:
		touches = 0

func touch_drag(event: InputEventScreenDrag):
	self.cursor += event.relative

func mouse_start(_event: InputEventMouseButton):
	if touches < 1:
		mouse_drag()

	touches += 1

func mouse_end(_event: InputEventMouseButton):
	touches -= 1
	if touches <= 0:
		touches = 0

func mouse_drag(_event: InputEventMouseMotion = null):
	if touches < 1: return

	var parent = self.get_parent()
	var center = self.get_global_position()

	self.cursor = (center - self.get_global_mouse_position()) * -1

func _input(event: InputEvent):
	if event is InputEventScreenTouch:
		if event.pressed:
			self.touch_start(event)

		else:
			self.touch_end(event)

	elif event is InputEventScreenDrag:
		self.touch_drag(event)

	elif event is InputEventMouseButton:
		if event.pressed:
			self.mouse_start(event)

		else:
			self.mouse_end(event)

	elif event is InputEventMouseMotion:
		self.mouse_drag(event)
