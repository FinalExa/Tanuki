extends Area2D

@export var bossName: String

func _on_body_entered(body):
	if (body is EnemyController && body.enemyName == bossName):
		body.AdvanceBossPhase()
		self.queue_free()
