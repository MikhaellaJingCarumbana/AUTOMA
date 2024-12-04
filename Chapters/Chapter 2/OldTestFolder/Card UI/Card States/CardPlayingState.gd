extends CardState

#const MOUSE_Y_SNAPBACK_THRESHOLD := 138

func enter() -> void:
    card_ui.targets.clear()
    var offset := Vector2(card_ui.parent.size.x / 2, -card_ui.size.y / 2)
    offset.x -= card_ui.size.x
    card_ui.drop_point_detector.monitoring = false
    CardEvents.card_aim_started.emit(card_ui)

func exit() -> void:
    CardEvents.card_aim_ended.emit(card_ui)

func on_input(event: InputEvent) -> void:
    var mouse_motion := event is InputEventMouseMotion
    #var mouse_at_bottom := card_ui.get_global_mouse_position().y > MOUSE_Y_SNAPBACK_THRESHOLD
    
    #if mouse_motion:
        #transition_requested.emit(self, CardState.Phase.RELEASED)
    if event.is_action_pressed("right_mouse"):
        transition_requested.emit(self, CardState.Phase.BASE)
    elif event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse"):
        get_viewport().set_input_as_handled()
        
        #transition_requested.emit(self, CardState.Phase.RELEASED)
    #var place = event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse")
    
    #if mouse_motion:
        #card_ui.global_position = card_ui.get_global_mouse_position() - card_ui.pivot_offset
    #if place:
    return
