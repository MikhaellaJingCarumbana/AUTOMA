extends Area2D

class_name Door

@export var destination_level_tag: String
@export var destination_door_tag: String
@export var spawn_direction = "up"

@onready var spawn = $Spawn

# Reference to the keys
@onready var key1: TextureRect = $"../../CanvasLayer/Keys/HBoxContainer/TextureRect"
@onready var key2: TextureRect = $"../../CanvasLayer/Keys/HBoxContainer/TextureRect2"
@onready var key3: TextureRect = $"../../CanvasLayer/Keys/HBoxContainer/TextureRect3"


func _on_body_entered(body):
	if body is Player:
		if all_keys_collected():
			NavigationManager.go_to_level(destination_level_tag, destination_door_tag)
		else:
			print("Keys not complete")  # Output message when keys are missing
# Function to check if all keys are collected (visible)
func all_keys_collected() -> bool:
	return key1.visible and key2.visible and key3.visible
	
