extends CharacterBody2D

const speed = 50
const max_speed = 600
const jump_vel = -150

var gravity = 60

var current_dir = "left"
var on_ground = false
var can_jump = true
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
	else:
		velocity.y += gravity * delta

	move_and_slide()


func _on_ground_sensor_body_entered(body: Node2D) -> void:
	if body.has_method("planet"):
		on_ground = true
		print("hello")


func _on_ground_sensor_body_exited(body: Node2D) -> void:
	if body.has_method("planet"):
		on_ground = false

func _on_timer_timeout() -> void:
	can_jump = true
