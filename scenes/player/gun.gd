extends Sprite2D
class_name Gun;

@onready var projectile_spawn_point: Marker2D = $ProjectileSpawnPoint;
@export var projectile: PackedScene
@export var my_owner: Player;

@export var owners_animation: AnimatedSprite2D

@export var timer: Timer

func _ready() -> void:
	i_frame_effect()

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
	var projectile_mode: Global.ProjectileMode;
	match my_owner.mode:
		Global.PlayerMode.PLAYER:
			projectile_mode = Global.ProjectileMode.PLAYER;
		Global.PlayerMode.CLONE:
			projectile_mode = Global.ProjectileMode.CLONE;
	var new_projectile := projectile.instantiate() as Projectile;
	new_projectile.mode = projectile_mode;
	new_projectile.position = projectile_spawn_point.global_position;
	new_projectile.target_position = (my_owner.get_current_look_direction() - projectile_spawn_point.global_position).normalized();
	get_tree().root.add_child(new_projectile);

func i_frame_effect() -> void:
	var elapsed := 0.0
	var duration := timer.time_left
	while elapsed < duration:
		modulate.a = 0.5
		await get_tree().create_timer(my_owner.i_frame_effect_length).timeout
		modulate.a = 1.0
		await get_tree().create_timer(my_owner.i_frame_effect_length).timeout
		elapsed += my_owner.i_frame_effect_length * 2
	modulate.a = 1.0
