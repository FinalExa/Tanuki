extends GuardNode

@export var normalAttack: EnemyAttack
@export var rageAttack: EnemyAttack

func Evaluate(_delta):
	if (!enemyController.isInRage):
		normalAttack.start_attack()
	else:
		rageAttack.start_attack()
	return NodeState.FAILURE
