extends CardState

func enter() -> void:
	card_ui.cardstatelabel.text = "N"
	card_ui.drop_point_detector.monitoring = true

func on_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		transition_requested.emit(self, CardState.Phase.DRAGGING)
