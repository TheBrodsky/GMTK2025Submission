extends BaseProjectile
class_name CloneProjectile

func get_damage_source() -> Global.ProjectileMode:
	return Global.ProjectileMode.CLONE
