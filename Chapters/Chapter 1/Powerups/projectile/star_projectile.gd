extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
	animated_sprite_2d.play("default")
	position += velocity * delta
	if position.x < 0 or position.x > 800:
		queue_free()
