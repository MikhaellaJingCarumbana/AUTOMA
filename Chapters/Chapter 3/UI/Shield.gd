extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@export var canvas_layer: Control
@onready var texture_rect: TextureRect = %TextureRect

var player_nearby: bool = false  # Track if the player is in range
var float_speed: float = 2.0  # Speed of floating movement
var float_amplitude: float = 5.0  # How much it moves up and down
var time_passed: float = 0.0  # Keeps track of time
var start_position: Vector2  # Store the initial position of the texture

func _ready() -> void:
	anim.play("default")
	start_position = texture_rect.position  # Save initial position

func _process(delta: float) -> void:
	# Apply floating effect to the paper (TextureRect)
	time_passed += delta * float_speed
	texture_rect.position.y = start_position.y + sin(time_passed) * float_amplitude

	# Check for interaction when player is nearby
	if player_nearby and Input.is_action_just_pressed("interact"):  
		if canvas_layer:
			canvas_layer.visible = !canvas_layer.visible  # Toggle visibility

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_nearby = true  

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_nearby = false  
