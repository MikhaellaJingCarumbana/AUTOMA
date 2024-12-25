extends GridContainer


func _ready() -> void:
	add_item()

func add_item(ID = "0"):
	var item_texture = load("res://Art/Database png/" + ItemData.get_texture(ID))
	var item_slot_type = ItemData.get_slot_type(ID)
	var item_STS = ItemData.get_STS(ID)
	
	var item_data = { "TEXTURE" : item_texture,
					"STS" : item_STS,
					"SLOT_TYPE" : item_slot_type}

	get_child(0).set_property(item_data)
