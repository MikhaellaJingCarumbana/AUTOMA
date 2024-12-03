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


func _on_chapters_pressed() -> void:
	var scene_path = "res://Chapters/Main UI/Chapters.tscn"
	if not FileAccess.file_exists(scene_path):
		print("Error: Scene file does not exist:", scene_path)
		return
	if get_tree() != null:
		get_tree().paused = false  # Unpause before changing scenes
		get_tree().change_scene_to_file("res://Chapters/Main UI/Chapters.tscn")
