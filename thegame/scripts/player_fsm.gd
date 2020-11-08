extends "res://scripts/state_machine.gd"

func _ready():
	add_state("idle")
	add_state("fall")
	add_state("move")
	call_deferred("set_state", states.idle)

func _state_logic(delta):
	var slide_count = parent.get_slide_count()
	parent._collision_normal = parent.get_slide_collision(slide_count - 1).normal if slide_count > 0 else parent._collision_normal
	
	var input = get_raw_input()
	
	match state:
		states.idle:
			parent._velocity = Vector2.ZERO
			parent._speed = 0
		states.fall:
			parent._speed = parent.max_speed
			parent._velocity = Vector2.ZERO * parent._speed
		states.move:
			parent._last_input_direction = input.direction if input.direction != Vector2.ZERO else parent._last_input_direction
			parent._speed = parent.max_speed
			parent._velocity = input.direction * parent._speed
	
	parent._move(delta)

func _get_transition(_delta):
	var input = get_raw_input()
	var event = decode_raw_input(input)

	return event

func _enter_state(_to_state, _from_state):
	pass

func _exit_state(_from_state, _to_state):
	pass

func decode_raw_input(input):
	var event = states.fall
			
	if input.direction != Vector2.ZERO:
		event = states.move

	return event

static func get_raw_input():
	return {
		direction = GameManager.get_input_direction()
	}
