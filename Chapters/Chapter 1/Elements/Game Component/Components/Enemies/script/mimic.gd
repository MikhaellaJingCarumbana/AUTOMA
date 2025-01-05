extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var in_area: bool = false
@onready var pause_menu: ColorRect = $"../../UI/Chest Puzzle/PauseMenu"
@onready var area_2d: Area2D = $Area2D
var is_open = false 
@onready var clues: Area2D = $"../Clues"
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var is_mimic_open = false

func _ready() -> void:
	var scale_node = get_node("PauseMenu/Scale")
	if scale_node:
		scale_node.connect("correct_answer_handled", _on_correct_answer_handled)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		emit_signal("player_entered", body)
		print("Player entered Mimic area")
	

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		emit_signal("player_exited", body)
		print("Player exited Mimic area")

func _on_correct_answer_handled() -> void:
	if is_instance_valid(clues):
		clues.show()
		collision_shape_2d.disabled = false
		print("clues are now visible")
