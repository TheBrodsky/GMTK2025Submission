extends EnemyProjectile
class_name Sidewinder


var time_alive: float = 0.0
var perpendicular_direction: Vector2

func _ready() -> void:
	assert(config is SidewinderConfig, "Sidewinder requires SidewinderConfig")
	# Calculate perpendicular direction for side-to-side movement
	perpendicular_direction = Vector2(-direction.y, direction.x)
	
	super._ready()

func _process(delta: float) -> void:
	time_alive += delta
	var sidewinder_config = config as SidewinderConfig
	
	# Calculate forward movement
	var forward_movement = direction * config.speed * delta
	
	# Calculate sideways oscillation using sin wave
	var sideways_offset = sin(time_alive * sidewinder_config.wave_frequency) * sidewinder_config.wave_amplitude
	var previous_sideways_offset = sin((time_alive - delta) * sidewinder_config.wave_frequency) * sidewinder_config.wave_amplitude
	var sideways_movement = perpendicular_direction * (sideways_offset - previous_sideways_offset)
	
	# Apply both movements
	global_position += forward_movement + sideways_movement
