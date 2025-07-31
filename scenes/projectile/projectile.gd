extends Area2D;
class_name Projectile;

@export var speed: int = 400;
@export var despawn_time: int = 1; # in seconds
@export var damage: int = 10;

var damage_source; # the instance that should be considered the "source" for the damage

var target_position: Vector2 :
	get:
		return target_position;
	set(value):
		target_position = value;
		velocity = target_position * speed;
var mode: Global.ProjectileMode :
	get:
		return mode;
	set(value):
		mode = value;
		mode_changed();
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
	
	# set collision layer (change what we "are") and mask (what we check for)
	match mode:
		Global.ProjectileMode.PLAYER:
			# Layer
			set_collision_layer_value(Global.CollisionLayer.PLAYER_PROJECTILE, true);
			set_collision_mask_value(Global.CollisionLayer.ENEMY, true);
		Global.ProjectileMode.CLONE:
			# Layer
			set_collision_layer_value(Global.CollisionLayer.CLONE_PROJECTILE, true);
			
			# Mask
			set_collision_mask_value(Global.CollisionLayer.PLAYER, true);
			set_collision_mask_value(Global.CollisionLayer.ENEMY, true);
		Global.ProjectileMode.ENEMY:
			# Layer
			set_collision_layer_value(Global.CollisionLayer.ENEMY_PROJECTILE, true);
			
			# Mask
			set_collision_mask_value(Global.CollisionLayer.PLAYER, true);
			set_collision_mask_value(Global.CollisionLayer.CLONE, true);

func _on_area_entered(area: Area2D) -> void:
	if area is not HitBoxComponent:
		return;
	var hitbox : HitBoxComponent = area;
	
	var attack = Attack.new();
	attack.attack_damage = damage;
	attack.damage_source = damage_source;
	
	hitbox.damage(attack);
	queue_free();
