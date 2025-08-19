extends GuardNode

@export var hyottokoReachPoint: HyottokoReachPoint

func Evaluate(_delta):
	if (enemyController.global_position.distance_to(hyottokoReachPoint.pointToReach) > hyottokoReachPoint.distanceFromPointToReach):
		if (enemyController.velocity == Vector2.ZERO):
			enemyController.enemyMovement.reset_movement_speed()
			enemyController.enemyMovement.set_location_target(hyottokoReachPoint.pointToReach)
		return NodeState.FAILURE
	enemyController.enemyMovement.set_new_target(null)
	return NodeState.SUCCESS
