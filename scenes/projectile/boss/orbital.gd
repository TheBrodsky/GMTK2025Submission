extends EnemyProjectile
class_name OrbitalProjectile

@export var orbital_center: Vector2 = Vector2.ZERO
@export var angular_velocity: float = 2.0  # radians per second

var initial_angle: float
var current_radius: float = 0.0
var time_alive: float = 0.0

func _ready() -> void:
	# Store the initial angle from the direction
	initial_angle = direction.angle()
	# Set orbital center to current position if not specified
	if orbital_center == Vector2.ZERO:
		orbital_center = global_position
	super._ready()

func _process(delta: float) -> void:
	time_alive += delta
	
	# Increase radius at constant rate (outward movement)
	current_radius += speed * delta
	
	# Rotate angle at constant rate
	var current_angle = initial_angle + angular_velocity * time_alive
	
	# Convert polar to cartesian and set position
	global_position = orbital_center + Vector2(
		current_radius * cos(current_angle),
		current_radius * sin(current_angle)
	)
	
	# Calculate velocity direction for proper rotation
	var velocity_direction = Vector2(
		speed * cos(current_angle) - current_radius * angular_velocity * sin(current_angle),
		speed * sin(current_angle) + current_radius * angular_velocity * cos(current_angle)
	)
	
	# Face movement direction
	rotation = velocity_direction.angle()
