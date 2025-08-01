extends Projectile
class_name Sidewinder

@export var wave_amplitude: float = 50.0  # How far side-to-side it moves
@export var wave_frequency: float = 3.0   # How fast the wave oscillates

var time_alive: float = 0.0
var perpendicular_direction: Vector2

func _ready() -> void:
	# Calculate perpendicular direction for side-to-side movement
	perpendicular_direction = Vector2(-direction.y, direction.x)
	
	super._ready()

func _process(delta: float) -> void:
	time_alive += delta
	
	# Calculate forward movement
	var forward_movement = direction * speed * delta
	
	# Calculate sideways oscillation using sin wave
	var sideways_offset = sin(time_alive * wave_frequency) * wave_amplitude
	var previous_sideways_offset = sin((time_alive - delta) * wave_frequency) * wave_amplitude
	var sideways_movement = perpendicular_direction * (sideways_offset - previous_sideways_offset)
	
	# Apply both movements
	global_position += forward_movement + sideways_movement
	
	# Update rotation to face movement direction
	var current_velocity = direction * speed + perpendicular_direction * cos(time_alive * wave_frequency) * wave_amplitude * wave_frequency
	rotation = current_velocity.angle()