extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")
const MAX_FALL_SPEED = 1200.0

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
	velocity.y += GRAVITY * delta
	
	if velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED
	
		
	velocity.x = direction.normalized().x * SPEED
	move_and_slide() 
