extends Sprite2D
class_name Gun;

@onready var projectile_spawn_point: Marker2D = $ProjectileSpawnPoint;
const PROJECTILE = preload("res://scenes/projectile/projectile.tscn")
@export var my_owner: Player;

func _process(_delta: float) -> void:
	my_owner.get_current_look_direction();

func shoot() -> void:
	var new_projectile := PROJECTILE.instantiate() as Projectile;
	new_projectile.mode = my_owner.mode;
	new_projectile.my_owner = self;
	new_projectile.position = projectile_spawn_point.global_position;
	new_projectile.target_position = (get_global_mouse_position() - projectile_spawn_point.global_position).normalized();
	get_tree().root.add_child(new_projectile);
