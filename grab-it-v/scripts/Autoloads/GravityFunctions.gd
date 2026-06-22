extends Node

func find_gravity_point(planets):
	var avg = Vector2(0.0,0.0)
	for i in range(len(planets)):
		avg += planets[i]
	return avg / len(planets)
