extends CharacterBody2D;
class_name Player;

@export var speed: int = 200;
@export var gun: Gun;

func get_input():
	var input_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized();
	velocity = input_direction * speed;

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		gun.shoot();

func _physics_process(_delta: float) -> void:
	get_input();
	move_and_slide();
	
