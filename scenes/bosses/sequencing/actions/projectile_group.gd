extends Node2D
class_name ProjectileGroup

@export var rotation_speed: float = 0.0  # Radians per second

func _ready() -> void:
	# Add to cleanup groups
	add_to_group("HardReset")
	add_to_group("SoftReset")

func _process(delta: float) -> void:
	# Rotate the entire group
	rotation += rotation_speed * delta
	
	# Check if all children are gone and cleanup
	if get_child_count() == 0:
		queue_free()
