extends GuardNode

@export var hyottokoBossController: HyottokoBossController

func Evaluate(_delta):
	if (hyottokoBossController.isCaptured):
		return NodeState.FAILURE
	return NodeState.SUCCESS
