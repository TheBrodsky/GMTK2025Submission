## Base class for all boss actions
## Actions come in three flavors:
## - Atomic: single action over time
## - Composite: multiple simultaneous actions
## - Sequence: chained actions
class_name BossAction extends Node

signal completed(boss_node: Node)

var duration: float = 1.0

var boss_node: Node

func _ready() -> void:
	completed.connect(_on_complete)

## Entry point for action; kicks it off
func execute(boss: Node):
	boss_node = boss

## Creates a copy of this action - override for custom cloning behavior
func clone() -> BossAction:
	return duplicate()

## In case there's any cleanup an action needs to do before it expires
func _on_complete(_boss_node: Node):
	pass
