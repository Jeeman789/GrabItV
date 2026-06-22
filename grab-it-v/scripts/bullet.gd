extends Area2D

const speed = 50

var direction = Vector2(1.0,0.0)
var planets = []
var point_of_gravity = Vector2(-1,-1)

func _physics_process(delta: float) -> void:
	movement(delta)

func movement(delta):
	position += direction * speed * delta

func gravity_force(delta, point: Vector2):
	var direction = (point - position).normalized()
	rotation_rad = direction.angle()
	velocity += direction * gravity * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Atmosphere"):
		planets.append(area.global_position)
		GravityFunctions.find_gravity_point(planets)

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("Atmosphere"):
		var index = 0
		for i in range(len(planets)):
			if planets[i] == area.global_position:
				index = i
		planets.remove_at(index)
		if len(planets) <= 0:
			point_of_gravity = Vector2(-1,-1)
		else:
			GravityFunctions.find_gravity_point(planets)
