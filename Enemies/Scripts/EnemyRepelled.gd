class_name EnemyRepelled
extends Area2D

@export var attackTag: String
@export var enemyController: EnemyController
@export var repelledTime: float
@export var repelledDistance: float
@export var repelledOffset: float

var repelledTimer: float
var repelledSpeed: float
var repelledDirection: Vector2
var repelledPosition: Vector2
var objectsInStopRange: Array[Node2D]

var interactablesInRange: Array[GenericInteractable]
var activatedInteractables: Array[GenericInteractable]

func _ready():
	repelledSpeed = 0
	if (repelledTime > 0):
		repelledSpeed = repelledDistance / repelledTime

func _process(_delta):
	StopRepel()
	ActivateInteractables()
	ClearArrays()

func _physics_process(delta):
	Repelled(delta)

func StartRepelled(direction: Vector2):
	enemyController.isRepelled = true
	enemyController.emit_signal("stop_attack")
	enemyController.velocity = Vector2.ZERO
	repelledTimer = repelledTime
	repelledDirection = direction
	repelledPosition = self.global_position
	look_at(global_position + repelledDirection)
	rotation_degrees += repelledOffset

func Repelled(delta):
	if (enemyController.isRepelled):
		if (repelledTimer > 0):
			repelledTimer -= delta
			enemyController.velocity = repelledSpeed * repelledDirection
			return
		enemyController.EndRepel()

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

func StopRepel():
	if (enemyController.isRepelled):
		if (objectsInStopRange.size() > 0):
			enemyController.EndRepel()

func _on_body_entered(body):
	if (body is GenericInteractable && !interactablesInRange.has(body)):
		interactablesInRange.push_back(body)

func _on_body_exited(body):
	if (body is GenericInteractable && interactablesInRange.has(body)):
		interactablesInRange.erase(body)
		if (activatedInteractables.has(body)):
			activatedInteractables.erase(body)

func _on_area_entered(area):
	if (area is GenericInteractable && !interactablesInRange.has(area)  && !(area is PlayerCharacter)):
		interactablesInRange.push_back(area)

func _on_area_exited(area):
	if (area is GenericInteractable && interactablesInRange.has(area)):
		interactablesInRange.erase(area)
		if (activatedInteractables.has(area)):
			activatedInteractables.erase(area)

func _on_area_2d_body_entered(body):
	if (!objectsInStopRange.has(body) && !(body is PlayerCharacter)):
		objectsInStopRange.push_back(body)

func _on_area_2d_body_exited(body):
	if (objectsInStopRange.has(body)):
		objectsInStopRange.erase(body)
