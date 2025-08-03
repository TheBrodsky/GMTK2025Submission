extends EnemyProjectile
class_name OrbitalProjectile

var initial_angle: float
var current_radius: float = 0.0
var time_alive: float = 0.0
var orbital_center: Vector2

func _ready() -> void:
	assert(config is OrbitalConfig, "OrbitalProjectile requires OrbitalConfig")
	# Store the initial angle from the direction
	initial_angle = direction.angle()
	# Set orbital center to spawn position
	orbital_center = global_position
	super._ready()

func _process(delta: float) -> void:
	time_alive += delta
	var orbital_config = config as OrbitalConfig
	
	# Increase radius at constant rate (outward movement) using base speed
	current_radius += config.speed * delta
	
	# Rotate angle at constant rate
	var current_angle = initial_angle + orbital_config.angular_speed * time_alive
	
	# Convert polar to cartesian and set position
	global_position = orbital_center + Vector2(cos(current_angle), sin(current_angle)) * current_radius
