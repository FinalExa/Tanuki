extends GuardNode

@export var enemyPatrol: EnemyPatrol

func Evaluate(delta):
	return startup(delta)

func startup(delta):
	if (enemyPatrol.startupActive == true):
		if (enemyPatrol.startupTimer > 0):
			enemyPatrol.startupTimer -= delta
			return NodeState.SUCCESS
		else:
			enemyPatrol.set_current_patrol_routine()
			enemyPatrol.startupActive = false
	return NodeState.FAILURE
