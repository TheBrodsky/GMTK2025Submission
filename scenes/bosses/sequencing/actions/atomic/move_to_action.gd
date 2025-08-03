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
	
	# Calculate grid positions with center at camera position
	# Top/bottom rows: 2/3rds from center to edges
	# Left/right columns: 3/4ths from center to edges
	var camera = get_viewport().get_camera_2d()
	var camera_size = get_viewport().get_visible_rect().size / camera.zoom
	var camera_center = camera.global_position
	print(camera_size)
	var half_width = camera_size.x / 2.0
	var half_height = camera_size.y / 2.0
	
	var horizontal_offset = half_width * 0.85
	var vertical_offset = half_height * (2.0/3.0)
	var grid_shift_down = 100.0  # Shift entire grid down due to tilemap asymmetry
	
	match target_type:
		TargetType.TOP_LEFT:
			return camera_center + Vector2(-horizontal_offset, -vertical_offset + grid_shift_down)
		TargetType.TOP_CENTER:
			return camera_center + Vector2(0, -vertical_offset + grid_shift_down)
		TargetType.TOP_RIGHT:
			return camera_center + Vector2(horizontal_offset, -vertical_offset + grid_shift_down)
		TargetType.CENTER_LEFT:
			return camera_center + Vector2(-horizontal_offset, grid_shift_down)
		TargetType.CENTER_CENTER:
			return camera_center + Vector2(0, grid_shift_down)
		TargetType.CENTER_RIGHT:
			return camera_center + Vector2(horizontal_offset, grid_shift_down)
		TargetType.BOTTOM_LEFT:
			return camera_center + Vector2(-horizontal_offset, vertical_offset + grid_shift_down)
		TargetType.BOTTOM_CENTER:
			return camera_center + Vector2(0, vertical_offset + grid_shift_down)
		TargetType.BOTTOM_RIGHT:
			return camera_center + Vector2(horizontal_offset, vertical_offset + grid_shift_down)
		TargetType.RANDOM:
			var padding = 75.0  # Half of boss size (150px)
			var top_padding = padding + 200.0  # Regular padding + extra 200px for tilemap asymmetry
			var min_x = camera_center.x - half_width + padding
			var max_x = camera_center.x + half_width - padding
			var min_y = camera_center.y - half_height + top_padding  
			var max_y = camera_center.y + half_height - padding
			return Vector2(
				Global.SequenceRNG.randf_range(min_x, max_x),
				Global.SequenceRNG.randf_range(min_y, max_y)
			)
		_:
			return coords
