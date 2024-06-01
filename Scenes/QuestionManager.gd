extends Node2D

# Variables to store questions, current question, and score
var questions = []
var current_question_index = -1
var score = 0
var wrong_answers = 0
var total_time = 0
var correct_answers = 0
var difficulty_thresholds = {
	"easy": {"wrong_answers": 2, "total_time": 30},
	"moderate": {"wrong_answers": 4, "total_time": 60},
	"difficult": {"wrong_answers": 6, "total_time": 90}
}
var current_difficulty = "easy"

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
	if current_question_index < questions[current_difficulty].size():
		var question = questions[current_difficulty][current_question_index]
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
		save_score(player_name_label.text, score)

func _on_submit_button_pressed():
	# Get the current question
	var question = questions[current_difficulty][current_question_index]

	# Check the answer
	if answer_input.text == question["correct_answer"]:
		score += 1
		correct_answers += 1
	else:
		wrong_answers += 1

	# Update the score label
	score_label.text = "Score: " + str(score)

	# Show the next question
	next_question()

func _on_try_again_button_pressed():
	# Reset the score, wrong answers, correct answers, and total time
	score = 0
	wrong_answers = 0
	correct_answers = 0
	total_time = 0
	
	# Reset the question index
	current_question_index = -1
	
	# Get the questions of the current difficulty
	var questions_of_current_difficulty = questions[current_difficulty]
	
	# Calculate the score percentage
	var score_percentage = float(score) / questions_of_current_difficulty.size()

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
	# Check if difficulty needs to be adjusted based on player performance
	if current_difficulty != "difficult" and (wrong_answers >= difficulty_thresholds[current_difficulty]["wrong_answers"] or total_time >= difficulty_thresholds[current_difficulty]["total_time"]):
		if current_difficulty == "easy":
			current_difficulty = "moderate"
		elif current_difficulty == "moderate":
			current_difficulty = "difficult"
		else:
			current_difficulty = "difficult"
		
		print("Difficulty adjusted to: " + current_difficulty)
