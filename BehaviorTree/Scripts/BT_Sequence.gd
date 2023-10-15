class_name BT_Sequence
extends BT_Node

func Evaluate():
	var anyChildIsRunning: bool
	anyChildIsRunning = false
	
	for i in children.size():
		if (children[i].Evaluate() == NodeState.FAILURE):
			state = NodeState.FAILURE
			return state
		else:
			if (children[i].Evaluate() == NodeState.SUCCESS):
				continue
			else:
				if (children[i].Evaluate() == NodeState.RUNNING):
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
