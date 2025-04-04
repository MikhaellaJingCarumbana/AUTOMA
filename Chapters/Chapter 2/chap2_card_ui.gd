class_name Chap2CardUI extends CardUI


# these are custom variables they will be set with data from *collection.json
@export var type : String
@export var description : String
@export var nice_name: String

@onready var type_label = $Frontface/TypeLabel

func _ready():
	super()
	card_data.connect("card_data_updated", _update_display)
	_update_display()

	
func _update_display():
	type_label.text = "%s" % card_data.type

 
