extends Node2D

const FOG_C_DIST = 4

@export var arrow_scene: PackedScene

var current_arrow

var path = []
var map
var is_player_moving = false
var is_gfinished = false

func _ready():
	# TODO refactor to use fog
	#$FogTileMap.z_index = 120
	$UIGroup.z_index = 125
	$UIGroup/FinishedLabel.hide()
			
	if Global.player_info.position != Vector2.ZERO:
		$Player.position = Global.player_info.position
		$UIGroup/SayBox.hide()
		prepeare_fog()
	else:
		clear_fog()
		show_intro_say()
	
	is_gfinished = Global.is_game_finished()
	
	if is_gfinished:
		$UIGroup/FinishedLabel.show()
	
	setup_navserver()
	$Player.play_anim()
	

func _input(event):
	if event is InputEventMouseButton and not (event as InputEventMouseButton).is_pressed():
		if is_gfinished:
			Global.reset_newgame_data()
			get_tree().change_scene_to_file("res://src/StartScreen.tscn")
		else:
			$Player.event_position = event.position
			_update_navigation_path($Player.position, event.position)
		

func _process(delta):
	if is_player_moving:
		var walk_distance = $Player.speed * delta
		move_along_path(walk_distance)

func clear_fog():
	pass
	# TODO refactor to use fog
	#var cell_position = $FogTileMap.local_to_map($Player.position)
	#Global.map_info.cfog_points.append(cell_position)
	#clear_fog_p(cell_position)


func clear_fog_p(cell_position):
	for ix in range(cell_position.x-FOG_C_DIST, cell_position.x+FOG_C_DIST):
		for iy in range(cell_position.y-FOG_C_DIST, cell_position.y+FOG_C_DIST):
			var current_position = Vector2(ix, iy)
			# TODO refactor to use fog
			#$FogTileMap.set_cellv(current_position, -1)
	
	#$FogTileMap.update_bitmask_region()


func prepeare_fog():
	for fog_item in Global.map_info.cfog_points:
		clear_fog_p(fog_item)


func player_moving_done():
	hide_arrow()
	clear_fog()
	Global.save_data()
	Global.player_info.position = $Player.position
	$Player.play_anim()


func show_intro_say():
	$UIGroup/SayBox.position = $Player.position
	$UIGroup/SayBox.show()


func player_moving_start():
	$Player.stop_anim()
	create_arrow()
	
	if $UIGroup/SayBox.is_visible_in_tree():
		$UIGroup/SayBox.hide()
	
	$AudioWalkPlayer.play()


func create_arrow():
	if current_arrow == null:
		current_arrow = arrow_scene.instantiate()
		add_child(current_arrow)
		
	current_arrow.set_arrow_position($Player.event_position)
	current_arrow.z_index = 109
	current_arrow.scale.x = 0.5
	current_arrow.scale.y = 0.5
	current_arrow.show()
	
	
func hide_arrow():
	current_arrow.hide()


func setup_navserver():
	map = NavigationServer2D.map_create()
	NavigationServer2D.map_set_active(map, true)

	var region = NavigationServer2D.region_create()
	NavigationServer2D.region_set_transform(region, Transform3D())
	NavigationServer2D.region_set_map(region, map)

	var navigation_poly = NavigationMesh.new()
	navigation_poly = $NavGroup/NavigationRegion2D.navigation_polygon
	NavigationServer2D.region_set_navigation_polygon(region, navigation_poly)

	await get_tree().physics_frame


func move_along_path(distance):
	var last_point = $Player.position
	while path.size():
		var distance_between_points = last_point.distance_to(path[0])
		
		if distance <= distance_between_points:
			$Player.position = last_point.lerp(path[0], distance / distance_between_points)
			return
		
		clear_fog()
		
		distance -= distance_between_points
		last_point = path[0]
		path.remove_at(0)
	
	$Player.position = last_point
	is_player_moving = false
	player_moving_done()


func _update_navigation_path(start_position, end_position):
	path = NavigationServer2D.map_get_path(map,start_position, end_position, true)
	path.remove_at(0)
	is_player_moving = true
	player_moving_start()



func _on_AudioWalkPlayer_finished():
	if is_player_moving:
		$AudioWalkPlayer.play()
