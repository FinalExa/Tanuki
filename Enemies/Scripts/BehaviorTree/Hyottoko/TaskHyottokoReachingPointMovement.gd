extends GuardNode

@export var hyottokoReachPoint: HyottokoReachPoint

func Evaluate(_delta):
	if (enemyController.global_position.distance_to(hyottokoReachPoint.pointToReach) > hyottokoReachPoint.distanceFromPointToReach):
		return NodeState.FAILURE
	enemyController.enemyMovement.set_new_target(null)
	return NodeState.SUCCESS
