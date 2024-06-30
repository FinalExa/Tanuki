extends GuardNode

@export var enemyAttackNormal: EnemyAttack
@export var enemyAttackRage: EnemyAttack

func Evaluate(_delta):
	if (enemyAttackNormal.attackLaunched || enemyAttackRage.attackLaunched):
		if(enemyController.enemyMovement.locationTargetEnabled || enemyController.enemyMovement.target != null):
			enemyController.enemyMovement.set_new_target(null)
		return NodeState.FAILURE
	return NodeState.SUCCESS

