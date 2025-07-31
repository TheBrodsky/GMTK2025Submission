## Generates random boss sequences from an action pool that fit a specific duration
class_name BossSequenceBuilder extends Node

@export var action_pool_scene: PackedScene

var action_pool: BossActionPool

func initialize_action_pool():
	if action_pool_scene and not action_pool:
		action_pool = action_pool_scene.instantiate()
		add_child(action_pool)
		print("Loaded action pool with ", action_pool.get_all_actions().size(), " actions")

func generate_sequence(sequence_duration: float, level: int = 1, run_seed: int = 0) -> BossSequence:
	var rng = RandomNumberGenerator.new()
	rng.seed = run_seed + level
	
	if not action_pool:
		initialize_action_pool()
	
	if not action_pool:
		push_error("No action pool available for sequence generation")
		return null
	
	var pool_actions = action_pool.get_all_actions()
	if pool_actions.is_empty():
		push_error("Action pool is empty")
		return null
	
	var sequence = BossSequence.new()
	var remaining_time = sequence_duration
	
	while remaining_time > 0:
		var available_actions = pool_actions.filter(func(action): return action.duration <= remaining_time)
		
		if available_actions.is_empty():
			var shortest_action = pool_actions.reduce(func(acc, action): return action if action.duration < acc.duration else acc)
			if shortest_action:
				sequence.add_child(shortest_action.duplicate())
				remaining_time -= shortest_action.duration
			break
		
		var selected_action = available_actions[rng.randi() % available_actions.size()]
		sequence.add_child(selected_action.duplicate())
		remaining_time -= selected_action.duration
	
	print("Generated boss sequence with ", sequence.get_child_count(), " actions")
	return sequence
