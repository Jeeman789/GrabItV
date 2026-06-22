extends Area2D

@export var bullet:PackedScene = preload("res://scenes/enemies/bullet.tscn")

func _ready():
	pass


func _on_fire_bullet_timeout() -> void:
	
	var current_bullet = bullet.instantiate()
	current_bullet.global_position = $muzzle.global_position
	get_tree().root.add_child(current_bullet)
