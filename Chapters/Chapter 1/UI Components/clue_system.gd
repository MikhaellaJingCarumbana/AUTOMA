extends Node

@onready var pause_menu: ColorRect = $PauseMenu
@onready var carousel_selection: Control = $CarouselSelection
@onready var clue_system: Node = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var clue_pressed = Input.is_action_just_pressed("Clue System")
	if (clue_pressed == true):
		get_tree().paused = true
		pause_menu.show()
		
func _on_button_pressed() -> void:
	pause_menu.hide()
	get_tree().paused = false
