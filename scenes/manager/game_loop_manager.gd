extends Node
class_name GameLoopManager;

@export var soft_reset_time: float = 60; # soft reset time in seconds

signal cause_soft_reset;
signal cause_hard_reset;

var player: Player;
var soft_reset_timer: Timer;

func _ready() -> void:
	soft_reset_timer = Timer.new();
	soft_reset_timer.wait_time = soft_reset_time;
	add_child(soft_reset_timer);
	soft_reset_timer.timeout.connect(_on_soft_reset_timer_timeout);
	
	soft_reset_timer.start(); # TODO: start the game in a different way?

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("suicide"): # todo: Remove again
		handle_soft_reset();

func _on_soft_reset_timer_timeout() -> void:
	handle_soft_reset();

func handle_soft_reset() -> void:
	cause_soft_reset.emit();
	# despawn everything in group "SoftReset"
	for soft_reset in get_tree().get_nodes_in_group("SoftReset"):
		soft_reset.queue_free();
	soft_reset_timer.start();

func handle_hard_reset() -> void:
	cause_hard_reset.emit();
	# despawn everything in group "HardReset"
	for hard_reset in get_tree().get_nodes_in_group("HardReset"):
		hard_reset.queue_free();

func _on_clone_manager_new_player_spawned(new_player: Player) -> void:
	if player:
		player.should_die.disconnect(_on_player_should_die)
	new_player.should_die.connect(_on_player_should_die);
	new_player.game_loop_manager = self;
	player = new_player;

func _on_player_should_die(_player: Player) -> void:
	handle_hard_reset();
