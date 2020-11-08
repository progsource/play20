extends ParallaxBackground

var speed : float = GameManager.gravity
var last_created_object_distance : float = 110.0
var object_distance : float = 100.0

var laser_gun_op = load("res://scripts/ObjectPool.gd").new()
export var laser_gun_left_pos : float = 0.0
export var laser_gun_right_pos : float = 180.0
const laser_gun_vertical_start_pos : float = 360.0

var doors_op = load("res://scripts/ObjectPool.gd").new()
var spike_doors_op = load("res://scripts/ObjectPool.gd").new()
var platforms_op = load("res://scripts/ObjectPool.gd").new()

func _init():
	laser_gun_op.init_object_pool("res://scenes/LaserGun.tscn", 10)
	platforms_op.init_object_pool("res://scenes/Platform.tscn", 10)
	doors_op.init_object_pool("res://scenes/Door.tscn", 10)
	spike_doors_op.init_object_pool("res://scenes/SpikeDoor.tscn", 10)


func _enter_tree():
	if GameManager.best_fall < 0.0:
		var best_fall_line = load("res://scenes/BestFallLine.tscn").instance()
		best_fall_line.position.y = GameManager.best_fall * -1.0
		$ParallaxLayer.add_child(best_fall_line)

func _ready():
	# warning-ignore:return_value_discarded
	GameManager.connect("prekill", self, "_on_kill")
	# warning-ignore:return_value_discarded
	GameManager.connect("speed_up", self, "_on_speed_up")


func _on_kill():
	var fall = scroll_offset.y - GameManager.player_pos_y
	GameManager.best_fall = fall if fall < GameManager.best_fall else GameManager.best_fall

func _process(delta):
	var add_distance = delta * speed
	scroll_offset.y -= add_distance
	last_created_object_distance += add_distance

	if last_created_object_distance > object_distance:
		_spawn_object()
		object_distance = GameManager.rng.randi_range(40, 140)
		last_created_object_distance = 0.0


func _spawn_object():
	var max_probability = (GameManager.door_probability +
		GameManager.spike_door_probabilty +
		GameManager.platform_probabilty +
		GameManager.spike_platform_probability +
		GameManager.laser_left_probability +
		GameManager.laser_right_probability)
	var rand = GameManager.rng.randi_range(0, max_probability)

	var max_door_prob = GameManager.door_probability
	var max_spike_door_prob = max_door_prob + GameManager.spike_door_probabilty
	var max_platform_prob = max_spike_door_prob + GameManager.platform_probabilty
	var max_spike_platform_prob = max_platform_prob + GameManager.spike_platform_probability
	var max_laser_left_prob = max_spike_platform_prob + GameManager.laser_left_probability
	var max_laser_right_prob = max_laser_left_prob + GameManager.laser_right_probability

	if rand < max_door_prob:
		# warning-ignore:return_value_discarded
		_add_door()
	elif rand < max_spike_door_prob:
		# warning-ignore:return_value_discarded
		_add_spike_door()
	elif rand < max_platform_prob:
		# warning-ignore:return_value_discarded
		_add_platform(false)
	elif rand < max_spike_platform_prob:
		# warning-ignore:return_value_discarded
		_add_platform(true)
	elif rand < max_laser_left_prob:
		# warning-ignore:return_value_discarded
		_add_laser_gun(true)
	elif rand < max_laser_right_prob:
		# warning-ignore:return_value_discarded
		_add_laser_gun(false)
	else:
		pass


func _physics_process(_delta):
	var collision = $ObjectDestroyer.move_and_collide(Vector2.ZERO, true, true, true)
	if collision:
		if collision.collider.is_in_group("laserguns"):
			_remove_laser_gun(collision.collider)
		if collision.collider.is_in_group("platforms"):
			_remove_platform(collision.collider)
		if collision.collider.is_in_group("doors"):
			_remove_door(collision.collider)
		if collision.collider.is_in_group("spikedoors"):
			_remove_spike_door(collision.collider)
		if collision.collider.is_in_group("bestfallline"):
			collision.collider.queue_free()


# returns false if it failed
func _add_laser_gun(var is_left : bool) -> bool:
	var gun = laser_gun_op.get_object()
	if not gun:
		return false

	gun.is_left = is_left

	if is_left:
		gun.rotation_degrees = 0.0
		gun.position = Vector2(laser_gun_left_pos, (-1 * scroll_offset.y) + laser_gun_vertical_start_pos)
	else:
		gun.rotation_degrees = 180.0
		gun.position = Vector2(laser_gun_right_pos, (-1 * scroll_offset.y) + laser_gun_vertical_start_pos)

	$ParallaxLayer.add_child(gun)

	gun.is_active = true
	gun.set_is_enabled(true)

	return true

func _remove_laser_gun(var gun) -> void:
	gun.set_is_enabled(false)
	$ParallaxLayer.remove_child(gun)
	laser_gun_op.return_object(gun)


func _add_platform(var has_spikes : bool) -> bool :
	var platform = platforms_op.get_object()
	if not platform:
		return false

	platform.has_spikes = has_spikes

	var pos = Vector2()
	pos.x = GameManager.rng.randi_range(30, 100)
	pos.y = (-1 * scroll_offset.y) + laser_gun_vertical_start_pos

	platform.position = pos

	$ParallaxLayer.add_child(platform)

	return true

func _remove_platform(var platform) -> void:
	$ParallaxLayer.remove_child(platform)
	platforms_op.return_object(platform)


func _add_door() -> bool :
	var door = doors_op.get_object()
	if not door:
		return false

	door.position.y = (-1 * scroll_offset.y) + laser_gun_vertical_start_pos

	$ParallaxLayer.add_child(door)

	return true

func _remove_door(var door) -> void :
	$ParallaxLayer.remove_child(door)
	doors_op.return_object(door)


func _add_spike_door() -> bool :
	var spike_door = spike_doors_op.get_object()
	if not spike_door:
		return false

	spike_door.position.y = (-1 * scroll_offset.y) + laser_gun_vertical_start_pos

	$ParallaxLayer.add_child(spike_door)

	return true

func _remove_spike_door(var door) -> void :
	$ParallaxLayer.remove_child(door)
	spike_doors_op.return_object(door)

func _on_speed_up(toogle):
	if toogle:
		speed = GameManager.gravity + GameManager.gravity * GameManager.speed_up_factor
	else:
		speed = GameManager.gravity
