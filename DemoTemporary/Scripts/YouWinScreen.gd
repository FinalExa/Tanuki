extends Area2D

func _on_body_entered(body):
	if (body is PlayerCharacter):
		PlayerWins(body)

func PlayerWins(player: PlayerCharacter):
	player.YouWin()
