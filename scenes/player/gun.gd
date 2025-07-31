extends Sprite2D
class_name Gun;

@onready var projectile_spawn_point: Marker2D = $ProjectileSpawnPoint;
@export var projectile: PackedScene
@export var my_owner: Player;

func _process(_delta: float) -> void:
	look_at(my_owner.get_current_look_direction());

func shoot() -> void:
	var projectile_mode: Global.ProjectileMode;
	match my_owner.mode:
		Global.PlayerMode.PLAYER:
			projectile_mode = Global.ProjectileMode.PLAYER;
		Global.PlayerMode.CLONE:
			projectile_mode = Global.ProjectileMode.CLONE;
	var new_projectile := projectile.instantiate() as Projectile;
	new_projectile.mode = projectile_mode;
	new_projectile.damage_source = my_owner;
	new_projectile.position = projectile_spawn_point.global_position;
	new_projectile.target_position = (my_owner.get_current_look_direction() - projectile_spawn_point.global_position).normalized();
	get_tree().root.add_child(new_projectile);
