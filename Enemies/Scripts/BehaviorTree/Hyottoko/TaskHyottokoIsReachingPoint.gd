extends GuardNode

@export var hyottokoController: HyottokoController

func Evaluate(_delta):
	if (hyottokoController.isReachingPoint):
		return NodeState.FAILURE
	return NodeState.SUCCESS
