extends Area2D;
class_name Projectile;

signal _mode_changed;

@export var speed : int = 400;
@export var despawn_time : int = 1; # in seconds

var my_owner: Gun;

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
	collision_layer = 0;
	collision_mask = 0;
	
	set_collision_mask_value(Global.CollisionLayer.ENEMY, true);
	
	# set collision layer (change what we "are")
	match mode:
		Global.PlayerMode.Player:
			# Layer
			set_collision_layer_value(Global.CollisionLayer.PLAYER_PROJECTILE, true);
		Global.PlayerMode.Clone:
			# Layer
			set_collision_layer_value(Global.CollisionLayer.ENEMY_PROJECTILE, true);
			
			# Mask
			set_collision_mask_value(Global.CollisionLayer.PLAYER, true);

func _on_body_entered(body: Node2D) -> void:
	if body == my_owner.my_owner:
		print("THIS IS ME")
	else:
		print("HELLO")
	pass # Replace with function body.
