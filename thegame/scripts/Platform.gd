extends StaticBody2D

var id : int = -1

onready var spikes = [$Spike1, $Spike2, $Spike3, $Spike4, $Spike5]

func _ready():
	add_to_group("platforms")
	_add_spikes()
	
func _add_spikes():
	if GameManager.rng.randf() <= 0.5:
		return
	
	for spike in spikes:
		spike.visible = true
