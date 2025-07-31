class_name BossCollection extends Resource

@export var bosses: Array[PackedScene];

func get_random_boss() -> PackedScene:
	if bosses.size() > 0:
		return bosses.pick_random();
	return null;
