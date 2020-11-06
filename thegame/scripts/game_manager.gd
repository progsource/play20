extends Node

# !!! Singleton

# ---------------- EVENTS
# warning-ignore:unused_signal
signal stop_time()
# warning-ignore:unused_signal
signal speed_up()
# warning-ignore:unused_signal
signal kill()

# ---------------- player vars
var gravity: float = 100.0
var stop_time: float = 1.0
var speed_up: float = 1.0
var spped_up_factor: float = 0.5
var life: int = 1

# ---------------- functions
func clamp_to_screen(position: Vector2) -> Vector2:
	var clamped_position = Vector2.ZERO
	var screen_size := get_viewport().get_visible_rect().size

	clamped_position.x = clamp(position.x, 0, screen_size.x)
	clamped_position.y = clamp(position.y, 0, screen_size.y)

	return clamped_position

static func get_input_direction(event=Input) -> Vector2:
	return Vector2(
		float(event.get_action_strength("move_right")) -
		float(event.get_action_strength("move_left")),
		Vector2.DOWN.y
	).normalized()
