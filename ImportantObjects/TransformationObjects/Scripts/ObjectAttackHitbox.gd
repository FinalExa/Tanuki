class_name ObjectAttackHitbox
extends AttackHitbox

var attackTag: String
@export var stunsGuard: bool

func LaunchAttackOnTargetInRange(targetInRange: Node2D):
	if (!hitTargets.has(targetInRange)):
		hitTargets.push_back(targetInRange)
		if (targetInRange.is_in_group("Interactable")):
			targetInRange.AttackInteraction(attackTag)
			return
		if (stunsGuard && targetInRange is GuardController):
			targetInRange.is_damaged(targetInRange.global_position.direction_to(self.global_position))
