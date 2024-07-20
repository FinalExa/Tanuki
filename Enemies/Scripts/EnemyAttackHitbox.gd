extends AttackHitbox

func _on_body_entered(body):
	if (body is PlayerCharacter):
		ActivateGameOver(body)

func ActivateGameOver(playerRef: PlayerCharacter):
	playerRef.GameOver(self)
