extends Node2D


@export var group_name: String

var positions : Array
var temp_positions : Array
var current_position : Marker2D

var direction : Vector2 = Vector2.ZERO

func _ready():
	positions = get_tree().get_nodes_in_group(group_name)
	
func _physics_process(delta):
	pass
	
func _get_position():
	temp_positions = positions.duplicate()
	temp_positions.shuffle()
	
func _get_next_position():
	if temp_positions.is_empty():
		_get_position()
	current_position = temp_positions.pop_front()
	direction = to_local(current_position.position).normalized()
	
