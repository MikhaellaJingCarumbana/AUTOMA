extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("Intro card draw")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("skip"):
		get_tree().change_scene_to_file("res://Chapters/Chapter 1/Regex - Map/Beginner-F.tscn")


func _on_button_mouse_entered() -> void:
	$AnimationPlayer.play("Card powerup")


func _on_button_mouse_exited() -> void:
	$AnimationPlayer.play("Card powerup_2")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Intro card draw":
		animation_player.play("Take card")
		
	if anim_name == "Take card":
		animation_player.play("Card powerup")
