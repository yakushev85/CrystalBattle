extends Node2D

const n_index = 100.0

export var max_offset = 20.0
var a_index = 0.0

func set_arrow_position(p: Vector2):
	a_index = 0.0
	position = p
	$Arrow2D.position = Vector2.ZERO
	

func _process(delta):
	if a_index == n_index:
		a_index = 0.0
	
	$Arrow2D.position.y = -1 * max_offset * sin((a_index/n_index) * PI)
	a_index += 1
