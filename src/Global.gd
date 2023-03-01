extends Node

var map_info = {
	"hiden_battle_entry": [],
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
	"award": {
		"health": 0,
		"mana": 0,
		"damage": 0,
		"spell": ""
	},
	"status": ""
}
