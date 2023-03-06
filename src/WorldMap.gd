extends Node2D

const FOG_C_DIST = 4

func _ready():		
	if Global.player_info.position != Vector2.ZERO:
		$Player.position = Global.player_info.position
		prepeare_fog()
	else:
		clear_fog()
	

func clear_fog():
	var cell_position = $FogTileMap.world_to_map($Player.position)
	Global.map_info.cfog_points.append(cell_position)
	clear_fog_p(cell_position)


func clear_fog_p(cell_position):
	for ix in range(cell_position.x-FOG_C_DIST, cell_position.x+FOG_C_DIST):
		for iy in range(cell_position.y-FOG_C_DIST, cell_position.y+FOG_C_DIST):
			var current_position = Vector2(ix, iy)
			$FogTileMap.set_cellv(current_position, -1)
	
	$FogTileMap.update_bitmask_region()


func prepeare_fog():
	for fog_item in Global.map_info.cfog_points:
		clear_fog_p(fog_item)


func _on_Player_moving_done():
	clear_fog()
