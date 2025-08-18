extends HyottokoController

@export var newSpeed: float

func IsRepelled(direction: Vector2):
	if (repelledSpeed > 0 && isStunned):
		StartRepelled(direction)

func AdvanceBossPhase():
	if (questToSendProgressSignal != null):
		questToSendProgressSignal.AdvanceStageByObject(self)
	enemyStunned.end_stun()
	enemyMovement.set_movement_speed(newSpeed)
	enemyPatrol.reset_patrol()
	enemyPatrol.restart_patrol()
