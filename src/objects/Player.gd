extends KinematicBody2D

export var speed = 100
var generated_velocity = Vector2.ZERO
var event_position = Vector2.ZERO

func _ready():
	$AnimatedSprite.animation = "idle"
	$AnimatedSprite.playing = true

func _process(delta):
	if generated_velocity.length() > 0:
		generated_velocity = generated_velocity.normalized() * speed
		
		$AnimatedSprite.flip_h = generated_velocity.x < 0
		
		$AnimatedSprite.animation = "run"
		
		generated_velocity = generated_velocity * delta
	
		var collision_obj = move_and_collide(generated_velocity)
		
		var dest_vector = event_position - position
		var dest_distance = sqrt(dest_vector.x*dest_vector.x + dest_vector.y*dest_vector.y)
		
		if collision_obj != null or dest_distance < 1:
			generated_velocity = Vector2.ZERO
	else:
		$AnimatedSprite.animation = "idle"
	

func _input(event):
	if event is InputEventMouseButton and not (event as InputEventMouseButton).is_pressed():
		event_position = event.position
		generated_velocity = event_position - position
		var norm_size = max(abs(generated_velocity.x), abs(generated_velocity.y))
		
		generated_velocity = generated_velocity / norm_size
