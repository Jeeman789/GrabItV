extends Node2D

var planets = []

func _ready() -> void:
	for child in get_children():
		if child.has_method("planet"):
			planets.append(child)
