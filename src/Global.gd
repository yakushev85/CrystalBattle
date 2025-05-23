extends Node

var enemy_spells = [
	{
		"name": "StealBlood", 
		"description": "Heal enemy from a damage",
		"icon": "res://assets/icons/spells/enemy/8.png"
	}, 
	{
		"name": "IncreaseDamage", 
		"description": "Double given damage.",
		"icon": "res://assets/icons/spells/enemy/43.png"
	}, 
	{
		"name": "DoubleShot", 
		"description": "Two picks instead of one.",
		"icon": "res://assets/icons/spells/enemy/29.png"
	}, 
	{
		"name": "RandomLine", 
		"description": "Regenerate vertical and horizontal lines after a pick.",
		"icon": "res://assets/icons/spells/enemy/27.png"
	}, 
	{
		"name": "RegenSpace", 
		"description": "Regenerate all crystals.",
		"icon": "res://assets/icons/spells/enemy/50.png"
	}
]

var spells_info = [
	{
		"name": "HealSpell", 
		"cost": 23,
		"description": "Heal while deal damage to an enemy.",
		"icon": "res://assets/icons/spells/player/16.png"
	}, 
	{
		"name": "IncreaseDamageSpell", 
		"cost": 42,
		"description": "Double given damage.",
		"icon": "res://assets/icons/spells/player/40.png"
	}, 
	{
		"name": "EnemySkipSpell", 
		"cost": 51,
		"description": "Skip enemy's pick.",
		"icon": "res://assets/icons/spells/player/32.png"
	}, 
	{
		"name": "RandomLineSpell", 
		"cost": 63,
		"description": "Regenerate vertical and horizantal lines after a pick.",
		"icon": "res://assets/icons/spells/player/19.png"
	}, 
	{
		"name": "ReflectDamageSpell", 
		"cost": 74,
		"description": "Player reflects taken damage.",
		"icon": "res://assets/icons/spells/player/7.png"
	}, 
	{
		"name": "RegenSpaceSpell", 
		"cost": 85,
		"description": "Regenerate all crystals.",
		"icon": "res://assets/icons/spells/player/48.png"
	}
]

var default_map_info = {
	"hiden_battle_entry": [],
	"cfog_points": []
}

var map_info = default_map_info.duplicate(true)

var default_player_info = {
	"health": 120,
	"mana": 100,
	"damage": 1.5,
	"position": Vector2.ZERO,
	"spells": ["HealSpell"],
	"new_game_health": 0,
	"new_game_damage": 0
}

var player_info = default_player_info.duplicate(true)

var default_battle_info = {
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

var battle_info = default_battle_info.duplicate(true)

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
	return !FileAccess.file_exists(DATA_SAVE)


func load_data():
	var data_file = FileAccess.open(DATA_SAVE, FileAccess.READ)
	
	if data_file.is_open():
		map_info = data_file.get_var()
		player_info = data_file.get_var()
		battle_info = data_file.get_var()
	else:
		print("Can't load ", DATA_SAVE)
	
	data_file.close()
	
	
func save_data():
	var data_file = FileAccess.open(DATA_SAVE, FileAccess.WRITE)
	
	if data_file.is_open():
		data_file.store_var(map_info)
		data_file.store_var(player_info)
		data_file.store_var(battle_info)
	else:
		print("Can't save ", DATA_SAVE)
	
	data_file.close()
	

func reset_newgame_data(is_new_plus=true):
	map_info.hiden_battle_entry = []
	map_info.cfog_points = []
	
	battle_info.status = ""
	
	if is_new_plus:
		player_info.position = Vector2.ZERO
		player_info.new_game_health = player_info.health
		player_info.new_game_damage = player_info.damage
	else:
		player_info = default_player_info.duplicate(true)
		
	save_data()
	
	
func load_debug_data():
	map_info = {
			"hiden_battle_entry": [
				"BattleEntry",
				"BattleEntry2",
				"BattleEntry3",
				"BattleEntry4",
				"BattleEntry5",
				"BattleEntry6",
				"BattleEntry7",
				"BattleEntry8",
				"BattleEntry9",
				"BattleEntry10",
				"BattleEntry11",
				"BattleEntry12",
				"BattleEntry13",
				"BattleEntry14",
				"BattleEntry15",
				"BattleEntry16",
				"BattleEntry17",
				"BattleEntry18",
				"BattleEntry19",
				"BattleEntry20",
				"BattleEntry21",
				"BattleEntry22",
				"BattleEntry23",
				"BattleEntry24",
				"BattleEntry25",
				#"BattleEntry26",
				"BattleEntry27",
				],
			"cfog_points": []
		}
	player_info = {
			"health": 1000,
			"mana": 1000,
			"damage": 10.0,
			"position": Vector2.ZERO,
			"spells": ["HealSpell", "IncreaseDamageSpell", "EnemySkipSpell", "RandomLineSpell", "ReflectDamageSpell", "RegenSpaceSpell"],
			"new_game_health": 0,
			"new_game_damage": 0
		}
