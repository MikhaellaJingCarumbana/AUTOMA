extends Node

@onready var pause_menu: ColorRect = $CarouselSelection/PauseMenu
@onready var carousel_selection: Control = $CarouselSelection
@onready var clue_system: Node = $"."
var is_open: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	carousel_selection.show()


func _on_back_pressed() -> void:
	carousel_selection.hide()
	get_tree().paused = false


func _on_previous_pressed() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("note"):
		if is_open:
			$AudioStreamPlayer2D.play()
			carousel_selection.hide()
			is_open = false
		else:
			$AudioStreamPlayer2D.play()
			carousel_selection.show()
			is_open = true
			
