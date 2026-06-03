extends CharacterBody2D

const speed = 50
const max_speed = 600
const jump_vel = -150

var gravity = 300

var current_dir = "left"
var on_ground = false
var can_jump = true
var planets = []
var gravity_point = Vector2(-1,-1)
var rotation_rad = 0.0

func _ready() -> void:	
	pass

func _physics_process(delta: float) -> void:
	movement(delta)
	print(rotation_rad)
	if abs(rotation - (rotation_rad - PI/2)) > 0.01:
		rotation = lerp_angle(rotation, rotation_rad - PI/2, 4 * delta)
	
func movement(delta):
	#Left and Right movement
	if Input.is_action_pressed("ui_left"):
		current_dir = "left"
		if velocity.x > 0:
			velocity.x = 0
		velocity.x -= speed
		if velocity.x < -max_speed:
			velocity.x = -max_speed
	elif Input.is_action_pressed("ui_right"):
		current_dir = "right"
		if velocity.x < 0:
			velocity.x = 0
		velocity.x += speed
		if velocity.x > max_speed:
			velocity.x = max_speed
	
	if Input.is_action_pressed("ui_up") and on_ground and can_jump:
		velocity.y = jump_vel
		can_jump = false
		$Jump_timer.start()
	elif gravity_point == Vector2(-1,-1):
		gravity_force(delta, Vector2(600, 300))
	else:
		gravity_force(delta, gravity_point)

	move_and_slide()

func gravity_force(delta, point: Vector2):
	var direction = (point - position).normalized()
	rotation_rad = direction.angle()
	velocity += direction * gravity * delta

func find_gravity_point():
	var avg = Vector2(0.0,0.0)
	for i in range(len(planets)):
		avg += planets[i]
	gravity_point = avg / len(planets)

func _on_ground_sensor_body_entered(body: Node2D) -> void:
	if body.is_in_group("Planet"):
		on_ground = true

func _on_ground_sensor_body_exited(body: Node2D) -> void:
	if body.is_in_group("Planet"):
		on_ground = false

func _on_timer_timeout() -> void:
	can_jump = true

func _on_planet_sensor_area_entered(area: Area2D) -> void:
	if area.is_in_group("Atmosphere"):
		planets.append(area.global_position)
		find_gravity_point()

func _on_planet_sensor_area_exited(area: Area2D) -> void:
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
