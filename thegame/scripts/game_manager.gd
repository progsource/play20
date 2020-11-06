extends Node

# !!! Singleton

# ---------------- EVENTS
# warning-ignore:unused_signal
signal stop_time()
# warning-ignore:unused_signal
signal speed_up()

# ---------------- player vars
var gavity: float = 1.0
var stop_time: float = 1.0
var speed_up: float = 1.0
var spped_up_factor: float = 0.5
var life: int = 1
