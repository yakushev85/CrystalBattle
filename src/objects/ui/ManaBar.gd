extends Node2D

export var max_mana_value = 100
var current_mana_value

func _ready():
	init_with_max()

func set_damage(damage_value):
	set_mana_value(current_mana_value-damage_value)

func set_mana_value(hv):
	current_mana_value = hv
	$ProgressBar.value = int(100*(current_mana_value/max_mana_value))
	
func get_health_value():
	return current_mana_value

func init_with_max():
	set_mana_value(max_mana_value)
