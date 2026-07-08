extends CharacterBody2D

const speed = 400
const grav_speed = 20

var direction = Vector2(1.0,0.0)
var planets = []
var point_of_gravity = Vector2(-1,-1)
var in_orbit = false
var rotation_rad = 0.0

func _ready() -> void:
	velocity = direction * speed

func _physics_process(delta: float) -> void:
	movement(delta)
	if abs(rotation - (rotation_rad)) > 0.01:
		rotation = lerp_angle(rotation, rotation_rad, 4 * delta)

func movement(delta):
	if in_orbit:
		gravity_force(point_of_gravity)
	
	move_and_slide()

func gravity_force(point: Vector2):
	var grav_dir = (point - position).normalized()
	print(grav_dir)
	rotation_rad = direction.angle()
	velocity += grav_dir * grav_speed
	velocity = velocity.normalized() * speed


func _on_bullet_sensor_area_entered(area: Area2D) -> void:
	print("hey")
	if area.is_in_group("Atmosphere"):
		planets.append(area.global_position)
		point_of_gravity = GravityFunctions.find_gravity_point(planets)
		in_orbit = true


func _on_bullet_sensor_area_exited(area: Area2D) -> void:
	if area.is_in_group("Atmosphere"):
		var index = 0
		for i in range(len(planets)):
			if planets[i] == area.global_position:
				index = i
		planets.remove_at(index)
		if len(planets) <= 0:
			in_orbit = false
		else:
			point_of_gravity = GravityFunctions.find_gravity_point(planets)
