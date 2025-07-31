## Pool of actions a boss can draw from when generating sequences
## Actions are added to the pool by making them child nodes
## Can contain both BossActions and other BossActionPools for nesting
class_name BossActionPool extends BossAction

@export var is_subpool: bool = false # if true, all actions must have same duration

func _ready():
	super._ready()
	_validate_pool_has_items()
	if is_subpool:
		_calculate_and_enforce_subpool_duration()

func get_all_items() -> Array[BossAction]:
	var items: Array[BossAction] = []
	for child in get_children():
		if child is BossAction:
			items.append(child)
	return items

func select_shortest_action() -> BossAction:
	var items = get_all_items()
	if items.is_empty():
		return null
	
	return items.reduce(func(acc, action): return action if action.duration < acc.duration else acc)

func select_random_action_with_max_duration(max_duration: float, rng: RandomNumberGenerator = null) -> BossAction:
	var items = get_all_items()
	var valid_items = items.filter(func(action): return action.duration <= max_duration)
	return _select_random_action(valid_items, rng)

func clone() -> BossAction:
	if is_subpool:
		# Subpools select a random action and return its clone
		var items = get_all_items()
		var selected = _select_random_action(items)
		return selected.clone() if selected else null
	else:
		# Regular pools should not be cloned directly
		push_error("Cannot clone a regular BossActionPool - only subpools support cloning")
		return null

func _select_random_action(items: Array[BossAction], rng: RandomNumberGenerator = null) -> BossAction:
	if not rng:
		rng = Global.SequenceRNG
	
	if items.is_empty():
		return null
	
	return items[rng.randi() % items.size()]

func _validate_pool_has_items():
	var items = get_all_items()
	if items.is_empty():
		push_error("BossActionPool has no child actions")

func _calculate_and_enforce_subpool_duration():
	var items = get_all_items()
	
	# Check that all items have the same duration
	var first_duration = items[0].duration
	for item in items:
		if abs(item.duration - first_duration) > 0.001: # small epsilon for float comparison
			push_error("Subpool contains actions with different durations: " + str(item.duration) + " vs " + str(first_duration))
			# Enforce the first duration on all items
			item.duration = first_duration
	
	duration = first_duration
