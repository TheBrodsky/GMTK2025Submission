extends RefCounted;
class_name Global;

# Defines the possible states of a instance of the player. can be "Player" (being controlled currently) or "Clone" (just replaying players actions)
enum PlayerMode {
	PLAYER,
	CLONE,
};

# Defining the Mode of the Projectile
enum ProjectileMode {
	PLAYER,
	CLONE,
	ENEMY,
}

enum CollisionLayer {
	PLAYER = 1,
	PLAYER_PROJECTILE = 2, # All Projectiles spawned by the currently active player
	CLONE_PROJECTILE = 3, # All Projectiles spawned by clones
	WALL = 4,
	ENEMY = 5,
	CLONE = 6,
	ENEMY_PROJECTILE = 7,
}

enum BossDifficulty {
	TEST = 0,
	EASY = 1,
	MEDIUM = 2,
	HARD = 3,
}

static var global_seed: int = 10
static var use_random_seed: bool = true
static var SequenceRNG: RandomNumberGenerator
static var selected_difficulty: BossDifficulty = BossDifficulty.EASY

static func _static_init():
	SequenceRNG = RandomNumberGenerator.new()
	
	if use_random_seed:
		# Generate a random seed and overwrite global_seed with it
		global_seed = randi()
	
	SequenceRNG.seed = global_seed
