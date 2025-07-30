extends CharacterBody2D;
class_name Player;

@export var speed: int = 200;
@export var gun: Gun;

signal _mode_changed;

@export var mode : Global.PlayerMode :
	get:
		return mode;
	set(value):
		mode = value;
		_mode_changed.emit();

func get_input():
	var input_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized();
	velocity = input_direction * speed;

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		gun.shoot();

func _physics_process(_delta: float) -> void:
	get_input();
	move_and_slide();

func _on__mode_changed() -> void:
	collision_layer = 0;
	collision_mask = 0;
	
	set_collision_mask_value(Global.CollisionLayer.WALL, true);
	set_collision_mask_value(Global.CollisionLayer.ENEMY_PROJECTILE, true);
	
	# set collision layer (change what we "are")
	match mode:
		Global.PlayerMode.Player:
			# Layer
			set_collision_layer_value(Global.CollisionLayer.PLAYER, true);
			
			# Mask
			set_collision_mask_value(Global.CollisionLayer.ENEMY, true);
		Global.PlayerMode.Clone:
			# Layer
			set_collision_layer_value(Global.CollisionLayer.ENEMY, true);
			
			# Mask
			set_collision_mask_value(Global.CollisionLayer.PLAYER_PROJECTILE, true);


func _on_health_component_on_hit(source: Variant) -> void:
	print("I HAVE BEEN HIT!!!!!!")
	pass # Replace with function body.
