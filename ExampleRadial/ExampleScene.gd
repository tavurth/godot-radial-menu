extends Control

func _on_TextureButton_pressed():
	print("A button was pressed")

func _on_RadialMenu_hovered(child):
	prints("Hovered", child)

func _on_RadialMenu_selected(child):
	prints("Selected", child)
