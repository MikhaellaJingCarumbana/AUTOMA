extends Node

@export_file("*.json") var json_file: String = ""
@onready var pause_menu: ColorRect = $PauseMenu
@onready var submit: Button = $PauseMenu/Submit
@onready var answer_input: LineEdit = $PauseMenu/answer_input
@onready var question_label: Label = $PauseMenu/Label

var questions = []
var current_question_index = -1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_question()
	next_question()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact_door():
	print("Interacting with the door code")
	pause_menu.show()
	


func _on_button_pressed() -> void:
	pause_menu.hide()
	
func load_question() -> void:
	if json_file == "":
		print("No JSON file selected")
		return
		
	var file = FileAccess.open(json_file, FileAccess.READ)
	if file: 
		var json_data = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var error = json.parse(json_data)
		
		if error == OK:
			questions = json.data
		else:
			print("Error parsing JSON: " + json.get_error_message() + " at lisne " + str(json.get_error_line()))
	else:
		print("Could not open file: " + json_file)

		
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
		get_tree().change_scene_to_file("res://Chapters/Chapter 1/Regex - Map/Intermediate-F.tscn")
		

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
	