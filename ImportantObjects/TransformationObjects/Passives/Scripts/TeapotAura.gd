class_name TeapotAura
extends Area2D

@export var interactableGroup: String
@export var auraInteractTag: String
var auraActive: bool
var enemiesInRange: Array[EnemyController]
var stunnedEnemies: Array[EnemyController]
var interactablesInRange: Array[GenericInteractable]

func _ready():
	hide()

func _process(_delta):
	ExecuteAuraOperations()

func ExecuteAuraOperations():
	if (auraActive):
		StunNearbyEnemies()
		Interact()

func StunNearbyEnemies():
	for i in enemiesInRange.size():
		if (!enemiesInRange[i].isStunned):
			if (stunnedEnemies.has(enemiesInRange[i])):
				stunnedEnemies.erase(enemiesInRange[i])
			if (!stunnedEnemies.has(enemiesInRange[i])):
				enemiesInRange[i].is_damaged(enemiesInRange[i].global_position.direction_to(self.global_position))
				stunnedEnemies.push_back(enemiesInRange[i])

func Interact():
	var newInteractables: Array[GenericInteractable]
	newInteractables.clear()
	for i in interactablesInRange.size():
		if (interactablesInRange[i] != null):
			newInteractables.push_back(interactablesInRange[i])
			interactablesInRange[i].AttackInteraction(auraInteractTag)
	interactablesInRange.clear()

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
	if (body.is_in_group(interactableGroup)):
		if (body is GenericInteractable && !interactablesInRange.has(body) && body.neededString == auraInteractTag):
			interactablesInRange.push_back(body)

func _on_body_exited(body):
	if (enemiesInRange.has(body)):
		enemiesInRange.erase(body)
	if (interactablesInRange.has(body)):
		interactablesInRange.erase(body)
