extends KinematicBody2D

export var down_speed = 600

var type
var go_down_y = -1

func set_type(new_type):
	type = new_type
	$ItemSprite.texture = load("res://assets/items/shiny/" + str(type) + ".png")

func get_type():
	return type
	
func _ready():
	$ItemSprite.show()
	$RemoveItemSprite.hide()
	$RemoveItemSprite.playing = false
	
func _process(delta):
	if go_down_y <= 0 or position.y == go_down_y:
		return
	
	var velocity = Vector2(0, 1)
	position += velocity * down_speed * delta
	
	if position.y > go_down_y:
		position.y = go_down_y
		go_down_y = -1

func go_down(gdy):
	go_down_y = gdy

func remove_with_animation():
	$ItemSprite.hide()
	$RemoveItemSprite.show()
	$RemoveItemSprite.playing = true

func _on_RemoveItemSprite_animation_finished():
	queue_free()
