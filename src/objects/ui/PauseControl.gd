extends Node2D



func _input(event):
	if event is InputEventMouseButton and not (event as InputEventMouseButton).is_pressed():
		if $PauseLabel.get_global_rect().has_point(event.position):
			get_tree().change_scene("res://src/StartScreen.tscn")

