extends GuardNode

@export var enemyPatrol: EnemyPatrol

func Evaluate(delta):
	extra_patrol_timer(delta)
	return NodeState.SUCCESS

func extra_patrol_timer(delta):
	if (enemyController.patrolIndicators.size() > 1 && enemyPatrol.loadedPatrolIndicator != enemyController.patrolIndicators[0]):
		if (enemyPatrol.extraPatrolTimer > 0):
			enemyPatrol.extraPatrolTimer -= delta
		else:
			enemyPatrol.loadedPatrolIndicator = enemyController.patrolIndicators[0]
			enemyPatrol.reset_patrol()
