extends Node2D

@export var forest_width = 0
@export var forest_height = 0
@export var randomizer_value = ""

const X_STEP = 32
const Y_STEP = 32
const N_TREE = 6


func _ready():
	randomize()
	create_forest()


func create_forest():
	var ri = 0
	var len_r = randomizer_value.length()
	
	for ix in range(0, forest_width, X_STEP):
		for iy in range(0, forest_height, Y_STEP):
			var tree_index = "1"
			
			if len_r == 0:
				tree_index = str((randi() % N_TREE) + 1)
			else:
				tree_index = randomizer_value[(ri % len_r)]
			
			var tree_scene = load("res://src/objects/trees/Tree" + tree_index + ".tscn") as PackedScene
			var tree_item = tree_scene.instantiate()
			
			tree_item.position.x = ix
			tree_item.position.y = iy
			
			ri += 1
			
			add_child(tree_item)
