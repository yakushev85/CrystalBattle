extends Node2D

@export var is_enemy = false
@export var avatar_type = 1

func _ready():
	refresh_avatar()

func refresh_avatar():
	var texture_path
	if is_enemy:
		texture_path = "res://assets/icons/enemy/con" + str(avatar_type+9) + ".png"
	else:
		texture_path = "res://assets/icons/player/base.png"
	
	$TextureRect.texture = load(texture_path)


func turn_on():
	$AnimationPlayer.play("TurnOn")
	
	
func damage():
	$AnimationPlayer.play("Damage")


func stop_anim():
	$AnimationPlayer.stop()

