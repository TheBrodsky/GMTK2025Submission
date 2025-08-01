## Moves the boss to a specific coordinate over the duration
## Grid positions divide the screen into a 4x4 grid with 9 intersection points:
## TOP_LEFT     TOP_CENTER     TOP_RIGHT
## CENTER_LEFT  CENTER_CENTER  CENTER_RIGHT  
## BOTTOM_LEFT  BOTTOM_CENTER  BOTTOM_RIGHT
class_name MoveToAction extends AtomicBossAction

enum TargetType {
	COORDS,
	TOP_LEFT,
	TOP_CENTER,
	TOP_RIGHT,
	CENTER_LEFT,
	CENTER_CENTER,
	CENTER_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_CENTER,
	BOTTOM_RIGHT
}

@export var target_type: TargetType = TargetType.CENTER_CENTER
@export var coords: Vector2 = Vector2.ZERO

var start_position: Vector2
var target_position: Vector2

func execute(boss: Node):
	super.execute(boss)
	start_position = boss.global_position
	target_position = _calculate_target_position()
	print(target_position)

func _perform_action(delta: float):
	var progress = 1.0 - (timer.time_left / duration)
	progress = clamp(progress, 0.0, 1.0)
	
	boss_node.global_position = start_position.lerp(target_position, progress)

func _calculate_target_position() -> Vector2:
	if target_type == TargetType.COORDS:
		return coords
	
	# Calculate grid positions - divides screen into 4x4 grid with 9 intersection points
	var viewport_size = get_viewport().get_visible_rect().size
	var grid_x = viewport_size.x / 4.0
	var grid_y = viewport_size.y / 4.0
	
	match target_type:
		TargetType.TOP_LEFT:
			return Vector2(grid_x, grid_y)
		TargetType.TOP_CENTER:
			return Vector2(grid_x * 2.0, grid_y)
		TargetType.TOP_RIGHT:
			return Vector2(grid_x * 3.0, grid_y)
		TargetType.CENTER_LEFT:
			return Vector2(grid_x, grid_y * 2.0)
		TargetType.CENTER_CENTER:
			return Vector2(grid_x * 2.0, grid_y * 2.0)
		TargetType.CENTER_RIGHT:
			return Vector2(grid_x * 3.0, grid_y * 2.0)
		TargetType.BOTTOM_LEFT:
			return Vector2(grid_x, grid_y * 3.0)
		TargetType.BOTTOM_CENTER:
			return Vector2(grid_x * 2.0, grid_y * 3.0)
		TargetType.BOTTOM_RIGHT:
			return Vector2(grid_x * 3.0, grid_y * 3.0)
		_:
			return coords
