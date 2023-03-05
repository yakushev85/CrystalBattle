extends Node2D

const FOG_C_DIST = 4

func _ready():		
	if Global.player_info.position != Vector2.ZERO:
		$Player.position = Global.player_info.position

	clear_fog()
	

func clear_fog():
	var cell_position = $FogTileMap.world_to_map($Player.position)
	
	for ix in range(cell_position.x-FOG_C_DIST, cell_position.x+FOG_C_DIST):
		for iy in range(cell_position.y-FOG_C_DIST, cell_position.y+FOG_C_DIST):
			var current_position = Vector2(ix, iy)
			$FogTileMap.set_cellv(current_position, -1)
	
	$FogTileMap.update_bitmask_region()


func _on_Player_moving_done():
	clear_fog()
