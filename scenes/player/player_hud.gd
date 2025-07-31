extends Control
class_name PlayerHud;

@export var health_label: Label;
@export var soft_reset_timer_label: Label;

@export var game_loop_manager: GameLoopManager;

var health: float:
	set(value):
		health = value;
		update_health_label();
var max_health: float:
	set(value):
		max_health = value;
		update_health_label();
var my_player: Player:
	set(value):
		player_changed(value);
		my_player = value;

func _physics_process(delta: float) -> void:
	update_soft_reset_timer();

func update_soft_reset_timer() -> void:
	soft_reset_timer_label.text = str(int(game_loop_manager.soft_reset_timer.time_left));

func _on_clone_manager_new_player_spawned(player: Player) -> void:
	my_player = player;

func player_changed(new_player: Player) -> void:
	# disconnect from old signals if old player was connected
	if my_player:
		my_player.health.health_updated.disconnect(_on_player_health_updated);
		my_player.health.max_health_updated.disconnect(_on_player_max_health_updated);
	
	new_player.health.health_updated.connect(_on_player_health_updated);
	new_player.health.max_health_updated.connect(_on_player_max_health_updated);
	
	health = new_player.health.health;
	max_health = new_player.health.max_health;

func _on_player_health_updated(new_health: float):
	health = new_health;

func _on_player_max_health_updated(new_max_health: float):
	max_health = new_max_health;

func update_health_label() -> void:
	health_label.text = "%s/%s" % [health, max_health]
