extends BaseProjectile
class_name EnemyProjectile

func setup_collision() -> void:
	collision_layer = 0
	collision_mask = 0
	
	# Layer - what we are
	set_collision_layer_value(Global.CollisionLayer.ENEMY_PROJECTILE, true)
	
	# Mask - what we check for
	set_collision_mask_value(Global.CollisionLayer.PLAYER, true)
	set_collision_mask_value(Global.CollisionLayer.CLONE, true)
	set_collision_mask_value(Global.CollisionLayer.WALL, true)
	
	# Connect wall collision signal
	body_entered.connect(_on_wall_collision)

func get_damage_source() -> Global.ProjectileMode:
	return Global.ProjectileMode.ENEMY

func _on_wall_collision(body: Node2D) -> void:
	# Default behavior: despawn when hitting walls
	queue_free()
