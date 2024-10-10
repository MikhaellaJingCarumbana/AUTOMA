extends Node
class_name FSMData

var states : Array
var initialState : State
var acceptingStates: Array
var transitions : Array
var letters: PackedStringArray

#Methods
func check_initial_state():
	pass #make sure only 1 initial state

func add_state(state:State):
	pass # Replace with function body.

func delete_state(state:State):
	#check if there is existing from or to transition
	#if naa call _delete_transition for that transition
	#proceed to state deletion
	pass #replace with function body.

func add_transition(from:State, to:State, value:String):
	pass #replace with function body.

func delete_transition(transition:Transition):
	pass #replace with function body.

func add_alphabet(value:String):
	pass #replace with function body.

func delete_alphabet(value:String):
	#check if alhpabet is used in transtions
	# if so delete all instances of transitions using alphabet
	#delete alphabet
	pass

func get_incoming(state:State):
	#gets all transitions that the to = state
	pass

func get_outgoing(state:State):
	#gets all transitions that the from = state
	pass

func check_if_string_IsValid():
	return false


#toCheck if ma call ang states:Array with helper method etc.
