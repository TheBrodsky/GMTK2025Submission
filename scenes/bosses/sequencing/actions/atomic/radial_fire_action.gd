## Fires N projectiles in an arc at regular intervals
@icon("res://assets/editor_icons/radial_icon.svg")
class_name RadialFireAction extends AtomicBossAction

@export_range(2, 50) var projectile_count: int = 8
@export var arc_degrees: float = 360.0
@export var fire_rate: float = 1.0 # fires per second
@export var angle_offset_per_burst_degrees: float = 0.0 # degrees to offset each subsequent burst
@export var aim_at_screen_center: bool = false # if true, orients the pattern toward screen center
@export var projectile_scene: PackedScene
@export var projectile_config: BaseProjectileConfig
@export var group_rotation_speed: float = 0.0 # radians per second to rotate the entire burst

var fire_timer: float = 0.0
var current_angle_offset_degrees: float = 0.0

func _perform_action(delta: float):
	fire_timer += delta
	
	var fire_interval = 1.0 / fire_rate
	if fire_timer >= fire_interval:
		fire_timer -= fire_interval
		_fire_radial_burst()

func _fire_radial_burst():
	var angles = _calculate_angles()
	var offset_radians = deg_to_rad(current_angle_offset_degrees)
	var base_angle_offset = 0.0
	
	if aim_at_screen_center:
		var camera = get_viewport().get_camera_2d()
		var screen_center = camera.global_position + Vector2(0, 100)  # Shift down for tilemap asymmetry
		var direction_to_center = (screen_center - boss_node.global_position).normalized()
		base_angle_offset = atan2(direction_to_center.y, direction_to_center.x)
	
	# Create a projectile group
	var group = ProjectileGroup.new()
	group.rotation_speed = group_rotation_speed
	group.position = boss_node.global_position
	get_tree().root.add_child(group)
	
	for angle in angles:
		var final_angle = angle + offset_radians + base_angle_offset
		var projectile = projectile_scene.instantiate() as BaseProjectile
		projectile.position = Vector2.ZERO  # Relative to group center
		projectile.direction = Vector2(cos(final_angle), sin(final_angle))
		
		# Apply config if provided
		if projectile_config:
			projectile.config = projectile_config
		
		group.add_child(projectile)
	
	current_angle_offset_degrees += angle_offset_per_burst_degrees

func _calculate_angles() -> Array[float]:
	var angles: Array[float] = []
	var arc_radians = deg_to_rad(arc_degrees)
	
	if arc_degrees >= 360.0:
		# Full circle - evenly spaced around
		for i in range(projectile_count):
			var angle = (2.0 * PI * i) / projectile_count
			angles.append(angle)
	else:
		# Arc - bullets at ends with even spacing between
		var start_angle = -arc_radians / 2.0
		var angle_step = arc_radians / (projectile_count - 1)
		
		for i in range(projectile_count):
			var angle = start_angle + (angle_step * i)
			angles.append(angle)
	
	return angles
