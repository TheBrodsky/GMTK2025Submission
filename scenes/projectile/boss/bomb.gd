extends EnemyProjectile
class_name Bomb

@export var deceleration: float = 50.0  # How fast it slows down
@export var explosion_projectile_scene: PackedScene  # What projectile to spawn on explosion
@export var explosion_projectile_count: int = 8  # Number of projectiles in explosion
@export var explosion_speed: float = 200.0  # Speed of explosion projectiles
@export var min_speed_threshold: float = 10.0  # Speed below which bomb explodes
@export var base_blink_frequency: float = 2.0  # Base blinks per second in first third

var current_speed: float
var has_exploded: bool = false
var time_to_explosion: float
var time_alive: float = 0.0
var sprite_node: Node2D

func _ready() -> void:
	current_speed = speed
	# Calculate time to explosion: time = (initial_speed - threshold) / deceleration
	time_to_explosion = (speed - min_speed_threshold) / deceleration
	# Find the sprite node for blinking effect
	sprite_node = get_node("BombSprite")
	super._ready()

func _process(delta: float) -> void:
	if has_exploded:
		return
	
	time_alive += delta
	
	# Decelerate over time
	current_speed = max(current_speed - deceleration * delta, 0.0)
	
	# Update velocity with new speed
	velocity = direction * current_speed
	
	# Move forward
	global_position += velocity * delta
	
	# Handle progressive blinking effect
	if sprite_node:
		var time_remaining = time_to_explosion - time_alive
		var third = time_to_explosion / 3.0
		
		var blink_frequency = base_blink_frequency
		if time_remaining <= third * 2.0:  # Last two thirds
			blink_frequency *= 2.0
		if time_remaining <= third:  # Last third
			blink_frequency *= 2.0  # Total 4x faster than base
		
		var blink_interval = 1.0 / blink_frequency
		var blink_cycle = fmod(time_alive, blink_interval * 2.0)
		var is_flash_on = blink_cycle < blink_interval
		
		# Flash between bright white and dimmed gray
		if is_flash_on:
			sprite_node.modulate = Color(2.0, 2.0, 2.0, 1.0)  # Bright flash
		else:
			sprite_node.modulate = Color(0.7, 0.7, 0.7, 1.0)  # Dimmed gray
	
	# Check if stopped and should explode
	if current_speed <= min_speed_threshold:
		explode()

func explode() -> void:
	if has_exploded:
		return
	
	has_exploded = true
	
	# Create explosion burst using radial pattern
	if explosion_projectile_scene:
		for i in range(explosion_projectile_count):
			var angle = (2.0 * PI * i) / explosion_projectile_count
			var explosion_projectile = explosion_projectile_scene.instantiate() as BaseProjectile
			explosion_projectile.position = global_position
			explosion_projectile.direction = Vector2(cos(angle), sin(angle))
			explosion_projectile.speed = explosion_speed
			get_tree().root.add_child(explosion_projectile)
	
	# Destroy the bomb
	queue_free()
