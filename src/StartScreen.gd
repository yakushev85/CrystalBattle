extends Node2D

func _ready():
	if Global.is_new_game():
		$PlayButton.hide()
	else:
		$PlayButton.show()
	
	$LoadingLabel.hide()
	$ConfirmationDialog.hide()


func _on_PlayButton_pressed():
	$AudioSelectPlayer.play()
	start_game()


func _on_StartTimer_timeout():
	if Global.battle_info.status == "IN":
		get_tree().change_scene_to_file("res://src/MainBattle.tscn")
	else:	
		get_tree().change_scene_to_file("res://src/WorldMap.tscn")


func _on_NewGameButton_pressed():
	$AudioSelectPlayer.play()
	
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
		Global.reset_newgame_data(false)
	else:
		Global.load_data()
		#Global.load_debug_data()
	
	$StartTimer.start()


func _on_ConfirmationDialog_confirmed():
	start_game(true)
