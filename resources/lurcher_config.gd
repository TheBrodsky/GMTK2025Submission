extends BaseProjectileConfig
class_name LurcherConfig

@export var lurch_cycle_time: float = 1.0  # Time for one complete stop-lurch cycle
@export var lurch_distance_multiplier: float = 2.0  # How much distance is covered in the lurch vs normal movement
@export var pause_ratio: float = 0.3  # Fraction of cycle spent stopped (0.3 = 30% stopped, 70% lurching)
