extends GuardNode

func Evaluate(delta):
	if (guardController.isChecking):
		return NodeState.FAILURE
	return NodeState.SUCCESS
