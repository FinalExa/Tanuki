extends GuardNode

func Evaluate(_delta):
	if (enemyController.isSpottingPlayer):
		return NodeState.FAILURE
	return NodeState.SUCCESS
