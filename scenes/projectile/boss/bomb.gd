extends EnemyProjectile
class_name Bomb

@export var explosion_projectile_scene: PackedScene  # What projectile to spawn on explosion

var current_speed: float
var has_exploded: bool = false
var time_to_explosion: float
var time_alive: float = 0.0
var sprite_node: Node2D

func _ready() -> void:
	assert(config is BombConfig, "Bomb requires BombConfig")
	var bomb_config = config as BombConfig
	current_speed = config.speed
	
	$AnimatedSprite2D.visible = false
	$BombSpriteHighlighted.visible = false
	
	# Calculate time to explosion based on detonation mode
	if bomb_config.detonation_mode == BombConfig.DetonationMode.DECELERATION:
		# Calculate time to explosion: time = (initial_speed - threshold) / deceleration
		time_to_explosion = (config.speed - bomb_config.min_speed_threshold) / bomb_config.deceleration
	else:  # TIME_LIMIT mode
		time_to_explosion = bomb_config.time_limit
	
	# Find the sprite node for blinking effect
	sprite_node = get_node("BombSprite")
	super._ready()

func _process(delta: float) -> void:
	if has_exploded:
		return
	
	time_alive += delta
	var bomb_config = config as BombConfig
	
	# Handle movement based on detonation mode
	if bomb_config.detonation_mode == BombConfig.DetonationMode.DECELERATION:
		# Decelerate over time
		current_speed = max(current_speed - bomb_config.deceleration * delta, 0.0)
	else:  # TIME_LIMIT mode - maintain constant speed
		current_speed = config.speed
	
	# Update velocity with new speed
	velocity = direction * current_speed
	
	# Move forward
	global_position += velocity * delta
	
	# Handle progressive blinking effect
	if sprite_node:
		var time_remaining = time_to_explosion - time_alive
		var third = time_to_explosion / 3.0
		
		var blink_frequency = bomb_config.base_blink_frequency
		if time_remaining <= third * 2.0:  # Last two thirds
			blink_frequency *= 2.0
		if time_remaining <= third:  # Last third
			blink_frequency *= 2.0  # Total 4x faster than base
		
		var blink_interval = 1.0 / blink_frequency
		var blink_cycle = fmod(time_alive, blink_interval * 2.0)
		var is_flash_on = blink_cycle < blink_interval
		
		# Flash between bright white and dimmed gray
		if is_flash_on:
			$BombSpriteHighlighted.visible = true
			$BombSprite.visible = false
			#sprite_node.modulate = Color(2.0, 2.0, 2.0, 1.0)  # Bright flash
		else:
			$BombSpriteHighlighted.visible = false
			$BombSprite.visible = true
			#sprite_node.modulate = Color(0.7, 0.7, 0.7, 1.0)  # Dimmed gray
	
	# Check detonation conditions based on mode
	if bomb_config.detonation_mode == BombConfig.DetonationMode.DECELERATION:
		# Check if stopped and should explode
		if current_speed <= bomb_config.min_speed_threshold:

			explode()
	else:  # TIME_LIMIT mode
		# Check if time limit reached
		if time_alive >= bomb_config.time_limit:
			$BombSpriteHighlighted.visible = false
			$BombSprite.visible = false
			$AnimatedSprite2D.visible = true
			$AnimatedSprite2D.play("default")
			explode()

func explode() -> void:
	
	if has_exploded:
		return
	
	has_exploded = true
	$BombSpriteHighlighted.visible = false
	$BombSprite.visible = false
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play("default")

	# Create explosion burst using radial pattern
	if explosion_projectile_scene:
		var bomb_config = config as BombConfig
		for i in range(bomb_config.explosion_projectile_count):
			var angle = (2.0 * PI * i) / bomb_config.explosion_projectile_count
			var explosion_projectile = explosion_projectile_scene.instantiate() as BaseProjectile
			explosion_projectile.position = global_position
			explosion_projectile.direction = Vector2(cos(angle), sin(angle))
			
			# Create a config for the explosion projectile if it doesn't have one
			if not explosion_projectile.config:
				explosion_projectile.config = BaseProjectileConfig.new()
			explosion_projectile.config.speed = bomb_config.explosion_speed
			
			get_tree().root.add_child(explosion_projectile)
	
	# Destroy the bomb
	queue_free()
