extends Node
class_name GameLoopManager;

@export var soft_reset_time: float = 60; # soft reset time in seconds

signal cause_soft_reset;

var soft_reset_timer: Timer;

func _ready() -> void:
	soft_reset_timer = Timer.new();
	soft_reset_timer.wait_time = soft_reset_time;
	add_child(soft_reset_timer);
	soft_reset_timer.timeout.connect(_on_soft_reset_timer_timeout);
	
	soft_reset_timer.start(); # TODO: start the game in a different way?

func _on_soft_reset_timer_timeout() -> void:
	cause_soft_reset.emit();
	handle_soft_reset();

func handle_soft_reset() -> void:
	# despawn everything in group "SoftReset"
	for soft_reset in get_tree().get_nodes_in_group("SoftReset"):
		soft_reset.queue_free();
