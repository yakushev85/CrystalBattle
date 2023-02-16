extends Node2D

func _ready():
	$ProgressBar.value = 100

func set_damage(damage_value):
	$ProgressBar.value -= damage_value

func set_health_value(health_value):
	$ProgressBar.value = health_value
	
func get_health_value():
	return $ProgressBar.value
