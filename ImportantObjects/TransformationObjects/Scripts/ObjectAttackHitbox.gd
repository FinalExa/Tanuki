class_name ObjectAttackHitbox
extends AttackHitbox

var attackTag: String
@export var stunList: Array[String]
@export var stunTier: EnemyStunned.StunTier

func LaunchAttackOnTargetInRange(targetInRange: Node2D):
	if (!hitTargets.has(targetInRange)):
		hitTargets.push_back(targetInRange)
		if (targetInRange is EnemyController && stunList.has(targetInRange.enemyName)):
			targetInRange.is_damaged(targetInRange.global_position.direction_to(self.global_position), stunTier)
		if (targetInRange.is_in_group("Interactable")):
			targetInRange.AttackInteraction(attackTag)
			return
