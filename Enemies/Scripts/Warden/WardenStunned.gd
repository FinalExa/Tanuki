class_name WardenStunned
extends EnemyStunned

@export var enemyCollider: CollisionShape2D

func start_stun(direction: Vector2):
	ExecuteStunStartup(direction)
	enemyCollider.disabled = true

func end_stun():
	ExecuteStunEnd()
	enemyCollider.disabled = false
