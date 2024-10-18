extends CardState

func enter() -> void:
	card_ui.cardstatelabel.text = "P"

func on_input(event: InputEvent) -> void:
	#var mouse_motion := event is InputEventMouseMotion
	#var place = event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse")
	
	#if mouse_motion:
		#card_ui.global_position = card_ui.get_global_mouse_position() - card_ui.pivot_offset
	#if place:
	return
