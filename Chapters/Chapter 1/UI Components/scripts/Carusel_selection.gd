extends Node


@onready var scroll_container: ScrollContainer = %ScrollContainer
@onready var object_container: HBoxContainer = %ObjectContainer

var targetScroll = 0

func _on_previous_pressed() -> void:
	var scrollValue = targetScroll - _get_space_between()
	
	await _tween_scroll(scrollValue)


func _on_next_pressed() -> void:
	var scrollValue = targetScroll + _get_space_between()
	
	await _tween_scroll(scrollValue)
	
func _get_space_between():
	var distanceSize = object_container.get_theme_constant("separation")
	var objectSize = object_container.get_children()[1].size.x
	
	return distanceSize + objectSize
	
func _tween_scroll(ScrollValue):
	targetScroll = ScrollValue
	
	var tween = get_tree().create_tween()
	tween.tween_property(scroll_container, "scroll_horizontal", ScrollValue, 0.25)
	await tween.finished
	
func _select_deselect_highlight():
	var selectedNode = get_selected_value()
	
	for object in object_container.get_children():
		if object is not TextureRect: continue
		
		if object == selectedNode: object.modulate = Color(1,1,1)
		else: object.modulate = Color(0,0,0)
	
func get_selected_value():
	var selectedPosition = %SelectionMarker.global_position
	
	for object in object_container.get_children():
		if object.get_global_rect().has_point(selectedPosition):
			return object
