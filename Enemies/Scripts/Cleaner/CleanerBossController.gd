class_name CleanerBossController
extends EnemyController

func IsRepelled(direction: Vector2):
	if (repelledSpeed > 0 && isStunned):
		StartRepelled(direction)

func DamagedExtraOperation(_direction: Vector2, _tier: EnemyStunned.StunTier):
	if (patrolIndicators.size() > 1):
		patrolIndicators.remove_at(0)
		enemyPatrol.select_new_patrol_indicator()
