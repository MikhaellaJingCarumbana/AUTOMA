extends CharacterBody2D

var anim

func _ready():
	# Get reference to AnimatedSprite2D node
	anim = $AnimatedSprite2D
	# Start playing the idle animation
	anim.play("Idle")

func _physics_process(delta):
	# NPC doesn't move, so no need for movement logic
	pass
