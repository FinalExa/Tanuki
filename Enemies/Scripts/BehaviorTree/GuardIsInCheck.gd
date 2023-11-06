extends GuardNode

func Evaluate(_delta):
	if (guardController.isChecking):
		return NodeState.FAILURE
	return NodeState.SUCCESS
