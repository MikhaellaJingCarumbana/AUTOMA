extends CharacterBody2D

@onready var sfx_player: AudioStreamPlayer2D = %sfx_player


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var is_on = false
@export var torch: AudioStream
@export var torch_die: AudioStream
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	anim.play("default")
	
	

func load_sfx(sfx_to_load):
	if %sfx_player.stream != sfx_to_load:
		%sfx_player.stop()
		%sfx_player.stream = sfx_to_load


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and is_on == false:
		$AnimatedSprite2D.visible = true
		$PointLight2D.visible = true
		is_on = true
		load_sfx(torch)
		sfx_player.play()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player") and is_on == true:
		$AnimatedSprite2D.visible = false
		$PointLight2D.visible = false
		is_on = false
		load_sfx(torch_die)
		sfx_player.play()
		
