extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var scene = preload("res://Chapters/Main UI/Chapters_enw.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("intro")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("skip"):
		get_tree().change_scene_to_file("res://Chapters/Chapter 1/Cutscene/Chapter 1 Menu.tscn")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "intro":
		get_tree().change_scene_to_file("res://Chapters/Chapter 1/Cutscene/Chapter 1 Menu.tscn")
