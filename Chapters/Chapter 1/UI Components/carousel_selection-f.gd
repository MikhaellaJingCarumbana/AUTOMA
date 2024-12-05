extends Control

@onready var scroll_container: ScrollContainer = %ScrollContainer
@onready var object_container: HBoxContainer = %ObjectContainer
@onready var clue_description: Label = $"PanelContainer/MarginContainer/VBoxContainer/Clue Description"

@export var clues: Array[TextureRect]

var targetScroll = 0

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	for object in object_container.get_children():
		if object is TextureRect:
			object.visible = false
			
func show_clue(index: int):
	print("Show clue called with index:", index)
	var texture_recs = object_container.get_children()
	var texture_rect_found = false
	
	for child in texture_recs:
		if child is TextureRect:
			texture_rect_found = true
			if index == 1:
				print("Revealing clue:", child.name)
				child.visible = true
				return
			index -= 1
		else:
			print("Skipped non-TextureRect:", child.name)
			
	if not texture_rect_found:
		print("Error: No TextureRects found in object_container")
	else:
		print("Error: Could not find texturerect for the given index:", index)
	
			
			
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
