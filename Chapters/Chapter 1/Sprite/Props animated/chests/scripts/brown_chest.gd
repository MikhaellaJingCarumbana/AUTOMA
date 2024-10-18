extends CharacterBody2D
class_name Brown_Chest

@onready var chest_sprite = $AnimatedSprite2D

func play_open_chest():
		chest_sprite.play("Brown_Open")
