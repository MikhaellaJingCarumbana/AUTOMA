extends CharacterBody2D


const speed = 200.0
const JUMP_VELOCITY = -400.0
@onready var sprite_2d = $AnimatedSprite2D
var current_dir = "none"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func player_movement(delta):
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0

	move_and_slide()

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D

	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("Running")
		elif movement == 0:
			anim.play("Idle")
	elif dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("Running")
		elif movement == 0:
			anim.play("Idle")
