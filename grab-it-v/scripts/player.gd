extends CharacterBody2D

signal level_finished

const speed = 20
const max_speed = 400
const jump_vel = 400

var gravity = 200

var current_dir = "left"
var upside_down = false
var on_ground = false
var can_jump = true
var planets = []
var gravity_point = Vector2(-1,-1)
var rotation_rad = 0.0

func _ready() -> void:	
	pass

func _physics_process(delta: float) -> void:
	movement(delta)
	if abs(rotation - (rotation_rad - PI/2)) > 0.01:
		rotation = lerp_angle(rotation, rotation_rad - PI/2, 4 * delta)
	
func movement(delta):
	#Left and Right movement
	var left_vec = Vector2(cos(rotation_rad + 2*PI/5), sin(rotation_rad + 2*PI/5))
	var right_vec = Vector2(cos(rotation_rad - 2*PI/5), sin(rotation_rad - 2*PI/5))
	if Input.is_action_pressed("ui_left"):
		if not upside_down:
			current_dir = "left"
			velocity += left_vec * speed
		else:
			current_dir = "right"
			velocity += right_vec * speed
	elif Input.is_action_pressed("ui_right"):
		if not upside_down:
			current_dir = "right"
			velocity += right_vec * speed
		else:
			current_dir = "left"
			velocity += left_vec * speed
	
	#Determine Orientation
	#if Input.is_action_just_released("ui_left") or Input.is_action_just_released("ui_right"):
		#print("hello")
		#if rotation < 3*PI/5 and rotation > -3*PI/5:
			#upside_down = false
		#else:
			#upside_down = true
	
	if velocity.length() > max_speed:
		velocity = velocity * (max_speed / velocity.length())
	
	#Jumping and Gravity
	if Input.is_action_pressed("ui_up") and on_ground and can_jump:
		velocity = Vector2(cos(rotation_rad + PI), sin(rotation_rad + PI)) * jump_vel
		can_jump = false
		$Jump_timer.start()
	elif gravity_point == Vector2(-1,-1):
		gravity_force(delta, Vector2(600, 300))
	else:
		gravity_force(delta, gravity_point)
	
	# Drag
	if on_ground:
		velocity = velocity * 0.9
		
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
	elif area.is_in_group("Flag"):
		level_finished.emit()
		print("hey")

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
