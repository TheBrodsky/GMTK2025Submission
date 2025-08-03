## Fires a stream of bullets that oscillates between two angles
@icon("res://assets/editor_icons/stream_icon.svg")
class_name StreamFireAction extends AtomicBossAction

@export var projectile_scene: PackedScene
@export var projectile_config: BaseProjectileConfig
@export var fire_rate: float = 5.0 # bullets per second
@export var starting_angle_degrees: float = 0.0
@export var ending_angle_degrees: float = 90.0
@export var oscillation_frequency: float = 1.0 # oscillations per second
@export var reset_oscillation_on_start: bool = false # if true, always starts at starting_angle
@export var aim_at_screen_center: bool = false # if true, orients the oscillation toward screen center

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
	boss_node.fire_audio.play()
	var angle_radians: float
	
	if aim_at_screen_center:
		var camera = get_viewport().get_camera_2d()
		var screen_center = camera.global_position + Vector2(0, 100)  # Shift down for tilemap asymmetry
		var direction_to_center = (screen_center - boss_node.global_position).normalized()
		var center_angle = atan2(direction_to_center.y, direction_to_center.x)
		
		# Center the oscillation arc around the direction to center
		var oscillation_progress = _calculate_oscillation_progress()
		var arc_size_radians = deg_to_rad(abs(ending_angle_degrees - starting_angle_degrees))
		var min_angle = center_angle - arc_size_radians / 2.0
		var max_angle = center_angle + arc_size_radians / 2.0
		angle_radians = lerp(min_angle, max_angle, oscillation_progress)
	else:
		var current_angle = _calculate_current_angle()
		angle_radians = deg_to_rad(current_angle)
	
	var projectile = projectile_scene.instantiate() as BaseProjectile
	projectile.position = boss_node.global_position
	projectile.direction = Vector2(cos(angle_radians), sin(angle_radians))
	
	# Apply config if provided
	if projectile_config:
		projectile.config = projectile_config
	
	get_tree().root.add_child(projectile)

func _calculate_oscillation_progress() -> float:
	var time_scaled = oscillation_timer * oscillation_frequency
	var oscillation_progress: float
	
	if reset_oscillation_on_start:
		# Sawtooth wave: 0->1, then reset to 0
		oscillation_progress = fmod(time_scaled, 1.0)
		if oscillation_progress > 0.99:
			oscillation_timer = 0.0
			oscillation_progress = 0.0
	else:
		# Triangle wave: 0->1->0
		oscillation_progress = abs(fmod(time_scaled * 2.0, 2.0) - 1.0)
	
	return oscillation_progress

func _calculate_current_angle() -> float:
	var oscillation_progress = _calculate_oscillation_progress()
	return lerp(starting_angle_degrees, ending_angle_degrees, oscillation_progress)
