extends Node2D

func _ready():
	if Global.is_new_game():
		$PlayButton.hide()
	else:
		$PlayButton.show()
	
	$LoadingLabel.hide()
	$ConfirmationDialog.hide()


func _on_PlayButton_pressed():
	start_game()


func _on_StartTimer_timeout():
	get_tree().change_scene("res://src/WorldMap.tscn")


func _on_NewGameButton_pressed():
	if Global.is_new_game():
		start_game(true)
	else:
		# confirm new game
		$ConfirmationDialog.show()


func start_game(is_new = false):
	$NewGameButton.hide()
	$PlayButton.hide()
	$LoadingLabel.show()
	
	if is_new:
		Global.save_data()
	else:
		Global.load_data()
	
	$StartTimer.start()


func _on_ConfirmationDialog_confirmed():
	start_game(true)
