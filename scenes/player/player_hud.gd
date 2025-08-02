extends Control
class_name PlayerHud;

@export var boss_health_bar: ProgressBar;
@export var soft_reset_timer_label: Label;
@export var game_loop_manager: GameLoopManager;

var boss_health: float:
	set(value):
		boss_health = value;
		update_health_bar();
var boss_max_health: float:
	set(value):
		boss_max_health = value;
		update_health_bar();
var current_boss: Boss:
	set(value):
		boss_changed(value);
		current_boss = value;

func _physics_process(_delta: float) -> void:
	update_soft_reset_timer();

func update_soft_reset_timer() -> void:
	soft_reset_timer_label.text = str(int(game_loop_manager.soft_reset_timer.time_left));

func boss_changed(new_boss: Boss) -> void:
	# disconnect from old signals if old player was connected
	if current_boss:
		current_boss.health.health_updated.disconnect(_on_boss_health_updated);
		current_boss.health.max_health_updated.disconnect(_on_boss_max_health_updated);
	
	new_boss.health.health_updated.connect(_on_boss_health_updated);
	new_boss.health.max_health_updated.connect(_on_boss_max_health_updated);
	
	boss_health = new_boss.health.health;
	boss_max_health = new_boss.health.max_health;

func _on_boss_health_updated(new_health: float):
	boss_health = new_health;

func _on_boss_max_health_updated(new_max_health: float):
	boss_max_health = new_max_health;

func update_health_bar() -> void:
	boss_health_bar.max_value = boss_max_health;
	boss_health_bar.value = boss_health;

func _on_game_loop_manager_new_boss_spawned(boss: Boss) -> void:
	current_boss = boss;
