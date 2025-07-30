extends CharacterBody2D;
class_name Player;

@export var speed: int = 200;
@export var gun: Gun;
@export var hitbox: HitBoxComponent;
@export var health: HealthComponent;

var frame_count = 0;
var input_recording: InputRecording = InputRecording.new();

signal _mode_changed;
signal should_die(player: Player);

@export var mode : Global.PlayerMode :
	get:
		return mode;
	set(value):
		mode = value;
		_mode_changed.emit();

func get_input():
	var input_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized();
	velocity = input_direction * speed;

func _physics_process(delta: float) -> void:
	frame_count += 1;
	match mode:
		Global.PlayerMode.Player:
			handle_player(delta);
		Global.PlayerMode.Clone:
			handle_clone(delta);

func handle_player(_delta: float) -> void:
	get_input();
	move_and_slide();
	
	var has_shot = false;
	if Input.is_action_pressed("shoot"): # todo: add cooldown
		gun.shoot();
		has_shot = true;
		
	if Input.is_action_just_pressed("suicide"): # todo: Remove again
		should_die.emit(self);
	
	var input := InputSnapshot.new();
	input.frame = frame_count;
	input.look_direction = (get_global_mouse_position() - global_position).normalized(); # todo: is that correct?
	input.move_direction = velocity;
	input.shooting_pressed = has_shot;
	
	input_recording.append(input);

func handle_clone(_delta: float) -> void:
	pass

func _on_health_component_got_damaged(attack: Attack) -> void:
	health.health -= attack.attack_damage;
	
	if health.health <= 0:
		match mode:
			Global.PlayerMode.Player:
				should_die.emit(self); # tell the clone manager that the "real" player died. # todo: check why we died. if clone killed us, run is over.
			Global.PlayerMode.Clone:
				queue_free();

func _on__mode_changed() -> void:
	collision_layer = 0;
	collision_mask = 0;
	
	hitbox.collision_layer = 0;
	hitbox.collision_mask = 0;
	
	set_collision_mask_value(Global.CollisionLayer.WALL, true);
	hitbox.set_collision_mask_value(Global.CollisionLayer.ENEMY_PROJECTILE, true);
	
	# set collision layer (change what we "are")
	match mode:
		Global.PlayerMode.Player:
			# Layer
			set_collision_layer_value(Global.CollisionLayer.PLAYER, true);
			hitbox.set_collision_layer_value(Global.CollisionLayer.PLAYER, true);
			
			# Mask
			set_collision_mask_value(Global.CollisionLayer.ENEMY, true);
		Global.PlayerMode.Clone:
			# Layer
			set_collision_layer_value(Global.CollisionLayer.ENEMY, true);
			hitbox.set_collision_layer_value(Global.CollisionLayer.ENEMY, true);
			
			# Mask
			set_collision_mask_value(Global.CollisionLayer.PLAYER, true);
			hitbox.set_collision_mask_value(Global.CollisionLayer.PLAYER_PROJECTILE, true);
