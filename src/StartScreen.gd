extends Node2D

func _ready():
	$PlayButton.show()
	$LoadingLabel.hide()
	

func _on_PlayButton_pressed():
	$PlayButton.hide()
	$LoadingLabel.show()
	$StartTimer.start()


func _on_StartTimer_timeout():
	get_tree().change_scene("res://src/WorldMap.tscn")
