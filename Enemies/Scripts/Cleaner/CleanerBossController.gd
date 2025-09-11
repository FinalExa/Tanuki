class_name CleanerBossController
extends EnemyController

@export var attackArea: CleanerOneShotArea
@export var newSpeed: float

func IsRepelled(direction: Vector2):
	if (enemyRepelled.repelledSpeed > 0 && isStunned):
		enemyRepelled.StartRepelled(direction)

func AdvanceBossPhase():
	if (questToSendProgressSignal != null):
		questToSendProgressSignal.AdvanceStageByObject(self)
	if (patrolIndicators.size() > 1):
		patrolIndicators.remove_at(0)
		enemyPatrol.loadedPatrolIndicator = patrolIndicators[0]
		enemyStunned.end_stun()
		enemyPatrol.reset_patrol()
		enemyPatrol.restart_patrol()
		enemyMovement.currentMovementSpeed = newSpeed
		attackArea.SetHitboxOff()

func _on_enemy_movement_reached_destination():
	if (attackArea.hitboxOff):
		attackArea.SetHitboxOn()
