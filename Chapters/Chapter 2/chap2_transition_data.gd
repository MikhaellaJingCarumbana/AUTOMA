class_name Chap2TransitionUIData extends CardUIData


@export var type : String
@export var description : String
@export var transition_type : String
@export var from_state : String
@export var to_state: String

func format_description():
    return description

func get_from_state() -> String:
     return from_state
        
func set_from_state(new_state: String) -> void:
    from_state = new_state

func get_to_state() -> String:
    return to_state

func set_to_state(new_state: String) -> void:
    to_state = new_state
