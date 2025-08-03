extends BaseProjectileConfig
class_name BombConfig

enum DetonationMode {
	DECELERATION,  # Detonates when speed drops below threshold (current behavior)
	TIME_LIMIT     # Detonates after a fixed time regardless of speed
}

@export var detonation_mode: DetonationMode = DetonationMode.DECELERATION
@export var deceleration: float = 75.0
@export var explosion_projectile_count: int = 8
@export var explosion_speed: float = 100.0
@export var min_speed_threshold: float = 10.0
@export var base_blink_frequency: float = 2.0
@export var time_limit: float = 3.0  # Time in seconds before detonation (for TIME_LIMIT mode)
