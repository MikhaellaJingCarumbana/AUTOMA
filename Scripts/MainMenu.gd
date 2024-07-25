extends Control

@onready var start_button = $VBoxContainer/Start
@onready var exit_button = $VBoxContainer/Exit
@onready var world_scene = preload("res://Scenes/world.tscn")
@onready var practice_questions = preload("res://Scenes/PracticeQuestionNew.tscn")




# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_exit_pressed():
		SilentWolf.Auth.logout_player()
		get_tree().quit()


func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/AutomaScene.tscn")



func _on_pratice_pressed():
	get_tree().change_scene_to_packed(world_scene)


func _on_leaderboard_pressed():
	get_tree().change_scene_to_file("res://Scenes/Leaderboard.tscn")


func _on_practice_pressed():
	get_tree().change_scene_to_packed(practice_questions)
