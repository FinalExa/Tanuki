extends GuardNode

@export var hyottokoController: HyottokoController

func Evaluate(_delta):
	if (hyottokoController.isEntranced):
		return NodeState.FAILURE
	return NodeState.SUCCESS
