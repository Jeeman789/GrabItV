extends Node2D

var ball_pos: Vector2

func _physics_process(delta: float) -> void:
	global_rotation = 0
	ball(delta)

func ball(delta):
	var mouse_direction:Vector2 = global_position.direction_to(get_global_mouse_position())
	$ball.position = mouse_direction * 2500
	ball_pos = $ball.global_position
