extends Node

@export_file("*.json") var json_file: String = ""
@onready var pause_menu: ColorRect = $PauseMenu
@onready var submit: Button = $PauseMenu/Submit
@onready var answer_input: LineEdit = $PauseMenu/answer_input
@onready var question_label: Label = $PauseMenu/Label
@export var question: String = ""
@onready var question_q: Label = $PauseMenu/question

var questions = []
var current_question_index = -1
var is_open = false

func _ready() -> void:
	question_q.text = question
	
func open_mimic():
	print("mimic opened")
	pause_menu.show()
	
func _on_back_pressed() -> void:
	pause_menu.hide()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		pause_menu.hide()
		print("IT'S OPEEENNNNNNNN")
