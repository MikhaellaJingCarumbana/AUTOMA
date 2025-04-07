extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var animation_finished: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    animation_player.play("draw card animation")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
    if anim_name == "draw card animation":
        animation_finished = true


func _on_chapter_button_pressed() -> void:
    get_tree().change_scene_to_file("res://Chapters/Chapter 1/Cutscene/Intro cutscene and Menu.tscn")
    

func _on_chapter_button_2_pressed() -> void:
    get_tree().change_scene_to_file("res://Chapters/Chapter 2/chapter2_cutscene.tscn")


func _on_chapter_button_3_pressed() -> void:
    get_tree().change_scene_to_file("res://Chapters/Chapter 3/Conversion-Maps/introduction.tscn")
