extends Sprite2D


@export var ID = "0"
@export var player_collision_layer: int = 2
@onready var game_manager: Node = get_parent().get_parent().get_node("GameManager")


func _ready() -> void:
	texture = load("res://Art/Database png/" + ItemData.get_texture(ID))
	print("AbstractItem ready: ", name)
	
	var area = $Area2D
	if area:
		area.set_collision_layer_value(0, true)
		area.set_collision_mask_value(0, true)
		print("Area2D collision mask set to: ", player_collision_layer)

func _on_body_entered(body) -> void:
	print("Collision detected with: ", body.name)
	
	if body.is_in_group("Player"):
		print("Player collision detected - adding item to inventory")
		InventoryManager.add_item(ID)
		queue_free()
		print("Item collected and freed!")
