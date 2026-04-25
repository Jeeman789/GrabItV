extends CharacterBody2D

const speed = 50
const max_speed = 600
const jump_vel = -150

var gravity = 60

var current_dir = "left"
var rotate = 0
var gravity_point = [0,0]
var rotation_deg = 0

func _ready() -> void:	
	pass

func _physics_process(delta: float) -> void:
	movement(delta)
	if rotate:
		rotation = lerp_angle(rotation, rotation_deg, 0.1 * delta)
	
func movement(delta):
	if Input.is_action_pressed("ui_left"):
		current_dir = "left"
		velocity.x -= speed
	elif Input.is_action_pressed("ui_right"):
		current_dir = "right"
		velocity.x += speed
	
	if Input.is_action_pressed("ui_up"):
		velocity.y = jump_vel
	else:
		velocity.y += gravity * delta
	
	velocity = velocity.limit_length(max_speed)
	move_and_slide()
	print(velocity)

func _on_gravity_sensor_body_entered(body: Node2D) -> void:
	if body.has_method("planet"):
		rotate += 1
		find_rotation(body, true)


func _on_gravity_sensor_body_exited(body: Node2D) -> void:
	if body.has_method("planet"):
		rotate -= 1
		find_rotation(body, false)

func find_rotation(planet, isAdding):
	if isAdding:
		gravity_point = (gravity_point * (rotate - 1)) + planet.position / rotate
	else:
		gravity_point = (gravity_point * rotate - planet.position) / (rotate - 1)
	
	rotation_deg = get_angle_to(gravity_point)
	
	
