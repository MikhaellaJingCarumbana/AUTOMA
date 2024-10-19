extends Node


var gameStarted : bool

var playerBody : CharacterBody2D
var playerWeaponEquip : bool
var playerAlive: bool
var playerDamageZone : Area2D
var playerDamageAmount : int

var setDamageZone : Area2D
var setDamageAmount : int
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
		"redirect_to_practice" : "res://Scenes/Pratice.tscn",
#		"email_confirmation_scene": "res://addons/silent_wolf/Auth/ConfirmEmail.tscn", # comment if email confirmation not enabled
		"reset_password_scene": "res://addons/silent_wolf/Auth/ResetPassword.tscn",
		"session_duration_seconds": 0,
		"saved_session_expiration_days": 30
	})
	
var active_line: Line2D = null
var active_line2: Line2D = null
var start_button: Button = null
var start_button2: Button = null
var end_button: Button = null

func set_active_line(line: Line2D):
	active_line = line
	active_line2 = line

func clear_active_line():
	active_line = null
	active_line2 = null
	start_button = null
	end_button = null

func get_active_line2() -> Line2D:
	return active_line2 
	
func get_active_line() -> Line2D:
	return active_line

func set_start_button(button: Button):
	start_button = button
	
func set_start_button2(button: Button):
	start_button2 = button

func set_end_button(button: Button):
	end_button = button

func get_start_button() -> Button:
	return start_button

func get_start_button2() -> Button:
	return start_button2
	
func get_end_button() -> Button:
	return end_button
