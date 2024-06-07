extends GuardNode

func Evaluate(_delta):
	var dist = enemyController.global_position.distance_to(enemyController.playerRef.global_position)
	if (dist > enemyController.hyottokoPushDistanceFromPlayer):
		if (enemyController.enemyMovement.target != enemyController.playerRef):
			enemyController.enemyMovement.set_new_target(enemyController.playerRef)
		return NodeState.FAILURE
	enemyController.enemyMovement.set_new_target(null)
	return NodeState.SUCCESS
