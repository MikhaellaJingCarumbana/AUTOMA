extends GridContainer

@export var target_weight: int
@onready var label: Label = $"../Label"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for slot in get_children():
		slot.connect("filled_changed", _on_slot_changed)


func _on_slot_changed() -> void:
	check_total_sts()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func check_total_sts() -> void:
	var total_sts = 0
	for slot in get_children():
		if slot.filled:
			total_sts += slot.get_STS()
			
	if total_sts == target_weight:
		label.text = "correct!"
	else:
		label.text = "Wrong" 
	
