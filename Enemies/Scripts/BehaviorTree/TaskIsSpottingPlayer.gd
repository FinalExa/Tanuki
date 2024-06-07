extends GuardNode

func Evaluate(_delta):
	if (enemyController.isSpottingPlayer):
		return NodeState.FAILURE
	if (!enemyController.isInPatrol):
		enemyController.enemyPatrol.resume_patrol()
	return NodeState.SUCCESS
