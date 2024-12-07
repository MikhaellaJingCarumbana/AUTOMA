extends AnimatedSprite2D

@onready var door_quiz_scene: Node = $"../UI/DoorCode"
@onready var interact_area: Interactable = $InteractArea
var is_player_near = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("Idle")
	
func interact():
	emit_signal("interacted")
	
