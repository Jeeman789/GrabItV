extends Node

@export var player : CharacterBody2D

var level_order = [
	"res://scenes/levels/proto_level.tscn",
	"res://scenes/levels/proto_level_2.tscn"
]
var current_level_index = 0
var current_level = null

func _ready():
	EventBus.level_finished.connect(_on_level_finished)
	next_scene(true)

func next_scene(first: bool = false):
	clear_scene()
	
	if not first:
		current_level_index += 1
	
	var level = load(level_order[current_level_index])
	if level:
		current_level = level.instantiate()
		add_child(current_level)
		
		var level_data = load_json_file("res://resources/level_data.json")
		player.position = Vector2(level_data["levels"][current_level.name]["spawn_point"]["x"], level_data["levels"][current_level.name]["spawn_point"]["y"])
		
	else:
		printerr("Failed to load level path: ", level_order[current_level_index])

func clear_scene():
	if is_instance_valid(current_level):
		current_level.queue_free()
		current_level = null

func load_json_file(file_path: String):
	var data = null
	if FileAccess.file_exists(file_path):
		var json_string = FileAccess.get_file_as_string(file_path)
		data = JSON.parse_string(json_string)
		
	return data

func _on_level_finished() -> void:
	next_scene()
