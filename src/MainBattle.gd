extends Node2D

signal enemy_won
signal player_won

export (PackedScene) var item_scene
export var item_size = 80
export var player_health = 100
export var player_mana = 100
export var player_dps = 1.0
export var enemy_health = 100
export var enemy_dps = 1.0
export var background_type = 1
export var player_type = 1
export var enemy_type = 3
export var game_area_x = 320
export var game_area_y = 64

# matrix size
const N = 8
# matrix items
const M = 8
# minimum length for scored line
const MIN_SCORED_LINE = 3
# player time limit in sec
const PLAYER_TIME_LIMIT = 31 
# matrix of items
var play_matrix = []
# game flags
var is_player_turn
var is_enemy_turn
var is_finished
# player's time
var player_time

func _ready():
	randomize()
	
	enemy_type = Global.battle_info.enemy_type
	enemy_health = Global.battle_info.enemy_health
	enemy_dps = Global.battle_info.enemy_damage
	
	background_type = Global.battle_info.enemy_background
	
	player_health = Global.player_info.health
	player_mana = Global.player_info.mana
	player_dps = Global.player_info.damage
	
	is_player_turn = false
	is_enemy_turn = false
	is_finished = false
	
	$BackgroundGroup/TextureRect.texture = load("res://assets/background/game_background_" + str(background_type) + ".png")
	
	$PlayerHealthBar.max_health_value = player_health
	$PlayerHealthBar.init_with_max()
	$PlayerManaBar.max_mana_value = player_mana
	$PlayerManaBar.init_with_max()
	$PlayerAvatar.avatar_type = player_type
	$PlayerAvatar.refresh_avatar()
	
	$EnemyHealthBar.max_health_value = enemy_health
	$EnemyHealthBar.init_with_max()
	$EnemyAvatar.avatar_type = enemy_type
	$EnemyAvatar.refresh_avatar()
	
	$MessageGroup/BigLabel.hide()
	
	$PlayerSpellBox.is_selection_allowed = false
	$PlayerSpellBox.set_visible_spells(Global.player_info.spells)
	
	$AwardBox.hide()


func _on_StartTimer_timeout():
	generate_matrix()
	$GameTimer.start()


func _on_GameTimer_timeout():
	if is_finished:
		return
	
	var scored_lines = update_matrix_play()
	if scored_lines.size() == 0:
		$GameTimer.stop()
		
		if $PlayerHealthBar/ProgressBar.value <= 0:
			emit_signal("enemy_won")
			return
		
		if $EnemyHealthBar/ProgressBar.value <= 0:
			emit_signal("player_won")
			return
		
		if is_player_turn:
			if $PlayerSpellBox.selected_spell == "EnemySkipSpell":
				$PlayerSpellBox.clear_selection()
			else:
				is_player_turn = false
				is_enemy_turn = true
		elif is_enemy_turn:
			is_player_turn = true
			is_enemy_turn = false
		else:
			is_player_turn = randf() > 0.5
			is_enemy_turn = not is_player_turn
		
		if is_enemy_turn:
			print_debug("Enemy turn")
			$PlayerSpellBox.is_selection_allowed = false
			$MessageGroup/MessageLabel.text = "Enemy's turn"
			$EnemyTimer.start()
		elif is_player_turn:
			print_debug("Player turn")
			$PlayerSpellBox.clear_selection()
			$PlayerSpellBox.is_selection_allowed = true
			check_spells()
			player_time = PLAYER_TIME_LIMIT
			$PlayerTimer.start()
	
	var damage = 0
	for score_line in scored_lines:
		damage += score_line.score
	
	if is_player_turn:
		do_enemy_damage(damage*player_dps)
	elif is_enemy_turn:
		do_player_damage(damage*enemy_dps)


func _on_EnemyTimer_timeout():
	enemy_turn()


func _on_PlayerTimer_timeout():
	if player_time > 0:
		player_time -= 1
		
		var formatted_time = str(player_time)
		if player_time < 10:
			formatted_time = "0" + formatted_time
			
		$MessageGroup/MessageLabel.text = "Your turn 0:" + formatted_time
	else:
		$PlayerTimer.stop()
		$GameTimer.start()


func _input(event):
	if is_player_turn and not is_finished and event is InputEventMouseButton and not (event as InputEventMouseButton).is_pressed():
		if not remove_cell(event.position.x, event.position.y):
			return
		$PlayerManaBar.is_mana_damaged = false
		do_enemy_damage(player_dps)
		$PlayerTimer.stop()
		$GameTimer.start()


func generate_matrix():
	for mx in range(N):
		play_matrix.append([])
		
		for my in range(N):
			var item = item_scene.instance()
			
			item.set_type((randi() % M) + 1)
			
			item.position.x = game_area_x + item_size*mx + item_size/2
			item.position.y = game_area_y + item_size*my + item_size/2
			
			play_matrix[mx].append(item)
			add_child(play_matrix[mx][my])


func check_lines():
	var scored_lines = []
	
	for mx in range(N-MIN_SCORED_LINE+1):
		for my in range(N):
			var current_type = play_matrix[mx][my].get_type()
			var current_score = 0 
			
			for mxs in range(mx, N):
				var i_type = play_matrix[mxs][my].get_type()
				
				if current_type > 0 and current_type == i_type:
					current_score += 1
				else:
					current_type = 0
			
			if current_score >= MIN_SCORED_LINE:
				var check_result = {}
				check_result.score = current_score
				check_result.mx0 = mx
				check_result.my0 = my
				check_result.mx1 = mx+current_score-1
				check_result.my1 = my
				scored_lines.append(check_result)
	
	for mx in range(N):
		for my in range(N-MIN_SCORED_LINE+1):
			var current_type = play_matrix[mx][my].get_type()
			var current_score = 0 
			
			for mys in range(my, N):
				var i_type = play_matrix[mx][mys].get_type()
				
				if current_type > 0 and current_type == i_type:
					current_score += 1
				else:
					current_type = 0
			
			if current_score >= MIN_SCORED_LINE:
				var check_result = {}
				check_result.score = current_score
				check_result.mx0 = mx
				check_result.my0 = my
				check_result.mx1 = mx
				check_result.my1 = my+current_score-1
				scored_lines.append(check_result)
	
	return scored_lines
	
	
func remove_lines(scored_lines):
	for scored_line in scored_lines:
		for mxi in range(scored_line.mx0, scored_line.mx1+1):
			for myi in range(scored_line.my0, scored_line.my1+1):
				if play_matrix[mxi][myi] != null:
					play_matrix[mxi][myi].remove_with_animation()
					play_matrix[mxi][myi] = null


func remove_cell(mouse_x, mouse_y):
	var mx = (mouse_x - game_area_x) / item_size
	var my = (mouse_y - game_area_y) / item_size
	
	if mx < 0 or mx >= N or my < 0 or my >= N:
		return false
		
	if $PlayerSpellBox.selected_spell == "RegenSpaceSpell":
		regen_space()
	
	if $PlayerSpellBox.selected_spell == "RandomLineSpell":
		random_lines(mx, my)
	else:
		remove_cell_m(mx, my)
	
	return true


func remove_cell_m(mx, my):
	play_matrix[mx][my].remove_with_animation()
	play_matrix[mx][my] = null


func move_upper_lines():
	var priz = true
	while priz:
		priz = false
		for mxi in range(N):
			for myi in range(N-1):
				if play_matrix[mxi][myi+1] == null and play_matrix[mxi][myi] != null:
					# update matrix data
					play_matrix[mxi][myi+1] = play_matrix[mxi][myi]
					play_matrix[mxi][myi] = null
					priz = true
					# apply animation
					play_matrix[mxi][myi+1].go_down(game_area_y + item_size*(myi+1) + item_size/2)

	priz = true
	var empty_mx = -1
	var empty_my = -1
		
	while priz:
		priz = false
		
		# find last empty cell
		for mxi in range(N):
			for myi in range(N):
				if play_matrix[mxi][myi] == null:
					empty_mx = mxi
					empty_my = myi
					priz = true
		
		if priz:
			# create new item
			var item = item_scene.instance()
			item.set_type((randi() % M) + 1)
			item.position.x = game_area_x + item_size*empty_mx + item_size/2
			item.position.y = game_area_y - item_size*(N-empty_my+3) + item_size/2
			# update matrix data
			play_matrix[empty_mx][empty_my] = item
			add_child(item)
			# apply animation
			item.go_down(game_area_y + item_size*empty_my + item_size/2)	


func update_matrix_play():
	move_upper_lines()
	
	var scored_lines = check_lines()
	
	if scored_lines.size() > 0:
		remove_lines(scored_lines)
	
	return scored_lines


func enemy_turn():
	var posible_point = {}
	posible_point.mx = randi() % N
	posible_point.my = randi() % N
	posible_point.score = 1
	#print_debug("initial enemy point:", posible_point)
	for mxi in range(N):
		for myi in range(N):
			var current_score = check_point(mxi, myi)
			
			if current_score > posible_point.score:
				posible_point.score = current_score
				posible_point.mx = mxi
				posible_point.my = myi
	
	#print_debug("generated enemy point:", posible_point)
	remove_cell_m(posible_point.mx, posible_point.my)
	do_player_damage(enemy_dps)
	$EnemyTimer.stop()
	$GameTimer.start()


func check_point(mx0, my0):
	var play_matrix_v = []
	
	for mx in range(N):
		play_matrix_v.append([])
		for my in range(N):
			if mx == mx0 and my > 0 and my <= my0:
				play_matrix_v[mx].append(play_matrix[mx][my-1].get_type())
			elif mx == mx0 and my == 0:
				play_matrix_v[mx].append(0)
			else:
				play_matrix_v[mx].append(play_matrix[mx][my].get_type())
	
	var scores = 0
	
	for mx in range(N-MIN_SCORED_LINE+1):
		for my in range(N):
			var current_type = play_matrix_v[mx][my]
			var current_score = 0 
			
			for mxs in range(mx, N):
				var i_type = play_matrix_v[mxs][my]
				
				if current_type > 0 and current_type == i_type:
					current_score += 1
				else:
					current_type = 0
			
			if current_score >= MIN_SCORED_LINE:
				scores += current_score
	
	for mx in range(N):
		for my in range(N-MIN_SCORED_LINE+1):
			var current_type = play_matrix_v[mx][my]
			var current_score = 0 
			
			for mys in range(my, N):
				var i_type = play_matrix_v[mx][mys]
				
				if current_type > 0 and current_type == i_type:
					current_score += 1
				else:
					current_type = 0
			
			if current_score >= MIN_SCORED_LINE:
				scores += current_score
	
	return scores


func _on_MainBattle_enemy_won():
	is_finished = true
	$MessageGroup/MessageLabel.hide()
	$MessageGroup/BigLabel.show()
	$MessageGroup/BigLabel.text = "You loose"
	Global.player_info.position = Vector2.ZERO
	Global.battle_info.status = "L"
	$FinishTimer.wait_time = 2
	$FinishTimer.start()


func _on_MainBattle_player_won():
	is_finished = true
	$MessageGroup/MessageLabel.hide()
	$MessageGroup/BigLabel.show()
	$MessageGroup/BigLabel.text = "You win!!"
	Global.map_info.hiden_battle_entry.append(Global.battle_info.entity_name)
	Global.battle_info.status = "W"
	Global.collect_awards()
	$AwardBox.show()
	$FinishTimer.wait_time = 4
	$FinishTimer.start()


func _on_FinishTimer_timeout():
	get_tree().change_scene("res://src/WorldMap.tscn")

func check_spells():
	var mana_value = $PlayerManaBar.current_mana_value
	var new_visible_spells = []
	
	for spell_name in $PlayerSpellBox.visible_spells:
		if $PlayerSpellBox.get_cost_by_spell(spell_name) <= $PlayerManaBar.current_mana_value:
			new_visible_spells.append(spell_name)
	
	$PlayerSpellBox.set_visible_spells(new_visible_spells) 

func do_enemy_damage(dv):
	if dv == 0:
		return
	
	if $PlayerSpellBox.selected_spell == "HealSpell":
		print_debug("HealSpell 2 * ", dv)
		$PlayerHealthBar.set_heal(2*dv)
		$PlayerManaBar.set_damage($PlayerSpellBox.get_cost_by_spell("HealSpell"))
	elif $PlayerSpellBox.selected_spell == "IncreaseDamageSpell":
		print_debug("IncreaseDamageSpell 2 * ", dv)
		$EnemyHealthBar.set_damage(2*dv)
		$PlayerManaBar.set_damage($PlayerSpellBox.get_cost_by_spell("IncreaseDamageSpell"))
	elif $PlayerSpellBox.selected_spell == "EnemySkipSpell":
		print_debug("EnemySkipSpell ", dv)
		$EnemyHealthBar.set_damage(dv)
		$PlayerManaBar.set_damage($PlayerSpellBox.get_cost_by_spell("EnemySkipSpell"))
	elif $PlayerSpellBox.selected_spell == "RandomLineSpell":
		print_debug("RandomLineSpell ", dv)
		$EnemyHealthBar.set_damage(dv)
		$PlayerManaBar.set_damage($PlayerSpellBox.get_cost_by_spell("RandomLineSpell"))
	elif $PlayerSpellBox.selected_spell == "ReflectDamageSpell":
		print_debug("ReflectDamageSpell ", dv)
		$EnemyHealthBar.set_damage(dv)
		$PlayerManaBar.set_damage($PlayerSpellBox.get_cost_by_spell("ReflectDamageSpell"))
	elif $PlayerSpellBox.selected_spell == "RegenSpaceSpell":
		print_debug("RegenSpaceSpell ", dv)
		$EnemyHealthBar.set_damage(dv)
		$PlayerManaBar.set_damage($PlayerSpellBox.get_cost_by_spell("RegenSpaceSpell"))
	else:
		print_debug("Damage ", dv)
		$EnemyHealthBar.set_damage(dv)


func do_player_damage(dv):
	if dv == 0:
		return
	
	if $PlayerSpellBox.selected_spell == "ReflectDamageSpell":
		print_debug("ReflectDamageSpell ", dv)
		$EnemyHealthBar.set_damage(dv)
	else:
		print_debug("Damage ", dv)
		$PlayerHealthBar.set_damage(dv)


func random_lines(mx, my):
	for i in range(N):
		play_matrix[mx][i].set_type((randi() % M) + 1)
		play_matrix[i][my].set_type((randi() % M) + 1)


func regen_space():
	for mx in range(N):
		for my in range(N):
			play_matrix[mx][my].set_type((randi() % M) + 1)

