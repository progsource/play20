extends Node2D

onready var player := $Player
onready var popup := $HUD/Popup
onready var optimal_position : Vector2 = $OtimalPosition.position

func _ready():
	# warning-ignore:return_value_discarded
	GameManager.connect("kill", self, "_on_kill")
	_unpause()

func _on_kill():
	_pause()
	popup.popup()
	
func _pause():
	player.set_process_input(false)
	GameManager.set_process_unhandled_input(false)
	get_tree().paused = true
	
func _unpause():
	player.set_process_input(true)
	GameManager.set_process_unhandled_input(true)
	get_tree().paused = false

func _physics_process(delta):
	if player.check_collision() or player.position.y == optimal_position.y:
		return
		
	if player.position.distance_to(optimal_position) > 5:
		var _velocity = Vector2(0.0, position.direction_to(optimal_position).y) * GameManager.gravity
		_velocity = player.move_and_slide(_velocity)
	else:
		player.position.y = optimal_position.y
