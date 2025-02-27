extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var canvas_layer: CanvasLayer = $CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if canvas_layer.visible:
		get_tree().paused = false
		
func _on_try_again_pressed() -> void:
	get_tree().reload_current_scene()
	

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Chapters/Main UI/Chapters_enw.tscn")
	
	
