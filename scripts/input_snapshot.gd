class_name InputSnapshot;

var move_direction: Vector2;
var look_direction: Vector2;
var shooting_pressed: bool;
var dashing: bool;

# Compares self with other to see if equal
func is_equal(other: InputSnapshot) -> bool:
	return move_direction.is_equal_approx(other.move_direction) \
		and look_direction.is_equal_approx(other.look_direction) \
		and shooting_pressed == other.shooting_pressed \
		and dashing == other.dashing;
