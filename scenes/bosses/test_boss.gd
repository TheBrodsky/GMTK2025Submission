extends CharacterBody2D;

@onready var sequence = $BossSequence

func _ready():
	sequence.execute(self)
	sequence.completed.connect(_on_sequence_completed)

func _on_sequence_completed(_boss: Node):
	print("Boss sequence completed!")

func _physics_process(_delta):
	move_and_slide()
