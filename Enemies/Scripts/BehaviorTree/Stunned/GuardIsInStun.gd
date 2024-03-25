extends GuardNode

func Evaluate(_delta):
	if (guardController.isStunned == true):
		return NodeState.FAILURE
	return NodeState.SUCCESS
