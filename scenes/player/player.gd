extends CharacterBody2D;
class_name Player;

@export var speed: float = 200;

func get_input():
	var input_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized();
	velocity = input_direction * speed;

func _physics_process(delta: float) -> void:
	get_input();
	move_and_slide();
	
