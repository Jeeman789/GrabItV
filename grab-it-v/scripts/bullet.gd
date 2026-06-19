extends Area2D

const speed = 200

func _physics_process(delta: float) -> void:
	velocity.x -= speed
	
	move_and_slide()
