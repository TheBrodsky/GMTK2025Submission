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
	BOTTOM_RIGHT,
	RANDOM
}

@export var target_type: TargetType = TargetType.CENTER_CENTER
@export var coords: Vector2 = Vector2.ZERO

var start_position: Vector2
var target_position: Vector2

func execute(boss: Node):
	super.execute(boss)
	start_position = boss.global_position
	target_position = _calculate_target_position()
	print("Moving boss from", boss.global_position, "to", target_position)

func _perform_action(_delta: float):
	var progress = 1.0 - (timer.time_left / duration)
	progress = clamp(progress, 0.0, 1.0)
	
	boss_node.global_position = start_position.lerp(target_position, progress)

func _calculate_target_position() -> Vector2:
	if target_type == TargetType.COORDS:
		return coords
	
	# Calculate grid positions with center at (0,0)
	# Top/bottom rows: 2/3rds from center to edges
	# Left/right columns: 3/4ths from center to edges
	var viewport_size = get_viewport().get_visible_rect().size
	var half_width = viewport_size.x / 2.0
	var half_height = viewport_size.y / 2.0
	
	# Calculate distances from center (0,0)
	var horizontal_offset = half_width * 0.75  # 3/4ths to edges
	var vertical_offset = half_height * (2.0/3.0)  # 2/3rds to edges
	
	match target_type:
		TargetType.TOP_LEFT:
			return Vector2(-horizontal_offset, -vertical_offset)
		TargetType.TOP_CENTER:
			return Vector2(0, -vertical_offset)
		TargetType.TOP_RIGHT:
			return Vector2(horizontal_offset, -vertical_offset)
		TargetType.CENTER_LEFT:
			return Vector2(-horizontal_offset, 0)
		TargetType.CENTER_CENTER:
			return Vector2(0, 0)
		TargetType.CENTER_RIGHT:
			return Vector2(horizontal_offset, 0)
		TargetType.BOTTOM_LEFT:
			return Vector2(-horizontal_offset, vertical_offset)
		TargetType.BOTTOM_CENTER:
			return Vector2(0, vertical_offset)
		TargetType.BOTTOM_RIGHT:
			return Vector2(horizontal_offset, vertical_offset)
		TargetType.RANDOM:
			# Boss is 50px wide/tall, add padding to keep it fully visible
			var padding = 25.0  # Half of boss size
			var min_x = -half_width + padding
			var max_x = half_width - padding
			var min_y = -half_height + padding  
			var max_y = half_height - padding
			return Vector2(
				Global.SequenceRNG.randf_range(min_x, max_x),
				Global.SequenceRNG.randf_range(min_y, max_y)
			)
		_:
			return coords
