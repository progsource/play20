extends StaticBody2D

var id : int = -1

onready var spikes = [$Spike1, $Spike2, $Spike3, $Spike4, $Spike5]

func _ready():
	add_to_group("platforms")
	for spike in spikes:
		spike.visible = false
		spike.get_node("CollisionPolygon2D").set_deferred("disabled", true)
	_add_spikes()
	
func _add_spikes():
	if GameManager.rng.randf() <= 0.5:
		return
	
	for spike in spikes:
		spike.visible = true
		spike.get_node("CollisionPolygon2D").set_deferred("disabled", false)
