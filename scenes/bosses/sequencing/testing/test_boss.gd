extends CharacterBody2D

@onready var action_pool = $BossAttackPool
var sequence_builder: BossSequenceBuilder
var current_sequence: BossSequence

func _ready():
	# Create sequence builder and set the action pool
	sequence_builder = BossSequenceBuilder.new()
	add_child(sequence_builder)
	sequence_builder.action_pool = action_pool
	
	# Generate and start a 15-second sequence
	_start_new_sequence()

func _start_new_sequence():
	if current_sequence:
		current_sequence.queue_free()
	
	current_sequence = sequence_builder.generate_sequence(15.0)
	if current_sequence:
		add_child(current_sequence)
		current_sequence.execute(self)
		current_sequence.completed.connect(_on_sequence_completed)

func _on_sequence_completed(boss: Node):
	print("Boss sequence completed! Starting new sequence...")
	_start_new_sequence()

func _physics_process(delta):
	move_and_slide()
