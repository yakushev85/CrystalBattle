extends Node2D

export var max_health_value = 100
var current_health_value

func _ready():
	init_with_max()

func set_damage(damage_value):
	set_health_value(current_health_value-damage_value)

func set_heal(heal_value):
	if current_health_value+heal_value > max_health_value:
		set_health_value(max_health_value)
	else:
		set_health_value(current_health_value+heal_value)

func set_health_value(hv):
	current_health_value = hv
	$Label.text = str(int(current_health_value))
	$ProgressBar.value = int(100*(current_health_value*1.0/max_health_value))

func init_with_max():
	set_health_value(max_health_value)
