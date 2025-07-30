extends Sprite2D;
class_name Projectile;

signal _mode_changed;

@export var speed : int = 400;
@export var despawn_time : int = 1; # in seconds
@export var hitbox : Area2D;

var target_position: Vector2 :
	get:
		return target_position;
	set(value):
		target_position = value;
		velocity = target_position * speed;
var mode: Global.PlayerMode :
	get:
		return mode;
	set(value):
		mode = value;
		_mode_changed.emit();
var velocity: Vector2 = Vector2.ZERO;

func _ready() -> void:
	despawn();

func _process(delta: float) -> void:
	global_position += velocity * delta;

func despawn() -> void:
	await get_tree().create_timer(despawn_time).timeout;
	queue_free();

# if the mode changes, change to correct collision layers (if clone, we want to effect player, but if from player, we don't)
func mode_changed() -> void:
	hitbox.collision_layer = 0;
	
	# set collision layer (change what we "are")
	match mode:
		Global.PlayerMode.Player:
			hitbox.set_collision_layer_value(Global.CollisionLayer.PLAYER_PROJECTILE, true);
		Global.PlayerMode.Clone:
			hitbox.set_collision_layer_value(Global.CollisionLayer.ENEMY_PROJECTILES, true);
