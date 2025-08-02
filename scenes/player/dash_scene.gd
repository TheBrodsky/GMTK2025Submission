class_name DashScene extends Sprite2D

@export var start_alpha: float = 0.5;
@onready var despawn_timer: Timer = $DespawnTimer
var life_time: float;

func _ready() -> void:
	life_time = despawn_timer.wait_time;
	modulate.a = start_alpha

func _process(delta: float) -> void:
	if despawn_timer.time_left > 0:
		modulate.a = start_alpha * (despawn_timer.time_left / life_time)
	else:
		modulate.a = 0.0

func _on_despawn_timer_timeout() -> void:
	queue_free();
