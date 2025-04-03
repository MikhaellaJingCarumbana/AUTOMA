extends Area2D

class_name Door

@export var destination_level_tag: String
@export var destination_door_tag: String
@export var spawn_direction = "up"

@onready var spawn = $Spawn

# Reference to the keys
@export var key1: TextureRect
@export var key2: TextureRect
@export var key3: TextureRect


func _on_body_entered(body):
	if body is Player:
		if key1 and key2 and key3:
			if all_keys_collected():
				NavigationManager.go_to_level(destination_level_tag, destination_door_tag)
			else:
				print("Keys not complete")  # Output message when keys are missing
				Dialogic.start("Door not accessible")
	# Function to check if all keys are collected (visible)
func all_keys_collected() -> bool:
	return key1.visible and key2.visible and key3.visible
	
