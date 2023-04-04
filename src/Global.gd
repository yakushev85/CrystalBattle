extends Node

var enemy_spells = [
	{
		"name": "StealBlood", 
		"description": "Heal enemy from players damage",
		"icon": "res://assets/icons/spells/enemy/8.png"
	}, 
	{
		"name": "IncreaseDamage", 
		"description": "Double enemy damage.",
		"icon": "res://assets/icons/spells/enemy/43.png"
	}, 
	{
		"name": "DoubleShot", 
		"description": "Two shots.",
		"icon": "res://assets/icons/spells/enemy/29.png"
	}, 
	{
		"name": "RandomLine", 
		"description": "Regenerate vertical and horizantal lines after enemy move.",
		"icon": "res://assets/icons/spells/enemy/27.png"
	}, 
	{
		"name": "RegenSpace", 
		"description": "Regenerate the game space.",
		"icon": "res://assets/icons/spells/enemy/50.png"
	}
]

var spells_info = [
	{
		"name": "HealSpell", 
		"cost": 23,
		"description": "Heal player while deal damage to enemy.",
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

var default_map_info = {
	"hiden_battle_entry": [],
	"cfog_points": []
}

var map_info = default_map_info

var default_player_info = {
	"health": 120,
	"mana": 100,
	"damage": 1.5,
	"position": Vector2.ZERO,
	"spells": ["HealSpell"],
	"new_game_health": 0,
	"new_game_damage": 0
}

var player_info = default_player_info

var battle_info = {
	"entity_name": "",
	"enemy_type": 7,
	"enemy_health": 100,
	"enemy_damage": 1.0,
	"enemy_background": 1,
	"enemy_spells": [],
	"enemy_s_usage": 0,
	"award": {
		"health": 0,
		"mana": 0,
		"damage": 0,
		"spell": ""
	},
	"c_enemy_health": 100,
	"c_player_health": 120,
	"c_player_mana": 100,
	"c_play_matrix": [],
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
		
		
func is_game_finished():
	return (map_info.hiden_battle_entry as Array).find("BattleEntry26") >= 0


const DATA_SAVE = "user://data.save"


func is_new_game():
	var data_file = File.new()
	var is_new = !data_file.file_exists(DATA_SAVE)
	data_file.close()
	
	return is_new


func load_data():
	var data_file = File.new()
	
	if data_file.open(DATA_SAVE, File.READ) == 0:
		map_info = data_file.get_var()
		player_info = data_file.get_var()
		battle_info = data_file.get_var()
	else:
		print("Can't load ", DATA_SAVE)
	
	data_file.close()
	
	
func save_data():
	var data_file = File.new()
	
	if data_file.open(DATA_SAVE, File.WRITE) == 0:
		data_file.store_var(map_info)
		data_file.store_var(player_info)
		data_file.store_var(battle_info)
	else:
		print("Can't save ", DATA_SAVE)
	
	data_file.close()
	

func reset_newgame_data():
	map_info = default_map_info
	player_info.position = Vector2.ZERO
	player_info.new_game_health = player_info.health
	player_info.new_game_damage = player_info.damage
	save_data()
	
	
func load_debug_data():
	map_info = {
			"hiden_battle_entry": [
				"BattleEntry",
				"BattleEntry2",
				"BattleEntry3",
				"BattleEntry4",
				"BattleEntry5",
				],
			"cfog_points": []
		}
	player_info = {
			"health": 270,
			"mana": 160,
			"damage": 2.0,
			"position": Vector2.ZERO,
			"spells": ["HealSpell"],
			"new_game_health": 0,
			"new_game_damage": 0
		}
