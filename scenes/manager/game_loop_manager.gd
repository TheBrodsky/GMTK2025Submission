extends Node
class_name GameLoopManager;

@export var clone_manager: CloneManager;

@export var soft_reset_time: float = 60; # soft reset time in seconds

@export var boss_collection: Dictionary[Global.BossDifficulty, BossCollection];

signal cause_soft_reset;
signal cause_hard_reset;

var player: Player;
var soft_reset_timer: Timer;
var current_difficulty: Global.BossDifficulty = Global.BossDifficulty.EASY; # decides what bosses to spawn

func _ready() -> void:
	soft_reset_timer = Timer.new();
	soft_reset_timer.wait_time = soft_reset_time;
	add_child(soft_reset_timer);
	soft_reset_timer.timeout.connect(_on_soft_reset_timer_timeout);
	
	if OS.is_debug_build():
		current_difficulty = Global.BossDifficulty.TEST;
	
	# Start the Game # TODO: start the game in a different way?
	handle_soft_reset();

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
	
	# Reset SequenceRNG to ensure consistent boss sequences on restart
	Global.SequenceRNG.seed = Global.global_seed;
	
	# Select a boss to spawn and spawn it
	var bosses_to_spawn = boss_collection.get(current_difficulty);
	if bosses_to_spawn && bosses_to_spawn.bosses && bosses_to_spawn.bosses.size() > 0:
		var boss_to_spawn: PackedScene = bosses_to_spawn.get_random_boss();
		var instance = boss_to_spawn.instantiate();
		get_tree().root.call_deferred("add_child", instance);
	else:
		push_error("something went wrong with spawning a boss. are you sure you have at least 1 boss in difficulty: %s" % current_difficulty);

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
