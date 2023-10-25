class_name BT_Sequence
extends BT_Node

func Evaluate(delta):
	var anyChildIsRunning: bool
	anyChildIsRunning = false
	
	for i in children.size():
		if (children[i].Evaluate(delta) == NodeState.FAILURE):
			state = NodeState.FAILURE
			return state
		else:
			if (children[i].Evaluate(delta) == NodeState.SUCCESS):
				continue
			else:
				if (children[i].Evaluate(delta) == NodeState.RUNNING):
					anyChildIsRunning = true
					return state
				else:
					state = NodeState.SUCCESS
					return state
	if (anyChildIsRunning == true):
		state = NodeState.SUCCESS
	else:
		state = NodeState.FAILURE
	return state
