extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var parent_enemy: NodePath
@onready var enemy: Node = get_node(parent_enemy)
@onready var game_manager: Node = $"../GameManager"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	animated_sprite_2d.play("default")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		queue_free()
		game_manager.add_clue()
