extends Control

@onready var three: LineEdit = $ColorRect/LineEdit3
@onready var puzzle_1: Control = $"."

func _process(delta: float) -> void:
	# Check if player presses the submit answer action
	if Input.is_action_just_pressed("submit answer"):
		if three.text == "aa":
			print("Correct!")  # Replace with desired action
			
		else:
			print("Incorrect!")  # Feedback for wrong answer
			puzzle_1.visible = false
			
