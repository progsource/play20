extends Node2D

onready var player := $Player
onready var popup := $Popup

func _ready():
	# warning-ignore:return_value_discarded
	GameManager.connect("kill", self, "_on_kill")
	_unpause()

func _on_kill():
	_pause()
	$Popup.popup()
	
func _pause():
	player.set_process_input(false)
	GameManager.set_process_unhandled_input(false)
	get_tree().paused = true
	
func _unpause():
	player.set_process_input(true)
	GameManager.set_process_unhandled_input(true)
	get_tree().paused = false
