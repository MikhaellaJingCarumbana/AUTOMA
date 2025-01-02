extends AnimatedSprite2D


var float_amplitude: float = 10.0  # How far the sprite moves up and down
var float_speed: float = 2.0      # How fast the sprite moves up and down
var initial_y: float = 0.0        # To store the original Y position of the sprite

var base_y_position: float = 0.0
var time_elapsed: float = 0.0
var is_floating: bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".play("default")
	initial_y = position.y

func _process(delta: float) -> void:
	position.y = base_y_position + sin(time_elapsed * float_speed) * float_amplitude
