extends Node2D


var laser_gun_op = load("res://scripts/ObjectPool.gd").new()
var doors_op = load("res://scripts/ObjectPool.gd").new()


func _enter_tree():
	pass # TODO as soon as objects are available
#	laser_gun_op.init_object_pool("res://scenes/LaserGun.tscn", 10)
#   doors_op.init_object_pool("res://scenes/Door.tscn", 4)


func _ready():
	pass


#func _process(delta):
#	pass
