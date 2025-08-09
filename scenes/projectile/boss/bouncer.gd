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

func _physics_process(_delta: float) -> void:
	# Use CharacterBody2D physics instead of manual movement
	velocity = current_direction * current_speed
	move_and_slide()
	rotation = velocity.angle()
	
	# Handle bouncing with proper collision normals
	if get_slide_collision_count() > 0:
		_on_wall_collision()

func _on_wall_collision() -> void:
	# Override parent behavior: bounce instead of despawning
	if bounces_remaining <= 0:
		queue_free()
		return
	
	# Get the collision normal from the first collision
	var collision = get_slide_collision(0)
	var normal = collision.get_normal()
	
	# Reflect the direction using the collision normal
	current_direction = current_direction.bounce(normal)
	
	# Apply bounce effects
	var bouncer_config = config as BouncerConfig
	bounces_remaining -= 1
	current_speed *= bouncer_config.bounce_damping
