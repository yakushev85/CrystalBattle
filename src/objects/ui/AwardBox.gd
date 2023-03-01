extends Node2D

func _ready():
	$HealthLabel.text = "+ " + str(Global.battle_info.award.health) + " health"
	$ManaLabel.text = "+ " + str(Global.battle_info.award.mana) + " mana"
	$DamageLabel.text = "+ " + str(100*Global.battle_info.award.damage) + " damage"
	
	if Global.battle_info.award.spell != null and Global.battle_info.award.spell != "":
		#$SpellRect.texture = load()
		#$SpellLabel.text = ""
		pass
	else:
		$SpellLabel.text = "No spell."
	


func _on_ButtonLabel_gui_input(event):
	if event is InputEventMouseButton and not (event as InputEventMouseButton).is_pressed():
		get_tree().change_scene("res://src/WorldMap.tscn")
