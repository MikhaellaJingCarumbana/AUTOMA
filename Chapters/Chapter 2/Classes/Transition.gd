extends Node
class_name Transition

@export var from: StateNode
@export var to: StateNode
var alphabet: Array[String]

func has(letter: String):
    return alphabet.any(func(s): return s == letter)

func _init(fromState, toState, value):
    from = fromState
    to = toState
    alphabet = value

#HelperMethods
func _ready():
    pass

func _process(delta):
    pass
