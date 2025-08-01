extends Node

@onready var sequence_builder = $BossSequenceBuilder
@onready var boss_node = $TestBoss

var current_sequence: BossSequence

func _ready():
	print("=== Starting Sequence Test ===")
	print("Generating 15-second sequence...")
	
	current_sequence = sequence_builder.generate_sequence(15.0, 1)
	if current_sequence:
		add_child(current_sequence)
		current_sequence.completed.connect(_on_sequence_completed)
		
		print("Starting sequence with ", current_sequence.get_child_count(), " actions")
		print("Expected duration: ", current_sequence.duration, " seconds")
		print("Actions:")
		for i in range(current_sequence.get_child_count()):
			var action = current_sequence.get_child(i)
			print("  ", i + 1, ". ", action.name, " (", action.duration, "s)")
		print("---")
		
		current_sequence.execute(boss_node)
	else:
		print("Failed to generate sequence!")

func _on_sequence_completed(boss: Node):
	print("=== Sequence Completed! ===")
	print("Boss node: ", boss.name)
