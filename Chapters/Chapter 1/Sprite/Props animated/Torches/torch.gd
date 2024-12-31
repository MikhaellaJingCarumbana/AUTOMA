extends CharacterBody2D

@onready var sfx_player: AudioStreamPlayer2D = %sfx_player


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var torch: AudioStream

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	load_sfx(torch)
	sfx_player.play()
	
	
func load_sfx(sfx_to_load):
	if %sfx_player.stream != sfx_to_load:
		%sfx_player.stop()
		%sfx_player.stream = sfx_to_load
