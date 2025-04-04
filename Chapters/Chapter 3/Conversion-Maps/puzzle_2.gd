extends Control

@onready var three: LineEdit = $ColorRect/LineEdit3
@onready var puzzle_1: Control = $"."
@onready var key2: TextureRect = $"../Keys/HBoxContainer/TextureRect2"
@onready var clue: TextureRect = $ColorRect/Panel/TextureRect

var float_speed: float = 2.0  
var float_amplitude: float = 5.0  
var time_passed: float = 0.0  
var start_position: Vector2

func _ready() -> void:
	start_position = clue.position  # Store initial position

func _process(delta: float) -> void:
	time_passed += delta * float_speed
	clue.position.y = start_position.y + sin(time_passed) * float_amplitude
	# Check if player presses the submit answer action
	if Input.is_action_just_pressed("submit answer"):
		if three.text == "aa":
			print("Correct!")  # Replace with desired action
			key2.visible = true
			puzzle_1.visible = false
		else:
			print("Incorrect!")  # Feedback for wrong answer
			puzzle_1.visible = false
			
