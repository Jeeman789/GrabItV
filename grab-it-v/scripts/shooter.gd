extends Area2D

@export var bullet:PackedScene = preload("res://scenes/enemies/bullet.tscn")
@onready var muzzle = $Muzzle

var direction_muzzle = Vector2(1,0)

func _ready():
	pass

func _on_fire_bullet_timeout() -> void:
	var current_bullet = bullet.instantiate()
	
	direction_muzzle = muzzle.global_position - global_position
	direction_muzzle = direction_muzzle.normalized()
	
	current_bullet.global_position = muzzle.global_position
	current_bullet.direction = direction_muzzle
	current_bullet.rotation = direction_muzzle.angle()
	
	get_tree().root.add_child(current_bullet)
