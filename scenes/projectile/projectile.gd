extends CharacterBody2D
class_name Projectile;

@export var speed : int = 400;
@export var despawn_time : int = 1; # in seconds
@export var collision_shape: CollisionShape2D;
var target_position;

func _ready() -> void:
	despawn();

func _physics_process(delta: float) -> void:
	velocity = target_position * speed;
	move_and_slide();

func despawn() -> void:
	await get_tree().create_timer(despawn_time).timeout;
	queue_free();
