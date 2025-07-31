extends RefCounted;
class_name Global;

# TODO Needs to be reworked to fit with Bosses so that Bosses can use the same projectile.
# Defines the possible states of a instance of the player. can be "Player" (being controlled currently) or "Clone" (just replaying players actions)
enum PlayerMode {
	Player,
	Clone,
};

# Defining the Mode of the Projectile
enum ProjectileMode {
	Player,
	Clone,
	Enemy
}

enum CollisionLayer {
	PLAYER = 1,
	PLAYER_PROJECTILE = 2, # All Projectiles spawned by the currently active player
	ENEMY_PROJECTILE = 3, # All Projectiles spawned by the clone and/or enemy
	WALL = 4,
	ENEMY = 5,
}
