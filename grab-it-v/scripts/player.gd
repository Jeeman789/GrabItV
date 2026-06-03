extends CharacterBody2D

const speed = 50
const max_speed = 600
const jump_vel = -150

var gravity = 60

var current_dir = "left"
var on_ground = false
var can_jump = true
var planets = []
var gravity_point = Vector2(-1,-1)
var rotate = 0
var rotation_deg = 0

func _ready() -> void:	
	pass

func _physics_process(delta: float) -> void:
	movement(delta)
	#if rotate:
	#	rotation = lerp_angle(rotation, rotation_deg, 0.1 * delta)
	
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
	elif gravity_point != Vector2(-1,-1):
		gravity_force(delta)

	move_and_slide()

func gravity_force(delta, point: Vector2 = Vector2(600,300)):
	var normal_force = (point - position).normalized()
	velocity += normal_force * gravity * delta

func find_gravity_point():
	var avg = Vector2(0.0,0.0)
	for i in range(len(planets)):
		avg.x += planets[i].position.x
		avg.y += planets[i].position.y
	gravity_point = avg / len(planets)
	print(gravity_point)

func _on_ground_sensor_body_entered(body: Node2D) -> void:
	if body.has_method("planet"):
		on_ground = true

func _on_ground_sensor_body_exited(body: Node2D) -> void:
	if body.has_method("planet"):
		on_ground = false

func _on_timer_timeout() -> void:
	can_jump = true

func _on_planet_sensor_body_entered(body: Node2D) -> void:
	if body.has_method("atmosphere"):
		planets.append(body)
		find_gravity_point()

func _on_planet_sensor_body_exited(body: Node2D) -> void:
	if body.has_method("atmosphere"):
		planets.append(body)
		find_gravity_point()
		var index = 0
		for i in range(len(planets)):
			if planets[i] == body:
				index = i
		planets.remove_at(index)
		if len(planets) <= 0:
			gravity_point = [-1,-1]
