extends Node2D


var laser_gun_op = load("res://scripts/ObjectPool.gd").new()
export var laser_gun_left_pos : float = 0.0
export var laser_gun_right_pos : float = 180.0
const laser_gun_vertical_start_pos : float = 90.0

var doors_op = load("res://scripts/ObjectPool.gd").new()


func _enter_tree():
	laser_gun_op.init_object_pool("res://scenes/LaserGun.tscn", 10)
#   doors_op.init_object_pool("res://scenes/Door.tscn", 4)


func _ready():
	# warning-ignore:return_value_discarded
	_add_laser_gun(true)
	# warning-ignore:return_value_discarded
	_add_laser_gun(false)
	
#	_remove_laser_gun($ObjectContainer.get_child(0))

#func _process(delta):
#	pass

# returns false if it failed
func _add_laser_gun(var is_left : bool) -> bool:
	var gun = laser_gun_op.get_object()
	if not gun:
		return false

	gun.is_left = is_left

	if is_left:
		gun.rotation_degrees = 0.0
		gun.position = Vector2(laser_gun_left_pos, laser_gun_vertical_start_pos)
	else:
		gun.rotation_degrees = 180.0
		# TODO remove +30 as soon as laserguns are randomly generated
		gun.position = Vector2(laser_gun_right_pos, laser_gun_vertical_start_pos + 226)

	$ObjectContainer.add_child(gun)

	gun.is_active = true
	gun.is_enabled = true
	
	return true

func _remove_laser_gun(var gun) -> void:
	gun.is_enabled = false
	$ObjectContainer.remove_child(gun)
	laser_gun_op.return_object(gun)
