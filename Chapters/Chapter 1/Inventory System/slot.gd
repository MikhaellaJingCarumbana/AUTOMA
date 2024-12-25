extends PanelContainer
class_name Slot

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export_enum("NONE: 0", "HEAD:1", "BODY:2", "LEG:3", "ACTIVE:4") var slot_type: int

var filled: bool = false


func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview(get_preview())
	
	return animated_sprite_2d
	
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is AnimatedSprite2D
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	var temp = animated_sprite_2d.property
	animated_sprite_2d.property = data.property
	data.property = temp

func get_preview():
	var preview_texture = animated_sprite_2d.new()
	
	preview_texture.texture = animated_sprite_2d.texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(30, 30)
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	
	return preview

func get_STS():
	return animated_sprite_2d.STS
	
func set_property(data):
	animated_sprite_2d.property = data
	
	if data["TEXTURE"] == null:
		filled = false
	else:
		filled = true
