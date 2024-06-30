extends GuardNode

@export var hyottokoController: HyottokoController

func Evaluate(delta):
	if (hyottokoController.isReachingPoint):
		return NodeState.FAILURE
	return NodeState.SUCCESS
