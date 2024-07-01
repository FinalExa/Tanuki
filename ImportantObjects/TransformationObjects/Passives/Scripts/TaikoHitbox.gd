extends AttackHitbox

@export var alertValueOnGuards: float

func _on_body_entered(body):
	EnemyEffects(body)

func EnemyEffects(body):
	if (!hitTargets.has(body)):
		if (body is GuardController):
			var guardRef: GuardController = body
			guardRef.guardAlert.stop_alert()
			guardRef.guardCheck.currentAlertValue = alertValueOnGuards
			guardRef.guardCheck.activate_check(characterRef)
			hitTargets.push_back(body)
		if (body is HyottokoController):
			body.SetDamaged(body.global_position.direction_to(characterRef.global_position))
			hitTargets.push_back(body)
