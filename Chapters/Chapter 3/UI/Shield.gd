extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var canvas_layer: Control = $"../CanvasLayer/Clue"

var player_nearby: bool = false  # Track if the player is in range

func _ready() -> void:
	anim.play("default")
	

func _process(delta: float) -> void:
	pass
	# Check for interaction when player is nearby
	if player_nearby and Input.is_action_just_pressed("interact"):  # Ensure "interact" is mapped to "E" in InputMap
		if canvas_layer:
			canvas_layer.visible = !canvas_layer.visible  # Toggle visibility

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_nearby = true  # Set flag to true when the player is in range

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_nearby = false  # Set flag to false when the player leaves
