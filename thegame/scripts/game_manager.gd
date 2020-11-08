extends Node

# !!! Singleton

# ---------------- EVENTS
# warning-ignore:unused_signal
signal stop_time(toogle)
# warning-ignore:unused_signal
signal speed_up(toogle)
# warning-ignore:unused_signal
signal action_toogle(toogle)
# warning-ignore:unused_signal
signal action_triggered(toogle)
# warning-ignore:unused_signal
signal prekill()
# warning-ignore:unused_signal
signal kill()

# ---------------- player vars
var gravity: float = 50.0
var stop_time: float = 1.0
var speed_up: float = 1.0
var speed_up_factor: float = 1
var life: int = 1
var player_pos_y : float = 0.0
var best_fall : float = 0.0

# --------------- other vars
var rng : RandomNumberGenerator = null
var can_use_action : bool = true

# ---------------- functions
func _ready():
	# warning-ignore:return_value_discarded
	GameManager.connect("action_toogle", self, "_on_action_toogle")
	
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
		Vector2.ZERO.y
	).normalized()

func _unhandled_input(event: InputEvent):
	var _stop_time = event.is_action_pressed("stop_time", true)
	var _speed_up = event.is_action_pressed("speed_up", true)

	if can_use_action:
		if _stop_time or _speed_up:
			emit_signal("action_triggered", true)
		else:
			emit_signal("action_triggered", false)
		emit_signal("stop_time", _stop_time)
		emit_signal("speed_up", _speed_up)
		return

	emit_signal("action_triggered", false)
	emit_signal("stop_time", false)
	emit_signal("speed_up", false)

func _on_action_toogle(toogle):
	can_use_action = toogle
