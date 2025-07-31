## Fires N projectiles in an arc at regular intervals
extends AtomicBossAction

@export_range(2, 50) var projectile_count: int = 8
@export var arc_degrees: float = 360.0
@export var fire_rate: float = 1.0 # fires per second
@export var projectile_scene: PackedScene

var fire_timer: float = 0.0

func _perform_action(delta: float):
	fire_timer += delta
	
	var fire_interval = 1.0 / fire_rate
	if fire_timer >= fire_interval:
		fire_timer -= fire_interval
		_fire_radial_burst()

func _fire_radial_burst():
	var angles = _calculate_angles()
	
	for angle in angles:
		var projectile = projectile_scene.instantiate() as Projectile
		projectile.mode = Global.PlayerMode.Clone # TODO See Global.PlayerMode
		projectile.position = boss_node.global_position
		projectile.target_position = Vector2(cos(angle), sin(angle)) # normalized direction
		get_tree().root.add_child(projectile)

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
