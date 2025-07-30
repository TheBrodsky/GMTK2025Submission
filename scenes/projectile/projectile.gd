extends CharacterBody2D
class_name Projectile;

signal _mode_changed;

@export var speed : int = 400;
@export var despawn_time : int = 1; # in seconds

var target_position;
var mode : Global.PlayerMode :
	get:
		return mode;
	set(value):
		mode = value;
		_mode_changed.emit();

func _ready() -> void:
	despawn();

func _physics_process(delta: float) -> void:
	velocity = target_position * speed;
	move_and_slide();

func despawn() -> void:
	await get_tree().create_timer(despawn_time).timeout;
	queue_free();

# if the mode changes, change to correct collision layers (if clone, we want to effect player, but if from player, we don't)
func mode_changed() -> void:
	collision_layer = 0;
	
	# set collision layer (change what we "are")
	match mode:
		Global.PlayerMode.Player:
			set_collision_layer_value(Global.CollisionLayer.PLAYER_PROJECTILE, true);
		Global.PlayerMode.Clone:
			set_collision_layer_value(Global.CollisionLayer.ENEMY_PROJECTILES, true);
	
