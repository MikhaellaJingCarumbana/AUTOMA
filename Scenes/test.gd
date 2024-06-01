extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	# Check if a player is logged in
	if SilentWolf.Auth.logged_in_player:
		# Set the label text to the logged-in player's name
		$"Label".text = SilentWolf.Auth.logged_in_player
	else:
		# Set a default text if no player is logged in
		$"Label".text = "Not logged in"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_pressed():
	# Get the player's name from the label
	var player_name = $"Label".text
	
	# Get the score from the LineEdit node
	var score_text = $"LineEdit".text
	
	# Convert the score to an integer
	var score = int(score_text)
	
	# Save the score to SilentWolf backend
	var sw_result: Dictionary = await SilentWolf.Scores.save_score(player_name, score).sw_save_score_complete
	
	# Check if the score is saved successfully
	if sw_result.success:
		print("Score persisted successfully: " + str(sw_result.score_id))
	else:
		print("Failed to save score: " + str(sw_result.error))
