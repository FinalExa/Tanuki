extends AttackHitbox


func LaunchAttackOnTargetInRange(targetInRange: Node2D):
	if (targetInRange is HyottokoController):
		if (!hitTargets.has(targetInRange)):
			targetInRange.hyottokoReachPoint.SetPointToReach(characterRef.global_position)
			hitTargets.push_back(targetInRange)
			return
