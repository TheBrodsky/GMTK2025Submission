## Fires a stream of bullets that oscillates between two angles
class_name StreamFireAction extends AtomicBossAction

@export var projectile_scene: PackedScene
@export var fire_rate: float = 5.0 # bullets per second
@export var starting_angle_degrees: float = 0.0
@export var ending_angle_degrees: float = 90.0
@export var oscillation_frequency: float = 1.0 # oscillations per second
@export var reset_oscillation_on_start: bool = false # if true, always starts at starting_angle
@export var aim_at_screen_center: bool = false # if true, orients the oscillation toward screen center
@export var bullet_speed_override: float = -1.0 # if > 0, overrides projectile's default speed

var fire_timer: float = 0.0
var oscillation_timer: float = 0.0

func _perform_action(delta: float):
	fire_timer += delta
	oscillation_timer += delta
	
	var fire_interval = 1.0 / fire_rate
	if fire_timer >= fire_interval:
		fire_timer -= fire_interval
		_fire_bullet()

func _fire_bullet():
	var current_angle = _calculate_current_angle()
	var angle_radians = deg_to_rad(current_angle)
	
	if aim_at_screen_center:
		var screen_center = get_viewport().get_visible_rect().size / 2.0
		var direction_to_center = (screen_center - boss_node.global_position).normalized()
		var base_angle_offset = atan2(direction_to_center.y, direction_to_center.x)
		angle_radians += base_angle_offset
	
	var projectile = projectile_scene.instantiate() as BaseProjectile
	projectile.position = boss_node.global_position
	projectile.direction = Vector2(cos(angle_radians), sin(angle_radians))
	if bullet_speed_override > 0.0:
		projectile.speed = bullet_speed_override
	
	get_tree().root.add_child(projectile)

func _calculate_current_angle() -> float:
	var oscillation_progress = sin(oscillation_timer * oscillation_frequency * 2.0 * PI)
	oscillation_progress = (oscillation_progress + 1.0) / 2.0 # normalize to 0-1
	
	if reset_oscillation_on_start:
		# Check if we've reached the ending angle (oscillation_progress near 1.0)
		if oscillation_progress > 0.99:
			oscillation_timer = 0.0
			oscillation_progress = 0.0
	
	return lerp(starting_angle_degrees, ending_angle_degrees, oscillation_progress)
