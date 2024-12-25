extends Sprite2D


@export var ID = "0"

func _ready() -> void:
	texture = load("res://Art/Database png/" + ItemData.get_texture(ID))


func _on_body_entered(area: Area2D) -> void:
	get_parent().find_child("Inventory").add_item(ID)
	queue_free()
