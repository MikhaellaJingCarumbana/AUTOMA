extends Control

@onready var scroll_container: ScrollContainer = %ScrollContainer
@onready var object_container: HBoxContainer = %ObjectContainer

var targetScroll = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_selection()
	
func _set_selection():
	await get_tree().create_timer(0.01).timeout
	_select_deselect_highlight()
		
func _on_previous_pressed() -> void:
	var scrollValue = targetScroll - _get_space_between()
	
	await _tween_scroll(scrollValue)
	
	_select_deselect_highlight()


func _on_next_pressed() -> void:
	var scrollValue = targetScroll + _get_space_between()
	
	await _tween_scroll(scrollValue)
	
	_select_deselect_highlight()
	
func _get_space_between():
	var distanceSize = object_container.get_theme_constant("separation")
	var objectSize = object_container.get_children()[1].size.x
	
	return distanceSize + objectSize
	
func _tween_scroll(scrollValue):
	targetScroll = scrollValue
	
	var tween = get_tree().create_tween()
	tween.tween_property(scroll_container, "scroll_horizontal", scrollValue, 0.25)
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