extends CardState

var played: bool

func enter() -> void:
	card_ui.cardstatelabel.text = "R"
	
	played = false
	
	if not card_ui.targets.is_empty():
		played = true
		print("play card for target(s)", card_ui.targets)


func on_input(_event: InputEvent) -> void:
	if played:
		return
	
	transition_requested.emit(self, CardState.Phase.BASE)