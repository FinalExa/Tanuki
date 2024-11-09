extends AttackHitbox

func LaunchAttackOnTargetInRange(targetInRange: Node2D):
	if (targetInRange is PlayerCharacter):
		ActivateGameOver(targetInRange)

func ActivateGameOver(playerRef: PlayerCharacter):
	playerRef.GameOver(self)
