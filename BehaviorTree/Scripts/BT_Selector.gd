class_name BT_Selector
extends BT_Node

func Evaluate(delta):
	for i in children.size():
		var result = children[i].Evaluate(delta)
		if (result == NodeState.FAILURE || result == NodeState.RUNNING):
			continue
		else:
			state = NodeState.SUCCESS
			return state
	state = NodeState.FAILURE
	return state
