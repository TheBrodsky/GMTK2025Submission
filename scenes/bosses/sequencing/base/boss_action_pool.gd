## Pool of actions a boss can draw from when generating sequences
## Actions are added to the pool by making them child nodes
class_name BossActionPool extends Node

func get_all_actions() -> Array[BossAction]:
	var actions: Array[BossAction] = []
	for child in get_children():
		if child is BossAction:
			actions.append(child)
	return actions
