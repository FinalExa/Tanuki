extends AttackHitbox

@export var launchDistance: float
@export var launchTime: float

func LaunchAttackOnTargetInRange(targetInRange: Node2D):
	if (targetInRange is PlayerCharacter && !hitTargets.has(targetInRange)):
		hitTargets.push_back(targetInRange)
		targetInRange.SetLaunched(launchDistance, launchTime, self.global_position.direction_to(targetInRange.global_position))
		if (targetInRange.transformationChangeRef.isTransformed):
			targetInRange.transformationChangeRef.DeactivateTransformation()
