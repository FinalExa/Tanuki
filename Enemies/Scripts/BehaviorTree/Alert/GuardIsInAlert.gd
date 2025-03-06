extends GuardNode

func Evaluate(_delta):
	if (enemyController.isInAlert):
		return NodeState.FAILURE
	return NodeState.SUCCESS
