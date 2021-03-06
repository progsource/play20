extends StaticBody2D


var id : int = -1

# it is enabled if it was added to the scene
# if it gets removed from the scene, it is disabled again
var is_enabled : bool = false setget set_is_enabled

# it is active if time is not stopped
var is_active : bool = false

var laser_op = load("res://scripts/ObjectPool.gd").new()
var laser_spawn_timer : Timer = null
var laser_speed : int = 1

# either it is left or right
var is_left = true

func set_is_enabled(var enabled : bool) -> void :
	is_enabled = enabled
	
	if not is_enabled:
		for c in $LaserContainer.get_children():
			if c.is_in_group("laser"):
				remove_laser(c)


func _enter_tree():
	laser_speed = GameManager.rng.randi_range(20, 40)

func _ready():
	laser_op.init_object_pool("res://scenes/Laser.tscn", 3)
	for laser in laser_op.unused_objects:
		laser.lasergun = self
		laser.speed = laser_speed

	add_to_group("laserguns")

	laser_spawn_timer = Timer.new()
	laser_spawn_timer.autostart = true
	laser_spawn_timer.wait_time = GameManager.rng.randi_range(1, 3)
	laser_spawn_timer.one_shot = false
	laser_spawn_timer.paused = true
	# warning-ignore:return_value_discarded
	laser_spawn_timer.connect("timeout", self, "_on_laser_spawn_timeout")
	add_child(laser_spawn_timer)

	# warning-ignore:return_value_discarded
	GameManager.connect("stop_time", self, "_on_stop_time_triggered")

func _on_stop_time_triggered(toogle):
	is_active = !toogle

func _process(_delta):
	if not is_enabled or not is_active:
		laser_spawn_timer.paused = true
		return

	laser_spawn_timer.paused = false


func _on_laser_spawn_timeout() -> void :
	_spawn_laser()


func _spawn_laser() -> void :
	var laser = laser_op.get_object()
	if not laser:
		return

	laser.position = $LaserContainer.position
	laser.is_left = is_left
	$LaserContainer.add_child(laser)
	$Sound.play(0.0 if is_left else 1.0)


func remove_laser(var laser) -> void :
	laser_op.return_object(laser)
	$LaserContainer.remove_child(laser)
