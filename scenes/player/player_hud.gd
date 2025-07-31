extends Control
class_name PlayerHud;

@export var health_label: Label;
@export var soft_reset_timer_label: Label;

var health: float:
	set(value):
		health = value;
		update_health_label();
var max_health: float:
	set(value):
		max_health = value;
		update_health_label();
var my_player: Player:
	get:
		return my_player;
	set(value):
		my_player = value;
		player_changed.emit();

signal player_changed;

func _on_clone_manager_new_player_spawned(player: Player) -> void:
	my_player = player;

func _on_player_changed() -> void:
	my_player.health.health_updated.connect(_on_player_health_updated);
	my_player.health.max_health_updated.connect(_on_player_max_health_updated);
	
	health = my_player.health.health;
	max_health = my_player.health.max_health;

func _on_player_health_updated(new_health: float):
	health = new_health;

func _on_player_max_health_updated(new_max_health: float):
	max_health = new_max_health;

func update_health_label() -> void:
	health_label.text = "%s/%s" % [health, max_health]
