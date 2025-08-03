## Actions that run one after another in sequence
## A boss' actions are defined by a sequence, which itself can include sequences.
@icon("res://assets/editor_icons/sequence_icon.svg")
class_name BossSequence extends BossAction

@export var loops: bool = false

var actions: Array[BossAction] = []

func _ready():
	super._ready()
	_get_actions()
	_calculate_duration()
	_chain_actions()

func execute(boss: Node):
	super.execute(boss)
	if actions.is_empty():
		push_error("Cannot execute sequence: no actions")
		return
	
	actions[0].execute(boss)

func clone() -> BossAction:
	var cloned = duplicate()
	# Replace any subpools in the cloned sequence
	_replace_subpools_in_cloned_node(cloned)
	return cloned

func _replace_subpools_in_cloned_node(node: Node):
	var children = node.get_children()
	for child in children:
		if child is BossActionPool and child.is_subpool:
			var cloned_action = child.clone()
			if cloned_action:
				var child_index = child.get_index()
				node.remove_child(child)
				node.add_child(cloned_action)
				node.move_child(cloned_action, child_index)
				child.queue_free()

func _get_actions():
	actions.clear()
	for child in get_children():
		if child is BossAction:
			actions.append(child)

func _calculate_duration():
	var total_duration = 0.0
	for action in actions:
		total_duration += action.duration
	duration = total_duration

func _chain_actions():
	for i in range(actions.size() - 1):
		actions[i].completed.connect(actions[i + 1].execute)
	
	if actions.size() > 0:
		actions[-1].completed.connect(_on_sequence_complete)

func _on_sequence_complete(boss: Node):
	if not loops:
		completed.emit(boss)
	else:
		execute(boss)
