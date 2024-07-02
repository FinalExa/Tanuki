extends GuardNode

@export var guardDistraction: GuardDistraction

func Evaluate(_delta):
	if (guardDistraction.isDistracted):
		return NodeState.FAILURE
	return NodeState.SUCCESS
