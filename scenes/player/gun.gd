extends Sprite2D
class_name Gun;

@onready var projectile_spawn_point: Marker2D = $ProjectileSpawnPoint;
const PROJECTILE = preload("res://scenes/projectile/projectile.tscn")
@export var my_owner: Player;

@export var owners_animation: AnimatedSprite2D

func _process(_delta: float) -> void:
	look_at(my_owner.get_current_look_direction());
	if rotation_degrees > 90 or rotation_degrees < -90:
		flip_v = true
	else:
		flip_v = false
	if owners_animation.flip_h == false:
		position = Vector2(4, -6)
	elif owners_animation.flip_h == true:
		position = Vector2(-4, -6)

func shoot() -> void:
	var new_projectile := PROJECTILE.instantiate() as Projectile;
	new_projectile.mode = my_owner.mode;
	new_projectile.my_owner = self;
	new_projectile.position = projectile_spawn_point.global_position;
	new_projectile.target_position = (my_owner.get_current_look_direction() - projectile_spawn_point.global_position).normalized();
	get_tree().root.add_child(new_projectile);
