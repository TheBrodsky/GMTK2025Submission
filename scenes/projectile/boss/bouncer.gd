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
	# Move normally - bouncing is handled by collision signals
	global_position += current_direction * current_speed * delta
	rotation = current_direction.angle()

func _on_wall_collision(body: Node2D) -> void:
	# Override parent behavior: bounce instead of despawning
	if bounces_remaining <= 0:
		queue_free()
		return
	
	# Determine bounce direction based on wall position
	# Since walls are only vertical or horizontal, we can use simple position checks
	var camera = get_viewport().get_camera_2d()
	var camera_size = get_viewport().get_visible_rect().size / camera.zoom
	var camera_center = camera.global_position
	var half_width = camera_size.x / 2.0
	var half_height = camera_size.y / 2.0
	
	var bullet_pos = global_position
	var left_bound = camera_center.x - half_width
	var right_bound = camera_center.x + half_width
	var top_bound = camera_center.y - half_height
	var bottom_bound = camera_center.y + half_height
	
	# Check which wall we're closest to and bounce accordingly
	# (In a better world, bullets would be CharacterBody2D and we'd use collision normals)
	if abs(bullet_pos.x - left_bound) < 50 or abs(bullet_pos.x - right_bound) < 50:
		# Hit left or right wall - reflect X
		current_direction.x = -current_direction.x
	elif abs(bullet_pos.y - top_bound) < 50 or abs(bullet_pos.y - bottom_bound) < 50:
		# Hit top or bottom wall - reflect Y
		current_direction.y = -current_direction.y
	else:
		# Fallback: reverse both components
		current_direction = -current_direction
	
	# Apply bounce effects
	var bouncer_config = config as BouncerConfig
	bounces_remaining -= 1
	current_speed *= bouncer_config.bounce_damping
