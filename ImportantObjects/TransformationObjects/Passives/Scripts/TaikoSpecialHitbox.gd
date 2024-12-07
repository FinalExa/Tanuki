extends AttackHitbox

func _on_body_entered(body):
	EnemyEffects(body)

func EnemyEffects(body):
	if (!hitTargets.has(body)):
		if (body is HyottokoController):
			body.hyottokoReachPoint.SetPointToReach(characterRef.global_position)
			hitTargets.push_back(body)
			return
		if (body is GuardController):
			body.
			hitTargets.push_back(body)
