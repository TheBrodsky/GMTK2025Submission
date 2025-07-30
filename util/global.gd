extends RefCounted;
class_name Global;

# Defines the possible states of a instance of the player. can be "Player" (being controlled currently) or "Clone" (just replaying players actions)
enum PlayerMode {
	Player,
	Clone,
};

enum CollisionLayer {
	PLAYER = 1,
	PLAYER_PROJECTILE = 2, # All Projectiles spawned by the currently active player
	ENEMY_PROJECTILE = 3, # All Projectiles spawned by the clone and/or enemy
	WALL = 4,
	ENEMY = 5,
}
