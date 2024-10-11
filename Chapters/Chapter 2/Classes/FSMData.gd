extends Node
class_name FSMData

var states : Array[State] = []
var initialState : State
var acceptingStates: Array[State] = []
var transitions : Array[Transition]
var newTransition : Transition
var alphabet: Array[String] = ['a','b']


#Methods
func set_initial_state(state:State):
	if states.find(state) == -1:
		print('Error setting initial state: State does not exist')
		return
	if check_initial_state() != null:
		print('Error setting initial state: There can only be one initial state')
		return
	initialState = state

func check_initial_state():
	if initialState != null:
		if states.find(initialState) != -1:
			return initialState
		else:
			print('Initial state does not exist in the states array. Setting initial state to null.')
			initialState = null
			return null
		
	else:
		print('No initial state has been set yet')
		return null

func add_accepting_state(state:State):
	if states.find(state) == -1:
		print('Error adding accepting state: State does not exist')
		return
	if acceptingStates.find(state) != -1:
		print('Error adding accepting state: State is already an accepting state')
		return
	acceptingStates.append(state)

func remove_accepting_state(state:State):
	if acceptingStates.find(state) == -1:
		print('Error removing accepting state: State is not an accepting state')
		return
	acceptingStates.erase(state)


func add_state(state:State):
	if states.find(state) != -1:
		print('Error adding state: State already exist')
		return
	else:
		states.append(state)


func delete_state(state:State):
	var transitions_to_delete = []
	if states.find(state) == -1:
		print('Error deleting state: State does not exist')
		return
	for transition in transitions:
		if transition.from == state or transition.to == state:
			transitions_to_delete.append(transition)
	
	for transition in transitions_to_delete:
		delete_transition(transition)
	states.erase(state)


func add_transition(from:State, to:State, value:Array[String]):
	for transition in transitions:
		if transition.from == from and transition.to == to and transition.value == value:
			print('Error adding transition: Transition already exist')
			return
	newTransition = Transition.new(from, to, value)
	transitions.append(newTransition)


func delete_transition(transition:Transition):
	if transitions.find(transition) == -1:
		print('Error deleting transition: transition does not exist')
		return
	transitions.erase(transition)


func add_letter(value:String):
	if alphabet.find(value) != -1:
		print('Error adding letter: letter already exist in alphabet')
		return
	else:
		alphabet.append(value)

func delete_letter(value:String):
	var transitions_to_delete = []
	if alphabet.find(value) == -1:
		print('Error deleting letter: letter does not exist in alphabet')
		return
	for transition in transitions:
		if value in transition.alphabet:
			transition.alphabet.erase(value)
			if transition.alphabet.size() == 0:
				transitions_to_delete.append(transition)
	
	for transition in transitions_to_delete:
		delete_transition(transition)
		
	alphabet.erase(value)


func get_incoming(state:State):
	var inTransitions : Array[Transition]
	for transition in transitions:
		if transition.to == state:
			inTransitions.append(transition)
	return inTransitions


func get_outgoing(state:State):
	var outTransitions : Array[Transition]
	for transition in transitions:
		if transition.from == state:
			outTransitions.append(transition)
	return outTransitions


func check_if_string_IsValid():
	return false



#Checking

func test_print():
	print("States:")
	for state in states:
		print("State: ", state.label)
	
	print("\nTransitions:")
	for transition in transitions:
		print("From: ", transition.from.label, " -> To: ", transition.to.label, " with Alphabet: ", transition.alphabet)

func print_transitions(state: State):
	var incoming = get_incoming(state)
	var outgoing = get_outgoing(state)
	print("Transitions for State: ", state.label)
	print("\nIncoming Transitions:")
	if incoming.size() == 0:
		print("  No incoming transitions.")
	else:
		for transition in incoming:
			print("  From: ", transition.from.label, " -> To: ", transition.to.label, " with Alphabet: ", transition.alphabet)
	print("\nOutgoing Transitions:")
	if outgoing.size() == 0:
		print("  No outgoing transitions.")
	else:
		for transition in outgoing:
			print("  From: ", transition.from.label, " -> To: ", transition.to.label, " with Alphabet: ", transition.alphabet)


func print_initial_state():
	var initial_state_result = check_initial_state()  # Call to check_initial_state
	if initial_state_result != null:
		print("Initial State is:", initial_state_result.label)
	else:
		print("Initial State is set to null.")


func _ready():
	var sampleState: State
	var sampleState2: State
	sampleState = State.new('Test1')
	sampleState2 = State.new('Test2')
	add_state(sampleState)
	add_state(sampleState2)
	
	add_transition(sampleState, sampleState2, ['a'])
	add_transition(sampleState, sampleState, ['b'])
	add_transition(sampleState2, sampleState2, ['a', 'b'])
	
	test_print()
	
	set_initial_state(sampleState)
	
	print_initial_state()
	
	add_accepting_state(sampleState2)
	
	delete_state(sampleState)
	
	print_initial_state()
	
	test_print()


#toCheck if ma call ang states:Array with helper method etc.
