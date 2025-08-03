class_name Boss extends CharacterBody2D

@export var sequence_duration: float = 60.0
@export var action_pool: BossActionPool
@export_group("Components")
@export var hitbox: HitBoxComponent;
@export var health: HealthComponent;

@onready var animated_sprite = $AnimatedSprite2D
@onready var fire_audio = $Fire
var previous_position: Vector2
var estimated_velocity: Vector2 = Vector2.ZERO
var sequence_builder: BossSequenceBuilder
var current_sequence: BossSequence

signal boss_dies;

func _ready():
	previous_position = global_position
	
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

func _process(delta):
	estimated_velocity = (global_position - previous_position) / delta
	previous_position = global_position
	if !estimated_velocity and animated_sprite.animation != "IdleBoss":
		animated_sprite.play("BossIdle")
	if estimated_velocity:
		animated_sprite.play("BossRun")
		toggle_flip_sprite(estimated_velocity)

func toggle_flip_sprite(dir: Vector2) -> void:
	if dir.x < 0:
		animated_sprite.flip_h = true
	elif dir.x > 0:
		animated_sprite.flip_h = false

func _on_health_component_got_damaged(attack: Attack) -> void:
	$Damage.play()
	health.health -= attack.attack_damage;
	if health.health <= 0:
		$Death.play()
		boss_dies.emit();
