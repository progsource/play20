extends StaticBody2D

var id : int = -1

onready var spikes = [$Spike1, $Spike2, $Spike3, $Spike4, $Spike5]

var has_spikes = false

func _ready():
	add_to_group("platforms")
	for spike in spikes:
		spike.visible = false
		spike.get_node("CollisionPolygon2D").set_deferred("disabled", true)
	if has_spikes:
		_add_spikes()


func _add_spikes():
	for spike in spikes:
		spike.visible = true
		spike.get_node("CollisionPolygon2D").set_deferred("disabled", false)
