extends GuardNode

@export var enemyStunned: EnemyStunned

func Evaluate(delta):
	if (enemyStunned.stunTimer > 0):
		enemyStunned.stunTimer -= delta
	else:
		enemyStunned.end_stun()
	return NodeState.FAILURE
