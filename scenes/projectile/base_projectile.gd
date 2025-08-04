extends CharacterBody2D
class_name BaseProjectile

@export var config: BaseProjectileConfig
@onready var damage_area: Area2D = $DamageArea

var direction: Vector2
var projectile_velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	# Calculate velocity from direction and speed
	projectile_velocity = direction * config.speed
	rotation = projectile_velocity.angle()
	setup_collision()
	damage_area.area_entered.connect(_on_area_entered)
	despawn()

func _physics_process(delta: float) -> void:
	velocity = projectile_velocity
	move_and_slide()
	
	# Check for wall collisions
	if get_slide_collision_count() > 0:
		_on_wall_collision()

func despawn() -> void:
	if config.despawn_time > 0:
		await get_tree().create_timer(config.despawn_time).timeout
		queue_free()

func setup_collision() -> void:
	# Collision layers are set in scene files
	# Override in child classes if needed
	pass

func _on_wall_collision() -> void:
	# Default behavior: despawn when hitting walls
	# Override in child classes for different behavior (e.g., bouncing)
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area is not HitBoxComponent:
		return
	var hitbox : HitBoxComponent = area
	
	var attack = Attack.new()
	attack.attack_damage = config.damage
	attack.damage_source = get_damage_source()
	
	hitbox.damage(attack)
	queue_free()

func get_damage_source() -> Global.ProjectileMode:
	# Override in child classes to return appropriate damage source
	return Global.ProjectileMode.ENEMY

func _on_screen_exited() -> void:
	queue_free()
