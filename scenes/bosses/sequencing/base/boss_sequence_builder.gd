## Generates random boss sequences from an action pool that fit a specific duration
class_name BossSequenceBuilder extends Node

@export var action_pool_scene: PackedScene

var action_pool: BossActionPool

func initialize_action_pool():
	if action_pool_scene and not action_pool:
		action_pool = action_pool_scene.instantiate()
		add_child(action_pool)
		print("Loaded action pool with ", action_pool.get_all_items().size(), " actions")

func generate_sequence(sequence_duration: float, level: int = 1) -> BossSequence:
	# Use global SequenceRNG for consistent randomization across all boss actions
	var rng = Global.SequenceRNG
	
	if not action_pool:
		initialize_action_pool()
	
	if not action_pool:
		push_error("No action pool available for sequence generation")
		return null
	
	var sequence = BossSequence.new()
	var remaining_time = sequence_duration
	
	while remaining_time > 0:
		var selected_action = action_pool.select_random_action_with_max_duration(remaining_time, rng)
		
		if not selected_action:
			var shortest_action = action_pool.select_shortest_action()
			if shortest_action:
				sequence.add_child(shortest_action.clone())
				remaining_time -= shortest_action.duration
			break
		
		sequence.add_child(selected_action.clone())
		remaining_time -= selected_action.duration
	
	print("Generated boss sequence with ", sequence.get_child_count(), " actions")
	return sequence
