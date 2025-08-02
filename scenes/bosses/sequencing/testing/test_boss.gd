extends CharacterBody2D

@export var sequence_duration: float = 30.0

@onready var action_pool = $BossAttackPool
var sequence_builder: BossSequenceBuilder
var current_sequence: BossSequence

@onready var animated_sprite = $AnimatedSprite2D
var previous_position: Vector2
var estimated_velocity: Vector2 = Vector2.ZERO

@export var health = 1000
@onready var health_bar = $BossHealthBar

var health_bar_global_pos: Vector2

func _ready():
	previous_position = global_position
	
	health_bar.value = health;
	health_bar_global_pos = health_bar.global_position
	
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
	health_bar.global_position = health_bar_global_pos
	move_and_slide()

func _process(delta):
	health_bar.global_position = health_bar_global_pos
	estimated_velocity = (global_position - previous_position) / delta
	previous_position = global_position
	if !estimated_velocity and animated_sprite.animation != "IdleBoss":
		animated_sprite.play("BossIdle")
	if estimated_velocity:
		animated_sprite.play("BossRun")
		toggle_flip_sprite(estimated_velocity)
		call_deferred("position_health_bar")

func position_health_bar():
	health_bar.global_position = health_bar_global_pos

func toggle_flip_sprite(dir: Vector2) -> void:
	if dir.x < 0:
		animated_sprite.flip_h = true
	elif dir.x > 0:
		animated_sprite.flip_h = false
		
func take_damage(): #NOT WORKING, NEED TO ADD A HITBOX AND HIT REGISTRATION!
	health -= 1
	health_bar.value = health;
