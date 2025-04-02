extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var canvas_layer: Control = $"../CanvasLayer/Clue"

var float_speed: float = 2.0  # Speed of floating movement
var float_amplitude: float = 5.0  # How much it moves up and down
var time_passed: float = 0.0  # Keeps track of time
var start_position: Vector2
var player_nearby: bool = false  # Track if the player is in range

func _ready() -> void:
	anim.play("default")
	start_position = position  # Save the initial position
	canvas_layer.visible = false  # Ensure the UI is hidden at the start

func _process(delta: float) -> void:
	# Floating effect
	time_passed += delta * float_speed
	position.y = start_position.y + sin(time_passed) * float_amplitude

	# Only allow interaction if player is nearby
	if player_nearby and Input.is_action_just_pressed("interact"):  # Ensure "interact" is mapped to "E" in InputMap
		canvas_layer.visible = !canvas_layer.visible  # Toggle visibility

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_nearby = true  # Set flag to true when the player is in range

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_nearby = false  # Set flag to false when the player leaves
		canvas_layer.visible = false  # Hide the clue when the player exits
