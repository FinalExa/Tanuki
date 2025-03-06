extends AttackHitbox

func LaunchAttackOnTargetInRange(targetInRange: Node2D):
	if (targetInRange is PlayerCharacter && !hitTargets.has(targetInRange)):
		hitTargets.push_back(targetInRange)
		ActivateGameOver(targetInRange)

func ActivateGameOver(playerRef: PlayerCharacter):
	playerRef.GameOver(self)
