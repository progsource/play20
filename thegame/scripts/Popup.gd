extends Popup

func _on_Main_Menu_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/StartScreen.tscn")

func _on_Restart_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/Game.tscn")
