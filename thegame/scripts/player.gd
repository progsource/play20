extends KinematicBody2D

var max_speed = GameManager.gravity

var _speed = 0
var _collision_normal = Vector2.ZERO
var _last_input_direction = Vector2.ZERO
var _velocity = Vector2.ZERO
var _deadly_groups = ["spikes", "laser"]

func _ready():
	yield(get_tree(), "idle_frame")

func _move(_delta):
	var _slide = move_and_slide(_velocity)
	GameManager.player_pos_y = position.y
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if _has_deadly_collision(collision):
			_kill()

	# in case there was no slide, we still want to check for collisions
	var collision_test = move_and_collide(Vector2(0, -4), true, true, true)
	if _has_deadly_collision(collision_test):
		_kill()

	position = GameManager.clamp_to_screen(position)


func _has_deadly_collision(var collision) -> bool :
	for deadly in _deadly_groups:
		if collision and collision.collider.is_in_group(deadly):
			return true
	return false

func _kill() -> void :
	GameManager.emit_signal("prekill")
	GameManager.emit_signal("kill")
	queue_free()
