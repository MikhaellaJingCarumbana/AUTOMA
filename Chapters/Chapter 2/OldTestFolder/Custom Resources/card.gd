class_name Card
extends Resource

enum Type {NONSTATE, STATE, STARTSTATE, ENDSTATE}
enum Target {}

@export_group("Card_Attributes")
@export var id: String
@export var type: Type
@export var target: Target

func is_state_card() -> bool:
    return type == Type.STATE

func set_state_card() -> void:
    type = Type.STATE

func set_nonstate_card() -> void:
    type = Type.NONSTATE

func is_nonstate_card() -> bool:
    return type == Type.NONSTATE
