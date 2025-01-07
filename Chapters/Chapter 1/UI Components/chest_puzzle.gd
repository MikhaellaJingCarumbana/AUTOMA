extends Control
@onready var scale_system: Scale = $Scale
@onready var question_q: Label = $PauseMenu/question
@onready var button: Button = $UI/Button
@export var question: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	question_q.text = question
	
	if scale_system.button_should_cloes():
		button.hide()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_button_pressed() -> void:
	scale_system.confirm_slots()
