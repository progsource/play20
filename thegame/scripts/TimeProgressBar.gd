extends ColorRect


var is_action_active := false 

func _ready():
	# warning-ignore:return_value_discarded
	GameManager.connect("action_triggered", self, "_on_action_triggered")

func _process(delta):
	var progress = $ProgressBar.value
	if is_action_active:
		if progress > 0:
			progress -= delta * GameManager.speed_use
		else:
			is_action_active = false
			GameManager.emit_signal("action_toogle", false)
	else:
		if progress < 100:
			progress += delta * GameManager.speed_load
			if progress > GameManager.action_toogle:
				GameManager.emit_signal("action_toogle", true)

	$ProgressBar.value = progress

func _on_action_triggered(toogle):
	is_action_active = toogle
