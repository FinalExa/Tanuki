extends Area2D

@export var attackTag: String
@export var enemyController: EnemyController

var interactablesInRange: Array[GenericInteractable]
var activatedInteractables: Array[GenericInteractable]

func _process(_delta):
	ActivateInteractables()
	ClearArrays()

func ActivateInteractables():
	if (enemyController.isRepelled && interactablesInRange.size() > 0 && interactablesInRange.size() != activatedInteractables.size()):
		for i in interactablesInRange.size():
			if (activatedInteractables.has(interactablesInRange[i])):
				continue
			interactablesInRange[i].InteractionWithRef(attackTag, enemyController)
			activatedInteractables.push_back(interactablesInRange[i])

func ClearArrays():
	if (!enemyController.isRepelled):
		if (interactablesInRange.size() > 0):
			interactablesInRange.clear()
		if (activatedInteractables.size() > 0):
			activatedInteractables.clear()

func _on_body_entered(body):
	if (body is GenericInteractable && !interactablesInRange.has(body)):
		interactablesInRange.push_back(body)

func _on_body_exited(body):
	if (body is GenericInteractable && interactablesInRange.has(body)):
		interactablesInRange.erase(body)
		if (activatedInteractables.has(body)):
			activatedInteractables.erase(body)

func _on_area_entered(area):
	if (area is GenericInteractable && !interactablesInRange.has(area)):
		interactablesInRange.push_back(area)

func _on_area_exited(area):
	if (area is GenericInteractable && interactablesInRange.has(area)):
		interactablesInRange.erase(area)
		if (activatedInteractables.has(area)):
			activatedInteractables.erase(area)
