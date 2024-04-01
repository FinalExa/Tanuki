extends GuardNode

@export var enemyAttack: EnemyAttack

func Evaluate(_delta):
	if (enemyAttack.attackLaunched):
		return NodeState.FAILURE
	return NodeState.SUCCESS
