extends GuardNode

func Evaluate(_delta):
	if (enemyController.isStunned || enemyController.isRepelled):
		return NodeState.FAILURE
	return NodeState.SUCCESS
