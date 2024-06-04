extends GuardNode

func Evaluate(_delta):
	if (guardController.isInPatrol):
		return NodeState.FAILURE
	else:
		return NodeState.SUCCESS
