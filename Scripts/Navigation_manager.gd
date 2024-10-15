extends Node


const scene_beginner = preload("res://Chapters/Chapter 1/Regex - Map/Beginner.tscn")
const scene_intermediate = preload("res://Chapters/Chapter 1/Regex - Map/Intermediate.tscn")

var spawn_door_tag

func go_to_level(level_tag, destination_tag):
	var scene_to_load
	
	match level_tag:
		"Beginner":
			scene_to_load = scene_beginner
		"Intermediate":
			scene_to_load =scene_intermediate
			
	if scene_to_load != null:
		spawn_door_tag = destination_tag
		get_tree().change_scene_to_file(scene_to_load)
