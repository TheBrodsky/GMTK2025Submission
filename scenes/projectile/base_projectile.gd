extends Area2D
class_name BaseProjectile

@export var speed: int = 400
@export var despawn_time: int = -1 # in seconds, -1 means no lifetime despawn
@export var damage: int = 10 # TODO remove damage; the player only has 1 hp

var direction: Vector2
var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	# Calculate velocity from direction and speed
	velocity = direction * speed
	rotation = velocity.angle()
	setup_collision()
	despawn()

func _process(delta: float) -> void:
	global_position += velocity * delta

func despawn() -> void:
	if despawn_time > 0:
		await get_tree().create_timer(despawn_time).timeout
		queue_free()

func setup_collision() -> void:
	# Override in child classes to set up specific collision layers/masks
	pass

func _on_area_entered(area: Area2D) -> void:
	if area is not HitBoxComponent:
		return
	var hitbox : HitBoxComponent = area
	
	var attack = Attack.new()
	attack.attack_damage = damage
	attack.damage_source = get_damage_source()
	
	hitbox.damage(attack)
	queue_free()

func get_damage_source() -> Global.ProjectileMode:
	# Override in child classes to return appropriate damage source
	return Global.ProjectileMode.ENEMY

func _on_screen_exited() -> void:
	queue_free()
