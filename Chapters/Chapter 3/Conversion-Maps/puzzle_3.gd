extends Control

@onready var four: LineEdit = $ColorRect/LineEdit3
@onready var puzzle_1: Control = $"."
@onready var key3: TextureRect = $"../Keys/HBoxContainer/TextureRect3"

func _process(delta: float) -> void:
	# Check if player presses the submit answer action
	if Input.is_action_just_pressed("submit answer"):
		if four.text == "aa (a+b)*" or four.text == "aa(a+b)*":
			print("Correct!")  # Replace with desired action
			key3.visible = true
			puzzle_1.visible = false
		else:
			print("Incorrect!")  # Feedback for wrong answer
			puzzle_1.visible = false
			
