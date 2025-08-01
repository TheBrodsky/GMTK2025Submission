extends Sprite2D
class_name Gun;

@onready var projectile_spawn_point: Marker2D = $ProjectileSpawnPoint;
const PROJECTILE = preload("res://scenes/projectile/projectile.tscn")
@export var my_owner: Player;

@export var owners_animation: AnimatedSprite2D

@export var timer: Timer

@export var clone_overlay: Sprite2D

func _ready() -> void:
	if my_owner.mode == Global.PlayerMode.Clone:
		clone_overlay.modulate.a = 1
		modulate.a = 0
	elif my_owner.mode == Global.PlayerMode.Player:
		clone_overlay.modulate.a = 0
		modulate.a = 1
	await i_frame_effect()

func _process(_delta: float) -> void:
	global_rotation = (my_owner.get_current_look_direction() - global_position).angle()
	flip_v = abs(rotation_degrees) > 90
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

func i_frame_effect() -> void:
	var elapsed := 0.0
	var duration := timer.time_left
	while elapsed < duration:
		if my_owner.mode == Global.PlayerMode.Player:
			modulate.a = 0.5
			await get_tree().create_timer(my_owner.i_frame_effect_length).timeout
			modulate.a = 1.0
			await get_tree().create_timer(my_owner.i_frame_effect_length).timeout
			elapsed += my_owner.i_frame_effect_length * 2
		elif my_owner.mode == Global.PlayerMode.Clone:
			clone_overlay.modulate.a = 0.5
			await get_tree().create_timer(my_owner.i_frame_effect_length).timeout
			clone_overlay.modulate.a = 1.0
			await get_tree().create_timer(my_owner.i_frame_effect_length).timeout
			elapsed += my_owner.i_frame_effect_length * 2
	if my_owner.mode == Global.PlayerMode.Player:
		modulate.a = 1
	elif my_owner.mode == Global.PlayerMode.Clone:
		clone_overlay.modulate.a = 1
