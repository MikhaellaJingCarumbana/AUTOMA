extends Sprite2D


@export var ID = "0"

func _ready() -> void:
	texture = load("res://Art/Database png/" + ItemData.get_texture(ID))


func _on_body_entered(area: Area2D) -> void:
	var inventory = get_tree().root.get_node("UI/TestScene/UI/Inventory")
	
