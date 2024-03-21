class_name BT_Selector
extends BT_Node

func Evaluate(delta):
	for i in children.size():
		var result = children[i].Evaluate(delta)
		if (result == NodeState.FAILURE):
			continue
		else:
			if (result == NodeState.SUCCESS):
				state = NodeState.SUCCESS
				return state
			else:
				if (result == NodeState.RUNNING):
					continue
				else:
					continue
	state = NodeState.FAILURE
	return state
