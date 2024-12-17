extends GuardNode

@export var enemyAttack: EnemyAttack

func Evaluate(_delta):
	if (enemyAttack.attackLaunched):
		if(enemyController.enemyMovement.locationTargetEnabled || enemyController.enemyMovement.target != null):
			enemyController.enemyMovement.set_new_target(null)
		return NodeState.FAILURE
	return NodeState.SUCCESS

