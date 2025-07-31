## Moves the boss in a straight line for the duration
extends AtomicBossAction

@export var direction: Vector2 = Vector2.RIGHT
@export var speed: float = 100.0

func execute(boss: Node):
	super.execute(boss)
	boss_node.velocity += direction.normalized() * speed

func _on_complete(boss_node: Node):
	boss_node.velocity -= direction.normalized() * speed
