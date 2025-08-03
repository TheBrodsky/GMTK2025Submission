extends EnemyProjectile
class_name Lurcher

var time_alive: float = 0.0

func _ready() -> void:
	assert(config is LurcherConfig, "Lurcher requires LurcherConfig")
	super._ready()

func _process(delta: float) -> void:
	time_alive += delta
	var lurcher_config = config as LurcherConfig
	
	# Calculate position in the lurch cycle (0 to 1)
	var cycle_progress = fmod(time_alive / lurcher_config.lurch_cycle_time, 1.0)
	
	# Calculate current speed multiplier based on cycle
	var speed_multiplier = _calculate_speed_multiplier(cycle_progress, lurcher_config.pause_ratio, lurcher_config.lurch_distance_multiplier)
	
	# Apply movement with current speed
	var movement = direction * config.speed * speed_multiplier * delta
	global_position += movement

func _calculate_speed_multiplier(cycle_progress: float, pause_ratio: float, lurch_multiplier: float) -> float:
	if cycle_progress < pause_ratio:
		# Paused phase - no movement
		return 0.0
	else:
		# Lurching phase - accelerated movement
		# The multiplier is calculated to maintain the average speed over the full cycle
		var lurch_phase_ratio = 1.0 - pause_ratio
		var average_speed_multiplier = lurch_multiplier / lurch_phase_ratio
		
		# Optional: Add acceleration curve within the lurch phase for more dynamic movement
		var lurch_progress = (cycle_progress - pause_ratio) / lurch_phase_ratio
		var acceleration_curve = _ease_in_out_curve(lurch_progress)
		
		return average_speed_multiplier * acceleration_curve

func _ease_in_out_curve(t: float) -> float:
	# Creates a smooth acceleration/deceleration curve
	# Starts slow, peaks in middle, slows at end
	return 4.0 * t * (1.0 - t) + 0.1  # +0.1 prevents complete stops mid-lurch
