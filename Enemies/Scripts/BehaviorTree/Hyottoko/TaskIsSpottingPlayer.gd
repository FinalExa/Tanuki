extends GuardNode

func Evaluate(_delta):
	if (enemyController.isSpottingPlayer):
		if (enemyController.isInPatrol):
			enemyController.enemyPatrol.stop_patrol()
		return NodeState.FAILURE
	if (!enemyController.isInPatrol):
		enemyController.enemyPatrol.resume_patrol()
	return NodeState.SUCCESS
