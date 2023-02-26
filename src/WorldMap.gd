extends Node2D

func _ready():		
	if Global.player_info.position != Vector2.ZERO:
		$Player.position = Global.player_info.position
	
