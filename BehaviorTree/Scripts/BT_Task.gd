class_name BT_Task
extends BT_Node

func Evaluate():
	if (Input.is_action_pressed("right")):
		print("c")
		return NodeState.SUCCESS
	return NodeState.FAILURE
