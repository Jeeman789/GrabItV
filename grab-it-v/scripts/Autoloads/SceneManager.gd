extends Node

var level_order = [
	"res://scenes/levels/proto_level.tscn",
	"res://scenes/levels/proto_level_2.tscn"
]
var current_level_index = 0
var current_level = null

func _ready():
	print("Ready called on:", self)
	next_scene(true)

func next_scene(first: bool = false):
	if is_instance_valid(current_level):
		current_level.queue_free()
		current_level = null
	
	if not first:
		current_level_index += 1
	
	var level = load(level_order[current_level_index])
	if level:
		current_level = level.instantiate()
		SceneManager.add_child(current_level)
		
		
	else:
		printerr("Failed to load level path: ", level_order[current_level_index])
	
	
