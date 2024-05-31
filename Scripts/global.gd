extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	SilentWolf.configure({
		"api_key": "Snwr2p5iWq2KxOa5qZgdm8uXTjoCazvw6EaQeDbv",
		"game_id": "automa",
		"log_level": 1
	})

	SilentWolf.configure_scores({
		"open_scene_on_close": "res://Scenes/world.tscn"
	})
	
	SilentWolf.configure_auth({
		"redirect_to_scene": "res://Scenes/world.tscn",
		"redirect_to_login": "res://Scenes/LoginNew.tscn",
		"login_scene": "res://Scenes/LoginNew.tscn",
		"redirect_to_register": "res://Scenes/Register.tscn",
		"redirect_to_menu": "res://Scenes/MainMenu.tscn",
#		"email_confirmation_scene": "res://addons/silent_wolf/Auth/ConfirmEmail.tscn", # comment if email confirmation not enabled
		"reset_password_scene": "res://addons/silent_wolf/Auth/ResetPassword.tscn",
		"session_duration_seconds": 0,
		"saved_session_expiration_days": 30
	})
