## Moves the boss in a straight line for the duration
class_name MoveLinearAction extends AtomicBossAction

@export var direction: Vector2 = Vector2.RIGHT
@export var speed: float = 100.0

func execute(boss: Node):
	super.execute(boss)
	boss.velocity += direction.normalized() * speed

func _on_complete(boss: Node):
	boss.velocity -= direction.normalized() * speed
