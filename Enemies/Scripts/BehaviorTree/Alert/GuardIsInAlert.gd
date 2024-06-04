extends GuardNode

func Evaluate(_delta):
	if (enemyController.isInAlert == true):
		return NodeState.FAILURE
	return NodeState.SUCCESS
