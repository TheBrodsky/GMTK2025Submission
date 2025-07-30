extends Node;
class_name HealthComponent;

@export var max_health: float;
var health: float;

signal got_damaged(attack: Attack);

func _ready() -> void:
	health = max_health;

func damage(attack: Attack) -> void: 
	got_damaged.emit(attack);
