class_name PlayerAttackHitbox
extends AttackHitbox

var attackTag: String

func LaunchAttackOnTargetInRange(targetInRange: Node2D):
	if (targetInRange.is_in_group("Interactable")):
		targetInRange.AttackInteraction(attackTag)
		return
	if (targetInRange is EnemyController && !hitTargets.has(targetInRange)):
		targetInRange.IsRepelled(characterRef.global_position.direction_to(targetInRange.global_position))
		hitTargets.push_back(targetInRange)
