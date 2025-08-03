extends BaseProjectile
class_name CloneProjectile

func setup_collision() -> void:
	collision_layer = 0
	collision_mask = 0
	
	# Layer - what we are
	set_collision_layer_value(Global.CollisionLayer.CLONE_PROJECTILE, true)
	
	# Mask - what we check for
	set_collision_mask_value(Global.CollisionLayer.PLAYER, true)
	set_collision_mask_value(Global.CollisionLayer.ENEMY, true)
	
	super.setup_collision()

func get_damage_source() -> Global.ProjectileMode:
	return Global.ProjectileMode.CLONE
