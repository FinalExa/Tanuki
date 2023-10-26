extends GuardNode

func Evaluate(delta):
	if (guardController.isInAlert == true):
		return NodeState.FAILURE
	return NodeState.SUCCESS
