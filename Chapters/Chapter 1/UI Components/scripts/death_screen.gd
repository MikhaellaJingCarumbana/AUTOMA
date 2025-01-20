extends Node

@onready var deathscreen : ColorRect = $PauseMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deathscreen.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resume_pressed() -> void:
	get_tree().reload_current_scene()


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Chapters/Main UI/Chapters_enw.tscn")

func game_over():
	deathscreen.show()
