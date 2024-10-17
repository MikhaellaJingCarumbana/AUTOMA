extends Node


const scene_beginner = preload("res://Chapters/Chapter 1/Regex - Map/Beginner.tscn")
const scene_intermediate = preload("res://Chapters/Chapter 1/Regex - Map/Intermediate.tscn")
const scene_advance = preload("res://Chapters/Chapter 1/Regex - Map/Advance.tscn")


signal on_triggr_player_spawn

var spawn_door_tag

func go_to_level(level_tag, destination_tag):
	var scene_to_load
	
	match level_tag:
		"Beginner":
			scene_to_load = scene_beginner
		"Intermediate":
			scene_to_load =scene_intermediate
		"Advance":
			scene_to_load = scene_advance
			
	if scene_to_load != null:
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		spawn_door_tag = destination_tag
		get_tree().change_scene_to_packed(scene_to_load)
func trigger_player_spawn(position: Vector2, direction: String):
	on_triggr_player_spawn.emit(position, direction)
