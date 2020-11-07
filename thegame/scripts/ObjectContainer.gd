extends ParallaxBackground

var speed : float = 20.0
var last_created_object_distance : float = 70.0
var object_distance : float = 60.0

var laser_gun_op = load("res://scripts/ObjectPool.gd").new()
export var laser_gun_left_pos : float = 0.0
export var laser_gun_right_pos : float = 180.0
const laser_gun_vertical_start_pos : float = 330.0

#var doors_op = load("res://scripts/ObjectPool.gd").new()

func _init():
	laser_gun_op.init_object_pool("res://scenes/LaserGun.tscn", 10)


func _process(delta):
	var add_distance = delta * speed
	scroll_offset.y -= add_distance
	last_created_object_distance += add_distance
	
	if last_created_object_distance > object_distance:
		_spawn_object()
		last_created_object_distance = 0.0


func _spawn_object():
	var rand = GameManager.rng.randi_range(0, 1) # left or right laser
	
	match rand:
		0:
			# warning-ignore:return_value_discarded
			_add_laser_gun(true)
		1:
			# warning-ignore:return_value_discarded
			_add_laser_gun(false)


func _physics_process(_delta):
	var collision = $ObjectDestroyer.move_and_collide(Vector2.ZERO, true, true, true)
	if collision:
		if collision.collider.is_in_group("laserguns"):
			_remove_laser_gun(collision.collider)


# returns false if it failed
func _add_laser_gun(var is_left : bool) -> bool:
	var gun = laser_gun_op.get_object()
	if not gun:
		return false

	gun.is_left = is_left

	if is_left:
		gun.rotation_degrees = 0.0
		gun.position = Vector2(laser_gun_left_pos, (-1 * scroll_offset.y) + laser_gun_vertical_start_pos)
	else:
		gun.rotation_degrees = 180.0
		# TODO remove +30 as soon as laserguns are randomly generated
		gun.position = Vector2(laser_gun_right_pos, (-1 * scroll_offset.y) + laser_gun_vertical_start_pos)

	$ParallaxLayer.add_child(gun)

	gun.is_active = true
	gun.set_is_enabled(true)

	return true

func _remove_laser_gun(var gun) -> void:
	gun.set_is_enabled(false)
	$ParallaxLayer.remove_child(gun)
	laser_gun_op.return_object(gun)
