extends Node

var planets = []

func gravity_force(delta, point: Vector2):
	var direction = (point - position).normalized()
	rotation_rad = direction.angle()
	velocity += direction * gravity * delta

func find_gravity_point(planets):
	var avg = Vector2(0.0,0.0)
	for i in range(len(planets)):
		avg += planets[i]
	return avg / len(planets)

func gravity_body_entered(area):
	if area.is_in_group("Atmosphere"):
		planets.append(area.global_position)
		find_gravity_point(planets)

func gravity_body_exited(area):
	if area.is_in_group("Atmosphere"):
		var index = 0
		for i in range(len(planets)):
			if planets[i] == area.global_position:
				index = i
		planets.remove_at(index)
		if len(planets) <= 0:
			gravity_point = Vector2(-1,-1)
		else:
			find_gravity_point()
