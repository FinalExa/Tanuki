class_name WardenStunned
extends EnemyStunned

@export var enemyCollider: CollisionShape2D

func start_stun(direction: Vector2):
	ExecuteStunStartup(direction)
	enemyController.remove_child(enemyCollider)

func end_stun():
	ExecuteStunEnd()
	enemyCollider.add_child(enemyCollider)
