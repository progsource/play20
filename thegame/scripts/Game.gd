extends Node2D

onready var player := $Player
onready var popup := $HUD/Popup

var is_paused = false

func _ready():
	# warning-ignore:return_value_discarded
	GameManager.connect("kill", self, "_on_kill")

	_unpause()

func _on_kill():
	if not is_paused:
		popup.die_sound.play(0.5)
	_pause()
	popup.popup()
	
func _pause():
	is_paused = true
	player.set_process_input(false)
	GameManager.set_process_unhandled_input(false)
	get_tree().paused = true
	
func _unpause():
	is_paused = false
	player.set_process_input(true)
	GameManager.set_process_unhandled_input(true)
	get_tree().paused = false
