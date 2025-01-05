extends Node

@export_file("*.json") var json_file: String = ""
@onready var pause_menu: ColorRect = $PauseMenu
@onready var submit: Button = $PauseMenu/Submit
@onready var answer_input: LineEdit = $PauseMenu/answer_input
@onready var question_label: Label = $PauseMenu/Label
@export var cutscene: String
@onready var game_manager: Node = %GameManager
@export var door_dialogue:String = ""
@onready var dialog: Label = $PauseMenu/Dialog

var questions = []
var current_question_index = -1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_question()

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

		

func _on_submit_pressed() -> void:
	var question = questions[current_question_index]
	
	var answer = answer_input.text.to_lower()
	var is_correct = false
	for correct_answer in question["correct_answers"]:
		if answer == correct_answer.to_lower():
			is_correct = true
			break
			
	if is_correct:
		get_tree().change_scene_to_file(cutscene)
	else:
		dialog.text = door_dialogue
		await get_tree().create_timer(0.5).timeout
		pause_menu.hide()
		game_manager.decrease_health()
		
	
	
