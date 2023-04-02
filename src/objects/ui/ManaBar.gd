extends Node2D

export (PackedScene) var message_scene
export var max_mana_value = 100
var current_mana_value
var is_mana_damaged

func _ready():
	is_mana_damaged = false
	init_with_max()

func set_damage(damage_value):
	if not is_mana_damaged:
		set_mana_value(current_mana_value-damage_value)
		if damage_value > 0:
			var message_hint = message_scene.instance() as Node2D
			message_hint.position.x = int($ProgressBar.rect_size.x / 2)
			add_child(message_hint)
			message_hint.set_damage_message("- " + str(damage_value) + " mana")
		
	is_mana_damaged = true

func set_restored(restored_value):
	if current_mana_value < max_mana_value:
		var message_hint = message_scene.instance() as Node2D
		message_hint.position.x = int($ProgressBar.rect_size.x / 2)
		add_child(message_hint)
		message_hint.set_heal_message("+ " + str(restored_value) + " mana")
	
	if current_mana_value+restored_value > max_mana_value:
		set_mana_value(max_mana_value)
	else:
		set_mana_value(current_mana_value+restored_value)


func set_mana_value(hv):
	current_mana_value = hv
	$Label.text = str(current_mana_value)
	$ProgressBar.value = int(100*(current_mana_value*1.0/max_mana_value))

func init_with_max():
	set_mana_value(max_mana_value)
