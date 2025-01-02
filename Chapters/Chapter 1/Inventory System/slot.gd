extends PanelContainer
class_name Slot

@onready var texture_rect: TextureRect = $TextureRect
@onready var container: Container = $Container



@export_enum("NONE: 0", "HEAD:1", "BODY:2", "LEG:3", "ACTIVE:4") var slot_type: int

var filled: bool = false 
var sts: int = 0

signal filled_changed


func _set_filled(value: bool) -> void:
	filled = value
	emit_signal("filled_changed")

func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview(get_preview())
	
	return texture_rect
	
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is TextureRect
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	var temp = texture_rect.property
	texture_rect.property = data.property
	data.property = temp
	
	if texture_rect.property and texture_rect.property.has("STS"):
		sts = texture_rect.property["STS"]
	else:
		sts = 0
		
		
	_set_filled(texture_rect.property != null)

func get_preview():
	var preview_texture = TextureRect.new()
	
	preview_texture.texture = texture_rect.texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(30, 30)
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	
	return preview

func get_STS() -> int:
	return sts
	
func set_property(data):
	texture_rect.property = data
	
	if data["TEXTURE"] == null:
		_set_filled(false)
	else:
		_set_filled(true)

func set_animated_sprite(animated_sprite: Node):
	container.add_child(animated_sprite)
	filled = true
