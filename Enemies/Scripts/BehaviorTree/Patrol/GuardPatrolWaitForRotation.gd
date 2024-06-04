extends GuardNode

@export var enemyPatrol: EnemyPatrol

func Evaluate(_delta):
	return wait_for_rotation()

func wait_for_rotation():
	if (enemyPatrol.isRotating):
		if (enemyController.enemyRotator.isDoneRotating):
			enemyPatrol.set_current_patrol_routine()
			enemyPatrol.isRotating = false
	return NodeState.SUCCESS
