extends CharacterBody2D

# Constants for movement
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Reference to the AnimatedSprite2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction (left or right)
	var direction := Input.get_axis("ui_left", "ui_right")

	# Move player left or right based on input
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Move and handle collisions
	move_and_slide()

	# Update the animation based on movement
	update_animation(direction)

# Function to update animations
func update_animation(direction: float) -> void:
	if direction != 0:
		# Play walk animation when moving
		animated_sprite.play("Walk")
		
		# Flip the sprite based on movement direction
		animated_sprite.flip_h = direction < 0
	else:
		# Play idle animation when not moving
		animated_sprite.play("idle")
