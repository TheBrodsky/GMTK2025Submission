extends EnemyProjectile
class_name Bouncer


var bounces_remaining: int
var current_direction: Vector2
var current_speed: float

func _ready() -> void:
	assert(config is BouncerConfig, "Bouncer requires BouncerConfig")
	var bouncer_config = config as BouncerConfig
	bounces_remaining = bouncer_config.max_bounces
	current_direction = direction
	current_speed = config.speed
	
	super._ready()

func _process(delta: float) -> void:
	# Calculate next position
	var next_position = global_position + current_direction * current_speed * delta
	
	# Check for wall collisions and bounce
	var camera = get_viewport().get_camera_2d()
	var camera_size = get_viewport().get_visible_rect().size / camera.zoom
	var camera_center = camera.global_position
	var half_width = camera_size.x / 2.0
	var half_height = camera_size.y / 2.0
	
	var bounced = false
	
	# Check horizontal bounds
	var left_bound = camera_center.x - half_width
	var right_bound = camera_center.x + half_width
	if next_position.x <= left_bound or next_position.x >= right_bound:
		current_direction.x = -current_direction.x  # Reflect X direction
		bounced = true
		
		# Clamp position to stay within bounds
		next_position.x = clamp(next_position.x, left_bound, right_bound)
	
	# Check vertical bounds  
	var top_bound = camera_center.y - half_height
	var bottom_bound = camera_center.y + half_height
	if next_position.y <= top_bound or next_position.y >= bottom_bound:
		current_direction.y = -current_direction.y  # Reflect Y direction
		bounced = true
		
		# Clamp position to stay within bounds
		next_position.y = clamp(next_position.y, top_bound, bottom_bound)
	
	# Handle bounce
	if bounced:
		var bouncer_config = config as BouncerConfig
		bounces_remaining -= 1
		current_speed *= bouncer_config.bounce_damping  # Reduce speed on bounce
		
		# Destroy if no bounces left
		if bounces_remaining < 0:
			queue_free()
			return
	
	# Update position and rotation
	global_position = next_position
	rotation = current_direction.angle()
