extends KinematicBody2D

var max_speed = GameManager.gravity

var _speed = 0
var _collision_normal = Vector2.ZERO
var _last_input_direction = Vector2.ZERO
var _velocity = Vector2.ZERO

func _ready():
	yield(get_tree(), "idle_frame")

func _move(_delta):
	var _slide = move_and_slide(_velocity)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group("spikes"):
			GameManager.emit_signal("kill")
			queue_free()
	
	position = GameManager.clamp_to_screen(position)
