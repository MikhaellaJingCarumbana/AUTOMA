extends CharacterBody2D

@onready var anim = $AnimatedSprite2D

func _ready():
	play_idle_animation()

func play_idle_animation():
	anim.play("idle")
