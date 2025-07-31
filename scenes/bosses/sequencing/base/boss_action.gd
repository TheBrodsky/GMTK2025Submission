## Base class for all boss actions
## Actions come in three flavors:
## - Atomic: single action over time
## - Composite: multiple simultaneous actions
## - Sequence: chained actions
class_name BossAction extends Node

@export var my_owner: Node; # the instance that

signal completed(boss_node: Node)

@export var duration: float = 1.0

var boss_node: Node

func _ready() -> void:
	completed.connect(_on_complete)
	
	if my_owner:
		return;
	var parent = get_parent();
	if parent is not BossAction:
		push_error("Boss Action with undefined owner. Unable to get from parent.")
		return;
	var parent_action: BossAction = parent;
	my_owner = parent_action.my_owner;

## Entry point for action; kicks it off
func execute(boss: Node):
	boss_node = boss

## In case there's any cleanup an action needs to do before it expires
func _on_complete(_boss_node: Node):
	pass
