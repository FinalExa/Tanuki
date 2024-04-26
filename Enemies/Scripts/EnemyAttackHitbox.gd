extends AttackHitbox

func _on_body_entered(body):
	if (body is PlayerCharacter):
		body.GameOver()
