extends Node
class_name StateMachine

var state = null setget set_state
var previous_state = null
var states = {}

onready var parent = get_parent()

func _physics_process(delta):
	if state == null:
		return
	
	_state_logic(delta)
	var transition = _get_transition(delta)
	if transition != null:
		set_state(transition)

func _state_logic(_delta):
	pass

func _get_transition(_delta):
	pass

func _enter_state(_to_state, _from_state):
	pass

func _exit_state(_from_state, _to_state):
	pass

func set_state(to_state):
	previous_state = state
	state = to_state

	if previous_state != null:
		_exit_state(previous_state, state)
	if to_state != null:
		_enter_state(state, previous_state)

func add_state(state_name):
	states[state_name] = states.size()
