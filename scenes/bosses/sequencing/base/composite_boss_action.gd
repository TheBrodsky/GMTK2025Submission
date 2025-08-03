## Multiple actions that run simultaneously, completes when all children complete
@icon("res://assets/editor_icons/compound_icon.svg")
class_name CompositeBossAction extends BossAction

var sub_actions: Array[BossAction] = []
var completed_actions: int = 0

func _ready():
	super._ready()
	_get_sub_actions()
	_calculate_duration()
	
	for sub_action in sub_actions:
		sub_action.completed.connect(_on_sub_action_completed)

func execute(boss: Node):
	super.execute(boss)
	completed_actions = 0
	for sub_action in sub_actions:
		sub_action.execute(boss)

func clone() -> BossAction:
	var cloned = duplicate()
	# Replace any subpools in the cloned composite
	_replace_subpools_in_cloned_node(cloned)
	return cloned

func _replace_subpools_in_cloned_node(node: Node):
	var children = node.get_children()
	for child in children:
		if child is BossActionPool and child.is_subpool:
			var cloned_action = child.clone()
			if cloned_action:
				node.remove_child(child)
				node.add_child(cloned_action)
				child.queue_free()

func _get_sub_actions():
	sub_actions.clear()
	for child in get_children():
		if child is BossAction:
			sub_actions.append(child)

func _calculate_duration():
	var max_duration = 0.0
	for sub_action in sub_actions:
		max_duration = max(max_duration, sub_action.duration)
	duration = max_duration

func _on_sub_action_completed(boss: Node):
	completed_actions += 1
	if completed_actions >= sub_actions.size():
		completed.emit(boss)
