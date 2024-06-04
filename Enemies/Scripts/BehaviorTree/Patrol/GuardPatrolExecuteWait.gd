extends GuardNode

@export var enemyPatrol: EnemyPatrol

func Evaluate(delta):
	return wait_active(delta)

func wait_active(delta):
	if (enemyPatrol.isWaiting && !enemyPatrol.patrolStopped):
		if (enemyPatrol.waitTimer > 0):
			enemyPatrol.waitTimer -= delta
			return NodeState.SUCCESS
		else:
			enemyPatrol.isWaiting = false
			enemyPatrol.set_current_patrol_routine()
	return NodeState.FAILURE
