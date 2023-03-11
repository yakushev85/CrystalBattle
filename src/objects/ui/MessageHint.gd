extends Node2D

export var y_speed = 100
export var y_max_anim = 300

func _ready():
	$DamageLabel.hide()
	$HealLabel.hide()
	$RewardLabel.hide()


func set_damage_message(value):
	$DamageLabel.text = value
	$DamageLabel.show()
	

func set_heal_message(value):
	$HealLabel.text = value
	$HealLabel.show()

func set_reward_message(value):
	$RewardLabel.text = value
	$RewardLabel.show()

func _process(delta):
	if $DamageLabel.is_visible_in_tree():
		animate_down($DamageLabel, y_speed*delta)
	elif $HealLabel.is_visible_in_tree():
		animate_down($HealLabel, y_speed*delta)
	elif $RewardLabel.is_visible_in_tree():
		animate_down($RewardLabel, y_speed*delta)


func animate_down(a_label:Label, delta_y):
	a_label.rect_position.y += delta_y
	
	if a_label.rect_position.y > y_max_anim:
		queue_free()
