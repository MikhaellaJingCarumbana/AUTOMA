extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var parent_chest: NodePath
@onready var chest: Node = get_node(parent_chest)
@onready var game_manager: Node = %GameManager
# Called when the node enters the scene tree for the first time.

@export var float_speed: float = 5.0
@export var float_amplitude: float = 3.0

var base_y_position: float = 0.0
var time_elapsed: float = 0.0

func _ready() -> void:
	base_y_position = global_position.y
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_elapsed += delta
	position.y = base_y_position + sin(time_elapsed * float_speed) * float_amplitude
	animated_sprite_2d.play("default")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and chest and chest.has_method("is_open") and chest.call("is_open"):
		queue_free()
		game_manager.add_clue()
		print("Clue added")
