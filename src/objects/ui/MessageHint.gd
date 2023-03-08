extends Node2D

const Y_SPEED = 100
const Y_MAX_ANIM = 300

func _ready():
	$DamageLabel.hide()
	$HealLabel.hide()


func set_damage_message(value):
	$DamageLabel.text = value
	$DamageLabel.show()
	

func set_heal_message(value):
	$HealLabel.text = value
	$HealLabel.show()


func _process(delta):
	if $DamageLabel.is_visible_in_tree():
		animate_down($DamageLabel, Y_SPEED*delta)
	elif $HealLabel.is_visible_in_tree():
		animate_down($HealLabel, Y_SPEED*delta)


func animate_down(a_label:Label, delta_y):
	a_label.rect_position.y += delta_y
	
	if a_label.rect_position.y > Y_MAX_ANIM:
		queue_free()
