extends Node

static var inventory: Node = null


static func register_inventory(inventory_node: Node):
	inventory = inventory_node
	

	
func add_item(item_id: String):
	if inventory:
		inventory.add_item(item_id)
	else:
		print("No inventory connected")
	
