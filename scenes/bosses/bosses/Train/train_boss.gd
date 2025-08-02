extends Node2D

@onready var sprite =  $Sprite2D
@onready var warning = $Warning

@export var attack_speed = 2
@export var attack_cooldown = 4

@export var health = 750
@onready var health_bar = $BossHealthBar

var health_bar_global_pos: Vector2

var rng = RandomNumberGenerator.new()
var velocity = Vector2()

var ready_to_attack = true

func _ready():
	warning.visible = false
	health_bar_global_pos = health_bar.global_position
	health_bar.max_value = health
	health_bar.value = health

func _physics_process(delta):
	position += velocity * delta
	
func _process(delta):
	if ready_to_attack == true:
		var attack_angle = deg_to_rad(rng.randi_range(0, 360))
		rotation = attack_angle
		visible = false
		position = Vector2(-100, 0).rotated(attack_angle)
		visible = true
		warning.visible = true
		await get_tree().create_timer(attack_speed).timeout
		warning.visible = false
		velocity = Vector2(200, 0).rotated(attack_angle)
		ready_to_attack = false
		await attack_cooldown_reset()
	call_deferred("position_health_bar")
	
func position_health_bar():
	health_bar.global_position = health_bar_global_pos
	
func attack_cooldown_reset():
	await get_tree().create_timer(attack_cooldown).timeout
	velocity = Vector2.ZERO
	ready_to_attack = true

func take_damage(): #NOT WORKING, NEED TO ADD A HITBOX AND HIT REGISTRATION!
	health -= 1
	health_bar.value = health;
