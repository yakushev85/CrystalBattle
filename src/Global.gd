extends Node

var spells_info = [
	{
		"name": "HealSpell", 
		"cost": 23,
		"description": "Heal player instead of deal a damage to enemy.",
		"icon": "res://assets/icons/spells/player/16.png"
	}, 
	{
		"name": "IncreaseDamageSpell", 
		"cost": 42,
		"description": "Double player damage.",
		"icon": "res://assets/icons/spells/player/40.png"
	}, 
	{
		"name": "EnemySkipSpell", 
		"cost": 51,
		"description": "Skip enemy move.",
		"icon": "res://assets/icons/spells/player/32.png"
	}, 
	{
		"name": "RandomLineSpell", 
		"cost": 63,
		"description": "Regenerate vertical and horizantal lines after player move.",
		"icon": "res://assets/icons/spells/player/19.png"
	}, 
	{
		"name": "ReflectDamageSpell", 
		"cost": 74,
		"description": "Player reflects next enemy damage.",
		"icon": "res://assets/icons/spells/player/7.png"
	}, 
	{
		"name": "RegenSpaceSpell", 
		"cost": 85,
		"description": "Regenerate the game space.",
		"icon": "res://assets/icons/spells/player/48.png"
	}
]

var map_info = {
	"hiden_battle_entry": [],
	"cfog_points": []
}

var player_info = {
	"health": 200,
	"mana": 100,
	"damage": 5.0,
	"position": Vector2.ZERO,
	"spells": []
}

var battle_info = {
	"entity_name": "",
	"enemy_type": 7,
	"enemy_health": 100,
	"enemy_damage": 1.0,
	"enemy_background": 1,
	"award": {
		"health": 0,
		"mana": 0,
		"damage": 0,
		"spell": ""
	},
	"status": ""
}

func get_spell_by_name(sname):
	if sname == null or sname == "":
		return null
	
	for spell in spells_info:
		if spell.name == sname:
			return spell
	
	return null


func collect_awards():
	player_info.health += battle_info.award.health
	player_info.mana += battle_info.award.mana
	player_info.damage += battle_info.award.damage
	var new_spell = battle_info.award.spell
	if new_spell != null and new_spell != "":
		player_info.spells.append(new_spell)
