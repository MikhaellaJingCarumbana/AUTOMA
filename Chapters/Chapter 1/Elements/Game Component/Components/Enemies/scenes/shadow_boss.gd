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
var is_dead: bool = false

var health_boss = 100:
	set(value):
		if is_dead:
			return
		health_boss = value
		progress_bar.value = value
		
		if value <= 0:
			is_dead = true
			$AnimationPlayer.play("dead")
			find_child("FiniteStateMachine").change_state("Death")

func _ready() -> void:
	$AnimationPlayer.play("flicker2")
	set_physics_process(false)
	
func _process(delta: float) -> void:
	if is_dead:
		return
		
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
	health_boss -= 3
	$Hit.play()
	print("Boss health: ", health_boss)
