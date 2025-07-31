extends Node;
class_name HealthComponent;

@export var max_health: float:
	get:
		return max_health;
	set(value):
		max_health = value;
		max_health_updated.emit(max_health);
var health: float:
	get:
		return health;
	set(value):
		health = value;
		health_updated.emit(health);

signal got_damaged(attack: Attack); # gets emitted whenever we took damage
signal health_updated(health: float); # gets emitted whenever current health has changed. sends current health.
signal max_health_updated(max_health: float); # gets emitted whenever max health has changed. sends max health.

func _ready() -> void:
	health = max_health;

func damage(attack: Attack) -> void: 
	got_damaged.emit(attack);
