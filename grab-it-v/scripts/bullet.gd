extends Area2D

const speed = 200

var direction = Vector2(1.0,0.0)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
