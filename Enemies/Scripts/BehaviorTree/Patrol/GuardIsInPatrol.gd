extends GuardNode

@export var guardPatrol: GuardPatrol

func Evaluate(_delta):
	if (guardController.isInPatrol):
		return NodeState.FAILURE
	else:
		return NodeState.SUCCESS
