extends GuardNode

@export var hyottokoReachPoint: HyottokoReachPoint

func Evaluate(delta):
	if (hyottokoReachPoint.pointReachedTimer > 0):
		hyottokoReachPoint.pointReachedTimer -= delta
		return NodeState.FAILURE
	hyottokoReachPoint.StopReachingPoint()
	return NodeState.FAILURE
