extends Node


@onready var scroll_container: ScrollContainer = %ScrollContainer
@onready var object_container: HBoxContainer = %ObjectContainer

var targetScroll = 0

func _ready() -> void:
	_set_selection()
	var game_manager = %GameManager
	game_manager.connect("clues_collected", _on_clue_collected)

func _set_selection():
	await get_tree().create_timer(0.01).timeout
	_select_deselect_highlight()

func _on_clue_collected(index: int):
	var clue_texture = object_container.get_children()[index]
	if clue_texture and clue_texture is TextureRect:
		clue_texture.visible = true
		
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
