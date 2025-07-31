## Base class for all boss actions
## Actions come in three flavors:
## - Atomic: single action over time
## - Composite: multiple simultaneous actions
## - Sequence: chained actions
class_name BossAction extends Node

signal completed(boss_node: Node)

@export var duration: float = 1.0

var boss_node: Node

## Entry point for action; kicks it off
func execute(boss: Node):
	boss_node = boss
