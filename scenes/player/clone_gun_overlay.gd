extends Sprite2D
class_name CloneGunOverlay;

@export var my_owner: Player;
@export var owners_animation: AnimatedSprite2D

func _process(_delta: float) -> void:
	global_rotation = (my_owner.get_current_look_direction() - global_position).angle()
	flip_v = abs(rotation_degrees) > 90
	if owners_animation.flip_h == false:
		position = Vector2(4, -6)
	elif owners_animation.flip_h == true:
		position = Vector2(-4, -6)
