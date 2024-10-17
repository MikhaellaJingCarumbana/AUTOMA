class_name Card
extends Resource

enum Type {NONSTATE, STATE, STARTSTATE, ENDSTATE}
enum Target {}

@export_group("Card_Attributes")
@export var id: String
@export var type: Type
@export var target: Target
