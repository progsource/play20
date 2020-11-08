extends Node2D

onready var player := $Player
onready var popup := $HUD/Popup
onready var optimal_position : Vector2 = $OtimalPosition.position

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

func _physics_process(_delta):
	if player.check_collision() or player.position.y == optimal_position.y:
		return
	elif player.position.y > optimal_position.y: # with floats only == is not enough
		player.position.y = optimal_position.y
	
	var _distance = Vector2(0.0, player.position.y).distance_to(Vector2(0.0, optimal_position.y))
	if _distance > 5:
		var _velocity = Vector2(0.0, position.direction_to(optimal_position).y) * GameManager.gravity
		_velocity = player.move_and_slide(_velocity)
	else:
		player.position.y = optimal_position.y
