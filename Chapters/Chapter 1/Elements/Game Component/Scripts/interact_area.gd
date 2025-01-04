class_name Interactable extends Area2D

@export var interact_label = "none"
@export var interact_type = "none"
@export var interact_value = "none"
@export var timeline_name = ""  # Add this line
@export var door_code_path: NodePath
@onready var door_code: Node = $"../../UI/DoorCode"
@export var chest_puzzle: Node
@export var is_interactable: bool = true

signal interacted

func interact():
	if door_code:
		door_code.interact_door()
	else:
		print("Error: door_code node not found")
		
func interact_mimic():
	if chest_puzzle:
		chest_puzzle.open_mimic()
	else:
		print("Error: chest puzzle node not found")
		
func disable():
	is_interactable = false
	print("Interaction disabled")

func enabled():
	is_interactable = true
	print("Interaction enabled")
		
