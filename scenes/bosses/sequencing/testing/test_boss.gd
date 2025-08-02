extends CharacterBody2D

@export var sequence_duration: float = 30.0

@onready var action_pool = $BossAttackPool
var sequence_builder: BossSequenceBuilder
var current_sequence: BossSequence

func _ready():
	# Create sequence builder and set the action pool
	sequence_builder = BossSequenceBuilder.new()
	add_child(sequence_builder)
	sequence_builder.action_pool = action_pool
	_start_new_sequence()

func _start_new_sequence():
	if current_sequence:
		current_sequence.queue_free()
	
	current_sequence = sequence_builder.generate_sequence(sequence_duration)
	if current_sequence:
		add_child(current_sequence)
		current_sequence.execute(self)
		current_sequence.completed.connect(_on_sequence_completed)

func _on_sequence_completed(_boss: Node):
	print("Boss sequence completed!")

func _physics_process(_delta):
	move_and_slide()
