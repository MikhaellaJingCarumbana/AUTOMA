extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var parent_chest: NodePath
@onready var chest: Node = get_node(parent_chest)
@onready var game_manager: Node = %GameManager
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var float_speed: float = 5.0
@export var float_amplitude: float = 3.0

var base_y_position: float = 0.0
var time_elapsed: float = 0.0

func _ready() -> void:
	base_y_position = global_position.y
	print("Clue ready. Position ", global_position)
	if collision_shape_2d.disabled:
		print("Collision shape is disabled")
	if not is_instance_valid(chest):
		print("PARENT CHEST NOT SET CORRECTLY")
	else:
		print("Parent chest resolved correctly",chest.name )
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_elapsed += delta
	position.y = base_y_position + sin(time_elapsed * float_speed) * float_amplitude
	animated_sprite_2d.play("default")

func _on_body_entered(body: Node2D) -> void:
	print("body entered clue area:", body.name)
	if body.is_in_group("Player"):
		print("Player detected in clue area")
		if chest and chest.is_open():
			print("Parent chest is open. Collectingc clue")
			queue_free()
			game_manager.add_clue()
		else:
			print("Parent chest is not open")
