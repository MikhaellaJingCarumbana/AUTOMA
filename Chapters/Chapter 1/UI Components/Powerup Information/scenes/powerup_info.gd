extends Node

@onready var pause_menu: ColorRect = $PauseMenu
var is_open: bool = false

# Called when the node enters the scene tree for the first time.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Info"):
		if is_open:
			pause_menu.hide()
			is_open = false
		else:
			pause_menu.show()
			is_open = true
