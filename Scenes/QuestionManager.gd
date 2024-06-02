extends Node2D

# Variables to store questions, current question, and score
var questions = {}
var current_question_index = -1
var score = 0
var wrong_answers = 0
var correct_answers = 0
var current_difficulty = "easy"
var shuffled_questions = []

# Nodes for UI elements
@onready var question_label = $QuestionLabel
@onready var answer_input = $AnswerInput
@onready var submit_button = $SubmitButton
@onready var score_label = $ScoreLabel
@onready var player_name_label = $PlayerNameLabel
@onready var try_again_button = $TryAgainButton
@onready var difficulty_label = $DifficultyLabel

func _ready():
	# Debug: Print current logged in player
	print("SilentWolf.Auth.logged_in_player: " + str(SilentWolf.Auth.logged_in_player))
	
	# Set the player name if logged in
	if SilentWolf.Auth.logged_in_player:
		player_name_label.text = SilentWolf.Auth.logged_in_player
		print("Player name set to: " + player_name_label.text)
	else:
		player_name_label.text = "Not logged in"
		print("No player logged in")
		
	# Load the questions from the JSON file
	load_questions("res://Data/questions.JSON")  # Adjust the path as necessary

	# Connect the button's pressed signal to the function
	submit_button.pressed.connect(self._on_submit_button_pressed)
	try_again_button.pressed.connect(self._on_try_again_button_pressed)

	# Shuffle and show the first question
	shuffle_questions()
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

func shuffle_questions():
	# Shuffle questions for the current difficulty
	shuffled_questions = questions[current_difficulty].duplicate()
	shuffled_questions.shuffle()
	current_question_index = -1

func next_question():
	# Increment the question index
	current_question_index += 1

	# Check if there are more questions
	if current_question_index < shuffled_questions.size():
		var question = shuffled_questions[current_question_index]
		print("Current question: ", question)  # Debug print
		question_label.text = question["question"]
		answer_input.text = ""
		try_again_button.hide()  # Hide "Try Again" button
		difficulty_label.text = "Difficulty: " + current_difficulty.capitalize()
		submit_button.show()  # Show the "Submit" button
	else:
		# No more questions, show final score and hide the "Submit" button
		question_label.text = "Quiz complete! Your final score is: " + str(score)
		submit_button.hide()  # Hide the "Submit" button
		try_again_button.show()  # Show "Try Again" button
		
		# Save score only if a player is logged in
		if player_name_label.text != "Not logged in":
			save_score(player_name_label.text, score)
		else:
			print("Player not logged in, score not saved")

func _on_submit_button_pressed():
	# Get the current question
	var question = shuffled_questions[current_question_index]
	print("Answering question: ", question)  # Debug print

	# Check the answer (case-insensitive)
	var answer = answer_input.text.to_lower()
	var correct = false
	for correct_answer in question["correct_answers"]:
		if answer == correct_answer.to_lower():
			correct = true
			break

	if correct:
		score += 1
		correct_answers += 1
	else:
		wrong_answers += 1

	# Update the score label
	score_label.text = "Score: " + str(score)

	# Show the next question
	next_question()

func _on_try_again_button_pressed():
	# Calculate the score percentage
	var total_questions = shuffled_questions.size()
	var score_percentage = float(score) / total_questions

	# Determine the new difficulty based on the score percentage
	if score_percentage >= 0.5:
		# Move to the next difficulty level
		if current_difficulty == "easy":
			current_difficulty = "moderate"
		elif current_difficulty == "moderate":
			current_difficulty = "difficult"
	else:
		# If the score percentage is below 50%, move to the previous difficulty level
		if current_difficulty == "difficult":
			current_difficulty = "moderate"
		elif current_difficulty == "moderate":
			current_difficulty = "easy"

	# Reset the score, wrong answers, correct answers
	score = 0
	wrong_answers = 0
	correct_answers = 0
	
	# Shuffle questions and reset the question index
	shuffle_questions()

	# Show the first question again
	next_question()

func save_score(player_name: String, score: int) -> void:
	# Save the score to SilentWolf backend
	SilentWolf.Scores.save_score(player_name, score).sw_save_score_complete.connect(self._on_score_saved)

func _on_score_saved(sw_result: Dictionary):
	if sw_result.success:
		print("Score persisted successfully: " + str(sw_result.score_id))
	else:
		print("Failed to save score: " + str(sw_result.error))

func _process(delta: float):
	# This function can be used for other periodic checks if needed
	pass

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
