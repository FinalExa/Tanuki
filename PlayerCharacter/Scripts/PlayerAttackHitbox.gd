extends AttackHitbox

func _on_body_entered(body):
	check_if_enemy(body)

func check_if_enemy(body):
	if (body is EnemyController && !hitTargets.has(body)):
		body.is_damaged(body.global_position.direction_to(characterRef.global_position))
		hitTargets.push_back(body)
