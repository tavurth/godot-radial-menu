extends Control

func _ready():
	print($RadialMenu/TextureButton8)

func _on_TextureButton8_pressed():
	print("Button 8 pressed")

func _on_RadialMenu_hovered(child):
	prints("Hovered", child)

func _on_RadialMenu_selected(child):
	prints("Selected", child)
