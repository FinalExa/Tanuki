class_name GuardDistraction
extends Area2D

@export var guardController: GuardController
@export var guardDistractionDiffuseArea: GuardDistractionDiffuseArea
@export var guardCheckValueOnEnd: float
@export var distractedObjDistance: float
@export var distractionGroup: String
@export var possibleDistractionGroup: String
var distractionSources: Array[Node2D]
var closestSource: Node2D
var isDistracted: bool

func _ready():
	guardDistractionDiffuseArea.guardDistraction = self

func _physics_process(_delta):
	ScanForDistractionSources()

func ScanForDistractionSources():
	if (guardController.isInPatrol && !isDistracted && distractionSources.size() > 0):
		var space_state = guardController.get_world_2d().direct_space_state
		closestSource = null
		for i in distractionSources.size():
			var query = PhysicsRayQueryParameters2D.create(guardController.global_position, distractionSources[i].global_position)
			var result = space_state.intersect_ray(query)
			if (result && result != { } && result.collider == distractionSources[i]):
				SetClosestDistractionSource(result.collider) 
		StartDistracted()
		return
	if (isDistracted):
		if (!closestSource.is_in_group(distractionGroup)):
			StopDistracted()
			return
		if (guardController.isStunned || guardController.isChecking || guardController.isInAlert || guardController.isInResearch):
			StopDistracted()

func SetClosestDistractionSource(receivedSource: Node2D):
	if (receivedSource.is_in_group(distractionGroup)):
		if (closestSource == null || (closestSource != null && closestSource != receivedSource && guardController.global_position.distance_to(receivedSource.global_position) > guardController.global_position.distance_to(closestSource.global_position))):
			closestSource = receivedSource

func StartDistracted():
	if (closestSource != null):
		guardController.enemyPatrol.stop_patrol()
		isDistracted = true
		guardDistractionDiffuseArea.ActivateDiffuseArea()

func StopDistracted():
	isDistracted = false
	closestSource = null
	guardController.guardCheck.currentAlertValue = guardCheckValueOnEnd
	guardController.guardCheck.ForceActivateCheck()
	guardDistractionDiffuseArea.DeactivateDiffuseArea()

func _on_body_entered(body):
	if (!distractionSources.has(body) && (body.is_in_group(distractionGroup)) || body.is_in_group(possibleDistractionGroup)):
		distractionSources.push_back(body)

func _on_body_exited(body):
	if (distractionSources.has(body)):
		distractionSources.erase(body)
		if (distractionSources.size() <= 0 && isDistracted):
			StopDistracted()
