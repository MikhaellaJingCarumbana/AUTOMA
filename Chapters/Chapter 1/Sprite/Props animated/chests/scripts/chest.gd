extends CharacterBody2D

@onready var sprite_2d = $AnimatedSprite2D  # Reference to the chest's AnimatedSprite2D
var is_chest_open = false  # Track if the chest is open or closed

func _ready():
	sprite_2d.play("Idle")  # Start with the chest closed

func open_chest():
	sprite_2d.stop()  # Stop any current animation

	if is_chest_open:
		# If the chest is open, play the close animation
		if sprite_2d.sprite_frames.has_animation("Close"):
			sprite_2d.play("Close")  # Play the closing animation
		is_chest_open = false  # Update the state to closed
	else:
		# If the chest is closed, play the open animation
		if sprite_2d.sprite_frames.has_animation("Open"):
			sprite_2d.play("Open")  # Play the opening animation
		is_chest_open = true  # Update the state to open
