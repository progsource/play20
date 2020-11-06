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
	
	position = GameManager.clamp_to_screen(position)
