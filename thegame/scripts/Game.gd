extends Node2D


var laser_gun_op = load("res://scripts/ObjectPool.gd").new()
export var laser_gun_left_pos : float = 0.0
export var laser_gun_right_pos : float = 180.0
const laser_gun_vertical_start_pos : float = 50.0

var doors_op = load("res://scripts/ObjectPool.gd").new()


func _enter_tree():
	laser_gun_op.init_object_pool("res://scenes/LaserGun.tscn", 10)
#   doors_op.init_object_pool("res://scenes/Door.tscn", 4)


func _ready():
	# warning-ignore:return_value_discarded
	_add_laser_gun(true)
	# warning-ignore:return_value_discarded
	_add_laser_gun(false)

#func _process(delta):
#	pass

# returns false if it failed
func _add_laser_gun(var is_left : bool) -> bool:
	var gun = laser_gun_op.get_object()
	if not gun:
		return false

	if is_left:
		gun.rotation_degrees = 0.0
		gun.position = Vector2(laser_gun_left_pos, laser_gun_vertical_start_pos)
	else:
		gun.rotation_degrees = 180.0
		gun.position = Vector2(laser_gun_right_pos, laser_gun_vertical_start_pos)

	$ObjectContainer.add_child(gun)
	return true
