extends CharacterBody2D

@onready var sprite_2d = $AnimatedSprite2D # Reference to the chest's AnimatedSprite2D
@onready var clues: Area2D = %Clues
var is_chest_open = false  # Track if the chest is open or closed
@onready var collision_shape_2d: CollisionShape2D = $"../Clues/CollisionShape2D"

func _ready():
	sprite_2d.play("Idle")  # Start with the chest closed
	if is_instance_valid(clues):
		clues.hide()
		collision_shape_2d.disabled = false
		
		if clues.has_meta("parent_chest"):
			clues.set_meta("parent_chest", self)

func open_chest():
	sprite_2d.stop()  # Stop any current animation

	if is_chest_open:
		# If the chest is open, play the close animation
		if sprite_2d.sprite_frames.has_animation("Close"):
			sprite_2d.play("Close")  # Play the closing animation
		is_chest_open = false  # Update the state to closed
		
		if is_instance_valid(clues):
			clues.hide()
			collision_shape_2d.disabled = true

	else:
		# If the chest is closed, play the open animation
		if sprite_2d.sprite_frames.has_animation("Open"):
			sprite_2d.play("Open")  # Play the opening animation
		is_chest_open = true  # Update the state to open
		
		if is_instance_valid(clues):
			clues.show()
			collision_shape_2d.disabled = false
			
func is_open() -> bool:
	return is_chest_open


func _on_death_zone_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
