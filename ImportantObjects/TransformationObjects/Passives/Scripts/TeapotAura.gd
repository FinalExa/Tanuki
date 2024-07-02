class_name TeapotAura
extends Area2D


var auraActive: bool
var enemiesInRange: Array[EnemyController]
var stunnedEnemies: Array[EnemyController]

func _ready():
	hide()

func _process(delta):
	StunNearbyEnemies()

func StunNearbyEnemies():
	if (auraActive):
		for i in enemiesInRange.size():
			if (!enemiesInRange[i].isStunned):
				if (stunnedEnemies.has(enemiesInRange[i])):
					stunnedEnemies.erase(enemiesInRange[i])
				if (!stunnedEnemies.has(enemiesInRange[i])):
					enemiesInRange[i].SetDamaged(enemiesInRange[i].global_position.direction_to(self.global_position))
					stunnedEnemies.push_back(enemiesInRange[i])

func SetAuraActive():
	auraActive = true
	show()

func UnsetAuraActive():
	auraActive = false
	stunnedEnemies.clear()
	hide()

func _on_body_entered(body):
	if (body is EnemyController && !enemiesInRange.has(body)):
		enemiesInRange.push_back(body)

func _on_body_exited(body):
	if (body is EnemyController && enemiesInRange.has(body)):
		enemiesInRange.erase(body)
