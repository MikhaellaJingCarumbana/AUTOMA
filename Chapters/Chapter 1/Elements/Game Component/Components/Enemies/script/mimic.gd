extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var in_area: bool = false
var is_open = false 
@onready var clues: Area2D = $"../Clues"
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var is_mimic_open = false
var is_inside = false
@export var chest_quiz: Node
@onready var area_2d: Area2D = $Interaction
@export var UI: Node
@onready var pause_menu: Control = $"../Chest Puzzles/Chest Puzzle/Control"
@export var button: Button

func _ready() -> void:
	
	area_2d.connect("body_entered", _on_area_2d_body_entered)
	area_2d.connect("body_exited", _on_area_2d_body_exited)
	
	var scale_node = get_node("Chest Puzzles/Chest Puzzle/PauseMenu")
	if scale_node:
		scale_node.connect("correct_answer_handled", _on_correct_answer_handled)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		emit_signal("player_entered", body)
		print("Player entered Mimic area")
		is_inside = true
	

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		emit_signal("player_exited", body)
		print("Player exited Mimic area")
		is_inside = false

func _on_correct_answer_handled() -> void:
	if is_instance_valid(clues):
		clues.show()
		collision_shape_2d.disabled = false
		print("clues are now visible")
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("open_mimic") and is_inside:
		print("interacted with mimic")
		toggle_chest_quiz()
		
func toggle_chest_quiz() -> void:
	if is_open:
		chest_quiz.hide()
		print("quiz open")
		is_open = false
	else:
		chest_quiz.show()
		is_open = true


		
