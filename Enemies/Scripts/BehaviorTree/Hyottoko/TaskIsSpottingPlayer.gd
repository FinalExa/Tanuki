extends GuardNode

func Evaluate(_delta):
	if (enemyController.isSpottingPlayer):
		if (enemyController.isInPatrol):
			enemyController.enemyPatrol.stop_patrol()
		return NodeState.FAILURE
	return NodeState.SUCCESS
