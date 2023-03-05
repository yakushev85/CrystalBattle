extends Node2D

export var enemy_health = 100
export var enemy_damage = 1.0
export var enemy_type = 1
export var enemy_background = 1

export var award_health = 10
export var award_mana = 10
export var award_damage = 0.01
export var award_spell = ""

func _ready():
	if is_hidden():
		$TextureRect.hide()
	else:
		refresh_icon()

func go_fight():
	Global.battle_info.entity_name = self.name
	Global.battle_info.enemy_type = enemy_type
	Global.battle_info.enemy_health = enemy_health
	Global.battle_info.enemy_damage = enemy_damage
	Global.battle_info.enemy_background = enemy_background
	Global.battle_info.award.health = award_health
	Global.battle_info.award.mana = award_mana
	Global.battle_info.award.damage = award_damage
	Global.battle_info.award.spell = award_spell
	
	get_tree().change_scene("res://src/MainBattle.tscn")


func _on_BattleEntry_body_entered(body):
	if body is KinematicBody2D and not is_hidden():
		go_fight()

func refresh_icon():
	var texture_path = "res://assets/icons/enemy/con" + str(enemy_type+9) + ".png"
	$TextureRect.texture = load(texture_path)

func is_hidden():
	for hidden_entity_name in Global.map_info.hiden_battle_entry:
		if hidden_entity_name == self.name:
			return true
	
	return false
