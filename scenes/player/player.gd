extends CharacterBody2D;
class_name Player;

@export var mode : Global.PlayerMode :
	get:
		return mode;
	set(value):
		mode = value;
		_mode_changed.emit();

@export_group("Stats")
@export var speed: int = 200;
@export var shoot_cooldown: float = 0.2; # in seconds

@export_group("Components")
@export var gun: Gun;
@export var hitbox: HitBoxComponent;
@export var health: HealthComponent;

@onready var timer = $ImmunityTimer

var shoot_cooldown_timer: Timer;
var can_shoot: bool = true;
var frame_count = 0;
var input_recording: InputRecording = InputRecording.new();
var latest_input: InputSnapshot; # stores the latest input snapshot, if we're clone.

var game_loop_manager: GameLoopManager;

signal _mode_changed;
signal should_die(player: Player); # gets emitted on a HARD RESET (when killed by its own clone)

func _ready() -> void:
	shoot_cooldown_timer = Timer.new();
	shoot_cooldown_timer.wait_time = shoot_cooldown;
	shoot_cooldown_timer.timeout.connect(_on_shoot_cooldown_timeout);
	add_child(shoot_cooldown_timer);
	timer.start()

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
	if can_shoot && Input.is_action_pressed("shoot"): # todo: add cooldown
		gun.shoot();
		has_shot = true;
		can_shoot = false;
		shoot_cooldown_timer.start();
	
	var input := InputSnapshot.new();
	input.look_direction = get_global_mouse_position();
	input.move_direction = velocity;
	input.shooting_pressed = has_shot;
	
	input_recording.append(frame_count, input);

func handle_clone(_delta: float) -> void:
	var current_input = input_recording.recording.get(frame_count);
	if current_input:
		var input: InputSnapshot = current_input;
		latest_input = input;
	
	if !latest_input:
		return;
	if latest_input.shooting_pressed:
		gun.shoot();
	velocity = latest_input.move_direction;
	move_and_slide();

# Returns the current look direction, based on if we're player or clone
func get_current_look_direction() -> Vector2:
	match mode:
		Global.PlayerMode.Player:
			return get_global_mouse_position();
		Global.PlayerMode.Clone:
			if latest_input:
				return latest_input.look_direction;
	return Vector2.ZERO;

func _on_health_component_got_damaged(attack: Attack) -> void:
	if timer.time_left == 0:
		health.health -= attack.attack_damage;
	
		if health.health <= 0:
			match mode:
				Global.PlayerMode.Player:
					var attack_source = attack.damage_source;
					if attack_source is Player:
						should_die.emit(self); # tell the clone manager that the "real" player died. we died by a player (must be a clone) and thus we trigger a hard reset
						return;
					game_loop_manager.handle_soft_reset(); # we died through something else (e.g. boss), trigger a soft reset
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
		Global.PlayerMode.Clone:
			# Layer
			set_collision_layer_value(Global.CollisionLayer.ENEMY, true);
			hitbox.set_collision_layer_value(Global.CollisionLayer.ENEMY, true);
			
			hitbox.set_collision_mask_value(Global.CollisionLayer.PLAYER_PROJECTILE, true);


func _on_shoot_cooldown_timeout() -> void:
	can_shoot = true;
