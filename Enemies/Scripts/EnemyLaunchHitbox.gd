extends AttackHitbox

@export var launchDistance: float
@export var launchTime: float

func LaunchAttackOnTargetInRange(targetInRange: Node2D):
	if (targetInRange is PlayerCharacter && !hitTargets.has(targetInRange)):
		hitTargets.push_back(targetInRange)
		HitPlayer(targetInRange)

func HitPlayer(playerRef: PlayerCharacter):
	playerRef.SetLaunched(launchDistance, launchTime, self.global_position.direction_to(playerRef.global_position))
	if (playerRef.transformationChangeRef.isTransformed):
		playerRef.transformationChangeRef.DeactivateTransformation()
	playerRef.transformationChangeRef.SetNoTransformation()
