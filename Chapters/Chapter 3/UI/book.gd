extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@export var canvas_layer: Control  # The clue/page UI

var float_speed: float = 2.0
var float_amplitude: float = 5.0
var time_passed: float = 0.0
var start_position: Vector2
var player_nearby: bool = false

func _ready() -> void:
	anim.play("default")
	start_position = position
	canvas_layer.visible = false  # Hide page at start

func _process(delta: float) -> void:
	# Floating effect
	time_passed += delta * float_speed
	position.y = start_position.y + sin(time_passed) * float_amplitude

	# Player can interact only when near
	if player_nearby and Input.is_action_just_pressed("interact"):
		canvas_layer.visible = !canvas_layer.visible

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_nearby = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_nearby = false
		canvas_layer.visible = false  # Optional: hide the page if they walk away
