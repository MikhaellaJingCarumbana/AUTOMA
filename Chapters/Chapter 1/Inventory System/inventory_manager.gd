extends Node

static var inventory: Node = null


static func register_inventory(inventory_node: Node):
	inventory = inventory_node
	

	
static func add_item(item_id: String):
	var item_scene = load("res://Chapters/Chapter 1/Inventory System/Collectible/Crystal.tscn")
	var instance = item_scene.instantiate()
	
	instance.get_node("AnimatedSprite2D").play("Default")
	
	if inventory:
		inventory.add_to_slot(instance)
	else:
		print("No inventory connected")
