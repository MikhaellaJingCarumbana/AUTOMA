extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("boss intro")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "boss intro":
		get_tree().change_scene_to_file("res://Chapters/Chapter 1/Regex - Map/Intro Map - 1.tscn")
