extends BaseProjectile
class_name PlayerProjectile

func get_damage_source() -> Global.ProjectileMode:
	return Global.ProjectileMode.PLAYER
