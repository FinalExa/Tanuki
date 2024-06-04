extends GuardNode

func Evaluate(_delta):
	if (enemyController.isStunned == true):
		return NodeState.FAILURE
	return NodeState.SUCCESS
