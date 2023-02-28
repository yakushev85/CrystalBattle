extends Node2D

export var max_mana_value = 100
var current_mana_value
var is_mana_damaged

func _ready():
	is_mana_damaged = false
	init_with_max()

func set_damage(damage_value):
	if not is_mana_damaged:
		set_mana_value(current_mana_value-damage_value)
	is_mana_damaged = true

func set_mana_value(hv):
	current_mana_value = hv
	$Label.text = str(current_mana_value)
	$ProgressBar.value = int(100*(current_mana_value*1.0/max_mana_value))

func init_with_max():
	set_mana_value(max_mana_value)
