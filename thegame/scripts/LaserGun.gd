extends StaticBody2D


var id : int = -1

# it is enabled if it was added to the scene
# if it gets removed from the scene, it is disabled again
var is_enabled : bool = false

# it is active if time is not stopped
var is_active : bool = false


func _ready():
	add_to_group("laserguns")
	# warning-ignore:return_value_discarded
	GameManager.connect("stop_time", self, "_on_stop_time_triggered")
	# warning-ignore:return_value_discarded
	GameManager.connect("stop_action", self, "_on_stop_action_triggered")


func _on_stop_time_triggered():
	is_active = false

func _on_stop_action_triggered():
	is_active = true
