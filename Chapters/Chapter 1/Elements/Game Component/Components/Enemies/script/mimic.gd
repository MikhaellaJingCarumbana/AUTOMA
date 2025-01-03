extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var in_area: bool = false
@onready var pause_menu: ColorRect = $"../../UI/Chest Puzzle/PauseMenu"
@onready var area_2d: Area2D = $Area2D


func _ready() -> void:
	area_2d.connect("body_entered", _on_area_2d_body_entered)
	area_2d.connect("body_exited", _on_area_2d_body_exited)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		emit_signal("player_entered", body)
		print("Player entered Mimic area")
	

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		emit_signal("player_exited", body)
		print("Player exited Mimic area")
