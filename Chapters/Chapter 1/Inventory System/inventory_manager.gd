extends Node

static var inventory: Node = null
@onready var Inventory: GridContainer = $Inventory


func _ready() -> void:
	InventoryManager.register_inventory(Inventory)

static func register_inventory(inventory_node: Node):
	inventory = inventory_node
	

	
func add_item(item_id: String):
	if inventory:
		inventory.add_item(item_id)
	else:
		print("No inventory connected")
	
