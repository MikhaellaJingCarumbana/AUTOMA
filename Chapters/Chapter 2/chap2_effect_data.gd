class_name Chap2EffectUIData extends CardUIData


@export var type : String
@export var description : String
@export var state : String
@export var effect: String

func format_description():
    return description

func get_state() -> String:
    return state

func set_state(new_state: String) -> void:
    state = new_state

func get_effect() -> String:
    return effect

func set_effect(new_effect: String) -> void:
    effect = new_effect
