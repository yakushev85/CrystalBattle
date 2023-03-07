extends Node2D

func _ready():
	$HealthLabel.text = "+ " + str(Global.battle_info.award.health) + " health"
	$ManaLabel.text = "+ " + str(Global.battle_info.award.mana) + " mana"
	$DamageLabel.text = "+ " + str(100*Global.battle_info.award.damage) + " damage"
	
	var spell = Global.get_spell_by_name(Global.battle_info.award.spell)
	if spell != null:
		$SpellRect.texture = load(spell.icon)
		$SpellRect.show()
		$SpellLabel.text = "New spell!\n" + spell.description + "\nThe spell costs " + str(spell.cost) + " mana."
	else:
		$SpellRect.hide()
		$SpellLabel.text = "No spell."

