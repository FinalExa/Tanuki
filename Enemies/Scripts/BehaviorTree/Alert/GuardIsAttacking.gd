extends GuardNode

@export var enemyAttack: EnemyAttack

func Evaluate(_delta):
	if (enemyAttack.attackLaunched):
		if(guardController.guardMovement.locationTargetEnabled || guardController.guardMovement.target != null):
			guardController.guardMovement.set_new_target(null)
		return NodeState.FAILURE
	return NodeState.SUCCESS
