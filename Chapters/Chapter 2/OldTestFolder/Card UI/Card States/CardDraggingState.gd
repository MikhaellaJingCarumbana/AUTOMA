extends CardState

func enter() -> void:
    #var statecard := card_ui.card.is_state_card()
    var ui_layer = get_tree().get_first_node_in_group("ui_layer")
    if ui_layer:
        card_ui.reparent(ui_layer)
        
    card_ui.panel.set("theme_override_styles/panel", card_ui.DRAG_STYLEBOX)

func on_input(event: InputEvent) -> void:
    var mouse_motion := event is InputEventMouseMotion
    var cancel = event.is_action_pressed("right_mouse")
    var confirm = event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse")
    
    if mouse_motion:
        card_ui.global_position = card_ui.get_global_mouse_position() - card_ui.pivot_offset
    if card_ui.mouse_entered:
        if cancel:
            transition_requested.emit(self, CardState.Phase.BASE)
        elif confirm:
            get_viewport().set_input_as_handled()
            transition_requested.emit(self, CardState.Phase.RELEASED)
