extends GuardNode

@export var hyottokoAttack: EnemyAttack

func Evaluate(_delta):
	hyottokoAttack.start_attack()
	return NodeState.FAILURE
