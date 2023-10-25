extends GuardNode

@export var guardStunned: GuardStunned

func Evaluate(delta):
	if (guardStunned.stunTimer > 0):
		guardStunned.stunTimer -= delta
	else:
		guardStunned.end_stun()
	return NodeState.FAILURE
