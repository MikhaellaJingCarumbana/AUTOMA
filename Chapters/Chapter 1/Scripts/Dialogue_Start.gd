extends Node

@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@export var timeline_file: String = ""
var has_played: bool = false
var is_time_line_running: bool = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player entered area!")
		Dialogic.start(timeline_file)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player") and has_played:
		print("Player exited area")
		Dialogic.end_timeline()
		queue_free()
