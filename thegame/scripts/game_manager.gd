extends Node

# !!! Singleton

# ---------------- EVENTS
# warning-ignore:unused_signal
signal stop_time(toogle)
# warning-ignore:unused_signal
signal speed_up(toogle)
# warning-ignore:unused_signal
signal stop_action()
# warning-ignore:unused_signal
signal kill()

# ---------------- player vars
var gravity: float = 100.0
var stop_time: float = 1.0
var speed_up: float = 1.0
var spped_up_factor: float = 0.5
var life: int = 1

# --------------- other vars
var rng : RandomNumberGenerator = null

# ---------------- functions
func _ready():
	# warning-ignore:return_value_discarded
	GameManager.connect("stop_action", self, "_on_stop_action")
	
func _enter_tree():
	rng = RandomNumberGenerator.new()
	rng.seed = OS.get_unix_time()
	rng.randomize()

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

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("stop_time"):
		emit_signal("stop_time", true)
	if event.is_action_released("stop_time"):
		emit_signal("stop_time", false)
	if event.is_action_pressed("speed_up"):
		emit_signal("speed_up", true)
	if event.is_action_released("speed_up"):
		emit_signal("speed_up", false)

func _on_stop_action():
	emit_signal("stop_time", false)
	emit_signal("speed_up", false)
