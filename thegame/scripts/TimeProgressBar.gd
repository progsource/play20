extends ColorRect


export var speed_load : int = 30
export var speed_use : int = 50
export var action_toogle : int = 25

var is_action_active := false 

func _ready():
	# warning-ignore:return_value_discarded
	GameManager.connect("action_triggered", self, "_on_action_triggered")

func _process(delta):
	var progress = $ProgressBar.value
	if is_action_active:
		if progress > 0:
			progress -= delta * speed_use
		else:
			is_action_active = false
			GameManager.emit_signal("action_toogle", false)
	else:
		if progress < 100:
			progress += delta * speed_load
			if progress > action_toogle:
				GameManager.emit_signal("action_toogle", true)

	$ProgressBar.value = progress

func _on_action_triggered(toogle):
	is_action_active = toogle
