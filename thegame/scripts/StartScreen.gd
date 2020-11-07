extends CenterContainer


func _ready():
	if OS.has_feature('JavaScript'):
		$VBoxContainer/Quit.visible = false

func _on_Play_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/Game.tscn")

func _on_Credits_pressed():
	pass # Replace with function body.

func _on_Quit_pressed():
	get_tree().quit()
