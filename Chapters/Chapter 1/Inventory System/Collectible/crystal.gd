extends AnimatedSprite2D

@onready var crystal: AnimatedSprite2D = $"."
@export var float_amplitude: float = 6.0
@export var float_speed: float = 5.0

var base_y_position: float = 0.0
var time_elapsed: float = 0.0
var is_floating: bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	base_y_position = position.y 
	crystal.play("default")
		
func _process(delta: float) -> void:
	if is_floating:
		time_elapsed += delta
		position.y = base_y_position + sin(time_elapsed * float_speed) * float_amplitude
