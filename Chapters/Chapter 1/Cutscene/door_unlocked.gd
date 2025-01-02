extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/AnimationPlayer.play("unlock")
	$CanvasLayer/AnimationPlayer.connect("animation_finished", _on_animation_finished)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_animation_finished(animation_name: String) -> void:
	if animation_name == "unlock":
		get_tree().change_scene_to_file("res://Chapters/Chapter 1/Regex - Map/Intermediate-F.tscn")
