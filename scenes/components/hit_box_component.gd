extends Area2D;
class_name HitBoxComponent;

@export var health_component: HealthComponent;

func _ready() -> void:
	if !health_component:
		push_error("No Health Component defined in the HitBoxComponent!!");

func damage(attack: Attack) -> void:
	if health_component:
		health_component.damage(attack);
