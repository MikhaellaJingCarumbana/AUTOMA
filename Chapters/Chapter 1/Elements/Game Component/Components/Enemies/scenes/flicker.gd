extends PointLight2D


@onready var tween = create_tween()

@export var flicker_interval: float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flicker


# Called every frame. 'delta' is the elapsed time since the previous frame.
fucn
