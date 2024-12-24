extends "res://Chapters/Chapter 1/Inventory System/slot.gd"
class_name PassiveSlot


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is TextureRect and data.slot_type == slot_type
