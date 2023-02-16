extends Node2D

export (PackedScene) var item_scene
export var item_size = 64

# matrix size
const N = 10
# matrix items
const M = 8
# minimum length for scored line
const min_scored_line = 3
# matrix of items
var play_matrix = []
var player_health = 100
var enemy_health = 100

var is_player_turn
var is_enemy_turn

func print_matrix_data(comm = ""):
	var line_m = ""
	
	for mxi in range(N):
		for myi in range(N):
			if play_matrix[mxi][myi] == null:
				line_m += "n"
			else:
				line_m += str(play_matrix[mxi][myi].get_type())
				
		line_m += "\n"
	
	print_debug(comm, "\n", line_m)

func generate_matrix():
	for mx in range(N):
		play_matrix.append([])
		
		for my in range(N):
			var item = item_scene.instance()
			
			item.set_type((randi() % M) + 1)
			
			item.position.x = $GameArea.position.x + item_size*mx + item_size/2
			item.position.y = $GameArea.position.y + item_size*my + item_size/2
			
			play_matrix[mx].append(item)
			add_child(play_matrix[mx][my])

func check_lines():
	var scored_lines = []
	
	for mx in range(N-min_scored_line+1):
		for my in range(N):
			var current_type = play_matrix[mx][my].get_type()
			var current_score = 0 
			
			for mxs in range(mx, N):
				var i_type = play_matrix[mxs][my].get_type()
				
				if current_type > 0 and current_type == i_type:
					current_score += 1
				else:
					current_type = 0
			
			if current_score >= min_scored_line:
				var check_result = {}
				check_result.score = current_score
				check_result.mx0 = mx
				check_result.my0 = my
				check_result.mx1 = mx+current_score-1
				check_result.my1 = my
				scored_lines.append(check_result)
	
	for mx in range(N):
		for my in range(N-min_scored_line+1):
			var current_type = play_matrix[mx][my].get_type()
			var current_score = 0 
			
			for mys in range(my, N):
				var i_type = play_matrix[mx][mys].get_type()
				
				if current_type > 0 and current_type == i_type:
					current_score += 1
				else:
					current_type = 0
			
			if current_score >= min_scored_line:
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
	var mx = (mouse_x - $GameArea.position.x) / item_size
	var my = (mouse_y - $GameArea.position.y) / item_size
	
	if mx < 0 or mx >= N or my < 0 or my >= N:
		return
	
	remove_cell_m(mx, my)

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
					play_matrix[mxi][myi+1].go_down($GameArea.position.y + item_size*(myi+1) + item_size/2)

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
			item.position.x = $GameArea.position.x + item_size*empty_mx + item_size/2
			item.position.y = $GameArea.position.y - item_size*(N-empty_my+3) + item_size/2
			# update matrix data
			play_matrix[empty_mx][empty_my] = item
			add_child(item)
			# apply animation
			item.go_down($GameArea.position.y + item_size*empty_my + item_size/2)	

func update_matrix_play():
	move_upper_lines()
	
	var scored_lines = check_lines()
	
	if scored_lines.size() > 0:
		remove_lines(scored_lines)
	
	return scored_lines

func _ready():
	randomize()
	is_player_turn = false
	is_enemy_turn = false

func _on_StartTimer_timeout():
	generate_matrix()
	$GameTimer.start()

func _on_GameTimer_timeout():
	var scored_lines = update_matrix_play()
	if scored_lines.size() == 0:
		$GameTimer.stop()
		
		if is_player_turn:
			is_player_turn = false
			is_enemy_turn = true
		elif is_enemy_turn:
			is_player_turn = true
			is_enemy_turn = false
		else:
			is_player_turn = randf() > 0.5
			is_enemy_turn = not is_player_turn
		
		if is_enemy_turn:
			$MessageGroup/MessageLabel.text = "Enemy's turn"
			$EnemyTimer.start()
			
		if is_player_turn:
			$MessageGroup/MessageLabel.text = "Your turn"
	
	var damage = 0
	for score_line in scored_lines:
		damage += score_line.score
	
	if is_player_turn:
		$EnemyHealthBar.set_damage(damage)
	elif is_enemy_turn:
		$PlayerHealthBar.set_damage(damage)

func _input(event):
	if is_player_turn and event is InputEventMouseButton and not (event as InputEventMouseButton).is_pressed():
		remove_cell(event.position.x, event.position.y)
		$EnemyHealthBar.set_damage(1)
		$GameTimer.start()

func enemyTurn():
	var posible_point = {}
	posible_point.mx = randi() % N
	posible_point.my = randi() % N
	posible_point.score = 1
	print_debug("initial enemy point:", posible_point)
	for mxi in range(N):
		for myi in range(N):
			var current_score = check_point(mxi, myi)
			
			if current_score > posible_point.score:
				posible_point.score = current_score
				posible_point.mx = mxi
				posible_point.my = myi
	
	print_debug("generated enemy point:", posible_point)
	remove_cell_m(posible_point.mx, posible_point.my)
	$PlayerHealthBar.set_damage(1)
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
	
	for mx in range(N-min_scored_line+1):
		for my in range(N):
			var current_type = play_matrix_v[mx][my]
			var current_score = 0 
			
			for mxs in range(mx, N):
				var i_type = play_matrix_v[mxs][my]
				
				if current_type > 0 and current_type == i_type:
					current_score += 1
				else:
					current_type = 0
			
			if current_score >= min_scored_line:
				scores += current_score
	
	for mx in range(N):
		for my in range(N-min_scored_line+1):
			var current_type = play_matrix_v[mx][my]
			var current_score = 0 
			
			for mys in range(my, N):
				var i_type = play_matrix_v[mx][mys]
				
				if current_type > 0 and current_type == i_type:
					current_score += 1
				else:
					current_type = 0
			
			if current_score >= min_scored_line:
				scores += current_score
	
	return scores


func _on_EnemyTimer_timeout():
	enemyTurn()
