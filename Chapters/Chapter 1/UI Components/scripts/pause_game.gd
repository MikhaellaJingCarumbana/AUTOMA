extends Node

@onready var pause_menu: ColorRect = $PauseMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var esc_pressed = Input.is_action_just_pressed("Pause")
	if (esc_pressed == true):
		get_tree().paused = true
		pause_menu.show()



func _on_resume_pressed() -> void:
	pause_menu.hide()
	get_tree().paused = false
	


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
