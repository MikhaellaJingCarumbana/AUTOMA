extends TextureRect

@export var slot_type: int = 0

@export var STS = 0:
	set(value):
		STS = value
		%debug.text = str(STS)
		
		if get_parent() is PassiveSlot:
			get_parent().get_parent().calculate()
		
@onready var property: Dictionary = { "TEXTURE": texture, 
									"STS": STS,
									"SLOT_TYPE": slot_type}:
	set(value):
		property = value
		
		if "TEXTURE" in property:
			texture = property["TEXTURE"]
		if "STS" in property:
			STS = property["STS"]
		if "SLOT_TYPE" in property:
			slot_type = property["SLOT_TYPE"]
