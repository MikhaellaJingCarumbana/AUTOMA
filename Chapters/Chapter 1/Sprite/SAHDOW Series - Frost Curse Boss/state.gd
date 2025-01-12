extends Node2D
class_name State
@onready var debug = owner.find_child("debug")
@onready var player = owner.get_parent().find_child("Player")
@onready var animation_player = owner.find_child("AnimatedSprite2D")
var can_transition: bool = true

func enter():
	super.enter()
	animation_player.play("Attack 2")
	can_transition = true
	
func transition():
	if can_tansition:
		can_transition = false
		get_parent().change_state()
