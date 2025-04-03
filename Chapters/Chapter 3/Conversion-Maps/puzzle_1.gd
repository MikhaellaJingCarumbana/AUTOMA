extends Control

@onready var one: LineEdit = $ColorRect/LineEdit2
@onready var two: LineEdit = $ColorRect/LineEdit3
@onready var puzzle_1: Control = $"."
@onready var key1: TextureRect = $"../Keys/HBoxContainer/TextureRect"


func _process(delta: float) -> void:
	# Check if player presses the submit answer action
	if Input.is_action_just_pressed("submit answer"):
		if one.text == "e" and two.text == "e":
			print("Correct!")  # Replace with desired action
			key1.visible = true
			puzzle_1.visible = false
		else:
			print("Incorrect!")  # Feedback for wrong answer
			puzzle_1.visible = false
			
