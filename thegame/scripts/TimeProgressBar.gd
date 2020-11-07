extends ColorRect


export var speed_load : int = 30
export var speed_use : int = 30
var is_action_active := false

func _ready():
	# warning-ignore:return_value_discarded
	GameManager.connect("stop_time", self, "_on_action_triggered")
	# warning-ignore:return_value_discarded
	GameManager.connect("speed_up", self, "_on_action_triggered")


func _process(delta):
	var progress = $ProgressBar.value
	if is_action_active:
		if progress > 0:
			progress -= delta * speed_use
		else:
			is_action_active = false
			GameManager.emit_signal("stop_action")
	else:
		if progress < 100:
			progress += delta * speed_load

	$ProgressBar.value = progress


func _on_action_triggered(toogle):
	is_action_active = toogle
	
	if is_action_active:
		return

	var progress = $ProgressBar.value
	if progress <= 0:
		GameManager.emit_signal("stop_action")
