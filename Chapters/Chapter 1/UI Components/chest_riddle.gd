extends Node

@export_file("*.json") var json_file: String = ""
@onready var submit: Button = $PauseMenu/Submit
@onready var answer_input: LineEdit = $PauseMenu/answer_input
@onready var question_label: Label = $PauseMenu/Label
@export var question: String = ""
@onready var back: Button = $PauseMenu/UI/Back
@onready var pause_menu: Control = $Control
@onready var question_q: Label = $Control/PauseMenu/question
@onready var ui: Control = $"../UI"
@onready var scale: Scale = $Control/Scale
@onready var button: Button = $UI/Button
@onready var mimic: CharacterBody2D = $"../../Mimic"



var questions = []
var current_question_index = -1
var is_open = false

func _ready() -> void:
	question_q.text = question
	
	if scale.button_should_cloes():
		button.hide()
	
func open_mimic():
	print("mimic opened")
	
func _on_back_pressed() -> void:
	pause_menu.hide()
	ui.hide()
	
func _on_button_pressed() -> void:
	scale.confirm_slots()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Submit answer") and mimic.opened_quiz():
		scale.confirm_slots()

	
