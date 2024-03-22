extends GuardNode

@export var guardResearch: GuardResearch

func Evaluate(_delta):
	if (guardController.isInResearch):
		return NodeState.FAILURE
	return NodeState.SUCCESS
