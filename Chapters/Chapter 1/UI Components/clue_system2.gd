extends Node

@onready var pause_menu: ColorRect = $CarouselSelection/PauseMenu
@onready var carousel_selection: Control = $CarouselSelection
@onready var clue_system: Node = $"."
var is_open: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame
		
func _on_button_pressed() -> void:
	carousel_selection.hide()
	get_tree().paused = false
	
func _input(event: InputEvent) -> void:
		if event.is_action_pressed("Clue System"):
			if is_open:
				$AudioStreamPlayer2D.play()
				carousel_selection.hide()
				is_open = false
			else:
				$AudioStreamPlayer2D.play()
				carousel_selection.show()
				is_open = true
