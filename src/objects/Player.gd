extends KinematicBody2D

signal moving_done
signal moving_start

var bridge_rects = [
	{
		"x0": 112, "y0": 128, "x1": 128, "y1": 160, 
		"xS": 112, "yS": 128, "xD": 256, "yD": 128
	},
	{
		"x0": 224, "y0": 128, "x1": 240, "y1": 160, 
		"xS": 240, "yS": 128, "xD": 96, "yD": 128
	},
	{
		"x0": 304, "y0": 32, "x1": 320, "y1": 64, 
		"xS": 304, "yS": 32, "xD": 416, "yD": 32
	},
	{
		"x0": 384, "y0": 32, "x1": 400, "y1": 64, 
		"xS": 400, "yS": 32, "xD": 272, "yD": 32
	},
	{
		"x0": 512, "y0": 224, "x1": 544, "y1": 288, 
		"xS": 528, "yS": 244, "xD": 528, "yD": 368
	},
	{
		"x0": 512, "y0": 320, "x1": 544, "y1": 336, 
		"xS": 528, "yS": 336, "xD": 528, "yD": 208
	},
	{
		"x0": 896, "y0": 192, "x1": 928, "y1": 256, 
		"xS": 912, "yS": 192, "xD": 912, "yD": 352
	},
	{
		"x0": 896, "y0": 320, "x1": 928, "y1": 336, 
		"xS": 912, "yS": 336, "xD": 912, "yD": 176
	},
	{
		"x0": 1008, "y0": 32, "x1": 1024, "y1": 64, 
		"xS": 1008, "yS": 32, "xD": 1184, "yD": 32
	},
	{
		"x0": 1152, "y0": 32, "x1": 1168, "y1": 64, 
		"xS": 1168, "yS": 32, "xD": 992, "yD": 32
	},
]

export var speed = 100
var generated_velocity = Vector2.ZERO
var event_position = Vector2.ZERO
var is_bridge_animation
var bridge_data
var bridge_velocity

func _ready():
	is_bridge_animation = false
	bridge_data = null
	bridge_velocity = Vector2.ZERO

func _process(delta):
	if is_bridge_animation:
		bridge_velocity = bridge_velocity.normalized() * speed * delta
		
		position = position + bridge_velocity
		
		var dest_vector = Vector2(bridge_data.xD, bridge_data.yD) - position
		var dest_distance = sqrt(dest_vector.x*dest_vector.x + dest_vector.y*dest_vector.y)
		
		if dest_distance < 1:
			is_bridge_animation = false
			emit_signal("moving_done")
		
		Global.player_info.position = position
			
	elif generated_velocity.length() > 0:
		generated_velocity = generated_velocity.normalized() * speed * delta
	
		var collision_obj = move_and_collide(generated_velocity)
		
		var dest_vector = event_position - position
		var dest_distance = sqrt(dest_vector.x*dest_vector.x + dest_vector.y*dest_vector.y)
		
		if collision_obj != null or dest_distance < 1:
			generated_velocity = Vector2.ZERO
			check_bridge()
			emit_signal("moving_done")
		
		Global.player_info.position = position
	

func _input(event):
	if event is InputEventMouseButton and not (event as InputEventMouseButton).is_pressed():
		event_position = event.position
		generated_velocity = event_position - position
		var norm_size = max(abs(generated_velocity.x), abs(generated_velocity.y))
		
		generated_velocity = generated_velocity / norm_size
		
		emit_signal("moving_start")

func check_bridge():
	for bridge_item in bridge_rects:
		if bridge_item.x0 < position.x and position.x < bridge_item.x1 and bridge_item.y0 < position.y and position.y < bridge_item.y1:
			position.x = bridge_item.xS
			position.y = bridge_item.yS
			
			bridge_velocity = Vector2(bridge_item.xD, bridge_item.yD) - Vector2(bridge_item.xS, bridge_item.yS)
			var norm_size = max(abs(bridge_velocity.x), abs(bridge_velocity.y))
		
			bridge_velocity = bridge_velocity / norm_size
			
			is_bridge_animation = true
			bridge_data = bridge_item
			
			return
