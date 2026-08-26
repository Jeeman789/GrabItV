extends Line2D

@export var radius: float = 1820
@export var point_count: int = 64 # Higher numbers make it smoother

func _ready():
	if get_parent().is_in_group("Small_Planet"):
		radius = 1820
	if get_parent().is_in_group("Med_Planet"):
		radius = 2980
	if get_parent().is_in_group("Big_Planet"):
		radius = 9325
	points = [] # Clear any editor points
	closed = true # Automatically connects the first and last point
	
	for i in range(point_count):
		var angle = i * 2.0 * PI / point_count
		var point = Vector2(cos(angle), sin(angle)) * radius
		add_point(point)
