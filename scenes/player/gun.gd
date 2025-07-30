extends Sprite2D
class_name Gun;

@onready var projectile_spawn_point: Marker2D = $ProjectileSpawnPoint;
const PROJECTILE = preload("res://scenes/projectile/projectile.tscn")

func _process(delta: float) -> void:
	look_at(get_global_mouse_position());

func shoot() -> void:
	var new_projectile := PROJECTILE.instantiate();
	new_projectile.position = projectile_spawn_point.global_position;
	new_projectile.target_position = (get_global_mouse_position() - projectile_spawn_point.global_position).normalized();
	get_tree().root.add_child(new_projectile);
