class_name BT_Selector
extends BT_Node

func Evaluate():
	for i in children.size():
		if (children[i].Evaluate() == NodeState.FAILURE):
			continue
		else:
			if (children[i].Evaluate() == NodeState.SUCCESS):
				state = NodeState.SUCCESS
				return state
			else:
				if (children[i].Evaluate() == NodeState.RUNNING):
					state = NodeState.RUNNING
					return state
				else:
					continue
	state = NodeState.FAILURE
	return state
