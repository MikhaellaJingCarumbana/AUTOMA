class_name Chap2TransitionUIData extends CardUIData


@export var type : String
@export var description : String
@export var from_state : String
@export var to_state: String

func format_description():
    return description
