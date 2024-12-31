extends Node

@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D

var has_entered: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _play_animation():
	%AnimationPlayer.play("Text")
	
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not has_entered:
		print("Player entered for the first time. Playing animation.")
		_play_animation()
		has_entered = true
	elif body.is_in_group("Player"):
		print("Player entered again, animation will not play.")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player exited. Resetting tracker.")
		has_entered = false
		%AnimationPlayer.play("exit")


func _on_button_pressed() -> void:
	pass # Replace with function body.
