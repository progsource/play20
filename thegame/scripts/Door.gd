extends StaticBody2D


var id : int = -1

func _ready():
	add_to_group("doors")
	$AnimationPlayer.play("move")
	
	# warning-ignore:return_value_discarded
	GameManager.connect("stop_time", self, "_on_stop_time_triggered")

func _on_stop_time_triggered(toogle):
	if toogle:
		$AnimationPlayer.stop(false)
	else:
		$AnimationPlayer.play("move")
