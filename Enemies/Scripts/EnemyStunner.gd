extends Area2D

@export var enemyNames: Array[String]
@export var movableRef: MovableObject
@export var stunTier: EnemyStunned.StunTier

func _on_body_entered(body):
	if (body is EnemyController && enemyNames.has(body.enemyName)):
		StunEnemy(body)

func StunEnemy(enemyController: EnemyController):
	enemyController.is_damaged(movableRef.global_position.direction_to(enemyController.global_position), stunTier)
	movableRef.ResetParentAndPosition()
