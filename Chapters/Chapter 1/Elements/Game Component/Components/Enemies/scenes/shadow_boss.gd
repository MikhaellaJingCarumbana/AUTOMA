extends CharacterBody2D


const SPEED = 1000.0
const JUMP_VELOCITY = -400.0

@onready var player = get_parent().find_child("Player")
@onready var sprite = $AnimatedSprite2D

var direction : Vector2

func _ready() -> void:
	$AnimationPlayer.play("flicker2")
	set_physics_process(false)
	
func _process(delta: float) -> void:
	direction = player.position - position
	
	if direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func _physics_process(delta: float) -> void:
	velocity = direction.normalized() * 500
	move_and_collide(velocity * delta)
