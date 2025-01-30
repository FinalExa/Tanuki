class_name WardenStunned
extends EnemyStunned

@export var enemyCollider: CollisionShape2D

func start_stun(direction: Vector2, tier: EnemyStunned.StunTier):
	ExecuteStunStartup(direction, tier)
	enemyCollider.disabled = true

func end_stun():
	ExecuteStunEnd()
	enemyCollider.disabled = false
