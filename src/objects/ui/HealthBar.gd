extends Node2D

export var max_health_value = 100
var current_health_value

func _ready():
	init_with_max()

func set_damage(damage_value):
	set_health_value(current_health_value-damage_value)

func set_health_value(hv):
	current_health_value = hv
	$ProgressBar.value = int(100*(current_health_value/max_health_value))
	
func get_health_value():
	return current_health_value

func init_with_max():
	set_health_value(max_health_value)
