extends GuardNode

func Evaluate(delta):
	if (guardController.isStunned == true):
		return NodeState.FAILURE
	return NodeState.SUCCESS
