extends CharacterBody2D

const speed = 50
const max_speed = 600
const jump_vel = -150

var gravity = 60

var current_dir = "left"
var rotate = false

func _ready() -> void:	
	pass

func _physics_process(delta: float) -> void:
	movement(delta)
	rotate()
	
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

func rotate():
	

func _on_gravity_sensor_body_entered(body: Node2D) -> void:
	if body.has_method("planet"):
		


func _on_gravity_sensor_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
