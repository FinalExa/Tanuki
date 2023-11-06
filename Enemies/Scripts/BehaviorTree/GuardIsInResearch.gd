extends GuardNode

func Evaluate(_delta):
	if (guardController.isInResearch == true):
		return NodeState.FAILURE
	return NodeState.SUCCESS
