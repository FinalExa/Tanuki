extends GuardNode

@export var guardResearch: GuardResearch

func Evaluate(_delta):
	if (enemyController.isInResearch):
		return NodeState.FAILURE
	return NodeState.SUCCESS
