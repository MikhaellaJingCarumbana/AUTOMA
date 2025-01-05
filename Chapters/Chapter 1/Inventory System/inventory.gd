extends GridContainer



func _ready() -> void:
	InventoryManager.register_inventory(self)
	
	
	
	
func add_item(ID = "0"):
	var item_texture = load("res://Art/Database png/" + ItemData.get_texture(ID))
	var item_slot_type = ItemData.get_slot_type(ID)
	var item_STS = ItemData.get_STS(ID)
	
	var item_data = { "TEXTURE" : item_texture,
					"STS" : item_STS,
					"SLOT_TYPE" : item_slot_type}
	
	var index = 0
	for i in get_children():
		if i.filled == false:
			index = i.get_index()
			break
	get_child(index).set_property(item_data)
	
func add_to_slot(animated_sprite_instance: Node):
	for slot in get_children():
		if not slot.filled:
			slot.set_animated_sprite(animated_sprite_instance)
			break
			

	#Streaksaver again ahahaha
