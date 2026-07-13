extends Control

var current_ui = null
var camera:Camera2D = null

@export var player:CharacterBody2D

func _ready() -> void:
	camera = player.get_child(5)
	EventBus.game_over.connect(_on_game_over)
	EventBus.pause.connect(_on_pause)

func _on_game_over():
	spawn_scene("res://scenes/UI/game_over.tscn")

func _on_pause():
	if get_tree().paused:
		clear_ui()
		get_tree().paused = false
	else:
		spawn_scene("res://scenes/UI/pause_menu.tscn")
		get_tree().paused = true

func clear_ui():
	if is_instance_valid(current_ui):
		current_ui.queue_free()
		current_ui = null

func spawn_scene(input_scene):
	get_tree().paused = true
	
	clear_ui()
	
	var scene = load(input_scene)
	if scene:
		current_ui = scene.instantiate()
		
		$CanvasLayer/CenterContainer.add_child(current_ui)
