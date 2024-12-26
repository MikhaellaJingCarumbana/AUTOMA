extends Node

signal item_added(item_id)

var inventory_node: Node = null

func register_inventory(inventory: Node) -> void:
	inventory_node = inventory
	
func add_item(id: String) -> void:
	if inventory_node:
		inventory_node.add_item(id)
	else:
		print("No inventory registered!")
