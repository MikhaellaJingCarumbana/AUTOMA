extends Node

@onready var pause_menu: ColorRect = $PauseMenu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact_door():
	print("Interacting with the door code")
	pause_menu.show()
	
