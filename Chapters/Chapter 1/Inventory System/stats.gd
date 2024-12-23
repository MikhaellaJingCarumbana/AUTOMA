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
		
		texture = property["TEXTURE"]
		STS = property["STS"]
		slot_type = property["SLOT_TYPE"]
