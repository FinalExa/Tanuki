extends PuzzleObject

var enemiesInRange: Array[EnemyController]
var enemiesStunned: Array[EnemyController]

func _process(delta):
	StunEnemiesInArea()

func StunEnemiesInArea():
	if (active):
		for i in enemiesInRange.size():
			if (!enemiesStunned.has(enemiesInRange[i])):
				enemiesInRange[i].Damaged(Vector2.ZERO, EnemyStunned.StunTier.LOW)
				enemiesStunned.push_back(enemiesInRange[i])

func _on_body_entered(body):
	if (body is EnemyController && !enemiesInRange.has(body)):
		enemiesInRange.push_back(body)

func _on_body_exited(body):
	if (body is EnemyController && enemiesInRange.has(body)):
		enemiesInRange.erase(body)
		if (enemiesStunned.has(body)):
			enemiesStunned.erase(body)
