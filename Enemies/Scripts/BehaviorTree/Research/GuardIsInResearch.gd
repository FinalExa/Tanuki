extends GuardNode

@export var guardResearch: GuardResearch

func Evaluate(_delta):
	if (guardController.isInResearch):
		guardResearch.researchHasFoundSomething = false
		return NodeState.FAILURE
	return NodeState.SUCCESS
