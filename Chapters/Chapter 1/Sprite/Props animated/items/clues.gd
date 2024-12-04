extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var parent_chest: NodePath
@onready var chest: Node = get_node(parent_chest)
@onready var game_manager: Node = $"../GameManager"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	animated_sprite_2d.play("default")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and chest and chest.has_method("is_open") and chest.call("is_open"):
		queue_free()
		game_manager.add_clue()
