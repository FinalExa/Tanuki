extends GuardNode

func Evaluate(delta):
	if (guardController.isInResearch == true):
		return NodeState.FAILURE
	return NodeState.SUCCESS
