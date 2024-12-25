extends Node

var content : Dictionary

func _ready():
	var file = FileAccess.open("res://Autoload/database.json", FileAccess.READ)
	
	content = JSON.parse_string(file.get_as_text())
	
	file.close()
	

func get_texture(ID = "0"):
	return content[ID]["texture"]
	
func get_STS(ID = "0"):
	return content[ID]["STS"]

func get_slot_type(ID = "0"):
	return content[ID]["slot_type"]
	
