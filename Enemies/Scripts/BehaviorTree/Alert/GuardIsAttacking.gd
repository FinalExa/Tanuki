extends GuardNode

@export var enemyAttack: EnemyAttack

func Evaluate(_delta):
	if (enemyAttack.attackLaunched):
		enemyController.guardAlert.set_last_target_info(enemyController.guardAlert.alertTarget)
		if(enemyController.guardMovement.locationTargetEnabled || enemyController.guardMovement.target != null):
			enemyController.guardMovement.set_new_target(null)
		return NodeState.FAILURE
	return NodeState.SUCCESS
