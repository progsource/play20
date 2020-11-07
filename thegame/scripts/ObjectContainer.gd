extends ParallaxBackground

var speed : float = 30.0
var last_created_object_distance : float = 110.0
var object_distance : float = 100.0

var laser_gun_op = load("res://scripts/ObjectPool.gd").new()
export var laser_gun_left_pos : float = 0.0
export var laser_gun_right_pos : float = 180.0
const laser_gun_vertical_start_pos : float = 360.0

var doors_op = load("res://scripts/ObjectPool.gd").new()

var platforms_op = load("res://scripts/ObjectPool.gd").new()

func _init():
	laser_gun_op.init_object_pool("res://scenes/LaserGun.tscn", 10)
	platforms_op.init_object_pool("res://scenes/Platform.tscn", 10)
	doors_op.init_object_pool("res://scenes/Door.tscn", 10)


func _process(delta):
	var add_distance = delta * speed
	scroll_offset.y -= add_distance
	last_created_object_distance += add_distance
	
	if last_created_object_distance > object_distance:
		_spawn_object()
		object_distance = GameManager.rng.randi_range(40, 140)
		last_created_object_distance = 0.0


func _spawn_object():
	var rand = GameManager.rng.randi_range(0, 100)
	
	if rand < 30:
		# warning-ignore:return_value_discarded
		_add_laser_gun(true)
	elif rand < 60:
		# warning-ignore:return_value_discarded
		_add_laser_gun(false)
	elif rand < 80:
		# warning-ignore:return_value_discarded
		_add_door()
	else:
		# warning-ignore:return_value_discarded
		_add_platform()


func _physics_process(_delta):
	var collision = $ObjectDestroyer.move_and_collide(Vector2.ZERO, true, true, true)
	if collision:
		if collision.collider.is_in_group("laserguns"):
			_remove_laser_gun(collision.collider)
		if collision.collider.is_in_group("platforms"):
			_remove_platform(collision.collider)
		if collision.collider.is_in_group("doors"):
			_remove_door(collision.collider)


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
		gun.position = Vector2(laser_gun_right_pos, (-1 * scroll_offset.y) + laser_gun_vertical_start_pos)

	$ParallaxLayer.add_child(gun)

	gun.is_active = true
	gun.set_is_enabled(true)

	return true

func _remove_laser_gun(var gun) -> void:
	gun.set_is_enabled(false)
	$ParallaxLayer.remove_child(gun)
	laser_gun_op.return_object(gun)


func _add_platform() -> bool :
	var platform = platforms_op.get_object()
	if not platform:
		return false
	
	var pos = Vector2()
	pos.x = GameManager.rng.randi_range(30, 100)
	pos.y = (-1 * scroll_offset.y) + laser_gun_vertical_start_pos
	
	platform.position = pos
	
	$ParallaxLayer.add_child(platform)
	
	return true

func _remove_platform(var platform) -> void:
	$ParallaxLayer.remove_child(platform)
	platforms_op.return_object(platform)


func _add_door() -> bool :
	var door = doors_op.get_object()
	if not door:
		return false
	
	door.position.y = (-1 * scroll_offset.y) + laser_gun_vertical_start_pos
	
	$ParallaxLayer.add_child(door)
	
	return true

func _remove_door(var door) -> void :
	$ParallaxLayer.remove_child(door)
	doors_op.return_object(door)

