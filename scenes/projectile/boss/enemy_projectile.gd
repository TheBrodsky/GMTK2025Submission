extends BaseProjectile
class_name EnemyProjectile

func get_damage_source() -> Global.ProjectileMode:
	return Global.ProjectileMode.ENEMY
