class_name BT_Sequence
extends BT_Node

func Evaluate(delta):
	var anyChildIsRunning: bool
	anyChildIsRunning = false
	
	for i in children.size():
		var result = children[i].Evaluate(delta)
		if (result == NodeState.FAILURE):
			state = NodeState.FAILURE
			return state
		else:
			if (result == NodeState.SUCCESS):
				continue
			else:
				if (result == NodeState.RUNNING):
					anyChildIsRunning = true
					return state
				else:
					state = NodeState.SUCCESS
					return state
	if (anyChildIsRunning):
		state = NodeState.SUCCESS
	else:
		state = NodeState.FAILURE
	return state
