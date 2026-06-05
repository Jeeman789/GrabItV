extends Node

var level_order = [
	"res://scenes/proto_level.tscn",
	"res://scenes/proto_level_2.tscn"
]
var current_level_index = 0

func next_scene():
	current_level_index += 1
	get_tree().change_scene_to_file(level_order[current_level_index])
