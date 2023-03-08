extends Node2D

export (PackedScene) var message_scene
export var max_health_value = 100
var current_health_value


func _ready():
	init_with_max()
	

func set_damage(damage_value):
	set_health_value(current_health_value-damage_value)
	if damage_value > 0:
		var message_hint = message_scene.instance() as Node2D
		message_hint.position.x = int($ProgressBar.rect_size.x / 2)
		add_child(message_hint)
		message_hint.set_damage_message("- " + str(damage_value) + " hp")
	

func set_heal(heal_value):
	if current_health_value+heal_value > max_health_value:
		set_health_value(max_health_value)
	else:
		set_health_value(current_health_value+heal_value)
	
		if heal_value > 0:
			var message_hint = message_scene.instance()
			add_child(message_hint)
			message_hint.set_heal_message("+ " + str(heal_value) + " hp")
	

func set_health_value(hv):
	current_health_value = hv
	$Label.text = str(int(current_health_value))
	$ProgressBar.value = int(100*(current_health_value*1.0/max_health_value))

func init_with_max():
	set_health_value(max_health_value)

