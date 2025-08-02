extends EnemyProjectile
class_name Bouncer

@export var max_bounces: int = 3  # Number of bounces before destroying
@export var bounce_damping: float = 0.9  # Speed reduction per bounce (1.0 = no damping)

var bounces_remaining: int
var current_direction: Vector2

func _ready() -> void:
	bounces_remaining = max_bounces
	current_direction = direction
	
	super._ready()

func _process(delta: float) -> void:
	# Calculate next position
	var next_position = global_position + current_direction * speed * delta
	
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
		bounces_remaining -= 1
		speed *= bounce_damping  # Reduce speed on bounce
		
		# Destroy if no bounces left
		if bounces_remaining < 0:
			queue_free()
			return
	
	# Update position and rotation
	global_position = next_position
	rotation = current_direction.angle()
