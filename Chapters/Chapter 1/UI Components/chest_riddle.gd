extends Node

@export_file("*.json") var json_file: String = ""
@onready var pause_menu: ColorRect = $PauseMenu
@onready var submit: Button = $PauseMenu/Submit
@onready var answer_input: LineEdit = $PauseMenu/answer_input
@onready var question_label: Label = $PauseMenu/Label


var questions = []
var current_question_index = -1
var is_open = false

func open_mimic():
	print("mimic opened")
	pause_menu.show()
	
