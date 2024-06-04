extends GuardNode

func Evaluate(_delta):
	if (enemyController.isInPatrol):
		return NodeState.FAILURE
	else:
		return NodeState.SUCCESS
