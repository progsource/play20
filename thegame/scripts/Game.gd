extends Node2D


var laser_gun_op = load("res://scripts/ObjectPool.gd").new()
export var laser_gun_left_pos : float = 0.0
export var laser_gun_right_pos : float = 180.0

var doors_op = load("res://scripts/ObjectPool.gd").new()


func _enter_tree():
	laser_gun_op.init_object_pool("res://scenes/LaserGun.tscn", 10)
#   doors_op.init_object_pool("res://scenes/Door.tscn", 4)


func _ready():
	var gun = laser_gun_op.get_object()
	if gun:
		gun.rotation_degrees = 0.0
		gun.position = Vector2(laser_gun_left_pos, 50.0)
		$ObjectContainer.add_child(gun)
	var gun_right = laser_gun_op.get_object()
	if gun_right:
		gun_right.rotation_degrees = 180.0
		gun_right.position = Vector2(laser_gun_right_pos, 50.0)
		$ObjectContainer.add_child(gun_right)

#func _process(delta):
#	pass
