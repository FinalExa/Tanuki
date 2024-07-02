extends GuardNode

func Evaluate(_delta):
	var dist = enemyController.global_position.distance_to(enemyController.playerRef.global_position)
	if (dist > enemyController.hyottokoPushDistanceFromPlayer):
		if (enemyController.enemyMovement.target != enemyController.playerRef):
			enemyController.enemyMovement.reset_movement_speed()
			enemyController.enemyMovement.set_new_target(enemyController.playerRef)
			enemyController.enemyRotator.setLookingAtNode(enemyController.playerRef)
		return NodeState.FAILURE
	enemyController.enemyMovement.set_new_target(null)
	return NodeState.SUCCESS
