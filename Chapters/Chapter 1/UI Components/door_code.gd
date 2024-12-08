extends Node

@export var question_File: Resource
@onready var pause_menu: ColorRect = $PauseMenu
@onready var question_label: Label = $PauseMenu/Label
@onready var submit: Button = $PauseMenu/Submit
@onready var answer_input: LineEdit = $PauseMenu/answer_input

var questions = []
var current_question_index = -1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact_door():
	print("Interacting with the door code")
	pause_menu.show()
	


func _on_button_pressed() -> void:
	pause_menu.hide()
	
func load_question() -> void:
	if not question_File:
		print("No question file selected in the inspector")
		return
		
	var file = FileAccess.open(question_File.resource_path, FileAccess.READ)
	if file:
		var json_data = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var error = json.parse(json_data)
		
		if error == OK:
			questions = json.data
			print("Questions loaded successfully")
			
		else:
			print("Error parsing JSON: " + json.get_error_message() + " at line " + str(json.get_error_line()))
	else:
		print("Question file could not be opened")
		
func next_question():
	
	current_question_index += 1
	
	if current_question_index < questions.size():
		var question = questions[current_question_index]
		question_label.text = question["question"]
		answer_input.text = ""
		submit.show()
	else:
		question_label.text = "Door unlocked"
		submit.hide()
		

func _on_submit_pressed() -> void:
	var question = questions[current_question_index]
	
	var answer = answer_input.text.to_lower()
	var is_correct = false
	for correct_answer in question["correct_answers"]:
		if answer == correct_answer.to_lower():
			is_correct = true
			break
			
	await get_tree().create_timer(1).timeout
	next_question()
	
