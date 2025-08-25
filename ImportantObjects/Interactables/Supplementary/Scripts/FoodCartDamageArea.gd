class_name FoodCartDamageArea
extends Area2D

var activated: bool
@export var cartTag: String
@export var interactableGroup: String
@export var enemiesToStun: Array[String]
var objectsInRange: Array[Node2D]
var enemiesInRange: Array[EnemyController]

func _process(delta):
	ExecuteDamage()

func ExecuteDamage():
	if (activated):
		StunAllEnemies()
		InteractWithObjects()

func StunAllEnemies():
	for i in enemiesInRange.size():
		if (!enemiesInRange[i].isStunned):
			enemiesInRange[i].Damaged(enemiesInRange[i].global_position.direction_to(self.global_position), EnemyStunned.StunTier.HIGH)

func InteractWithObjects():
	var nullFound: bool
	for i in objectsInRange.size():
		if (objectsInRange[i] != null):
			objectsInRange[i].AttackInteraction(cartTag)
			return
		nullFound = true
	if (nullFound):
		var i: int = objectsInRange.size() - 1
		while (i >= 0):
			if (objectsInRange[i] == null):
				objectsInRange.remove_at(i)
			i -= 1

func Activate():
	activated = true

func Deactivate():
	activated = false

func _on_body_entered(body):
	if (body is EnemyController && !enemiesInRange.has(body) && enemiesToStun.has(body.enemyName)):
		enemiesInRange.push_back(body)
		return
	if (body.is_in_group(interactableGroup) && !objectsInRange.has(body)):
		objectsInRange.push_back(body)

func _on_body_exited(body):
	if (body is EnemyController && enemiesInRange.has(body)):
		enemiesInRange.erase(body)
	if (body.is_in_group(interactableGroup) && objectsInRange.has(body)):
		objectsInRange.erase(body)

func _on_area_entered(area):
	if (area.is_in_group(interactableGroup) && !objectsInRange.has(area)):
		objectsInRange.push_back(area)

func _on_area_exited(area):
	if (area.is_in_group(interactableGroup) && objectsInRange.has(area)):
		objectsInRange.erase(area)
