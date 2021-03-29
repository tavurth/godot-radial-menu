extends Control

var touches = 0
var cursor = Vector2(0, 0)

func touch_start(event: InputEventScreenTouch):
	touches += 1

func touch_end(event: InputEventScreenTouch):
	touches -= 1
	if touches <= 0:
		touches = 0
		cursor = Vector2(0, 0)

func touch_drag(event: InputEventScreenDrag):
	self.cursor += event.relative

func mouse_start(event: InputEventMouseButton):
	touches += 1

func mouse_end(event: InputEventMouseButton):
	touches -= 1
	if touches <= 0:
		touches = 0
		cursor = Vector2(0, 0)

func mouse_drag(event: InputEventMouseMotion):
	if touches < 1: return

	var parent = self.get_parent()
	var center = parent.get_position() + parent.get_pivot_offset()

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
