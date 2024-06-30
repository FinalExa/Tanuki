extends AttackHitbox

func _on_body_entered(body):
	EnemyEffects(body)

func EnemyEffects(body):
	if (body is HyottokoController):
		body.hyottokoReachPoint.SetPointToReach(characterRef.global_position)
