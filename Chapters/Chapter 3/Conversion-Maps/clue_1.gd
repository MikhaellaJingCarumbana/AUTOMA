extends Control

var float_speed: float = 2.0  # Speed of floating
var float_amplitude: float = 5.0  # How much it floats up and down
var time_passed: float = 0.0
var start_position: Vector2

func _ready() -> void:
	start_position = position  # Store the original position

func _process(delta: float) -> void:
	time_passed += delta * float_speed
	position.y = start_position.y + sin(time_passed) * float_amplitude
