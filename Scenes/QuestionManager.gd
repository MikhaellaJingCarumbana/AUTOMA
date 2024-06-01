extends Node2D

# Variables to store questions, current question, and score
var questions = []
var current_question_index = -1
var score = 0

# Nodes for UI elements
@onready var question_label = $QuestionLabel
@onready var answer_input = $AnswerInput
@onready var submit_button = $SubmitButton
@onready var score_label = $ScoreLabel

func _ready():
	# Load the questions from the JSON file
	load_questions("res://Data/questions.JSON")  # Adjust the path as necessary

	# Connect the button's pressed signal to the function
	submit_button.pressed.connect(self._on_submit_button_pressed)

	# Show the first question
	next_question()

func load_questions(file_path: String):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json_data = file.get_as_text()
		file.close()

		var json = JSON.new()  # Create a new instance of the JSON class
		var error = json.parse(json_data)
		
		if error == OK:
			questions = json.data
		else:
			print("Error parsing JSON: " + json.get_error_message() + " at line " + str(json.get_error_line()))
	else:
		print("Questions file not found")

func next_question():
	# Increment the question index
	current_question_index += 1

	# Check if there are more questions
	if current_question_index < questions.size():
		var question = questions[current_question_index]
		question_label.text = question["question"]
		answer_input.text = ""
	else:
		# No more questions, show final score
		question_label.text = "Quiz complete! Your final score is: " + str(score)
		answer_input.hide()
		submit_button.hide()

func _on_submit_button_pressed():
	# Get the current question
	var question = questions[current_question_index]

	# Check the answer
	if answer_input.text == question["correct_answer"]:
		score += 1

	# Update the score label
	score_label.text = "Score: " + str(score)

	# Show the next question
	next_question()
