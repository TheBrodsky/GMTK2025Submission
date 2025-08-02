extends CharacterBody2D;
class_name Player;

@export var mode : Global.PlayerMode :
	get:
		return mode;
	set(value):
		mode = value;
		mode_changed();

@export_group("Stats")
@export var speed: int = 200;
@export var dash_speed: int = 400;
@export var dash_effect_creation_frame: int = 10; # after how many physics steps it should create a new dash effect when dashing
var current_dash_effect_creation_frame: int = 0;

var i_frame_effect_lenght: float; # set from the duration of the immunity timer

@export_group("Components")
@export var gun: Gun;
@export var hitbox: HitBoxComponent;
@export var health: HealthComponent;
@export var dash_scene: PackedScene;

@onready var immunity_timer: Timer = $ImmunityTimer
@onready var shoot_cooldown_timer: Timer = $ShootCooldownTimer
@onready var dash_cooldown_timer: Timer = $Dashing/DashCooldownTimer # how long to wait until we can dash again. cooldown starts AFTER dash ended
@onready var dash_duration_timer: Timer = $Dashing/DashDurationTimer # on timeout, ends dash. effectively saying how long the dash goes for

var can_shoot: bool = true;
var can_dash: bool = true;
var is_dashing: bool = false;
var is_invincible: bool = true;
var frame_count = 0;
var input_recording: InputRecording = InputRecording.new();
var latest_input: InputSnapshot; # stores the latest input snapshot, if we're clone.
var last_input_direction: Vector2 = Vector2.ZERO;

var game_loop_manager: GameLoopManager;

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

signal should_die(player: Player); # gets emitted on a HARD RESET (when killed by its own clone)

func _ready() -> void:
	i_frame_effect_lenght = immunity_timer.wait_time;
	i_frame_effect()

func get_input():
	if is_dashing:
		velocity = last_input_direction * dash_speed;
		return;
	var input_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized();
	last_input_direction = input_direction;
	handle_movement_animation(input_direction)
	velocity = input_direction * speed;

func _physics_process(delta: float) -> void:
	frame_count += 1;
	
	if is_dashing:
		current_dash_effect_creation_frame += 1;
		if current_dash_effect_creation_frame >= dash_effect_creation_frame:
			create_dash_effect();
			current_dash_effect_creation_frame = 0;
	
	match mode:
		Global.PlayerMode.PLAYER:
			handle_player(delta);
		Global.PlayerMode.CLONE:
			handle_clone(delta);
			
func i_frame_effect() -> void:
	var elapsed := 0.0
	var duration: float = immunity_timer.time_left
	while elapsed < duration:
		modulate.a = 0.5
		await get_tree().create_timer(i_frame_effect_lenght).timeout
		modulate.a = 1.0
		await get_tree().create_timer(i_frame_effect_lenght).timeout
		elapsed += i_frame_effect_lenght * 2
	modulate.a = 1.0

func handle_player(_delta: float) -> void:
	var input := InputSnapshot.new();
	get_input();
	move_and_slide();
	clamp_to_screen();
	
	if can_dash && Input.is_action_just_pressed("dash"):
		input.dashing = true;
		start_dashing();
	
	if can_shoot && Input.is_action_pressed("shoot"):
		gun.shoot();
		can_shoot = false;
		shoot_cooldown_timer.start();
		
		input.shooting_pressed = true;
	
	input.look_direction = get_global_mouse_position();
	input.move_direction = velocity;
	
	input_recording.append(frame_count, input);
	
func handle_movement_animation(dir):
	if mode == Global.PlayerMode.PLAYER:
		if !velocity:
			animated_sprite.play("IdlePlayer")
		if velocity:
			animated_sprite.play("RunPlayer")
			toggle_flip_sprite(dir)
	if mode == Global.PlayerMode.CLONE:
		if !velocity:
			animated_sprite.play("IdleClone")
		if velocity:
			animated_sprite.play("RunClone")
			toggle_flip_sprite(dir)
	
func toggle_flip_sprite(dir: Vector2):
	if dir.x < 0:
		animated_sprite.flip_h = true
	elif dir.x > 0:
		animated_sprite.flip_h = false

func handle_clone(_delta: float) -> void:
	var current_input = input_recording.recording.get(frame_count);
	if current_input:
		var input: InputSnapshot = current_input;
		latest_input = input;
	
	if !latest_input:
		return;
	if latest_input.shooting_pressed:
		gun.shoot();
		
	if latest_input.dashing:
		start_dashing();
		
	velocity = latest_input.move_direction;
	handle_movement_animation(latest_input.move_direction)
	move_and_slide();
	clamp_to_screen();

# Returns the current look direction, based on if we're player or clone
func get_current_look_direction() -> Vector2:
	match mode:
		Global.PlayerMode.PLAYER:
			return get_global_mouse_position();
		Global.PlayerMode.CLONE:
			if latest_input:
				return latest_input.look_direction;
	return Vector2.ZERO;

func _on_health_component_got_damaged(attack: Attack) -> void:
	if is_invincible:
		return;
	health.health -= attack.attack_damage;

	if health.health <= 0:
		match mode:
			Global.PlayerMode.PLAYER:
				var attack_source := attack.damage_source;
				if attack_source == Global.ProjectileMode.CLONE:
					should_die.emit(self); # tell the clone manager that the "real" player died. we died by a player (must be a clone) and thus we trigger a hard reset
					return;
				game_loop_manager.handle_soft_reset(); # we died through something else (e.g. boss), trigger a soft reset
			Global.PlayerMode.CLONE:
				queue_free();

func mode_changed() -> void:
	collision_layer = 0;
	collision_mask = 0;
	
	hitbox.collision_layer = 0;
	hitbox.collision_mask = 0;
	
	set_collision_mask_value(Global.CollisionLayer.WALL, true);
	hitbox.set_collision_mask_value(Global.CollisionLayer.ENEMY_PROJECTILE, true);
	
	# set collision layer (change what we "are")
	match mode:
		Global.PlayerMode.PLAYER:
			# Layer
			set_collision_layer_value(Global.CollisionLayer.PLAYER, true);
			hitbox.set_collision_layer_value(Global.CollisionLayer.PLAYER, true);
			
			# Mask
			hitbox.set_collision_mask_value(Global.CollisionLayer.CLONE_PROJECTILE, true);
		Global.PlayerMode.CLONE:
			# Layer
			set_collision_layer_value(Global.CollisionLayer.CLONE, true);
			hitbox.set_collision_layer_value(Global.CollisionLayer.CLONE, true);

func clamp_to_screen() -> void:
	var viewport_size = get_viewport().get_visible_rect().size
	var half_width = viewport_size.x / 2.0
	var half_height = viewport_size.y / 2.0
	var player_size = 25.0  # Approximate half-width of player sprite
	
	global_position.x = clamp(global_position.x, -half_width + player_size, half_width - player_size)
	global_position.y = clamp(global_position.y, -half_height + player_size, half_height - player_size)

func _on_shoot_cooldown_timeout() -> void:
	can_shoot = true;

func _on_dash_cooldown_timeout() -> void:
	can_dash = true;

func _on_immunity_timer_timeout() -> void:
	is_invincible = false;

func _on_dash_duration_timer_timeout() -> void:
	is_dashing = false;
	is_invincible = false;
	dash_cooldown_timer.start();
	current_dash_effect_creation_frame = 0;

func start_dashing() -> void:
	can_dash = false;
	dash_duration_timer.start();
	is_dashing = true;
	is_invincible = true;

func create_dash_effect() -> void:
	var frame_index: int = animated_sprite.frame;
	var animation_name: String = animated_sprite.animation;
	var sprite_frames: SpriteFrames = animated_sprite.sprite_frames;
	var current_texture: Texture2D = sprite_frames.get_frame_texture(animation_name, frame_index);
	
	var new_temporal_sprite: DashScene = dash_scene.instantiate();
	new_temporal_sprite.texture = current_texture;
	new_temporal_sprite.position = global_position;
	new_temporal_sprite.modulate.a = 0.25;
	new_temporal_sprite.scale = Vector2(0.05,0.05);
	new_temporal_sprite.flip_h = animated_sprite.flip_h;
	get_tree().root.add_child(new_temporal_sprite);
