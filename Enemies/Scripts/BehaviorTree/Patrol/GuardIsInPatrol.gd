extends GuardNode

func Evaluate(_delta):
	if (enemyController.isInPatrol):
		return NodeState.FAILURE
	return NodeState.SUCCESS
