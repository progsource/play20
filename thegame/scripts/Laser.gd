extends KinematicBody2D

var id : int = -1
var speed = 20
var lasergun = null
var is_left = true


func _ready():
	add_to_group("laser")


func _physics_process(delta):
	if not lasergun.is_active:
		return

	var modifier = 1 if is_left else -1
	var collision = move_and_collide(Vector2(modifier * delta * speed, 0))

	if collision and collision.collider.is_in_group("walls"):
		lasergun.remove_laser(self)
