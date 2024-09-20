extends CharacterBody2D

@export var speed = 100
var event_position = Vector2.ZERO
var is_playing_def_anim = false

func play_anim():
	is_playing_def_anim = true
	$AnimationPlayer.play("Default")


func stop_anim():
	is_playing_def_anim = false


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Default" and is_playing_def_anim:
		$AnimationPlayer.play("Default")
