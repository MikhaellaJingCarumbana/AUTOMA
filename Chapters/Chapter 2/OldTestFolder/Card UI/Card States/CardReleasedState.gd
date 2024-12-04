extends CardState

var played: bool
var statecard: bool


func enter() -> void:
    #card_ui.cardstatelabel.text = "1"
    card_ui.panel.set("theme_override_styles/panel", card_ui.BASE_STYLEBOX)
    var nonstate:= card_ui.card.is_nonstate_card()
    if nonstate != null:
        card_ui.card.set_state_card()
        print("card type is ", card_ui.card.type)
    
    played = false
    statecard = card_ui.card.is_state_card()
    if not card_ui.targets.is_empty():
        played = true
        print("play card for target(s)", card_ui.targets)


func on_input(event: InputEvent) -> void:
    var select = event.is_action_pressed("left_mouse")
    var remove = event.is_action_pressed("right_mouse")
    if played:
        if select: 
            var mouse_motion := event is InputEventMouseMotion
            var place = event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse")
            if mouse_motion:
                card_ui.global_position = card_ui.get_global_mouse_position() - card_ui.pivot_offset
            if place:
                if statecard:
                    transition_requested.emit(self, CardState.Phase.PLAYING)
        if remove:
            transition_requested.emit(self, CardState.Phase.BASE)
            played = false
        else:
            return
        
        
    
    transition_requested.emit(self, CardState.Phase.BASE)
