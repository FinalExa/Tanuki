extends GuardNode

@export var guardPatrol: GuardPatrol

func Evaluate(delta):
	extra_patrol_timer(delta)
	return NodeState.SUCCESS

func extra_patrol_timer(delta):
	if (guardController.patrolIndicators.size() > 1 && guardPatrol.loadedPatrolIndicator != guardController.patrolIndicators[0]):
		if (guardPatrol.extraPatrolTimer > 0):
			guardPatrol.extraPatrolTimer -= delta
		else:
			guardPatrol.loadedPatrolIndicator = guardController.patrolIndicators[0]
			guardPatrol.reset_patrol()
