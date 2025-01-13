extends CharacterBody2D


var DEFAULT_SPEED = 100.0
var SPEED = DEFAULT_SPEED
const JUMP_VELOCITY = -400.0
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")
const MAX_FALL_SPEED = 1200.0
@onready var health: AnimationPlayer = $AnimationPlayer
@onready var progress_bar: ProgressBar = $UI/ProgressBar

@onready var player = get_parent().find_child("Player")
@onready var sprite = $AnimatedSprite2D

var direction : Vector2

var health_boss = 100:
	set(value):
		health = value
		progress_bar.value = value
		if value <= 0:
			progress_bar.visible = false
			find_child("FiniteStateMachine").change_state("Death")

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
	
func take_damage():
	health_boss -= 10
