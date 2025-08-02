extends EnemyProjectile
class_name Bouncer


var bounces_remaining: int
var current_direction: Vector2

func _ready() -> void:
	assert(config is BouncerConfig, "Bouncer requires BouncerConfig")
	var bouncer_config = config as BouncerConfig
	bounces_remaining = bouncer_config.max_bounces
	current_direction = direction
	
	super._ready()

func _process(delta: float) -> void:
	# Calculate next position
	var next_position = global_position + current_direction * config.speed * delta
	
	# Check for wall collisions and bounce
	var viewport_size = get_viewport().get_visible_rect().size
	var half_width = viewport_size.x / 2.0
	var half_height = viewport_size.y / 2.0
	
	var bounced = false
	
	# Check horizontal bounds
	if next_position.x <= -half_width or next_position.x >= half_width:
		current_direction.x = -current_direction.x  # Reflect X direction
		bounced = true
		
		# Clamp position to stay within bounds
		next_position.x = clamp(next_position.x, -half_width, half_width)
	
	# Check vertical bounds  
	if next_position.y <= -half_height or next_position.y >= half_height:
		current_direction.y = -current_direction.y  # Reflect Y direction
		bounced = true
		
		# Clamp position to stay within bounds
		next_position.y = clamp(next_position.y, -half_height, half_height)
	
	# Handle bounce
	if bounced:
		var bouncer_config = config as BouncerConfig
		bounces_remaining -= 1
		config.speed *= bouncer_config.bounce_damping  # Reduce speed on bounce
		
		# Destroy if no bounces left
		if bounces_remaining < 0:
			queue_free()
			return
	
	# Update position and rotation
	global_position = next_position
	rotation = current_direction.angle()
